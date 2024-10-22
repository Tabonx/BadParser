//
//  BadTokenizer.swift
//  BadParser
//
//  Created by Pavel Kroupa on 22.10.2024.
//

public struct BadTokenizer {
    public init() {}

    public func tokenize(_ jsonString: String) throws -> [Token] {
        var current = 0
        var tokens: [Token] = []
        let characters = Array(jsonString)

        while current < characters.count {
            var char = characters[current]

            if char.isWhitespace {
                current += 1
                continue
            }

            if char == "{" {
                tokens.append(Token(type: .braceOpen, value: String(char)))
                current += 1
                continue
            }
            if char == "}" {
                tokens.append(Token(type: .braceClose, value: String(char)))
                current += 1
                continue
            }
            if char == "[" {
                tokens.append(Token(type: .bracketOpen, value: String(char)))
                current += 1
                continue
            }
            if char == "]" {
                tokens.append(Token(type: .bracketClose, value: String(char)))
                current += 1
                continue
            }
            if char == ":" {
                tokens.append(Token(type: .colon, value: String(char)))
                current += 1
                continue
            }
            if char == "," {
                tokens.append(Token(type: .comma, value: String(char)))
                current += 1
                continue
            }

            if char == "\"" {
                var value = ""
                current += 1
                char = characters[current]

                while char != "\"", current < characters.count {
                    value.append(char)

                    current += 1
                    char = characters[current]
                }

                current += 1
                tokens.append(Token(type: .string, value: String(value)))
                continue
            }

            if char.isNumber || char.isLetter {
                var value = String(char)
                current += 1
                if characters.indices ~= current {
                    char = characters[current]
                } else {
                    throw ParseError.missingToken
                }

                while current < characters.count, char.isNumber || char.isLetter || char == "." {
                    value.append(char)
                    current += 1
                    if characters.indices ~= current {
                        char = characters[current]
                    } else {
                        throw ParseError.missingToken
                    }
                }

                let stringValue = String(value)

                if isNumber(stringValue) {
                    tokens.append(Token(type: .number, value: stringValue))
                } else if isBooleanTrue(stringValue) {
                    tokens.append(Token(type: .true, value: stringValue))
                } else if isBooleanFalse(stringValue) {
                    tokens.append(Token(type: .false, value: stringValue))
                } else if isNull(stringValue) {
                    tokens.append(Token(type: .null, value: stringValue))

                } else {
                    throw TokenizerError.unknownValue(stringValue)
                }

                continue
            }

            current += 1
        }

        return tokens
    }
}
