//    
//  RequestProtocol.swift
//  HYLASTIX Fridge
//

import Foundation

/// The request type that matches the URLSessionTask types.
enum RequestType {
    /// Will translate to a URLSessionDataTask.
    case data
    // Add more request types if needed such as download, upload etc..
}

/// The expected remote response type.
enum ResponseDataType {
    /// Used when the expected response is a JSON payload.
    case json
}

/// HTTP request methods.
enum RequestMethod: String {
    /// HTTP GET
    case get = "GET"
    /// HTTP POST
    case post = "POST"
    /// HTTP PUT
    case put = "PUT"
    /// HTTP PATCH
    case patch = "PATCH"
    /// HTTP DELETE
    case delete = "DELETE"
}

/// Type alias used for HTTP request headers.
typealias ReaquestHeaders = [String: String]
/// Type alias used for HTTP request parameters. Used for query parameters for GET requests and in the HTTP body for POST, PUT and PATCH requests.
typealias RequestParameters = [String : Any?]
/// Type alias used for the HTTP request download/upload progress.
typealias ProgressHandler = (Float) -> Void

/// Protocol to which the HTTP requests must conform.
protocol RequestProtocol {
    associatedtype Response: Decodable

    /// The path that will be appended to API's base URL.
    var path: String { get }

    /// The HTTP method.
    var method: RequestMethod { get }

    /// The HTTP headers/
    var headers: ReaquestHeaders? { get }

    /// The request parameters used for HTTP body.
    var parameters: RequestParameters? { get }

    /// The request parameters used for query parameters.
    var queryParameters: RequestParameters? { get }

    /// The request type.
    var requestType: RequestType { get }

    /// The expected response data type.
    var responseDataType: ResponseDataType { get }

    var data: Data? { get }

    var maxRetryCount: Int { get }
}

extension RequestProtocol {

    /// Creates a URLRequest from this instance.
    /// - Parameter environment: The environment against which the `URLRequest` must be constructed.
    /// - Returns: An optional `URLRequest`.
    public func urlRequest() -> URLRequest? {
        // Create the base URL.
        guard let url = url(with: baseURL()) else {
            return nil
        }
        // Create a request with that URL.
        var request = URLRequest(url: url)

        // Append all related properties.
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonBody


        return request
    }


    /// Returns the authorization header value based on server type
    public func authorization(token: String) -> String {
        return "Bearer \(token)"
    }

    /// Creates a URL with the given base URL.
    /// - Parameter baseURL: The base URL string.
    /// - Returns: An optional `URL`.
    private func url(with baseURL: String) -> URL? {
        // Create a URLComponents instance to compose the url.
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        // Add the request path to the existing base URL path
        urlComponents.path = urlComponents.path + path

        // Add query items to the request URL
        urlComponents.queryItems = queryItems

        return urlComponents.url
    }

    /// Returns the URLRequest `URLQueryItem`
    private var queryItems: [URLQueryItem]? {
        guard let parameters = queryParameters else {
            return nil
        }
        // Convert parameters to query items.
        return parameters.compactMap { (key: String, value: Any?) -> URLQueryItem? in
            guard let value = value else {
                return nil
            }
            var valueString: String? = nil
            // TODO: Need a better way to pass nested parameters
            if value is Array<Any> || value is Dictionary<AnyHashable, Any> {
                valueString = toJson(from: value)
            } else {
                valueString = String(describing: value)
            }
            return URLQueryItem(name: key, value: valueString)
        }
    }

    private func toJson(from object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

    /// Returns the URLRequest body `Data`
    private var jsonBody: Data? {
        guard let parameters = parameters else {
            return nil
        }
        // Convert parameters to JSON data
        var jsonBody: Data?
        do {
            jsonBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print(error)
        }
        return jsonBody
    }

    /// Returns the BaseURL based on serer type
    private func baseURL() -> String {
        return APIEnvironment.baseURL
    }

    var headers: ReaquestHeaders? {
        return nil
    }

    var parameters: RequestParameters? {
        return nil
    }

    var queryParameters: RequestParameters? {
        return nil
    }

    var requestType: RequestType {
        return .data
    }

    var responseDataType: ResponseDataType {
        return .json
    }

    var data: Data? {
        return nil
    }

    var maxRetryCount: Int {
        return 0
    }
}
