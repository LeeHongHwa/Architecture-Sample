//
//  ModelType.swift
//  MVP-Sample
//
//  Created by lyhonghwa on 2018. 8. 1..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//
import UIKit

typealias JSONObject = [String: Any]

protocol ModelType {
    init(json: JSONObject)
}
