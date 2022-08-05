// Generated by Create API
// https://github.com/CreateAPI/CreateAPI

import Foundation
import NaiveDate

/// The status of auto merging a pull request.
public struct AutoMerge: Codable {
    /// Simple User
    public var enabledBy: SimpleUser
    /// The merge method to use.
    public var mergeMethod: MergeMethod
    /// Title for the merge commit message.
    public var commitTitle: String
    /// Commit message for the merge commit.
    public var commitMessage: String

    /// The merge method to use.
    public enum MergeMethod: String, Codable, CaseIterable {
        case merge
        case squash
        case rebase
    }

    public init(enabledBy: SimpleUser, mergeMethod: MergeMethod, commitTitle: String, commitMessage: String) {
        self.enabledBy = enabledBy
        self.mergeMethod = mergeMethod
        self.commitTitle = commitTitle
        self.commitMessage = commitMessage
    }

    private enum CodingKeys: String, CodingKey {
        case enabledBy = "enabled_by"
        case mergeMethod = "merge_method"
        case commitTitle = "commit_title"
        case commitMessage = "commit_message"
    }
}