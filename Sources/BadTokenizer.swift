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
                var isEscaped = false

                while current < characters.count {
                    char = characters[current]

                    if isEscaped {
                        switch char {
                        case "n":
                            value.append("\n")
                        case "t":
                            value.append("\t")
                        case "u":
                            // unicode - grab the next 4 characters
                            let unicodeHex = String(jsonString[current + 1 ... current + 4])

                            if let scalar = UnicodeScalar(Int(unicodeHex, radix: 16)!) {
                                value.append(Character(scalar))
                            }

                            current += 4
                        default:
                            // For other escaped characters, just append
                            value.append(char)
                        }
                        isEscaped = false
                    } else if char == "\\" {
                        isEscaped = true
                    } else if char == "\"" {
                        break
                    } else {
                        value.append(char)
                    }

                    current += 1
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

extension StringProtocol {
    subscript(_ offset: Int) -> Element { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>) -> SubSequence { prefix(range.lowerBound + range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>) -> SubSequence { prefix(range.lowerBound + range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>) -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>) -> SubSequence { suffix(Swift.max(0, count - range.lowerBound)) }
}
