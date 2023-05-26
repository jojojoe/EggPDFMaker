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
import MessageUI
import Photos

class PDfMakTool: NSObject {
    
    static let `default` = PDfMakTool()
    var historyItems: [HistoryItem] = []
    var importPDFSuccessBlock: ((HistoryItem)->Void)?
    let k_historyItemChange = "historyItemChange"
    let k_historyItemDelete = "historyItemDelete"
    let pdfwidth: CGFloat = 612
    let pdfheight: CGFloat = 792
    
    //Picture Scan
    static let privacyUrl = "https://sites.google.com/view/picture-scan-privacy-policy/home"
    static let termsUrl = "https://sites.google.com/view/picture-scan-terms-of-use/home"
    static let feedbackEmail = "cobinjian110@163.com"
    static let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    static let shareStr = "Share with friends:\("itms-apps://itunes.apple.com/cn/app/id\("6449423346")?mt=8")"
    
    
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
    
    func postDeleteHistoryItem() {
        // 发送添加历史记录通知
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: k_historyItemDelete),
            object: nil,
            userInfo: nil)
        
    }
    
    // 在history collection添加通知 刷新页面
    
    func searchingHistory(contnetStr: String) -> [HistoryItem] {
        
        let results = historyItems.filter {
            $0.displayName.lowercased().contains(contnetStr)
        }
        return results
    }
    
    func deleteHistoryItem(item: HistoryItem) {
        let fileURL = item.dirFilePath()
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {

        }
        historyItems.removeAll {
            $0.pdfFilePath == item.pdfFilePath
        }
        KRProgressHUD.showSuccess(withMessage: "The deletion was successful!")
        postAddHistoryItem()
//        postDeleteHistoryItem()
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
//            let thumbImgPath = dict["thumbImgPath"] as? String ?? ""
            
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
                    if dictArray.count == 0 {
                        dictArray.append(dict)
                    } else {
                        dictArray.insert(dict, at: 0)
                    }
                }
            }
        } catch {
            print("Error parsing info.json files: \(error.localizedDescription)")
        }
        return dictArray
        
    }
 
    
    func  saveHistoryFile(originFileUrl: URL) -> HistoryItem {
        
        var fileName = "Document"
        let nameStr = originFileUrl.absoluteString.lastPathComponent
        if nameStr.contains(".") {
              let strs = nameStr.components(separatedBy: ".")
            if let name = strs.first {
                fileName = name
            }
        }
        
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
        let infoDictJsonPath = documentDirectoryPath + pinjiePath + "/info.json"
        let pdfinfoPathstr = pinjiePath + "/info.json"
        
//        let thumbImgPath = documentDirectoryPath + pinjiePath + "/thumb.jpg"
//        let thumbImgPathStr = pinjiePath + "/thumb.jpg"
        
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
        
        
        var dict: [String: Any] = [:]
        
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        let formattedDateString = timestampToString(timestamp: currentTimestamp)
        let disname: String = fileName
        
        dict["timeStr"] = formattedDateString
        dict["displayName"] = disname
        dict["pdfFilePath"] = pdfPathNameStr
        dict["pdfInfoPath"] = pdfinfoPathstr
//        dict["thumbImgPath"] = thumbImgPathStr
        
        let success = saveDictToSandbox(dict: dict, filename: infoDictJsonPath)
        
        //
        let webV = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        webV.load(URLRequest(url: originFileUrl))
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//            [weak self] in
//            guard let `self` = self else {return}
//            if let thumb = webV.screenshot, let img = thumb.scaled(toWidth: 100) {
//                let thumbsuccess = self.saveUrlThumbToSandbox(thumbImg: thumb, filename: thumbImgPath)
//                debugPrint("thumbsuccess = \(thumbsuccess)")
//            }
//        }
        
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
    
    func saveHistoryImgsToPDF(images: [UIImage], completionBlock: @escaping ((HistoryItem)->Void)) {
        DispatchQueue.global().async {
            [weak self] in
            guard let `self` = self else {return}
            
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
            
    //        let thumbImgPath = documentDirectoryPath + pinjiePath + "/thumb.jpg"
    //        let thumbImgPathStr = pinjiePath + "/thumb.jpg"
            
            
            var dict: [String: Any] = [:]
            
            let currentTimestamp = Int(Date().timeIntervalSince1970)
            let formattedDateString = self.timestampToString(timestamp: currentTimestamp)
            let disname: String = "Document"
            let pdfinfoPathstr = pinjiePath + "/info.json"
            dict["timeStr"] = formattedDateString
            dict["displayName"] = disname
            dict["pdfFilePath"] = pdfPathNameStr
            dict["pdfInfoPath"] = pdfinfoPathstr
    //        dict["thumbImgPath"] = thumbImgPathStr
            
            let success = self.saveDictToSandbox(dict: dict, filename: infoDictJsonPath)
            
            let item = HistoryItem(timeStr: formattedDateString, pdfFilePath: pdfPathNameStr, displayName: disname, pdfInfoPath: pdfinfoPathstr)
            if self.historyItems.count == 0 {
                self.historyItems.append(item)
            } else {
                self.historyItems.insert(item, at: 0)
            }
            //
            self.postAddHistoryItem()
            completionBlock(item)
        }
       
        
//        return item
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
    
    func saveUrlThumbToSandbox(thumbImg: UIImage, filename: String) -> Bool {
        do {
            if let imgdata = thumbImg.jpegData(compressionQuality: 0.8) {
                let url = URL(fileURLWithPath: filename)
                try imgdata.write(to: url)
                return true
            } else {
                return false
            }
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
    func shareFile(item: HistoryItem, fatherVC: UIViewController) {
        let vc = UIActivityViewController(activityItems: [item.pdfPathUrl()], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = fatherVC.view
        fatherVC.present(vc, animated: true)
    }
}

extension PDfMakTool {
    func compressImage(_ image: UIImage, maxLength: CGFloat) -> Data? {
        var compression: CGFloat = 0.9
        let maxCompression: CGFloat = 0.1
        var imageData = image.jpegData(compressionQuality: compression)
        
        while let data = imageData, CGFloat(data.count) > maxLength && compression > maxCompression {
            compression -= 0.1
            imageData = image.jpegData(compressionQuality: compression)
        }
        
        return imageData
    }
}
    
extension PDfMakTool: UIPrintInteractionControllerDelegate {
    func printFile(item: HistoryItem) {
        KRProgressHUD.show()
        let printInVC = UIPrintInteractionController.shared
        printInVC.showsPaperSelectionForLoadedPapers = true
        let info = UIPrintInfo(dictionary: nil)
        info.jobName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Sample Print"
        printInVC.printInfo = info
        
        info.orientation = .portrait // Portrait or Landscape
        info.outputType = .general //ContentType
        
        if item.pdfFilePath.lowercased().contains("pdf") {
            KRProgressHUD.dismiss()
            printInVC.printingItems = [item.pdfPathUrl()] //array of NSData, NSURL, UIImage.
            printInVC.present(animated: true) {
                controller, completed, error in
                debugPrint("completed = \(completed)")
                if completed {
                    KRProgressHUD.showSuccess(withMessage: "Print complete!")
                }
            }
        } else {
            let webV = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            webV.load(URLRequest(url: item.pdfPathUrl()))
            printInVC.printFormatter = webV.viewPrintFormatter()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                KRProgressHUD.dismiss()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                printInVC.present(animated: true) {
                    controller, completed, error in
                    debugPrint("completed = \(completed)")
                    if completed {
                        KRProgressHUD.showSuccess(withMessage: "Print complete!")
                    }
                }
            }
        }
        
        
        printInVC.delegate = self
    }
    
    func printInteractionControllerWillStartJob(_ printInteractionController: UIPrintInteractionController) {
        
    }
    
}

extension PDfMakTool {
    func renameFileName(item: HistoryItem, renameStr: String) {
        
        let infoJsonUrl = item.infoPathUrl()
        if let data = try? Data(contentsOf: infoJsonUrl), var dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            dict["displayName"] = renameStr
            
            do {
                let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let url = infoJsonUrl
                try data.write(to: url)
                //
                item.displayName = renameStr
                postAddHistoryItem()
                
                KRProgressHUD.showSuccess(withMessage: "The file name was modified successfully")
            } catch {
                debugPrint("Error saving dict to sandbox: \(error.localizedDescription)")
            }
        }
    }
    func showRenameFileAlert(item: HistoryItem, fatherVC: UIViewController) {
        let alertController = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter new name"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let renameAction = UIAlertAction(title: "Rename", style: .default) { _ in
            if let textField = alertController.textFields?.first, let newName = textField.text {
                debugPrint("New name: \(newName)")
                if newName != "" {
                    self.renameFileName(item: item, renameStr: newName)
                } else {
                    KRProgressHUD.showInfo(withMessage: "Please enter valid text")
                }
                
            } else {
                KRProgressHUD.showInfo(withMessage: "Please enter valid text")
            }
        }
        alertController.addAction(renameAction)
        fatherVC.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    
}

extension PDfMakTool: WKNavigationDelegate {
    func exportFileToPDF(targetUrl: URL, fatherV: UIView, importPDFSuccessBlock: @escaping ((HistoryItem)->Void)) {
        self.importPDFSuccessBlock = importPDFSuccessBlock
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
        if targetUrl.absoluteString.lowercased().contains("txt") || targetUrl.absoluteString.lowercased().contains("md") {
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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
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
        
//        let thumbImgPath = documentDirectoryPath + pinjiePath + "/thumb.jpg"
//        let thumbImgPathStr = pinjiePath + "/thumb.jpg"
        
        debugPrint("pdf url - \(pdfFilePath)")
        
        let infoDictJsonPath = documentDirectoryPath + pinjiePath + "/info.json"
        var dict: [String: Any] = [:]
        
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        let formattedDateString = timestampToString(timestamp: currentTimestamp)
        var disname: String = "Document"
        
        if let nameStr = webView.url?.absoluteString.lastPathComponent, nameStr.contains(".") {
            let strs = nameStr.components(separatedBy: ".")
            if let name = strs.first {
                disname = name
            }
        }
        
        let pdfinfoPathstr = pinjiePath + "/info.json"
        dict["timeStr"] = formattedDateString
        dict["displayName"] = disname
        dict["pdfFilePath"] = pdfPathNameStr
        dict["pdfInfoPath"] = pdfinfoPathstr
//        dict["thumbImgPath"] = thumbImgPathStr
        
        let success = saveDictToSandbox(dict: dict, filename: infoDictJsonPath)
//        if let thumb = webView.screenshot, let img = thumb.scaled(toWidth: 100) {
//            let thumbsuccess = self.saveUrlThumbToSandbox(thumbImg: thumb, filename: thumbImgPath)
//            debugPrint("thumbsuccess = \(thumbsuccess)")
//        }
        
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
        
        //
        do {
            try pdfData.write(to: URL(fileURLWithPath: pdfFilePath), options: .atomic)
            //
            debugPrint("PDF success:\(pdfFilePath)")
            
            if historyItems.count == 0 {
                historyItems.append(item)
            } else {
                historyItems.insert(item, at: 0)
            }
            
            postAddHistoryItem()
            
            self.importPDFSuccessBlock?(item)
            
        } catch {
            //
            debugPrint("PDF error \(error.localizedDescription)")
            KRProgressHUD.showSuccess(withMessage: "Import failed Please try again.")
        }
        //
        webView.removeFromSuperview()
    }
}

extension PDfMakTool: MFMailComposeViewControllerDelegate {
    func showFeedbcak(fatherViewController: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let version = UIDevice.current.systemVersion
            let modelName = UIDevice.current.modelName
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "0.0.0"
            let appName = "\(PDfMakTool.appName)"
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            vc.setSubject("\(appName) Feedback")
            vc.setToRecipients([PDfMakTool.feedbackEmail])
            vc.setMessageBody("\n\n\nSystem Version：\(version)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion)", isHTML: false)
            fatherViewController.present(vc, animated: true, completion: nil)
        } else {
            KRProgressHUD.showError(withMessage: "The device doesn't support email")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func openSafiPrivacyURL(str: String) {
        if let path = URL(string: str) {
            if UIApplication.shared.canOpenURL(path) {
                UIApplication.shared.open(path, options: [:]) { success in
                }
            }
        }
    }
    
    func openShareApp(fatherViewController: UIViewController) {
        let activityItems = [PDfMakTool.shareStr] as [Any]
        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        fatherViewController.present(vc, animated: true)
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

extension UIDevice {
    ///The device model name, e.g. "iPhone 6s", "iPhone SE", etc
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPad1,1":            return "iPad"
        case "iPad2,1":            return "iPad 2"
        case "iPad3,1":            return "iPad (3rd generation)"
        case "iPad3,4":            return "iPad (4th generation)"
        case "iPad6,11":           return "iPad (5th generation)"
        case "iPad7,5":            return "iPad (6th generation)"
        case "iPad7,11":           return "iPad (7th generation)"
        case "iPad11,6":           return "iPad (8th generation)"
        case "iPad12,1":           return "iPad (9th generation)"
        case "iPad4,1":            return "iPad Air"
        case "iPad5,3":            return "iPad Air 2"
        case "iPad11,3":           return "iPad Air (3rd generation)"
        case "iPad13,1":           return "iPad Air (4th generation)"
        case "iPad13,16":          return "iPad Air (5th generation)"
        case "iPad6,7":            return "iPad Pro (12.9-inch)"
        case "iPad6,3":            return "iPad Pro (9.7-inch)"
        case "iPad7,1":            return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3":            return "iPad Pro (10.5-inch)"
        case "iPad8,1":            return "iPad Pro (11-inch)"
        case "iPad8,5":            return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,9":            return "iPad Pro (11-inch) (2nd generation)"
        case "iPad8,11":           return "iPad Pro (12.9-inch) (4th generation)"
        case "iPad13,4":           return "iPad Pro (11-inch) (3rd generation)"
        case "iPad13,8":           return "iPad Pro (12.9-inch) (5th generation)"
        case "iPad2,5":            return "iPad mini"
        case "iPad4,4":            return "iPad mini 2"
        case "iPad4,7":            return "iPad mini 3"
        case "iPad5,1":            return "iPad mini 4"
        case "iPad11,1":           return "iPad mini (5th generation)"
        case "iPad14,1":           return "iPad mini (6th generation)"
        case "iPhone1,1":          return "iPhone"
        case "iPhone1,2":          return "iPhone 3G"
        case "iPhone2,1":          return "iPhone 3GS"
        case "iPhone3,1":          return "iPhone 4"
        case "iPhone4,1":          return "iPhone 4S"
        case "iPhone5,1":          return "iPhone 5"
        case "iPhone5,3":          return "iPhone 5c"
        case "iPhone6,1":          return "iPhone 5s"
        case "iPhone7,2":          return "iPhone 6"
        case "iPhone7,1":          return "iPhone 6 Plus"
        case "iPhone8,1":          return "iPhone 6s"
        case "iPhone8,2":          return "iPhone 6s Plus"
        case "iPhone8,4":          return "iPhone SE (1st generation)"
        case "iPhone9,1":          return "iPhone 7"
        case "iPhone9,2":          return "iPhone 7 Plus"
        case "iPhone10,1":         return "iPhone 8"
        case "iPhone10,2":         return "iPhone 8 Plus"
        case "iPhone10,3":         return "iPhone X"
        case "iPhone11,8":         return "iPhone XR"
        case "iPhone11,2":         return "iPhone XS"
        case "iPhone11,6":         return "iPhone XS Max"
        case "iPhone12,1":         return "iPhone 11"
        case "iPhone12,3":         return "iPhone 11 Pro"
        case "iPhone12,5":         return "iPhone 11 Pro Max"
        case "iPhone12,8":         return "iPhone SE (2nd generation)"
        case "iPhone13,1":         return "iPhone 12 mini"
        case "iPhone13,2":         return "iPhone 12"
        case "iPhone13,3":         return "iPhone 12 Pro"
        case "iPhone13,4":         return "iPhone 12 Pro Max"
        case "iPhone14,4":         return "iPhone 13 mini"
        case "iPhone14,5":         return "iPhone 13"
        case "iPhone14,2":         return "iPhone 13 Pro"
        case "iPhone14,3":         return "iPhone 13 Pro Max"
        case "iPhone14,6":         return "iPhone SE (3rd generation)"
        case "iPhone14,7":         return "iPhone 14"
        case "iPhone14,8":         return "iPhone 14 Plus"
        case "iPhone15,2":         return "iPhone 14 Pro"
        case "iPhone15,3":         return "iPhone 14 Pro Max"
        case "iPod1,1":            return "iPod touch"
        case "iPod2,1":            return "iPod touch (2nd generation)"
        case "iPod3,1":            return "iPod touch (3rd generation)"
        case "iPod4,1":            return "iPod touch (4th generation)"
        case "iPod5,1":            return "iPod touch (5th generation)"
        case "iPod7,1":            return "iPod touch (6th generation)"
        case "iPod9,1":            return "iPod touch (7th generation)"

        case "i386", "x86_64":     return "Simulator"
        default:                   return identifier
        }
    }
}

public class TaskDelay {
    
    public init() {}
    public static var `default` = TaskDelay()
    var taskBlock: ((_ cancel: Bool)->Void)?
    var actionBlock: (()->Void)?
    
    public func taskDelay(afterTime: TimeInterval, task:@escaping ()->Void) {
        actionBlock = task
        taskBlock = { cancel in
            if let actionBlock = TaskDelay.default.actionBlock {
                if !cancel {
                    DispatchQueue.main.async {
                        actionBlock()
                    }
                    
                }
            }
            TaskDelay.default.taskBlock = nil
            TaskDelay.default.actionBlock = nil
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + afterTime) {
            if let taskBlock = TaskDelay.default.taskBlock {
                taskBlock(false)
            }
        }
        
    }
    
    public func taskCancel() {
        DispatchQueue.main.async {
            if let taskBlock = TaskDelay.default.taskBlock {
                taskBlock(true)
            }
        }
    }
}

class HistoryItem {
    var timeStr: String
    var displayName: String
    var pdfFilePath: String
    var pdfInfoPath: String
    var thumbImg: UIImage?
//    var thumbImgPath: String
    
    init(timeStr: String, pdfFilePath: String, displayName: String, pdfInfoPath: String) {
        self.timeStr = timeStr
        self.displayName = displayName
        self.pdfFilePath = pdfFilePath
        self.pdfInfoPath = pdfInfoPath
//        self.thumbImgPath = thumbImgPath
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
    
//    func thumbImgPathUrl() -> URL {
//        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let pinjiePath = documentDirectoryPath + thumbImgPath
//        let url = URL(fileURLWithPath: pinjiePath)
//        return url
//    }
    
    
    func dirFilePath() -> URL {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let deletestr = pdfFilePath.deletingLastPathComponent
        let pinjiePath = documentDirectoryPath + deletestr
        let url = URL(fileURLWithPath: pinjiePath)
        return url
        
    }
    
}

