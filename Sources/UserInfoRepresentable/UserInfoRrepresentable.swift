public protocol UserInfoRepresentable {
    init(userInfo: [AnyHashable: Any]) throws
    func convertToUserInfo() -> [AnyHashable: Any]
}
