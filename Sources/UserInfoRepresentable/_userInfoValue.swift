public func _userInfoValue<T>(_ value: T) -> Any {
    value
}

public func _userInfoValue<T: UserInfoRepresentable>(_ value: T) -> Any {
    value.convertToUserInfo()
}
