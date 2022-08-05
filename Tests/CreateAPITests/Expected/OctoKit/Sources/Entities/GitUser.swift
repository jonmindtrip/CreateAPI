// Generated by Create API
// https://github.com/CreateAPI/CreateAPI

import Foundation
import NaiveDate

/// Metaproperties for Git author/committer information.
public struct GitUser: Codable {
    /// Example: "Chris Wanstrath"
    public var name: String?
    /// Example: "chris@ozmm.org"
    public var email: String?
    /// Example: "2007-10-29T02:42:39.000-07:00"
    public var date: String?

    public init(name: String? = nil, email: String? = nil, date: String? = nil) {
        self.name = name
        self.email = email
        self.date = date
    }
}