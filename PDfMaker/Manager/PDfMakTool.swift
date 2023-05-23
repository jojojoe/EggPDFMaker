//
//  PDfMakTool.swift
//  PDfMaker
//
//  Created by JOJO on 2023/4/28.
//

import Foundation
import UIKit
import WebKit
import KRProgressHUD
import PDFKit

class PDfMakTool: NSObject {
    
    static let `default` = PDfMakTool()
    var historyItems: [HistoryItem] = []
    
    let k_historyItemChange = "historyItemChange"
    let pdfwidth: CGFloat = 612
    let pdfheight: CGFloat = 792
    
    override init() {
        super.init()
        
    }
    
    func postAddHistoryItem() {
        // 发送添加历史记录通知
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: k_historyItemChange),
            object: nil,
            userInfo: nil)
        
    }
    
    // 在history collection添加通知 刷新页面
    
    func searchingHistory(contnetStr: String) -> [HistoryItem] {
        
        let results = historyItems.filter {
            $0.displayName.contains(contnetStr)
        }
        return results
    }
    
    
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
        let pdfPathNameStr = pinjiePath + "/\(fileNameStr)\(".")\(urltypeStr)"
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
        //
        postAddHistoryItem()
        
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
        //
        postAddHistoryItem()
        
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

extension PDfMakTool {
    
    
    
}

extension PDfMakTool: WKNavigationDelegate {
    func exportFileToPDF(targetUrl: URL, fatherV: UIView) {
        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}"
        let script = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(script)
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        
        //
        let webV = WKWebView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height + 50, width: pdfwidth, height: pdfheight), configuration: wkWebConfig)
        
        fatherV.addSubview(webV)
        webV.navigationDelegate = self
        //
        if targetUrl.absoluteString.lowercased().contains("txt") {
            do {
                let data = try Data(contentsOf: targetUrl)
                webV.load(data, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: targetUrl)
            } catch {
                
            }
        } else {
            let request = URLRequest(url: targetUrl)
            webV.load(request)
        }
        KRProgressHUD.show()
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("webView: WKWebView, didFinish")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.exportWebV(webView: webView)
            KRProgressHUD.dismiss()
        }
        
        
    }
    
    private func exportWebV(webView: WKWebView) {
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
        
        //
        let printPageRenderer = UIPrintPageRenderer()
        // 设置打印页面大小和边距

        let pageWidth = webView.bounds.size.width
        let pageHeight = webView.bounds.size.height
        let printableRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let printable = CGRectInset(printableRect, 20, 20)
        
        let fmt = webView.viewPrintFormatter()
        fmt.maximumContentWidth = pageWidth
        fmt.maximumContentHeight = pageHeight
        // 添加WebView的内容到打印页面渲染器
        printPageRenderer.addPrintFormatter(fmt, startingAtPageAt: 0)
        
        // 设置打印页面渲染器的页面大小和边距
        printPageRenderer.setValue(printableRect, forKey: "paperRect")
        printPageRenderer.setValue(printable, forKey: "printableRect")
        
        // 创建PDF数据
        let pdfData = NSMutableData()
        
        // 将打印页面渲染器的内容绘制到PDF数据
        UIGraphicsBeginPDFContextToData(pdfData, printableRect, nil)
        
        for pageIndex in 0..<printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            let bounds = UIGraphicsGetPDFContextBounds()
            printPageRenderer.drawPage(at: pageIndex, in: printable)
        }
        
        UIGraphicsEndPDFContext()
        
        // 将PDF数据写入文件
        do {
            try pdfData.write(to: URL(fileURLWithPath: pdfFilePath), options: .atomic)
            // PDF导出成功，你可以在这里进行进一步处理或导出
            debugPrint("PDF导出成功：\(pdfFilePath)")
            
            if historyItems.count == 0 {
                historyItems.append(item)
            } else {
                historyItems.insert(item, at: 0)
            }
            
            postAddHistoryItem()
            KRProgressHUD.showSuccess(withMessage: "Export PDF successfully!")
            
        } catch {
            // PDF导出失败
            debugPrint("PDF导出失败 \(error.localizedDescription)")
            KRProgressHUD.showSuccess(withMessage: "Export failed Please try again.")
        }
        
        //
        webView.removeFromSuperview()
        
         
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
