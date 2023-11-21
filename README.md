# `userinfo-representable`

`userinfo-representable` helps a conversion from `userInfo` to your types.

## Usage
Define your types with attaching `@UserInfoRepresentable`.  
Like this example, `@UserInfoRepresentable` can be nested.

```swift
@UserInfoRepresentable
struct Foo {
    var number: Int
    @UserInfoKey("custom key") var text: String
    var bar: Bar
}

@UserInfoRepresentable
struct Bar {
    let value: String
}
```

And then, you can parse `userInfo` like this.
```swift
let userInfo: [AnyHashable: Any] = [
    "number": 123,
    "custom key": "text",
    "bar": [
        "value": "bar"
    ],
]
let foo = try Foo(userInfo: userInfo)
```

And, you can also convert the type to `userInfo`.
```swift 
let userInfo: [AnyHashable: Any] = foo.convertToUserInfo()
```
