//
//  AdviceAPIService.swift
//  Master's Advices
//
//  Created by Edgar Sgroi on 16/04/20.
//  Copyright © 2020 Edgar Sgroi. All rights reserved.
//

import Foundation

class AdviceAPIService {
    
    func makeRequest(_ completion: @escaping (Result<Response, Error>) -> Void) {
        if let url = URL(string: "https://api.adviceslip.com/advice") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(Response.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(res))
                        }
                        
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}
