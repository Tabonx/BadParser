//
//  Node.swift
//  BadParser
//
//  Created by Pavel Kroupa on 22.10.2024.
//

public enum Node: Equatable {
    indirect case object(value: [String: Node])
    indirect case array(elements: [Node])
    case string(value: String)
    case number(value: Double)
    case bool(value: Bool)
    case null
}
