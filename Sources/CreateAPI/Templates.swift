// The MIT License (MIT)
//
// Copyright (c) 2021 Alexander Grebenyuk (github.com/kean).

import OpenAPIKit30
import Foundation

// TODO: When parsing additionalProperties remove known keys
final class Templates {
    let options: GenerateOptions
    
    var access: String { options.access.isEmpty ? "" :  options.access + " " }
    
    init(options: GenerateOptions) {
        self.options = options
    }

    var fileHeader: String {
        if let header = options.fileHeader.header {
            return header
        }
        
        var output = """
        // Generated by Create API
        // https://github.com/kean/CreateAPI
        """
        
        if options.fileHeader.addSwiftLintDisabled {
            output += "\n"
            output += """
            //
            // swiftlint:disable all
            """
        }

        output += "\n\nimport Foundation"
        
        return output
    }
    
    // MARK: Entity
    
    /// Generates an entity declaration:
    ///
    ///     public struct <name>: Decodable {
    ///         <contents>
    ///     }
    func entity(name: TypeName, contents: [String], protocols: [String]) -> String {
        let isStruct = (options.schemes.isGeneratingStructs && !options.schemes.entitiesGeneratedAsClasses.contains(name.rawValue)) || (options.schemes.entitiesGeneratedAsStructs.contains(name.rawValue))
        let type = isStruct ? "struct" : (options.schemes.isMakingClassesFinal ? "final class" : "class")
        let lhs = [options.access, type, name.rawValue]
            .compactMap { $0 }.joined(separator: " ")
        let rhs = ([isStruct ? nil : options.schemes.baseClass] + protocols)
            .compactMap { $0 }.joined(separator: ", ")

        let declaration = rhs.isEmpty ? lhs : "\(lhs): \(rhs)"
        
        return """
        \(declaration) {
        \(contents.joined(separator: "\n\n").indented)
        }
        """
    }
    
    // MARK: Enum
    
    func enumOneOf(name: TypeName, contents: [String], isHashable: Bool) -> String {
        var protocols = options.schemes.adoptedProtocols
        if isHashable { protocols.insert("Hashable") }
        return """
        \(access)enum \(name): \(protocols.sorted().joined(separator: ", ")) {
        \(contents.joined(separator: "\n\n").indented)
        }
        """
    }
        
    func `case`(property: Property) -> String {
        "case \(property.name)(\(property.type))"
    }
    
    func `case`(name: String, value: String) -> String {
        if name.trimmingCharacters(in: CharacterSet.ticks) != value {
            return "case \(name) = \"\(value)\""
        } else {
            return "case \(name)"
        }
    }
    
    func enumOfStrings(name: TypeName, contents: String) -> String {
        return """
        \(access)enum \(name): String, Codable, CaseIterable {
        \(contents.indented)
        }
        """
    }
    
    // MARK: Query Parameters
    
    func toQueryParameters(properties: [Property]) -> String {
        let statements: [String] = properties.map {
            if $0.isOptional {
                return """
                if let \($0.name) = self.\($0.name.accessor) {
                    query["\($0.key)"] = \($0.name).description
                }
                """
            } else {
                return "query[\"\($0.key)\"] = self.\($0.name.accessor).description"
            }
        }
        return """
        \(access)func asQuery() -> [String: String?] {
            var query: [String: String?] = [:]
        \(statements.joined(separator: "\n").indented)
            return query
        }
        """
    }
    
    // MARK: Init
    
    func initializer(properties: [Property]) -> String {
        guard !properties.isEmpty else {
            return "public init() {}"
        }
        let statemenets = properties.map {
            "self.\($0.name.accessor) = \($0.name)"
        }.joined(separator: "\n")
        let arguments = properties.map {
            "\($0.name): \($0.type)\($0.isOptional ? "? = nil" : "")"
        }.joined(separator: ", ")
        return """
        \(access)init(\(arguments)) {
        \(statemenets.indented)
        }
        """
    }
    
    // MARK: Decodable
    
    func decode(properties: [Property]) -> String {
        properties.map(decode).joined(separator: "\n")
    }
    
    /// Generates a decode statement.
    ///
    ///     self.id = values.decode(Int.self, forKey: "id")
    func decode(property: Property) -> String {
        let decode = property.isOptional ? "decodeIfPresent" : "decode"
        return "self.\(property.name.accessor) = try values.\(decode)(\(property.type).self, forKey: \"\(property.key)\")"
    }
    
    /// Generated decoding of the directly inlined nested object.
    ///
    ///     self.animal = try Animal(from: decoder)
    func decodeFromDecoder(property: Property) -> String {
        "self.\(property.name.accessor) = try \(property.type)(from: decoder)"
    }
    
    func initFromDecoder(properties: [Property]) -> String {
        initFromDecoder(contents: decode(properties: properties))
    }
    
    func initFromDecoder(contents: String) -> String {
        """
        \(access)init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: StringCodingKey.self)
        \(contents.indented)
        }
        """
    }
    
    func initFromDecoderAnyOf(properties: [Property]) -> String {
        let contents = properties.map {
            "self.\($0.name.accessor) = try? container.decode(\($0.type).self)"
        }.joined(separator: "\n")
        return """
        \(access)init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
        \(contents.indented)
        }
        """
    }
    
    func initFromDecoderOneOf(properties: [Property]) -> String {
        var statements = ""
        for property in properties {
            statements += """
            if let value = try? container.decode(\(property.type).self) {
                self = .\(property.name)(value)
            } else
            """
            statements += " "
        }
        
        statements += """
        {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Failed to intialize `oneOf`")
        }
        """
        
        return """
        \(access)init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
        \(statements.indented)
        }
        """
    }
    
