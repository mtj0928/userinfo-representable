@attached(member, names: arbitrary)
@attached(extension, conformances: UserInfoRepresentable)
public macro UserInfoRepresentable() = #externalMacro(module: "UserInfoRepresentableMacro", type: "UserInfoRepresentableMacro")

@attached(peer)
public macro UserInfoKey(_ key: AnyHashable) = #externalMacro(module: "UserInfoRepresentableMacro", type: "UserInfoKeyMacro")
