//
//  NetworkService.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/24/24.
//

import Foundation

protocol NetworkService {
    static var shared: NetworkService { get }
    
    func data<T: Decodable>(urlString: String) async throws -> T
}

enum NetworkServiceError: Error {
    case invalidResponse
    case invalidStatusCode
    case decodeFailed
}

final class DefaultNetworkService {
    private let session: URLSession = .shared
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    
    static let shared: NetworkService = DefaultNetworkService()
    
    private init() { }
    
    private func handleResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkServiceError.invalidResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkServiceError.invalidStatusCode
        }
    }
    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        try jsonDecoder.decode(T.self, from: data)
    }
}

extension DefaultNetworkService: NetworkService {
    func data<T: Decodable>(urlString: String) async throws -> T {
        let (data, response) = try await session.data(from: URL(string: urlString)!)
        try handleResponse(response)
        return try decode(data)
    }
}
