import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct UserInfoRepresentableMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        UserInfoKeyMacro.self,
        UserInfoRepresentableMacro.self
    ]
}
