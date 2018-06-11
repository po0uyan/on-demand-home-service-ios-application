//
//  MoreServicesButton.swift
//  pinwork
//
//  Created by Pouyan on 6/7/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
extension UIView {
    func loadFromNibIfEmbeddedInDifferentNib() -> Self {
        let isJustAPlaceholder = subviews.count == 0
        if isJustAPlaceholder {
            let theRealThing = type(of: self).viewFromNib()
            theRealThing.frame = frame
            translatesAutoresizingMaskIntoConstraints = false
            theRealThing.translatesAutoresizingMaskIntoConstraints = false
            return theRealThing
        }
        return self
    }
}
extension UIView {
    class func viewFromNib(withOwner owner: Any? = nil) -> Self {
        let name = String(describing: type(of:      self)).components(separatedBy: ".")[0]
        let view = UINib(nibName: name, bundle: nil).instantiate(withOwner: owner, options: nil)[0]
        return cast(view)!
    }
}
private func cast<T, U>(_ value: T) -> U? {
    return value as? U
}
class MoreServicesButton: UIButton {
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        return self.loadFromNibIfEmbeddedInDifferentNib()
    }

}