    func encodeOneOf(properties: [Property]) -> String {
        let statements = properties.map {
            "case .\($0.name)(let value): try container.encode(value)"
        }
        return """
        \(access)func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
        \(statements.joined(separator: "\n").indented)
            }
        }
        """
    }
    
    // MARK: Encodable
    
    func encode(properties: [Property]) -> String {
        let contents = properties.map {
            let encode = $0.isOptional ? "encodeIfPresent" : "encode"
            return "try values.\(encode)(\($0.name), forKey: \"\($0.key)\")"
        }.joined(separator: "\n")
        
        return """
        \(access)func encode(to encoder: Encoder) throws {
            var values = encoder.container(keyedBy: StringCodingKey.self)
        \(contents.indented)
        }
        """
    }
    
    // MARK: Properties
    
    /// Generates a list of properties.
    func properties(_ properties: [Property]) -> String {
        properties.map(property).joined(separator: "\n")
    }
    
    /// Generates a property with comments and everything.
    ///
    ///     public var files: [Files]?
    func property(_ property: Property) -> String {
        var output = ""
        if let context = property.context {
            output += comments(for: context, name: property.name.rawValue)
        }
        output += "\(access)var \(property.name): \(property.type)\(property.isOptional ? "?" : "")"
        return output
    }
    
    // MARK: Typealias
    
    func `typealias`(name: DeclarationName, type: DeclarationName) -> String {
        "\(access)typealias \(name) = \(type)"
    }
    
    // MARK: Comments
    
    /// Generates inline comments for a declaration containing a title, description, and examples.
    func comments(for context: JSONSchemaContext, name: String) -> String {
        let options = options.comments
        guard options.isEnabled else {
            return ""
        }
        var output = ""
        
        var title = context.title ?? ""
        var description = context.description ?? ""
        if title == description && options.addTitle && options.addDescription {
            description = ""
        }
        if title.components(separatedBy: .whitespaces).joined(separator: "").caseInsensitiveCompare(name) == .orderedSame {
            title = ""
        }
        
        if options.addTitle, !title.isEmpty {
            let title = options.capitilizeTitle ? title.capitalizingFirstLetter() : title
            output += "/// \(title)\n"
        }
        if options.addDescription, !description.isEmpty, description != context.title {
            if !output.isEmpty {
                output += "///\n"
            }
            let description = options.capitilizeDescription ? description.capitalizingFirstLetter() : description
            for line in description.lines {
                output += "/// \(line)\n"
            }
        }
        if options.addExamples, let example = context.example?.value {
            let value: String
            if JSONSerialization.isValidJSONObject(example) {
                let data = try? JSONSerialization.data(withJSONObject: example, options: [.prettyPrinted, .sortedKeys])
                value = String(data: data ?? Data(), encoding: .utf8) ?? ""
            } else {
                value = "\(example)"
            }
            if value.count > 1 { // Only display if it's something substantial
                if !output.isEmpty {
                    output += "///\n"
                }
                let lines = value.lines
                if lines.count == 1 {
                    output += "/// Example: \(value)\n"
                } else {
                    output += "/// Example:\n///\n"
                    for line in lines {
                        output += "/// \(line)\n"
                    }
                }
            }
        }
        return output
    }
    
    // MARK: Method
    
    func method(name: String, parameters: [String] = [], returning type: String, contents: String) -> String {
        """
        \(access)func \(name)(\(parameters.joined(separator: ", "))) -> \(type) {
        \(contents.indented)
        }
        """
    }
    
    // MARK: Headers

    func headers(name: String, contents: String) -> String {
        """
        \(access)enum \(name) {
        \(contents.indented)
        }
        """
    }
    
    func header(for property: Property, header: OpenAPI.Header) -> String {
        var name = property.name.rawValue
        if (property.key.hasPrefix("x-") || property.key.hasPrefix("X-")) {
            name = PropertyName(String(property.key.dropFirst(2)), options: options).rawValue
        }
        var output = ""
        if options.comments.isEnabled, options.comments.addDescription,
           let description = header.description, !description.isEmpty {
            let description = options.comments.capitilizeDescription ? description.capitalizingFirstLetter() : description
            for line in description.lines {
                output += "/// \(line)\n"
            }
        }
        if options.isAddingDeprecations, header.deprecated {
            output += deprecated
        }
        output += """
        \(access)static let \(name) = HTTPHeader<\(property.type)>(field: \"\(property.key)\")
        """
        return output
    }
    
    // MARK: Misc
    
    var deprecated: String {
        #"@available(*, deprecated, message: "Deprecated")"# + "\n"
    }
    
    var requestOperationIdExtension: String {
       """
       extension Request {
           private func id(_ id: String) -> Request {
               var copy = self
               copy.id = id
               return copy
           }
       }
       """
    }
}

extension String {
    var indented: String {
        indented(count: 1)
    }
    
    func indented(count: Int) -> String {
        lines
            .map { $0.isEmpty ? $0 : String(repeating: " ", count: count * 4) + $0 }
            .joined(separator: "\n")
    }
}

extension String {
    // Unlike `components(separatedBy: "\n")`, it keeps empty lines.
    var lines: [String] {
        var lines: [String] = []
        var index = startIndex
        while let newLineIndex = self[index...].firstIndex(of: "\n") {
            lines.append(String(self[index..<newLineIndex]))
            index = self.index(after: newLineIndex)
        }
        lines.append(String(self[index...]))
        return lines
    }
}
