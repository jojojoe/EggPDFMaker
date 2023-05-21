//
//  PDfMakTool.swift
//  PDfMaker
//
//  Created by JOJO on 2023/4/28.
//

import Foundation
import UIKit


class HistoryItem {
    var timeStr: String
    var displayName: String
    var pdfFilePath: String
    var pdfInfoPath: String
    init(timeStr: String, pdfFilePath: String, displayName: String, pdfInfoPath: String) {
        self.timeStr = timeStr
        self.displayName = displayName
        self.pdfFilePath = pdfFilePath
        self.pdfInfoPath = pdfInfoPath
    }
    
    func pdfPathUrl() -> URL {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let pinjiePath = documentDirectoryPath + pdfFilePath
        let url = URL(fileURLWithPath: pinjiePath)
        return url
    }
    
    func infoPathUrl() -> URL {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let pinjiePath = documentDirectoryPath + pdfInfoPath
        let url = URL(fileURLWithPath: pinjiePath)
        return url
    }
    
}


class PDfMakTool: NSObject {
    
    static let `default` = PDfMakTool()
    var historyItems: [HistoryItem] = []
    
    
    override init() {
        super.init()
        
    }
    
    func postAddHistoryItem() {
        // 发送添加历史记录通知
    }
    
    // 在history collection添加通知 刷新页面
    
    
    func loadHistoryItem() {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = documentDirectoryPath + "/history"
        let dictArray = parseInfoJsonFiles(directoryPath: filePath)
        historyItems = []
        for dict in dictArray {
            let timestr = dict["timeStr"] as? String ?? ""
            let displayName = dict["displayName"] as? String ?? ""
            let pdfFilePath = dict["pdfFilePath"] as? String ?? ""
            let pdfInfoPath = dict["pdfInfoPath"] as? String ?? ""
            
            
            let item = HistoryItem(timeStr: timestr, pdfFilePath: pdfFilePath, displayName: displayName, pdfInfoPath: pdfInfoPath)
            historyItems.append(item)
        }
    }
    
