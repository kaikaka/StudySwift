//
//  UIViewExtension.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/2.
//

import SnapKit
import UIKit

/// 当前屏幕宽度
public let screen_Width = UIScreen.main.bounds.size.width

/// 当前屏幕高度
public let screen_Height = UIScreen.main.bounds.size.height

/// 当前设备宽度与设计的比例
public let widthmultiple = screen_Width / 750

extension UIView {
    /// 添加线
    /// - Parameters:
    ///   - frame: frame
    ///   - backgroundColor: 颜色
    func addLine(frame: CGRect = CGRect(x: 0, y: 0, width: 375, height: 1), backgroundColor: UIColor = UIColor.gray) {
        let lineView = UIView()
        lineView.frame = frame
        lineView.backgroundColor = backgroundColor
        addSubview(lineView)
        bringSubviewToFront(lineView)
    }

    /// 设置view width的值
    public var width: CGFloat {
        set(newVal) {
            var frame = self.frame
            frame.size.width = newVal
            self.frame = frame
        }
        get {
            return frame.size.width
        }
    }

    /// 设置view的高度
    public var hegith: CGFloat {
        set(newVal) {
            var frame = self.frame
            frame.size.height = newVal
            self.frame = frame
        }
        get {
            return frame.size.height
        }
    }

    /// 设置viewx坐标
    public var x: CGFloat {
        get {
            return frame.origin.x
        }
        set(newVal) {
            var frame = self.frame
            frame.origin.x = newVal
            self.frame = frame
        }
    }

    /// 设置view的y坐标
    public var y: CGFloat {
        get {
            return frame.origin.y
        }
        set(newVal) {
            var frame = self.frame
            frame.origin.y = newVal
            self.frame = frame
        }
    }

    // 设置view的中心点x坐标
    public var centerX: CGFloat {
        get {
            return center.x
        }
        set(newVal) {
            var center = self.center
            center.x = newVal
            self.center = center
        }
    }

    // 设置view的中心点y坐标
    public var centerY: CGFloat {
        get {
            return center.y
        }
        set(newVal) {
            var center = self.center
            center.y = newVal
            self.center = center
        }
    }

    /// 设置修改view的size值
    public var size: CGSize {
        get {
            return frame.size
        }
        set(newVal) {
            var frame = self.frame
            frame.size = newVal
            self.frame = frame
        }
    }

    /// 设置修改view的origin值
    public var origin: CGPoint {
        get {
            return frame.origin
        }
        set(newVal) {
            var frame = self.frame
            frame.origin = newVal
            self.frame = frame
        }
    }

    public var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }

    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }

    public var top: CGFloat {
        return frame.origin.y
    }

    /// FOR safe area
    var safeArea: ConstraintBasicAttributesDSL {
        #if swift(>=3.2)
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.snp
            }
            return snp
        #else
            return snp
        #endif
    }

    /// 底部安全距离
    var safeAreaBottomPadding: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0
            return bottomPadding
        }
        return 0
    }

    public var windowFrame: CGRect? {
        return superview?.convert(frame, to: nil)
    }

    public func isShowingOnKeyWindow() -> Bool {
        guard
            let keyWindow = UIApplication.shared.keyWindow
        else {
            return false
        }
        let newFrame = keyWindow.convert(frame, to: superview)
        let intersects = newFrame.intersects(keyWindow.bounds)
        return !isHidden && alpha > 0 && window == keyWindow && intersects
    }

    public var parentVC: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UIView {
    /// SwifterSwift: Border color of view; also inspectable from Storyboard.
    @IBInspectable public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }

    /// SwifterSwift: Border width of view; also inspectable from Storyboard.
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /// SwifterSwift: Corner radius of view; also inspectable from Storyboard.
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }

    public func round(radius: CGFloat, corners: UIRectCorner) {
        let bezierPath = UIBezierPath(roundedRect: bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: radius,
                                                          height: radius))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        layer.mask = shapeLayer
    }

    @IBInspectable public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    /// SwifterSwift: Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    /// SwifterSwift: Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    /// SwifterSwift: Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
}

extension UIView {
    /// SwifterSwift: Shake directions of a view.
    ///
    /// - horizontal: Shake left and right.
    /// - vertical: Shake up and down.
    public enum ShakeDirection {
        case horizontal
        case vertical
    }

    /// SwifterSwift: Shake animations types.
    ///
    /// - linear: linear animation.
    /// - easeIn: easeIn animation
    /// - easeOut: easeOut animation.
    /// - easeInOut: easeInOut animation.
    public enum ShakeAnimationType {
        case linear
        case easeIn
        case easeOut
        case easeInOut
    }

    /// SwifterSwift: Angle units.
    ///
    /// - degrees: degrees.
    /// - radians: radians.
    public enum AngleUnit {
        /// degrees.
        case degrees

        /// radians.
        case radians
    }

    /// SwifterSwift: Shake view.
    ///
    /// - Parameters:
    ///   - direction: shake direction (horizontal or vertical), (default is .horizontal)
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - animationType: shake animation type (default is .easeOut).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    public func shake(direction: ShakeDirection = .horizontal, duration: TimeInterval = 1, animationType: ShakeAnimationType = .easeOut, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        let animation: CAKeyframeAnimation
        switch direction {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }
        switch animationType {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }

    /// SwifterSwift: Rotate view by angle on relative axis.
    ///
    /// - Parameters:
    ///   - angle: angle to rotate view by.
    ///   - type: type of the rotation angle.
    ///   - animated: set true to animate rotation (default is true).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    public func rotate(byAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, delay: 0, options: .curveLinear, animations: { () -> Void in
            self.transform = self.transform.rotated(by: angleWithType)
        }, completion: completion)
    }

    /// SwifterSwift: Rotate view to angle on fixed axis.
    ///
    /// - Parameters:
    ///   - angle: angle to rotate view to.
    ///   - type: type of the rotation angle.
    ///   - animated: set true to animate rotation (default is false).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    public func rotate(toAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, animations: {
            self.transform = self.transform.concatenating(CGAffineTransform(rotationAngle: angleWithType))
        }, completion: completion)
    }

    /// SwifterSwift: Scale view by offset.
    ///
    /// - Parameters:
    ///   - offset: scale offset
    ///   - animated: set true to animate scaling (default is false).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    public func scale(by offset: CGPoint, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () -> Void in
                self.transform = self.transform.scaledBy(x: offset.x, y: offset.y)
            }, completion: completion)
        } else {
            transform = transform.scaledBy(x: offset.x, y: offset.y)
            completion?(true)
        }
    }
}

extension UIView {
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}
