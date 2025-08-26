//
//  APIRequestDispatcher.swift
//  HYLASTIX Fridge
//

import Foundation

/// Enum of API Errors
enum APIError: Error {
    /// No data received from the server.
    case noData
    /// The server response was invalid (unexpected format).
    case invalidResponse
    /// The request was rejected: 400-499
    case badRequest(
        String = "Request Failed".localized,
        String = ""
    )
    /// Encountered a server error.
    case serverError(String = "Server Error".localized, url: String?)
    /// There was an error parsing the data.
    case parseError(String?)
    /// Unknown error.
    case unknown

    func errorMessage() -> (String, String?) {
        switch self {
        case .badRequest(let title, let message):
            return (title, message)
        case .serverError:
            return (
                "Server Error".localized,
                "please_try_again".localized
            )
        default:
            return ("Server Error".localized, nil)
        }
    }
}

struct APIErrorResponse: Decodable {
    let title: String
    let message: String
}

/// Class that handles the dispatch of requests to an environment with a given configuration.
class APIRequestDispatcher {

    private static let unauthorizedStatusCode: Int = 401

    /// The network session configuration.
    private let networkSession: NetworkSessionProtocol

    /// Required initializer.
    /// - Parameters:
    ///   - environment: APIEnvironment is  used to determine on which environment the requests will be executed.
    ///   - networkSession: Instance conforming to `NetworkSessionProtocol` used for executing requests with a specific configuration.
    required init(
        networkSession: NetworkSessionProtocol
    ) {
        self.networkSession = networkSession
    }

    /// Executes a request.
    /// - Parameters:
    ///   - request: Instance conforming to `RequestProtocol`
    func execute<Request: RequestProtocol>(request: Request) async throws -> OperationResult<Request.Response> {
        // Create a URL request.
        guard var urlRequest = request.urlRequest() else {
            throw APIError.badRequest("Invalid URL for: \(request)")
        }

        debugPrint("[APIRequestDispatcher] executing [\(request.method)]: \(urlRequest.url!)")

        // Add the environment specific headers.
        APIEnvironment.headers?.forEach { (key: String, value: String) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

#if DEBUG
        if ProcessInfo.processInfo.environment["LOG_CURL"] != nil {
            debugPrint("CURL: \(urlRequest.cURLRepresentation)")
        }
#endif

        // Count retried calls
        var retryCount = 0

        // Request response
        var response: OperationResult<Request.Response> = .error(APIError.unknown)

        // Check retry attempts
        while retryCount <= request.maxRetryCount {
            // Execute the request.
            do {
                switch request.requestType {
                case .data:
                    let (data, urlResponse) = try await networkSession.data(for: urlRequest)
                    response = try handleJsonTaskResponse(data: data, urlResponse: urlResponse, request: request)
                }
            } catch let error {
                debugPrint("[ERROR] APIRequestDispatcher failed to handle \(request) : \(error)")
                response = .error(error)
            }

            // If the request is successful, return a response, otherwise try retry
            switch response {
            case .error(_):
                break
            default:
                return response
            }

            retryCount += 1
        }

        return response
    }

    /// Handles the token refresh if needed
    ///

    /// Handles the data response that is expected as a JSON object output.
    /// - Parameters:
    ///   - data: The `Data` instance to be serialized into a JSON object.
    ///   - urlResponse: The received `URLResponse` instance.
    ///   - request: Instance conforming to `RequestProtocol`
    /// - Returns: An `OperationResult` instance.
    private func handleJsonTaskResponse<Request: RequestProtocol>(
        data: Data?,
        urlResponse: URLResponse,
        request: Request
    ) throws -> OperationResult<Request.Response> {
        // Check if the response is valid.
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        // Verify the HTTP status code.
        let result = verify(data: data, urlResponse: urlResponse)
        switch result {
        case .success(let data):
            let parsedResponse: Result<Request.Response, Error> = parse(data: data as? Data)
            switch parsedResponse {
            case .success(let json):
                return .json(json)
            case .failure(let error):
                if let stringData = data as? Data,
                   let stringResponse = String(data: stringData, encoding: .utf8) {
                    debugPrint("[ERROR] failed JSON verification \(stringResponse)")
                    return .json(true as? Request.Response)
                } else {
                    throw error
                }
            }
        case .failure(let error):
            throw error
        }
    }

    /// Parses a `Data` object into a JSON object.
    /// - Parameter data: `Data` instance to be parsed.
    /// - Returns: A `Result` instance.
    private func parse<ResponseType: Decodable>(data: Data?) -> Result<ResponseType, Error> {
        guard let data = data else {
            return .failure(APIError.invalidResponse)
        }

        // Check if the response is empty (204 No Content case)
        if data.isEmpty {
            if ResponseType.self == String.self {
                return .success("" as! ResponseType) // Return empty string if expecting a string
            }
            return .failure(APIError.invalidResponse)
        }

        // Attempt to decode as JSON
        guard let json: ResponseType = Parser.parse(jsonData: data) else {
            return .failure(APIError.parseError("Error parsing object"))
        }
        return .success(json)
    }

    /// Checks if the HTTP status code is valid and returns an error otherwise.
    /// - Parameters:
    ///   - data: The data or file URL.
    ///   - urlResponse: The received `HTTPURLResponse` instance.
    /// - Returns: A `Result` instance.
    private func verify(data: Any?, urlResponse: HTTPURLResponse) -> Result<Any, Error> {
        switch urlResponse.statusCode {
        case 200...299:
            if let data = data {
                return .success(data)
            } else {
                return .failure(APIError.noData)
            }
        case 400...599:
            if urlResponse.statusCode == Self.unauthorizedStatusCode {
                NotificationCenter.default.post(
                    name: Notification.Name("AppConstants.unauthorizedRequestNotification"),
                    object: nil
                )
            }
            let parsedResponse: Result<APIErrorResponse, Error> = parse(data: data as? Data)
            if case .success(let errorResponse) = parsedResponse {
                return .failure(APIError.badRequest(errorResponse.title, errorResponse.message))
            } else {
                // If there is custom error returned we can create custom error model and parse it here
                return .failure(APIError.serverError(url: urlResponse.url?.absoluteString))
            }
        default:
            return .failure(APIError.unknown)
        }
    }
}

extension APIRequestDispatcher {
    static let shared: APIRequestDispatcher = {
        return APIRequestDispatcher(networkSession: APINetworkSession())
    }()
}

private extension URLRequest {
    var cURLRepresentation: String {
        guard let url = self.url else {
            return "Invalid URL"
        }

        var components = ["curl"]

        // HTTP Method
        if let method = self.httpMethod, method != "GET" {
            components.append("-X \(method)")
        }

        // Headers
        if let headers = self.allHTTPHeaderFields {
            for (key, value) in headers {
                components.append("-H '\(key): \(value)'")
            }
        }

        // Body
        if let httpBody = self.httpBody,
           let bodyString = String(data: httpBody, encoding: .utf8) {
            components.append("-d '\(bodyString)'")
        }

        // URL
        components.append("'\(url.absoluteString)'")

        return components.joined(separator: " \\\n  ")
    }
}
