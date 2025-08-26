//    
//  APIOperation.swift
//  HYLASTIX Fridge
//

import Foundation

/// The expected result of an API Operation.
enum OperationResult<Response> {
    /// JSON reponse.
    case json(_ : Response?)
    /// An error.
    case error(_ : Error)
}

/// API Operation class that can  execute and cancel a request.
class APIOperation<Request: RequestProtocol> {
    typealias Output = OperationResult

    /// The `URLSessionTask` to be executed/
    private var task: URLSessionTask?

    /// Instance conforming to the `RequestProtocol`.
    internal var request: Request

    /// Designated initializer.
    /// - Parameter request: Instance conforming to the `RequestProtocol`.
    init(_ request: Request) {
        self.request = request
    }

    /// Cancels the operation and the encapsulated task.
    func cancel() {
        task?.cancel()
    }

    /// Execute a request using a request dispatcher.
    /// - Parameters:
    ///   - requestDispatcher: `APIRequestDispatcher` object that will execute the request.
    ///   - completion: Completion block.
    func execute(in requestDispatcher: APIRequestDispatcher) async throws -> OperationResult<Request.Response> {
        try await requestDispatcher.execute(request: request)
    }

}
