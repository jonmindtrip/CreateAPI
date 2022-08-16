// Generated by Create API
// https://github.com/CreateAPI/CreateAPI

import Foundation
import NaiveDate

public struct Order: Codable {
    public var identifier: Int64?
    public var petID: Int64?
    public var quantity: Int32?
    public var shipDate: Date?
    /// Order Status
    public var status: Status?
    public var isDone: Bool

    /// Order Status
    public enum Status: String, Codable, CaseIterable {
        case placed
        case approved
        case delivered
    }

    public init(identifier: Int64? = nil, petID: Int64? = nil, quantity: Int32? = nil, shipDate: Date? = nil, status: Status? = nil, isDone: Bool? = nil) {
        self.identifier = identifier
        self.petID = petID
        self.quantity = quantity
        self.shipDate = shipDate
        self.status = status
        self.isDone = isDone ?? false
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: StringCodingKey.self)
        self.identifier = try values.decodeIfPresent(Int64.self, forKey: "id")
        self.petID = try values.decodeIfPresent(Int64.self, forKey: "petId")
        self.quantity = try values.decodeIfPresent(Int32.self, forKey: "quantity")
        self.shipDate = try values.decodeIfPresent(Date.self, forKey: "shipDate")
        self.status = try values.decodeIfPresent(Status.self, forKey: "status")
        self.isDone = try values.decodeIfPresent(Bool.self, forKey: "complete") ?? false
    }

    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: StringCodingKey.self)
        try values.encodeIfPresent(identifier, forKey: "id")
        try values.encodeIfPresent(petID, forKey: "petId")
        try values.encodeIfPresent(quantity, forKey: "quantity")
        try values.encodeIfPresent(shipDate, forKey: "shipDate")
        try values.encodeIfPresent(status, forKey: "status")
        try values.encodeIfPresent(isDone, forKey: "complete")
    }
}