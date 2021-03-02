//
//  PlaceholderTextView.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/2.
//

import Foundation
import RxSwift
import SnapKit

open class PlaceholderTextView: UITextView {
    public let placeholderLabel: UILabel = UILabel()
    @IBInspectable public var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    @IBInspectable public var placeholderColor: UIColor = UIColor(hexString: "c7c7cd") {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }

    override open var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }

    override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }

    func commonInit() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(PlaceholderTextView.textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)

        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        addSubview(placeholderLabel)

        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(2)
        }
    }

    override open var text: String! {
        didSet {
            textDidChange()
        }
    }

    @objc func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
