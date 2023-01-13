//
//  Optional+Extention.swift
//  Walley
//
//  Created by Pavel Sharkov on 01.05.2022.
//

public extension Optional {
    func `do`(_ action: (Wrapped) -> Void) {
        map(action)
    }
}

public extension Optional where Wrapped == String {
    var orEmpty: String { self ?? "" }
}
