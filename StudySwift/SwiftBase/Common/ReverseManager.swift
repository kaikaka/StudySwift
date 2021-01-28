//
//  ReverseManager.swift
//  StudySwift
//
//  Created by Yoon on 2021/1/10.
//

import UIKit
import AVFoundation

struct TrackFileData {
    var size:Double = 0 //文件大小
    var index:Int = 0 //文件索引
    var path:String = "" //文件路径
}

struct PieceFileData {
    var pifData:[TrackFileData] = [] //所有符合条件的文件的路径
    var size:Double = 0 //每块的大小
}

class ReverseManager: NSObject {
    static let defaultManager = ReverseManager()
    
    private var paths:[TrackFileData] = [] //小视频的路径
    private var filesManager:FileManager = FileManager.default
    private var videoNum:Int = 0 //计数小视频 递归调用
    
    /// 分割视频
    /// - Parameters:
    ///   - path: 要分割的视频路径
    ///   - startPoint: 开始的时间
    ///   - complete: 回调
    public func trimWithAssetPath(_ assetPath:String, startPoint:CMTime, complete:@escaping ((_ files:[TrackFileData]) -> Void)) {
        //从路径获取视频资源
        let asset = AVAsset.init(url: URL.init(fileURLWithPath: assetPath))
        
        var asssetVideoTrack:AVAssetTrack!
        var asssetAudioTrack:AVAssetTrack!
        //获取音视频轨道数据
        if asset.tracks(withMediaType: AVMediaType.video).count != 0 {
            asssetVideoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        }
        
        if asset.tracks(withMediaType: AVMediaType.audio).count != 0 {
            asssetAudioTrack = asset.tracks(withMediaType: AVMediaType.audio)[0]
        }
        
        /// 视频时长
        let assetTime = asset.duration
        
        let sub1Time = CMTimeSubtract(startPoint, assetTime)
//        print(sub1Time.value,sub1Time.flags,sub1Time.timescale)
        if CMTimeGetSeconds(sub1Time) >= 0 {
            complete(self.paths)
            return
        }
        //设置每段视频的长度为1秒,如果最后不足1秒了, intervalTime 就设置为余下的时间.
        var intervalTime = CMTimeMake(value: Int64(assetTime.timescale), timescale: assetTime.timescale)
        var endTime = CMTimeAdd(startPoint, intervalTime)
        let subTime = CMTimeSubtract(endTime, assetTime)
        
        if CMTimeGetSeconds(subTime) > 0 {
            intervalTime = CMTimeSubtract(intervalTime, subTime)
            endTime = CMTimeAdd(endTime, intervalTime)
        }
        
        let mutableComposition = AVMutableComposition.init()
        // 从AVAsset插入视频和音频轨道的一半时间范围
        let compositionVideoTrack = mutableComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        if compositionVideoTrack == nil { return }
        if asssetVideoTrack != nil {
            //放置视频
            try? compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: startPoint, duration: intervalTime), of: asssetVideoTrack, at: CMTime.zero)
        }
        
        if asssetAudioTrack != nil {
            //音频可以不倒放
            let compositionAudioTrack = mutableComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            try? compositionAudioTrack?.insertTimeRange(CMTimeRangeMake(start: startPoint, duration: intervalTime), of: asssetAudioTrack, at: CMTime.zero)
        }
        
        /// 分割视频的路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        //小视频文件名
        let oPath = path?.appending("/\(self.videoNum).mp4")
        guard let outPath = oPath else { return }
        self.videoNum += 1
        
        //保存小视频
        let mergeFileUrl = URL.init(fileURLWithPath:outPath)
        /* a 系统方法 导出文件比较大*/
        let exporter = AVAssetExportSession.init(asset: mutableComposition, presetName: AVAssetExportPreset1280x720)
        exporter?.outputURL = mergeFileUrl
        exporter?.outputFileType = AVFileType.mov
        exporter?.shouldOptimizeForNetworkUse = true
        exporter?.exportAsynchronously(completionHandler: {
            if let fileData = try? Data.init(contentsOf: URL.init(string: "file://\(outPath)")!) {
                let f = TrackFileData.init(size: Double(fileData.count), index: self.videoNum - 1, path: outPath)
                self.paths.append(f)
            }
            
            self.trimWithAssetPath(assetPath, startPoint: endTime, complete: complete)
        })
         
        /*
         b 用SDAVAssetExportSession 压缩保存 但是失败
         
        let instruction = AVMutableVideoCompositionInstruction.init()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: mutableComposition.duration)
        
        let mutableVideoComposition = AVMutableVideoComposition.init()
        mutableVideoComposition.renderSize = CGSize.init(width: 720, height: 1280)
        mutableVideoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mutableVideoComposition.instructions = [instruction]
        
        let exporter = SDAVAssetExportSession.init(asset: mutableComposition)
        exporter?.outputFileType = AVFileType.mp4.rawValue
        exporter?.videoComposition = mutableVideoComposition
        exporter?.outputURL = mergeFileUrl
        exporter?.videoSettings = [AVVideoCodecKey: AVVideoCodecH264,
                                   AVVideoWidthKey: 720,
                                   AVVideoHeightKey: 1280,
                                   AVVideoCompressionPropertiesKey:[AVVideoAverageBitRateKey: 3000000,
                                                                    AVVideoProfileLevelKey: AVVideoProfileLevelH264High40]]
        exporter?.audioSettings = [AVFormatIDKey: kAudioFormatMPEG4AAC,
                                   AVNumberOfChannelsKey: 2,
                                   AVSampleRateKey: 44100,
                                   AVEncoderBitRateKey: 128000,]
        exporter?.exportAsynchronously(completionHandler: {
            if let fileData = try? Data.init(contentsOf: URL.init(string: "file://\(outPath)")!) {
                let f = TrackFileData.init(size: Double(fileData.count), index: self.videoNum, path: outPath)
                self.paths.append(f)
            }
            
            self.trimWithAssetPath(assetPath, startPoint: endTime, complete: complete)
        })*/
    }
  
    public func calculatePieceData(_ offset:Double,files:[TrackFileData]) -> [PieceFileData] {
        
        var pifArray:[PieceFileData] = []
        var pif = PieceFileData.init(pifData: [],size: 0)
        var tempData:Double = 0
        for (idx,file) in files.enumerated() {
            if tempData >= offset {
                pif.size = tempData
                pifArray.append(pif)
                pif = PieceFileData.init(pifData: [], size: 0)
                tempData = 0
            } else {
                if idx == files.count - 1 && tempData < offset {
                    pif.pifData.append(file)
                    pif.size = tempData
                    pifArray.append(pif)
                }
            }
            tempData += file.size
            pif.pifData.append(file)
        }
        return pifArray
    }
    
    /// 检测数据是否符合上传要求
    /// - Parameters:
    ///   - pifData: 数据
    ///   - minOffset: 最小值
    public func checkOfAddToPreviousPiece(_ pifData:[PieceFileData],minOffset:Double) -> [PieceFileData] {
        if pifData.count == 1 { return pifData }
        var pData = pifData
        if var lastData = pData.last {
            if lastData.size < minOffset {
                let lastlastData = pifData[pifData.count - 2]
                lastData.pifData += lastlastData.pifData
                lastData.size += lastlastData.size
                lastData.pifData.sort { (obj1, obj2) -> Bool in
                    obj1.index < obj2.index
                }
                pData.removeLast()
                pData.removeLast()
                pData.append(lastData)
                return pData
            }
        }
        return pData
    }
    
    /// 合成视频
    /// - Parameters:
    ///   - pifData: 数据
    ///   - path: 合成路径
    public func syntheticVideo(_ pifData:[PieceFileData], outputPath:String) -> [URL] {
        if pifData.count == 0 { return [] }
        var piePath:[URL] = []
        
        for file in pifData {
            let videoComposition = AVMutableVideoComposition.init()
            let mixComposition = AVMutableComposition.init()
            let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
            videoTrack?.preferredTransform = CGAffineTransform.identity
//            let roateInstruction = AVMutableVideoCompositionInstruction.init()
//            let roateLayerInstruction = AVMutableVideoCompositionLayerInstruction.init(assetTrack: videoTrack!)
            
            for pfile in file.pifData {
                let asset = AVURLAsset.init(url: URL.init(fileURLWithPath: pfile.path))
                if let assetVideoTrack = asset.tracks(withMediaType: .video).first {
                    try? videoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration), of: assetVideoTrack, at: CMTime.zero)
                    
//                    roateLayerInstruction.setTransform(CGAffineTransform.init(rotationAngle: ((3.14159265359 * 180)/180)), at: CMTime.zero)
//
//                    roateInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: (videoTrack?.timeRange.duration)!)
//                    roateInstruction.layerInstructions.append(roateLayerInstruction)
//
//
//                    videoComposition.instructions.append(roateInstruction)
//                    videoComposition.renderSize = CGSize.init(width: videoTrack!.naturalSize.width, height: videoTrack!.naturalSize.width)
//                    videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
                    
                    try? self.filesManager.removeItem(atPath: pfile.path)
                }
            }
            let mergeFileURL = URL.init(fileURLWithPath: "\(outputPath)\(arc4random()).mp4")
            
            let exporter = AVAssetExportSession.init(asset: mixComposition, presetName: AVAssetExportPreset1280x720)
            exporter?.outputURL = mergeFileURL
            exporter?.outputFileType = AVFileType.mov
            exporter?.shouldOptimizeForNetworkUse = true
            exporter?.exportAsynchronously(completionHandler: {
                piePath.append(mergeFileURL)
            })
            
            
//            let exporter = SDAVAssetExportSession.init(asset: mixComposition)
//
//            exporter?.outputFileType = AVFileType.mp4.rawValue
//            exporter?.videoComposition = videoComposition
//            exporter?.shouldOptimizeForNetworkUse = true
//            exporter?.outputURL = mergeFileURL
//            exporter?.videoSettings = [AVVideoCodecKey: AVVideoCodecH264,
//                                       AVVideoWidthKey: 720,
//                                       AVVideoHeightKey: 1280,
//                                       AVVideoCompressionPropertiesKey:[AVVideoAverageBitRateKey: 3000000,
//                                                                        AVVideoProfileLevelKey: AVVideoProfileLevelH264High40]]
//            exporter?.audioSettings = [AVFormatIDKey: kAudioFormatMPEG4AAC,
//                                       AVNumberOfChannelsKey: 2,
//                                       AVSampleRateKey: 44100,
//                                       AVEncoderBitRateKey: 128000]
//
//            exporter?.exportAsynchronously(completionHandler: {
//            })
            
        }
        return []
    }
}
