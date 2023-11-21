import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(UserInfoRepresentableMacro)
import UserInfoRepresentableMacro

private let testMacros: [String: Macro.Type] = [
    "UserInfoRepresentable": UserInfoRepresentableMacro.self,
    "UserInfoKey": UserInfoKeyMacro.self
]
#endif

final class UserInfoRepresentableMacroTests: XCTestCase {

    func testUserInfoRepresentable() {
#if canImport(UserInfoRepresentableMacro)
        assertMacroExpansion(
            """
            @UserInfoRepresentable
            struct UserNameUpdateNotificationStorage {
                let oldName: String
                let newName: String

                @UserInfoKey("custom")
                let value: String

                let immutableValue = 10
                static var staticValue = "static"
                var computedValue: Int { 1 }
            }
            """,
            expandedSource:
            """
            struct UserNameUpdateNotificationStorage {
                let oldName: String
                let newName: String
                let value: String

                let immutableValue = 10
                static var staticValue = "static"
                var computedValue: Int { 1 }

                init(userInfo: [AnyHashable: Any]) throws {
                    self.oldName = try _extract("oldName", from: userInfo)
                    self.newName = try _extract("newName", from: userInfo)
                    self.value = try _extract("custom", from: userInfo)
                }

                func convertToUserInfo() -> [AnyHashable : Any] {
                    [
                        "oldName": _userInfoValue(oldName),
                        "newName": _userInfoValue(newName),
                        "custom": _userInfoValue(value),
                    ]
                }
            }

            extension UserNameUpdateNotificationStorage: UserInfoRepresentable {
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
