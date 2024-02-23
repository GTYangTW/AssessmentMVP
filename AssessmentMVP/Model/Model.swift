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
/*
struct Employee: Decodable {
    let id: String
    let name: String
    let position: String
    let expertise: [String]
    let avatar: URL
}
struct Banner: Decodable {
    let url: URL
}

enum Result: Decodable {
    case employee(Employee)
    case banner(Banner)

    private enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "employee":
            self = .employee(try Employee(from: decoder))
        case "banner":
            self = .banner(try Banner(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown type")
        }
    }
}
 

// 定義根模型
struct DataJson: Decodable {
    let results: [Result]
}
 */
// MARK: - TableView enum case（向上類型整合）
/*
enum Result: Decodable {
    case employee(id: String, name: String, position: String, type: String, expertise: [String], avatar: URL)
    case banner(type: String, url: URL)

    //
    private enum CodingKeys: String, CodingKey {
        case id, name, position, type, expertise, avatar, url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decodeIfPresent(String.self, forKey: .id)
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let position = try container.decodeIfPresent(String.self, forKey: .position)
        let type = try container.decode(String.self, forKey: .type)
        let expertise = try container.decodeIfPresent([String].self, forKey: .expertise)
        let avatar = try container.decodeIfPresent(URL.self, forKey: .avatar)
        let url = try container.decodeIfPresent(URL.self, forKey: .url)
        
        switch type {
        case .employee:
            self = .employee(id: id, name: name, position: position, type: type, expertise: expertise, avatar: avatar)
        case .banner:
            self = .banner(type: type, url: url)
        }
    }
}

enum DataJson: Decodable {
    case regular(results: [Result])

    private enum CodingKeys: String, CodingKey {
        case results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let results = try container.decode([Result].self, forKey: .results)

        self = .regular(results: results)
    }
}
*/
