//
//  ColorCell
//

import UIKit

class ColorCell: UICollectionViewCell {
  
  @IBOutlet weak var colorPanel: UIView!
  @IBOutlet weak var rgbLabel: UILabel!
  
  var color: UIColor {
    set {
      self.colorPanel.backgroundColor = newValue
    }
    
    get {
      return self.colorPanel.backgroundColor ?? UIColor.white
    }
  }
  
  
}
