import UIKit

protocol NibLoadableView: class { }

extension UITableViewCell: NibLoadableView { }

extension NibLoadableView where Self: UIView {    
    static var NibName: String {
        return String(describing: self)
    }
}
