//
//  UserModel.swift
//  test_abz
//
//  Created by Anton on 18.09.2024.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let positionId: Int
    let registrationTimestamp: Int
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, position, photo
        case positionId = "position_id"
        case registrationTimestamp = "registration_timestamp"
    }
}

struct UsersResponse: Codable {
    let success: Bool
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let page: Int
    let links: Links
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case success, totalPages = "total_pages", totalUsers = "total_users", count, page, links, users
    }
    
    struct Links: Codable {
        let nextUrl: String?
        let prevUrl: String?
        
        enum CodingKeys: String, CodingKey {
            case nextUrl = "next_url"
            case prevUrl = "prev_url"
        }
    }
}

struct UserResponse: Codable {
    let success: Bool
    let message: String
    let user: User?
}

struct Position: Decodable {
    let id: Int
    let name: String
}

struct PositionResponse: Decodable {
    let success: Bool
    let positions: [Position]
}
