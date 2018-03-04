import Foundation
enum L10n {
    static var localizeFunc: (String, String, CVarArg...)->(String) = tr
    static var memorizer: String { return localize("Localizable", "memorizer") }
    static var emptyPileList: String { return localize("Localizable", "empty_pile_list") }
    
    private static func localize(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        return localizeFunc(table, key, args)
    }
}
extension L10n {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: table,
                                       bundle: Bundle(for: BundleToken.self), comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}
private final class BundleToken {}
