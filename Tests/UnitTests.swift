//
//  UnitTests.swift
//  BadParser
//
//  Created by Pavel Kroupa on 22.10.2024.
//

@testable import BadParser
import Foundation
import Testing

class BadParserTests {
    @Test("Valid JSON Tests", .timeLimit(.minutes(4)), arguments: validJSONCases)
    func validJSON(_ json: String) async throws {
        #expect(throws: Never.self) {
            let tokens = try BadTokenizer().tokenize(json)
            _ = try BadParser().parse(tokens)
        }
    }

    @Test("Malformed JSON Tests", arguments: malformedJSONCases)
    func malformedLocalJSON(_ json: String) async throws {
        #expect(throws: (any Error).self) {
            let tokens = try BadTokenizer().tokenize(json)
            _ = try BadParser().parse(tokens)
        }
    }

    @Test("Escaped characters Tests")
    func escapedCharacters() async throws {
        let string = Bundle.module.url(forResource: "EscapedString", withExtension: "json", subdirectory: "TestData")!

        let json = try String(contentsOf: string, encoding: .utf8)

        let tokens = try BadTokenizer().tokenize(json)
        let parsed = try BadParser().parse(tokens)

        let node = Node.object(value: [
            "message": .string(value: "This is a test string with a quote: \" and a backslash: \\"),
            "path": .string(value: "C:\\Users\\Name\\Documents"),
            "newline": .string(value: "This string contains a newline character.\nSee?"),
            "tab": .string(value: "This string contains a tab character.\tTabbed in."),
            "unicode": .string(value: "This string contains a unicode character: \u{263A}"),
            "backslashes": .string(value: "Multiple backslashes: \\\\"),
            "quotes": .string(value: "A quote inside: \"hello\""),
        ])
        #expect(node == parsed)
    }
}

let escapedPaths: [String] = [
    "EscapedString",
]

let malformedJSONCases: [String] = [
    // Trailing comma in object
    """
    { "name": "John", "age": 30, }
    """,

    // Trailing comma in array
    """
    [1, 2, 3, ]
    """,

    // Unclosed object
    """
    { "name": "John", "age": 30
    """,

    // Unclosed array
    """
    [1, 2, 3
    """,

    // Missing comma between object properties
    """
    { "name": "John" "age": 30 }
    """,

    // Missing comma between array elements
    """
    [1 2, 3]
    """,

    // Missing key in object
    """
    { "name": "John", : 30 }
    """,

    // Missing value in object
    """
    { "name": "John", "age": }
    """,

    // Invalid value (non-quoted string)
    """
    { "name": John, "age": 30 }
    """,

    // Extra closing brace in object
    """
    { "name": "John", "age": 30 }} 
    """,

    // Extra closing bracket in array
    """
    [1, 2, 3]] 
    """,

    // Single quotes for string keys and values (JSON requires double quotes)
    """
    { 'name': 'John', 'age': 30 }
    """,

    // Using `undefined` instead of `null` or a valid value
    """
    { "name": undefined }
    """,

    // Using single equals instead of colon
    """
    { "name" = "John", "age": 30 }
    """,

    // Comma without a value
    """
    { "name": "John",, "age": 30 }
    """,
]

let validJSONCases: [String] = [
    // Simple object with different data types
    """
    { "name": "John", "age": 30, "isDeveloper": true }
    """,

    // Empty object
    """
    { }
    """,

    // Simple array of numbers
    """
    [1, 2, 3]
    """,

    // Empty array
    """
    []
    """,

    // Nested objects
    """
    {
      "person": {
        "name": "John",
        "address": {
          "city": "New York",
          "zipcode": 10001
        }
      }
    }
    """,

    // Nested arrays
    """
    {
      "numbers": [ [1, 2], [3, 4], [5, 6] ]
    }
    """,

    // Array of mixed types
    """
    [1, "string", null, true, { "key": "value" }]
    """,

    // Object with escaped characters
    """
    { "text": "This is a string with a newline\\n and a tab\\t" }
    """,

    // Object with null value
    """
    { "name": "John", "age": null }
    """,

    // Array with different data types
    """
    [1, "two", false, null]
    """,

    // Object with a boolean value
    """
    { "isActive": true, "hasNotifications": false }
    """,

    // Object with unicode characters
    """
    { "emoji": "😊", "language": "日本語" }
    """,

    // Large numbers in an object
    """
    { "bigNumber": 1234567890123456789 }
    """,

    // Object with special characters in strings
    """
    { "quote": "He said, \\\"Hello World!\\\"" }
    """,

    // Array with only one element
    """
    [42]
    """,

    // Boolean array
    """
    [true, false, true]
    """,

    // Object with nested arrays and objects
    """
    {
      "items": [
        { "id": 1, "name": "Item 1" },
        { "id": 2, "name": "Item 2" }
      ]
    }
    """,

    // Object with number in string format
    """
    { "phoneNumber": "123-456-7890" }
    """,

    // Object with decimal numbers
    """
    { "price": 19.99, "discount": 0.15 }
    """,

    // Object with an array of objects
    """
    { "users": [
        { "id": 1, "name": "John" },
        { "id": 2, "name": "Jane" }
      ]
    }
    """,
]
