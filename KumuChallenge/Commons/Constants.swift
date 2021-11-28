//
//  Constants.swift
//  KumuChallenge
//
//  Created by Jc on 10/2/21.
//

import UIKit

enum ResultError: Error {
    case saveError(error: Error?)
    case contextError(error: Error?)
    
    var description: String {
        switch self {
        case .saveError(let error):
            return error?.localizedDescription ?? "Saving error"
        case .contextError(let error):
            return error?.localizedDescription ?? "Context error"
        }
    }
}

typealias VoidClosure = (()->())
typealias ResultClosure = ((Result<Any?, ResultError>)->())

let bgColor = UIColor(hexString: "16142B")
