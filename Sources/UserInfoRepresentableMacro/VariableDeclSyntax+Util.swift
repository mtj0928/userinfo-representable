import SwiftSyntax

// Reference:
// https://github.com/apple/swift/blob/98e65d015979c7b5a58a6ecf2d8598a6f7c85794/lib/Macros/Sources/ObservationMacros/Extensions.swift#L73-L85
extension VariableDeclSyntax {
    var isComputed: Bool {
        if accessorsMatching({ $0 == .keyword(.get) }).count > 0 {
            return true
        }
        return bindings.contains { binding in
            if case .getter = binding.accessorBlock?.accessors {
                return true
            } else {
                return false
            }
        }
    }

    private func accessorsMatching(_ predicate: (TokenKind) -> Bool) -> [AccessorDeclSyntax] {
        let patternBindings = bindings.compactMap { binding in binding.as(PatternBindingSyntax.self) }
        let accessors: [AccessorDeclListSyntax.Element] = patternBindings.compactMap { patternBinding in
            switch patternBinding.accessorBlock?.accessors {
            case .accessors(let accessors):
                return accessors
            default:
                return nil
            }
        }.flatMap { $0 }
        return accessors.compactMap { accessor in
            guard let decl = accessor.as(AccessorDeclSyntax.self) else {
                return nil
            }
            if predicate(decl.accessorSpecifier.tokenKind) {
                return decl
            } else {
                return nil
            }
        }
    }
}
