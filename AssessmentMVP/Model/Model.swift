//
//  Model.swift
//  AssessmentMVP
//
//  Created by 10362 on 2024/2/7.
//

import Foundation

// MARK: - JSON Codable
struct Result: Codable {
    var id, name, position: String?
    var type: ResultType
    var expertise: [String]?
    var avatar: URL?
    var url: URL?
}
enum ResultType: String, Codable {
    case employee
    case banner
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
