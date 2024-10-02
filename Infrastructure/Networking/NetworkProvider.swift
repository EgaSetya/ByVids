//
//  NetworkProvider.swift
//  ByVids
//
//  Created by Ega Setya Putra on 30/10/24.
//

import Combine
import Foundation

import Moya

public struct NetworkProvider<Target> where Target: TargetType {
    private let provider: MoyaProvider<Target>
    
    public init(
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = NetworkProvider.defaultEndpointCreator,
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure = NetworkProvider.endpointResolver(),
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
        callbackQueue: DispatchQueue? = nil,
        trackInflights: Bool = false,
        withBearerToken: Bool = true
    ) {
        provider = MoyaProvider(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            callbackQueue: callbackQueue,
            trackInflights: trackInflights
        )
    }
    
    public func request<D: Decodable>(
        _ token: Target,
        _ responseType: D.Type,
        atKeyPath keyPath: String? = nil,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<D, NetworkError> {
        Future { promise in
            self.provider.request(token) { result in
                switch result {
                case .failure(let error):
                    if isOffline(error: error) {
                        promise(.failure(NetworkError.Offline))
                    } else {
                        promise(.failure(NetworkError.Custom(message: "error", code: error.errorCode)))
                    }
                case .success(let response):
                    do {
                        try handleHTTPStatusCode(response.statusCode, responseURL: response.response?.url)

                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let value = try response.map(D.self, atKeyPath: keyPath, using: decoder, failsOnEmptyData: true)
                        promise(.success(value))
                    } catch let error {
                        promise(.failure(NetworkError.Decoding(error)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

private extension NetworkProvider {
    func handleHTTPStatusCode(_ statusCode: Int, responseURL: URL?) throws {
        switch statusCode {
        case 401:
            throw NetworkError.Unauthorized
        case 400...499:
            throw NetworkError.BadRequest(responseURL?.absoluteString ?? "")
        case 500:
            throw NetworkError.ServerError
        default:
            break
        }
    }
}
