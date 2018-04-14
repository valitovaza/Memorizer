import UIKit

class PileCell: UITableViewCell {
    static let openedConstraint: CGFloat = 50.0
    
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
}
