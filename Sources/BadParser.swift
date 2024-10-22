//
//  BadParser.swift
//  BadParser
//
//  Created by Pavel Kroupa on 22.10.2024.
//

public struct BadParser {
    public init() {}

    public func parse(_ json: String) throws -> Node {
        let tokenizer = BadTokenizer()
        let tokens = try tokenizer.tokenize(json)

        return try parse(tokens)
    }

    public func parse(_ tokens: [Token]) throws -> Node {
        if tokens.isEmpty {
            return .null
        }

        var current = 0

        func advance() throws -> Token {
            current += 1
            if tokens.indices ~= current {
                return tokens[current]
            } else {
                throw ParseError.missingToken
            }
        }

        func parseObject() throws -> Node {
            var object: [String: Node] = [:]
            var token = try advance() // Advance to the first token

            if token.type == .braceClose {
                return .object(value: [:])
            }

            while true {
                guard token.type == .string else {
                    throw ParseError.unexpectedToken(token) // Expect a string for the key
                }

                let key = token.value
                token = try advance()

                if token.type != .colon {
                    throw ParseError.expectedToken("Expected ':' in key-value pair")
                }

                token = try advance() // Move past the colon

                // Parse the value associated with the key
                let value = try parseValue()
                object[key] = value

                token = try advance()

                // If the next token is a closing brace, we're done with the object
                if token.type == .braceClose {
                    break
                }

                // If the next token is not a comma, it's invalid (i.e. missing comma)
                if token.type != .comma {
                    throw ParseError.unexpectedToken(token) // Missing comma between key-value pairs
                }

                // Advance past the comma
                token = try advance()

                // Check for trailing comma by verifying that the token after the comma is not the closing brace
                if token.type == .braceClose {
                    throw ParseError.unexpectedToken(token) // Trailing comma is not allowed
                }
            }

            return .object(value: object)
        }

        func parseArray() throws -> Node {
            var elements = [Node]()
            var token = try advance() // Eat '{'

            // Check for empty array case
            if token.type == .bracketClose {
                return .array(elements: elements)
            }

            while true {
                let value = try parseValue()
                elements.append(value)

                token = try advance()

                // If we encounter a closing bracket, we're done with the array
                if token.type == .bracketClose {
                    break
                }

                // If the next token is not a comma, throw an error (i.e. missing comma case)
                if token.type != .comma {
                    throw ParseError.unexpectedToken(token)
                }

                // Advance after the comma to the next value
                token = try advance()

                // Ensure that after the comma, a value follows, not the closing bracket
                if token.type == .bracketClose {
                    throw ParseError.unexpectedToken(token) // Trailing comma
                }
            }

            return .array(elements: elements)
        }

        func parseValue() throws -> Node {
            let token = tokens[current]

            switch token.type {
            case .braceOpen:
                return try parseObject()
            case .bracketOpen:
                return try parseArray()
            case .string:
                return .string(value: token.value)
            case .number:
                if let number = Double(token.value) {
                    return .number(value: number)
                } else {
                    throw ParseError.invalidValue(token)
                }
            case .true:
                return .bool(value: true)
            case .false:
                return .bool(value: false)
            case .null:
                return .null
            default:
                throw ParseError.unexpectedToken(token)
            }
        }

        let nodes = try parseValue()
        if current != tokens.count - 1 {
            throw ParseError.missingToken
        }

        return nodes
    }
}
