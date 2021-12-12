// Generated by Create API
// https://github.com/kean/CreateAPI
//
// swiftlint:disable all

import Foundation
import APIClient
import HTTPHeaders

public enum Paths {}

extension Paths {
    public static var pets: Pets {
        Pets(path: "/pets")
    }

    public struct Pets {
        /// Path: `/pets`
        public let path: String

        /// List all pets
        public func get(parameters: GetParameters) -> Request<petstore_disable_inlining.Pets> {
            .get(path, query: parameters.asQuery())
        }

        public enum GetResponseHeaders {
            /// A link to the next page of responses
            public static let next = HTTPHeader<String>(field: "x-next")
        }

        public struct GetParameters {
            public var limit: Int?

            public init(limit: Int? = nil) {
                self.limit = limit
            }

            public func asQuery() -> [String: String?] {
                var query: [String: String?] = [:]
                if let limit = self.limit {
                    query["limit"] = limit.description
                }
                return query
            }
        }
    }
}

extension Paths.Pets {
    public func petID(_ petID: String) -> WithPetID {
        WithPetID(path: path + "/" + petID)
    }

    public struct WithPetID {
        /// Path: `/pets/{petId}`
        public let path: String

        /// Info for a specific pet
        public func get() -> Request<Pet> {
            .get(path)
        }
    }
}

