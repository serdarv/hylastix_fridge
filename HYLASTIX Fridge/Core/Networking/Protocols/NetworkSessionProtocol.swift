//    
//  NetworkSessionProtocol.swift
//  HYLASTIX Fridge
//

import Foundation

/// Protocol to which network session handling classes must conform to.
protocol NetworkSessionProtocol {
    /// Create a data task.
    /// - Parameter request: `URLRequest` object.
    /// - Returns: A tuple containing `Data` and `URLResponse`.
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}
