//
//  UITapGestureRecognizerExtension.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/2.
//

import UIKit

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText, self.state == .ended else {
            return false
        }

        let locationOfTouchInLabel = self.location(in: label)
        let labelSize = label.bounds.size

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: labelSize)
        let textStorage: NSTextStorage = NSTextStorage(attributedString: attributedText)

        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInLabel, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        let target = NSMakeRange(targetRange.location, max(1, targetRange.length - 1)) // 去除最后一位，防止点击在空白处，也返回最后一位字符。如果只有一位取1
        return NSLocationInRange(indexOfCharacter, target)
    }
}
