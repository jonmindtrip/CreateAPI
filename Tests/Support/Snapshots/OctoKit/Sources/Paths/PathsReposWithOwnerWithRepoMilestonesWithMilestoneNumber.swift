// Generated by Create API
// https://github.com/CreateAPI/CreateAPI

import Foundation
import Get
import HTTPHeaders
import URLQueryEncoder

extension Paths.Repos.WithOwner.WithRepo.Milestones {
    public func milestoneNumber(_ milestoneNumber: Int) -> WithMilestoneNumber {
        WithMilestoneNumber(path: "\(path)/\(milestoneNumber)")
    }

    public struct WithMilestoneNumber {
        /// Path: `/repos/{owner}/{repo}/milestones/{milestone_number}`
        public let path: String

        /// Get a milestone
        ///
        /// [API method documentation](https://docs.github.com/rest/reference/issues#get-a-milestone)
        public var get: Request<OctoKit.Milestone> {
            Request(method: "GET", url: path, id: "issues/get-milestone")
        }

        /// Update a milestone
        ///
        /// [API method documentation](https://docs.github.com/rest/reference/issues#update-a-milestone)
        public func patch(_ body: PatchRequest? = nil) -> Request<OctoKit.Milestone> {
            Request(method: "PATCH", url: path, body: body, id: "issues/update-milestone")
        }

        public struct PatchRequest: Encodable {
            /// The title of the milestone.
            public var title: String?
            /// The state of the milestone. Either `open` or `closed`.
            public var state: State?
            /// A description of the milestone.
            public var description: String?
            /// The milestone due date. This is a timestamp in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format: `YYYY-MM-DDTHH:MM:SSZ`.
            public var dueOn: Date?

            /// The state of the milestone. Either `open` or `closed`.
            public enum State: String, Codable, CaseIterable {
                case `open`
                case closed
            }

            public init(title: String? = nil, state: State? = nil, description: String? = nil, dueOn: Date? = nil) {
                self.title = title
                self.state = state
                self.description = description
                self.dueOn = dueOn
            }

            public func encode(to encoder: Encoder) throws {
                var values = encoder.container(keyedBy: StringCodingKey.self)
                try values.encodeIfPresent(title, forKey: "title")
                try values.encodeIfPresent(state, forKey: "state")
                try values.encodeIfPresent(description, forKey: "description")
                try values.encodeIfPresent(dueOn, forKey: "due_on")
            }
        }

        /// Delete a milestone
        ///
        /// [API method documentation](https://docs.github.com/rest/reference/issues#delete-a-milestone)
        public var delete: Request<Void> {
            Request(method: "DELETE", url: path, id: "issues/delete-milestone")
        }
    }
}