import XCTest
@testable import UserInfoRepresentable

final class UserInfoRepresentableTests: XCTestCase {
    func testConversionFromUserInfo() throws {
        let userInfo: [AnyHashable: Any] = [
            100: 123,
            "text": (nil as String?) as Any,
            "bar": [
                "value": "bar"
            ],
        ]
        let foo = try Foo(userInfo: userInfo)
        XCTAssertEqual(foo.number, 123)
        XCTAssertEqual(foo.text, nil)
        XCTAssertEqual(foo.bar.value, "bar")
    }

    func testConversionFromType() throws {
        let foo = Foo(number: 123, text: nil, bar: Bar(value: "bar"))

        let fooUserInfo = foo.convertToUserInfo()
        XCTAssertEqual(fooUserInfo.count, 3)
        XCTAssertEqual(fooUserInfo[100] as? Int, 123)
        XCTAssertEqual(fooUserInfo["text"] as? String, nil)

        let barUserInfo = try XCTUnwrap(fooUserInfo["bar"] as? [AnyHashable: Any])
        XCTAssertEqual(barUserInfo.count, 1)
        XCTAssertEqual(barUserInfo["value"] as? String, "bar")
    }
}

@UserInfoRepresentable
struct Foo {
    @UserInfoKey(100)
    var number: Int
    var text: String?
    var bar: Bar

    init(number: Int, text: String? = nil, bar: Bar) {
        self.number = number
        self.text = text
        self.bar = bar
    }
}

@UserInfoRepresentable
struct Bar {
    let value: String

    init(value: String) {
        self.value = value
    }
}
