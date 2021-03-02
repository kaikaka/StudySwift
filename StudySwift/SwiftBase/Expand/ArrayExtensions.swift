//
//  ArrayExtension.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/2.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

extension Array where Element: Hashable {
    /// 数组去重
    var deduplicates: [Element] {
        var keys: [Element: ()] = [:]
        return filter {
            keys.updateValue((), forKey: $0) == nil
        }
    }
    
    /// 在头部插入元素
    ///
    /// - Parameter newElement: 待插入的元素
    mutating func prepend(_ newElement: Element) {
        insert(newElement, at: 0)
    }
    
    
    /// 将序列插入数组头部
    ///
    /// - Parameter newElements: 待插入序列
    mutating func prepend<S>(contentsOf newElements: S) where S : Sequence, Array.Element == S.Element {
        insert(contentsOf: Array(newElements), at: 0)
    }
    
    
    /// 删除并返回数组头元素
    ///
    /// - Returns: 元素
    mutating func popFirst() -> Element? {
        guard let ele = first else { return nil }
        self = Array(dropFirst())
        return ele
    }
    
    
    /// 交换两个位置上的元素
    ///
    ///     [1, 2, 3, 4, 5].safeSwap(from: 3, to: 0) -> [4, 2, 3, 1, 5]
    ///     ["h", "e", "l", "l", "o"].safeSwap(from: 1, to: 0) -> ["e", "h", "l", "l", "o"]
    ///
    /// - Parameters:
    ///   - index: 第一个元素的位置
    ///   - otherIndex: 另一个元素的位置
    mutating func safeSwap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex..<endIndex ~= index else { return }
        guard startIndex..<endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }
    
    ///移除数组元素
    mutating func removeElement(_ element: Element) {
        if let index = firstIndex(of: element) {
            remove(at: index)
        }
    }
    
    ///数组分组
    ///count:每组几个
    func split(count: Int) -> [[Element]] {

        let moNum = self.count % count
        let num = self.count / count
        let index = moNum == 0 ? (num) : (self.count / count + 1)

        var last: [[Element]] = []
        for i in 0..<index {
            var tmp: [Element] = []
            let tmpCount = (i == index - 1 && moNum != 0) ? moNum : count
            for j in 0..<tmpCount {
                tmp.append(self[count * i + j])
            }
            last.append(tmp)
        }
        return last
    }
    ///数组分组
    ///key、属性相同的为一组
    func group<U: Hashable>(by key: (Element) -> U) -> [[Element]] {
      //keeps track of what the integer index is per group item
      var indexKeys = [U : Int]()

      var grouped = [[Element]]()
      for element in self {
        let key = key(element)
        
        if let ind = indexKeys[key] {
          grouped[ind].append(element)
        }
        else {
          grouped.append([element])
          indexKeys[key] = grouped.count - 1
        }
      }
      return grouped
    }
}
