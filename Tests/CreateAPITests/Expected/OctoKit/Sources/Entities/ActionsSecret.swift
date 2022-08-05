// Generated by Create API
// https://github.com/CreateAPI/CreateAPI

import Foundation
import NaiveDate

/// Set secrets for GitHub Actions.
public struct ActionsSecret: Codable {
    /// The name of the secret.
    ///
    /// Example: "SECRET_TOKEN"
    public var name: String
    public var createdAt: Date
    public var updatedAt: Date

    public init(name: String, createdAt: Date, updatedAt: Date) {
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}