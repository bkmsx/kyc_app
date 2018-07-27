//
//  ColorLabel.swift
//  Kyc
//
//  Created by Lai Trung Tien on 7/27/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit

class ColorLabel: UILabel {

    override func awakeFromNib() {
        
    }
    
    func setTextColor(shortText: String, color: UIColor) {
        let result = text!.range(of: shortText)
        let attrString = NSMutableAttributedString.init(attributedString: attributedText!)
        attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: result!.nsRange)
       attributedText = attrString
    }

}

extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                        self.lowerBound.encodedOffset)
    }
}
