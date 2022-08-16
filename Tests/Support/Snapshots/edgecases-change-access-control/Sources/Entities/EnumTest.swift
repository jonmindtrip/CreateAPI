// Generated by Create API
// https://github.com/CreateAPI/CreateAPI

import Foundation
import NaiveDate

struct EnumTest: Codable {
    var enumString: EnumString?
    var enumInteger: Int32?
    var enumNumber: Double?
    var outerEnum: OuterEnum?

    enum EnumString: String, Codable, CaseIterable {
        case upper = "UPPER"
        case lower
        case empty = ""
    }

    init(enumString: EnumString? = nil, enumInteger: Int32? = nil, enumNumber: Double? = nil, outerEnum: OuterEnum? = nil) {
        self.enumString = enumString
        self.enumInteger = enumInteger
        self.enumNumber = enumNumber
        self.outerEnum = outerEnum
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: StringCodingKey.self)
        self.enumString = try values.decodeIfPresent(EnumString.self, forKey: "enum_string")
        self.enumInteger = try values.decodeIfPresent(Int32.self, forKey: "enum_integer")
        self.enumNumber = try values.decodeIfPresent(Double.self, forKey: "enum_number")
        self.outerEnum = try values.decodeIfPresent(OuterEnum.self, forKey: "outerEnum")
    }

    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: StringCodingKey.self)
        try values.encodeIfPresent(enumString, forKey: "enum_string")
        try values.encodeIfPresent(enumInteger, forKey: "enum_integer")
        try values.encodeIfPresent(enumNumber, forKey: "enum_number")
        try values.encodeIfPresent(outerEnum, forKey: "outerEnum")
    }
}