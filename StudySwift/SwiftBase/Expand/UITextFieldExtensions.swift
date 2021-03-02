//
//  UITextFieldExtension.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/2.
//

import UIKit

extension UITextField {
    /// 设置placeholder的字体颜色
    public func changePlaceholder(_ placeholder: String, placeColor: UIColor, textColor: UIColor) {
        let attributes = [
            NSAttributedString.Key.foregroundColor: placeColor]
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: attributes)
        self.textColor = textColor
    }
}
