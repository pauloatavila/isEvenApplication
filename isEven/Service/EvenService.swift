//
//  EvenService.swift
//  isEven
//
//  Created by Paulo Atavila on 28/05/21.
//

import Foundation

private let apiURL = "https://api.isevenapi.xyz/api/iseven/"

protocol ServiceProtocol {
    func fetchIsEven(for number: Int, completion: @escaping (Swift.Result<EvenResult, APIError>) -> Void)
}

struct EvenService: ServiceProtocol {
    let session: NetworkSessionProtocol
    
    init(session: NetworkSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchIsEven(for number: Int, completion: @escaping (Swift.Result<EvenResult, APIError>) -> Void) {
        guard let api = URL(string: apiURL + String(number)) else {
            completion(.failure(.urlError))
            return
        }
        
        let task = session.dataTask(with: api) { (data, response, error) in
            if let error = error {
                completion(.failure(.dataError(error)))
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.response))
                return
            }
            switch response.statusCode {
            case 200..<300:
                self.decode(data: data, completion: completion)
                
            default:
                completion(.failure(.response))
            }
            
        }
        
        task.resume()
    }
    
    func decode(data: Data?, completion: @escaping (Swift.Result<EvenResult, APIError>) -> Void) {
        guard let jsonData = data else {
            completion(.failure(.data))
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(EvenResult.self, from: jsonData)
            completion(.success(decoded))
        } catch let error {
            completion(.failure(.decoder(error)))
        }
    }
    
}

protocol NetworkSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: NetworkSessionProtocol {}

enum APIError: LocalizedError {
    case urlError
    case decoder(Error)
    case data
    case dataError(Error)
    case response
}