    func parseInfoJsonFiles(directoryPath: String) -> [[String: Any]] {
        var dictArray = [[String: Any]]()
        do {
            let folderUrls = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: directoryPath), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for folderUrl in folderUrls where folderUrl.hasDirectoryPath {
                let infoJsonUrl = folderUrl.appendingPathComponent("info.json")
                if let data = try? Data(contentsOf: infoJsonUrl), let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    dictArray.append(dict)
                }
            }
        } catch {
            print("Error parsing info.json files: \(error.localizedDescription)")
        }
        return dictArray
    }
 
    
    func  saveHistoryFile(originFileUrl: URL) -> HistoryItem {
        
        let manager = FileManager.default
        let dateStr = CLongLong(round(Date().unixTimestamp*1000)).string
        
        let pinjiePath = "/history/\(dateStr)"
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

        let filePath = documentDirectoryPath + pinjiePath

        //
        let urltypeStr = extractFileType(from: originFileUrl.absoluteString) ?? "pdf"
        //
        let fileNameStr = CLongLong(round(Date().unixTimestamp*1000)).string
        let pdfFilePath = filePath + "/\(fileNameStr)\(".")\(urltypeStr)"
        let pdfPathNameStr = pinjiePath + "/\(fileNameStr)\("."))\(urltypeStr)"
        //
        
        let isExist = manager.fileExists(atPath: filePath)
        if !isExist {
            do {
                try manager.createDirectory(atPath: filePath, withIntermediateDirectories: true)
                let targetUrl = URL(fileURLWithPath: pdfFilePath)
                try manager.copyItem(at: originFileUrl, to: targetUrl)
                
            } catch {
                debugPrint("createDirectory error:\(error)")
            }
        } else {
            do {
                try manager.removeItem(atPath: filePath)
                try manager.createDirectory(atPath: filePath, withIntermediateDirectories: true)
                let targetUrl = URL(fileURLWithPath: pdfFilePath)
                try manager.copyItem(at: originFileUrl, to: targetUrl)
                
            } catch {
                debugPrint("removeItem error:\(error)")
            }
        }
        
        debugPrint("pdf url - \(pdfFilePath)")
        
        let infoDictJsonPath = documentDirectoryPath + pinjiePath + "/info.json"
        var dict: [String: Any] = [:]
        
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        let formattedDateString = timestampToString(timestamp: currentTimestamp)
        let disname: String = "Document"
        let pdfinfoPathstr = pinjiePath + "/info.json"
        dict["timeStr"] = formattedDateString
        dict["displayName"] = disname
        dict["pdfFilePath"] = pdfPathNameStr
        dict["pdfInfoPath"] = pdfinfoPathstr
        
        let success = saveDictToSandbox(dict: dict, filename: infoDictJsonPath)
        debugPrint("saveDictToSandbox Success = \(success)")
        let item = HistoryItem(timeStr: formattedDateString, pdfFilePath: pdfPathNameStr, displayName: disname, pdfInfoPath: pdfinfoPathstr)
        if historyItems.count == 0 {
            historyItems.append(item)
        } else {
            historyItems.insert(item, at: 0)
        }
        return item
    }
    
    func  saveHistoryImgsToPDF(images: [UIImage]) -> HistoryItem {
        
        let manager = FileManager.default
        let dateStr = CLongLong(round(Date().unixTimestamp*1000)).string
        
        let pinjiePath = "/history/\(dateStr)"
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

        let filePath = documentDirectoryPath + pinjiePath
        
        let isExist = manager.fileExists(atPath: filePath)
        if !isExist {
            do {
                try manager.createDirectory(atPath: filePath, withIntermediateDirectories: true)
            } catch {
                debugPrint("createDirectory error:\(error)")
            }
        } else {
            do {
                try manager.removeItem(atPath: filePath)
                try manager.createDirectory(atPath: filePath, withIntermediateDirectories: true)
            } catch {
                
                debugPrint("removeItem error:\(error)")
            }
        }
        
        //
        let fileNameStr = CLongLong(round(Date().unixTimestamp*1000)).string
        let pdfFilePath = filePath + "/\(fileNameStr)\(".pdf")"
        let pdfPathNameStr = pinjiePath + "/\(fileNameStr)\(".pdf")"
        UIGraphicsBeginPDFContextToFile(pdfFilePath, .zero, nil)
        
        let bounds = UIGraphicsGetPDFContextBounds()
        let pdfWidth = bounds.size.width
        let pdfHeight = bounds.size.height
        
        for image in images {
            
            UIGraphicsBeginPDFPage()
            let imageW = image.size.width
            let imageH = image.size.height
            if (imageW <= pdfWidth && imageH <= pdfHeight) {
                let originX = (pdfWidth - imageW) / 2
                let originY = (pdfHeight - imageH) / 2
                image.draw(in: CGRect(x: originX, y: originY, width: imageW, height: imageH))
            } else {
                var widthm: CGFloat = 0
                var heightm: CGFloat = 0
                
                if ((imageW / imageH) > (pdfWidth / pdfHeight)) {
                    widthm = pdfWidth
                    heightm = widthm * imageH / imageW
                } else {
                    heightm = pdfHeight;
                    widthm = heightm * imageW / imageH;
                }
                image.draw(in: CGRect(x: (pdfWidth - widthm) / 2, y: (pdfHeight - heightm) / 2, width: widthm, height: heightm))
            }
        }
        
        UIGraphicsEndPDFContext()
        
        debugPrint("pdf url - \(pdfFilePath)")
        
        let infoDictJsonPath = documentDirectoryPath + pinjiePath + "/info.json"
        var dict: [String: Any] = [:]
        
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        let formattedDateString = timestampToString(timestamp: currentTimestamp)
        let disname: String = "Document"
        let pdfinfoPathstr = pinjiePath + "/info.json"
        dict["timeStr"] = formattedDateString
        dict["displayName"] = disname
        dict["pdfFilePath"] = pdfPathNameStr
        dict["pdfInfoPath"] = pdfinfoPathstr
        let success = saveDictToSandbox(dict: dict, filename: infoDictJsonPath)
        
        let item = HistoryItem(timeStr: formattedDateString, pdfFilePath: pdfPathNameStr, displayName: disname, pdfInfoPath: pdfinfoPathstr)
        if historyItems.count == 0 {
            historyItems.append(item)
        } else {
            historyItems.insert(item, at: 0)
        }
        return item
    }
    
    func timestampToString(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func saveDictToSandbox(dict: [String: Any], filename: String) -> Bool {
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let url = URL(fileURLWithPath: filename)
            try data.write(to: url)
            return true
        } catch {
            print("Error saving dict to sandbox: \(error.localizedDescription)")
            return false
        }
    }
    
    
    func extractFileType(from urlString: String) -> String? {
        if let url = URL(string: urlString) {
            let fileExtension = url.pathExtension.lowercased()
            return fileExtension
        }
        return nil
    }
}

public class Once {
    var already: Bool = false

    public init() {}

    public func run(_ block: () -> Void) {
        guard !already else {
            return
        }
        block()
        already = true
    }
}


enum FontCusNames: String {
    case SFProRegular = "SFProText-Regular"
    case SFProMedium = "SFProText-Medium"
    case SFProSemiBold = "SFProText-Semibold"
    case SFProBold = "SFProText-Bold"
    case MontLight = "Montserrat-Light"
    case MontRegular = "Montserrat-Regular"
    case MontMedium = "Montserrat-Medium"
    case MontSemiBold = "Montserrat-SemiBold"
    case MontBold = "Montserrat-Bold"
    
    
    func font(sizePoint: CGFloat) -> UIFont {
        return UIFont(name: rawValue, size: sizePoint) ?? UIFont.systemFont(ofSize: sizePoint)
    }
}


