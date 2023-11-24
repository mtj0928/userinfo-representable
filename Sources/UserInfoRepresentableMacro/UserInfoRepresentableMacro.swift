import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct UserInfoRepresentableMacro: ExtensionMacro, MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let targetProperties = try declaration.memberBlock.members.compactMap { memberBlockItem in
            try extractStoredProperty(node: memberBlockItem)
        }
        let assigns = targetProperties.map { property in property.assignToProperty() }
        let keyAndValues = targetProperties.isEmpty ? [":"] : targetProperties.map { property in property.keyAndValue() }
        return [
            """
            public init(userInfo: [AnyHashable: Any]) throws {
                \(raw: assigns.joined(separator: "\n"))
            }
            """,
            """
            public func convertToUserInfo() -> [AnyHashable : Any] {
                [
                    \(raw: keyAndValues.joined(separator: "\n"))
                ]
            }
            """
        ]
    }

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        [
            try ExtensionDeclSyntax(
                """
                extension \(type): UserInfoRepresentable {}
                """
            )
        ]
    }

    private static func extractStoredProperty(node: MemberBlockItemSyntax) throws -> TargetProperty? {
        guard let variableDeclSyntax = node.decl.as(VariableDeclSyntax.self),
              let binding = variableDeclSyntax.bindings.first?.as(PatternBindingSyntax.self)
        else { return nil }

        let isStatic = variableDeclSyntax.modifiers.contains { declModifierSyntax in
            declModifierSyntax.name.tokenKind == .keyword(.static)
        }

        if isStatic { return nil }

        let isLetMember = variableDeclSyntax.bindingSpecifier.tokenKind == .keyword(.let)
        let isImmutableMember = isLetMember && binding.initializer != nil
        if isImmutableMember || variableDeclSyntax.isComputed { return nil }

        guard let name = binding.pattern.as(IdentifierPatternSyntax.self) else {
            return nil
        }

        let customNameExpr = variableDeclSyntax.attributes.compactMap { node -> ExprSyntax? in
            guard let attribute = node.as(AttributeSyntax.self),
                  attribute.attributeName.as(IdentifierTypeSyntax.self)?.name.text == userInfoKeyName,
                  let labeledExprSyntax = attribute.arguments?.as(LabeledExprListSyntax.self)?.first else {
                return nil
            }
            return labeledExprSyntax.expression
        }.first

        return TargetProperty(name: name, customKey: customNameExpr)
    }

    struct TargetProperty {
        let name: IdentifierPatternSyntax
        let customKey: ExprSyntax?

        func assignToProperty() -> String {
            let key: any SyntaxProtocol = customKey ?? "\"\(raw: name.identifier.text)\""
            return """
            self.\(name.identifier.text) = try _extract(\(key.description), from: userInfo)
            """
        }

        func keyAndValue() -> String {
            let key: any SyntaxProtocol = customKey ?? "\"\(raw: name.identifier.text)\""
            return """
            \(key): _userInfoValue(\(name)),
            """
        }
    }
}

extension UserInfoRepresentableMacro {
    static let userInfoKeyName = "UserInfoKey"
}
