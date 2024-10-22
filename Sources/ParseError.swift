//
//  ParseError.swift
//  BadParser
//
//  Created by Pavel Kroupa on 22.10.2024.
//

public enum ParseError: Error {
    case unexpectedToken(Token)
    case invalidValue(Token)
    case expectedToken(String)
    case missingToken
}
