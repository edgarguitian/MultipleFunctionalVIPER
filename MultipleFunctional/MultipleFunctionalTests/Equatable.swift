//
//  Equatable.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 29/1/24.
//
@testable import MultipleFunctional
extension Note: Equatable {
    public static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.titulo == rhs.titulo &&
        lhs.descripcion == rhs.descripcion
    }
}
