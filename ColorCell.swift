//
//  ColorCell
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    @IBOutlet weak var colorPanel: UIView!
    
    var color: UIColor {
        set {
            self.colorPanel.backgroundColor = newValue
        }
        
        get {
            return self.colorPanel.backgroundColor ?? UIColor.whiteColor()
        }
    }
}
