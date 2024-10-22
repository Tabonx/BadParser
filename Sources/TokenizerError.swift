//
//  TokenizerError.swift
//  BadParser
//
//  Created by Pavel Kroupa on 22.10.2024.
//

public enum TokenizerError: Error {
    case unknownValue(String)
    case invalidEscapeSequence
}
