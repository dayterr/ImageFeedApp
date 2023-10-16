//
//  ServiceExtension.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 09.10.2023.
//

import Foundation

extension URLSession {
    
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        let task = dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data,
                   let response = response,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode
                {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if statusCode < 200 || statusCode >= 300 {
                        completion(.failure(NetworkError.codeError))
                        return
                    }
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch let error {
                        completion(.failure(error))
                        return
                    }
                    
                }
            }
        }
        return task
    }
}
