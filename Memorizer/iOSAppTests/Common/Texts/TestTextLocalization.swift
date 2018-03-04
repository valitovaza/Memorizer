import XCTest
@testable import iOSApp

extension L10n {
    static func enTr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        return testLocalize(table, key, "en", args)
    }
    static func ruTr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        return testLocalize(table, key, "ru-RU", args)
    }
    private static func testLocalize(_ table: String, _ key: String,
                              _ language: String, _ args: CVarArg...) -> String {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            let basePath = Bundle.main.path(forResource: "Base", ofType: "lproj")!
            return Bundle(path: basePath)!.localizedString(forKey: key, value: "", table: table)
        }
        
        return Bundle(path: path)!.localizedString(forKey: key, value: "", table: table)
    }
}
