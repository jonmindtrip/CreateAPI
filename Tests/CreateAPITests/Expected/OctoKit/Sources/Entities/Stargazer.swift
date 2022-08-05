// Generated by Create API
// https://github.com/CreateAPI/CreateAPI

import Foundation
import NaiveDate

public struct Stargazer: Codable {
    public var starredAt: Date
    /// Simple User
    public var user: SimpleUser?

    public init(starredAt: Date, user: SimpleUser? = nil) {
        self.starredAt = starredAt
        self.user = user
    }

    private enum CodingKeys: String, CodingKey {
        case starredAt = "starred_at"
        case user
    }
}