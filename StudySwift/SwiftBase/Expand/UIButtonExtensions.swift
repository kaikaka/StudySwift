//
//  UIButtonExtension.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/2.
//

import Kingfisher
import UIKit

extension UIButton {
    /**
     改变button 的imageview 和 title为垂直排列

     - parameter offset:
     */
    public func changeEdgeVertical(_ offset: Float) {
        let titleSize = titleLabel!.intrinsicContentSize
        let imageSize = imageView!.bounds.size
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -imageSize.height - CGFloat(offset / 2), right: 0.0)
        imageEdgeInsets = UIEdgeInsets(top: -titleSize.height - CGFloat(offset / 2), left: 0.0, bottom: 0.0, right: -titleSize.width)
    }

    /**
     改变button 的imageview 在title的左侧

     - parameter offset:
     */
    public func changeEdgeLeftImage(_ offset: CGFloat) {
        let titleSize = titleLabel!.intrinsicContentSize
        let imageSize = imageView!.bounds.size
        imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width + offset, bottom: 0, right: -(titleSize.width + offset))
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageSize.width + offset), bottom: 0, right: imageSize.width + offset)
    }

    /// 统一修改按钮配置颜色
    public func changeBackgroundImage(_ defaultColor: UIColor, highlightedColor: UIColor, disabledColor: UIColor) {
        setBackgroundImage(defaultColor.getImage(), for: .normal)
        setBackgroundImage(highlightedColor.getImage(), for: .highlighted)
        setBackgroundImage(disabledColor.getImage(), for: .disabled)
    }

    /// 通过字符串设置按钮颜色 ， 透明度修改0.3
    public func changeBackgroundImage(_ defaultHex: String, highlightedHex: String, disabledHex: String) {
        setBackgroundImage(UIColor(hexString: defaultHex).getImage(), for: .normal)
        setBackgroundImage(UIColor(hexString: highlightedHex).getImage(), for: .highlighted)
        setBackgroundImage(UIColor(hexString: disabledHex).getImage(), for: .disabled)
    }

    /// 通过字符串设置按钮颜色 ， 透明度修改0.3
    public func changeBackgroundImage(_ defaultHex: String) {
        setBackgroundImage(UIColor(hexString: defaultHex).getImage(), for: .normal)
        setBackgroundImage(UIColor(hexString: defaultHex, alpha: 0.3).getImage(), for: .highlighted)
        setBackgroundImage(UIColor(hexString: defaultHex, alpha: 0.3).getImage(), for: .disabled)
    }

    /// 通过url 加载网络图片
    public func setUrlImage(url: String, forState state: UIControl.State = .normal, options: KingfisherOptionsInfo = [.transition(ImageTransition.fade(1.2))]) {
        kf.setImage(with: URL(string: url)!, for: state, options: options)
    }
    
    func delayEnable() { //防止重复点击
        isEnabled = false
        let dispatchTime: DispatchTime = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: { [weak self] in
            self?.isEnabled = true
        })
    }
}
