//
//  UILabelExtation.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-05-07.
//

import UIKit

extension UILabel {
    
    func setLabelRightIcon(text:String, rightIcon: UIImage? = nil) {
        
        let myString = NSMutableAttributedString(string: "")
        
        let rightAttachment = NSTextAttachment()
        rightAttachment.image = rightIcon
        rightAttachment.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        let rightAttachmentStr = NSAttributedString(attachment: rightAttachment)
        
        if semanticContentAttribute == .forceRightToLeft {
            if rightIcon != nil {
                myString.append(rightAttachmentStr)
                myString.append(NSAttributedString(string: "  "))
            }
            myString.append(NSAttributedString(string: text))
            
        } else {
            if rightIcon != nil {
                myString.append(NSAttributedString(string: text))
                myString.append(NSAttributedString(string: "  "))
                myString.append(rightAttachmentStr)
            }
        }
        attributedText = myString
    }
}

