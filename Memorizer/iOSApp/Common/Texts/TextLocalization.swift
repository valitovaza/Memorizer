import Foundation
enum L10n {
    static var localizeFunc: (String, String, CVarArg...)->(String) = tr
    static var memorizer: String { return localize("Localizable", "memorizer") }
    static var emptyPileList: String { return localize("Localizable", "empty_pile_list") }
    static var createСard: String { return localize("Localizable", "create_card") }
    static var addCard: String { return localize("Localizable", "add_card") }
    static var pileName: String { return localize("Localizable", "pile_name") }
    static var createPile: String { return localize("Localizable", "create_pile") }
    static var editСard: String { return localize("Localizable", "edit_card") }
    static var editPile: String { return localize("Localizable", "edit_pile") }
    
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
