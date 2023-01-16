//
//  Command.swift
//  Wallpaper
//
//  Created by Pavel Sharkov on 01.05.2022.
//

import Foundation

final class Command {
    init(id: String = "unnamed",
        file: StaticString = #file,
        function: StaticString = #function,
        line: Int = #line,
        action: @escaping () -> Void) {
        self.id = id
        self.action = action
        self.function = function
        self.file = file
        self.line = line
    }

    private let file: StaticString
    private let function: StaticString
    private let line: Int
    private let id: String
    private let action: () -> Void

    func dispatched(on queue: DispatchQueue) -> Command {
        return Command {
            queue.async {
                self.perform()
            }
        }
    }

    func dispatch() {
        action()
    }

    func perform() {
        action()
    }

    static let nop = Command {}
    
    @objc
    func debugQuickLookObject() -> AnyObject? {
        return """
        type: \(String(describing: type(of: self)))
        id: \(id)
        file: \(file)
        function: \(function)
        line: \(line)
        """ as NSString
    }
}

extension Command: Codable {
    convenience init(from _: Decoder) throws {
        self.init {}
    }

    func encode(to _: Encoder) throws {}
}

final class CommandWith<T> {
    init(_ action: @escaping (T) -> Void) {
        self.action = action
    }

    let action: (T) -> Void

    func perform(with value: T) {
        action(value)
    }

    func bind(to value: T) -> Command {
        return Command { self.perform(with: value) }
    }

    static var nop: CommandWith {
        return CommandWith { _ in }
    }

    func dispatched(on queue: DispatchQueue) -> CommandWith {
        return CommandWith { value in
            queue.async {
                self.perform(with: value)
            }
        }
    }

    func then(_ another: CommandWith) -> CommandWith {
        return CommandWith { value in
            self.perform(with: value)
            another.perform(with: value)
        }
    }
}

extension Command: Equatable {
    static func == (_: Command, _: Command) -> Bool {
        return true
    }
}

extension CommandWith: Equatable {
    static func == (_: CommandWith, _: CommandWith) -> Bool {
        return true
    }
}

extension CommandWith: Hashable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(ObjectIdentifier(self))
    }
}

extension CommandWith: Codable {
    convenience init(from _: Decoder) throws {
        self.init { _ in }
    }

    func encode(to _: Encoder) throws {}
}

extension CommandWith {
    func map<U>(transform: @escaping (U) -> T) -> CommandWith<U> {
        return CommandWith<U> { u in
            self.perform(with: transform(u))
        }
    }
}
