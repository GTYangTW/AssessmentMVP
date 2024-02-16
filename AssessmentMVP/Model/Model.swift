//
//  Model.swift
//  AssessmentMVP
//
//  Created by 10362 on 2024/2/7.
//

import Foundation

struct Result: Codable {
    var id, name, position: String?
    var type: String
    var expertise: [String]?
    var avatar: URL?
    var url: URL?
}

struct DataJson: Codable {
    var results: [Result]
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

enum NetworkConnectionStatus: String {
    case online
    case offline
}
