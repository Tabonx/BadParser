//
//  Tokenizer+Utils.swift
//  BadParser
//
//  Created by Pavel Kroupa on 22.10.2024.
//

extension BadTokenizer {
    func isNumber(_ value: String) -> Bool {
        return Double(value) != nil
    }

    func isBooleanTrue(_ value: String) -> Bool {
        return value == "true"
    }

    func isBooleanFalse(_ value: String) -> Bool {
        return value == "false"
    }

    func isNull(_ value: String) -> Bool {
        return value == "null"
    }
}
