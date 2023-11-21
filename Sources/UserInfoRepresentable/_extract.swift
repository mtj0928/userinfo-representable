public func _extract<T>(_ key: AnyHashable, from userInfo: [AnyHashable: Any]) throws -> T {
    guard let value = userInfo[key] as? T else {
        throw MissingKeyError(missingKey: key)
    }
    return value
}

public func _extract<T: UserInfoRepresentable>(_ key: AnyHashable, from userInfo: [AnyHashable: Any]) throws -> T {
    guard userInfo.keys.contains(key) else {
        throw MissingKeyError(missingKey: key)
    }
    if let value = userInfo[key] as? T {
        return value
    } else if let value = userInfo[key] as? [AnyHashable: Any] {
        return try T(userInfo: value)
    }
    throw MissingKeyError(missingKey: key)
}

public struct MissingKeyError: Error {
    let missingKey: AnyHashable
}

extension MissingKeyError: CustomStringConvertible {
    public var description: String {
        "\(missingKey) is not contained in the given userInfo"
    }
}
