//
//  TokenType.swift
//  BadParser
//
//  Created by Pavel Kroupa on 22.10.2024.
//

public enum TokenType: String, Sendable {
    case braceOpen
    case braceClose
    case bracketOpen
    case bracketClose
    case string
    case number
    case comma
    case colon
    case `true`
    case `false`
    case null
}
