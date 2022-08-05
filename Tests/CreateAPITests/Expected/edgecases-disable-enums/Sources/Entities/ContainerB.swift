// Generated by Create API
// https://github.com/CreateAPI/CreateAPI

import Foundation
import NaiveDate

public struct ContainerB: Codable {
    public var child: Child

    public struct Child: Codable {
        public var `enum`: String
        public var renameMe: String
        public var child: Child

        public struct Child: Codable {
            public var `enum`: String
            public var renameMe: String

            public init(`enum`: String, renameMe: String) {
                self.enum = `enum`
                self.renameMe = renameMe
            }

            private enum CodingKeys: String, CodingKey {
                case `enum`
                case renameMe = "rename-me"
            }
        }

        public init(`enum`: String, renameMe: String, child: Child) {
            self.enum = `enum`
            self.renameMe = renameMe
            self.child = child
        }

        private enum CodingKeys: String, CodingKey {
            case `enum`
            case renameMe = "rename-me"
            case child
        }
    }

    public init(child: Child) {
        self.child = child
    }
}