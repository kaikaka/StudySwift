//
//  UIImageExtension.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/2.
//

import ImageIO
import UIKit

extension UIImage {
    public class func gifImageWithData(data: NSData) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("image doesn't exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source: source).0
    }

    public class func gifsImagesWithData(data: NSData) -> [UIImage]? {
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("image doesn't exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source: source).1
    }

    public class func gifImageWithURL(gifUrl: String) -> UIImage? {
        guard let bundleURL = NSURL(string: gifUrl)
        else {
            print("image named \"\(gifUrl)\" doesn't exist")
            return nil
        }
        guard let imageData = NSData(contentsOf: bundleURL as URL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }

        return gifImageWithData(data: imageData)
    }

    public class func gifImageWithName(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        guard let imageData = NSData(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gifImageWithData(data: imageData)
    }

    public class func gifsImagesWithName(name: String) -> [UIImage]? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        guard let imageData = NSData(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gifsImagesWithData(data: imageData)
    }

    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)

        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        delay = delayObject as! Double

        if delay < 0.1 {
            delay = 0.1
        }

        return delay
    }

    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }

        if a! < b! {
            let c = a
            a = b
            b = c
        }

        var rest: Int
        while true {
            rest = a! % b!

            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }

    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(a: val, gcd)
        }

        return gcd
    }

    class func animatedImageWithSource(source: CGImageSource) -> (UIImage?, [UIImage]) {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        for i in 0 ..< count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }

            let delaySeconds = UIImage.delayForImageAtIndex(index: Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
        }()

        let gcd = gcdForArray(array: delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for i in 0 ..< count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)

            for _ in 0 ..< frameCount {
                frames.append(frame)
            }
        }

        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)

        return (animation, frames)
    }
    
    /// 返回图片尺寸
    /// - Parameter str: 图片地址
    /// - Returns: 图片尺寸
   class func imageSise(str: String) -> CGSize {
       ///https://static1.keepcdn.com/picture/2020/08/06/15/24/a6e9e3667cdaaa635c507fa87511ce4b56c42c44_576x768.jpg
      let imgUrl = URL.init(string: str)
      if (imgUrl != nil) {
        let lastPathComponent = imgUrl?.lastPathComponent.components(separatedBy: ".").first
        let splitedArray = lastPathComponent?.components(separatedBy: "_").last?.components(separatedBy: "x").compactMap {
            NSInteger($0)
        }
        if splitedArray?.count == 2 {
            return CGSize.init(width: splitedArray?.first ?? 0, height: splitedArray?.last ?? 0)
        } else {
            // MARK: - TODO获取网路图片
            return CGSize.zero
        }
      } else {
        return CGSize.zero
      }
   }
}

extension UIImage {
    class func color(_ withColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(withColor.cgColor)
        context!.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}
