//
//  ViewModel.swift
//  Master's Advices
//
//  Created by Edgar Sgroi on 16/04/20.
//  Copyright © 2020 Edgar Sgroi. All rights reserved.
//

import Foundation
import UIKit

class ViewModel {
    
    let service = AdviceAPIService()
    var advice: String?
    var adviceChar: [Character]?
    
    init() {
    }
    
    func adviceRequest() {
        service.makeRequest({ (response) in
            switch response {
            case .success(let ads):
                self.advice = ads.slip.advice
                self.adviceChar = Array(self.advice!)
                NotificationCenter.default.post(name: .updateAdvice, object: nil)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        })
    }
}

extension Notification.Name {
    static let updateAdvice = Notification.Name("update_advice")
}
