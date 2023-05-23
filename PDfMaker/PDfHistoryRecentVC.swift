//
//  PDfHistoryRecentVC.swift
//  PDfMaker
//
//  Created by JOJO on 2023/5/22.
//

import UIKit
import KRProgressHUD


class PDfHistoryRecentVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupContentV()
    }
    


}

extension PDfHistoryRecentVC {
    
    func setupContentV() {
        view.backgroundColor = UIColor(hexString: "#EFEFEF")
        view.clipsToBounds = true
        
        //
        let backbtn = UIButton()
        view.addSubview(backbtn)
        backbtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.width.height.equalTo(44)
        }
        backbtn.setImage(UIImage(named: "ArrowLeft"), for: .normal)
        backbtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        //
        
        let titLB = UILabel()
        titLB.textColor = UIColor(hexString: "#1C1E37")
        titLB.font = FontCusNames.MontSemiBold.font(sizePoint: 20)
        view.addSubview(titLB)
        titLB.snp.makeConstraints {
            $0.centerY.equalTo(backbtn.snp.centerY).offset(0)
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        titLB.text = "Recent files"
        
        //
        let fileCollection = PDfHomeRecentListView()
        view.addSubview(fileCollection)
        fileCollection.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(titLB.snp.bottom).offset(22)
        }
        fileCollection.itemSelectBlock = {
            [weak self] fileitem in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.showURLPreviewVC(url: fileitem.pdfPathUrl())
            }
        }
        fileCollection.itemMoreClickBlock = {
            [weak self] fileitem in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.showItemMoreSheetAlert(item: fileitem)
            }
        }
        
        fileCollection.updateContent(fileList: PDfMakTool.default.historyItems)
        
        
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func showURLPreviewVC(url: URL) {
        let _ = PDfMakTool.default.saveHistoryFile(originFileUrl: url)
        let previewVC = PDfWePreviewVC(webUrl: url)
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    
}

extension PDfHistoryRecentVC {
    
    func showItemMoreSheetAlert(item: HistoryItem) {
        let sheetAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let renameAction = UIAlertAction(title: "Rename", style: .default) { (action) in
            self.renameAction(item: item)
            sheetAlert.dismiss(animated: true)
        }
        let printAction = UIAlertAction(title: "Print", style: .default) { (action) in
            self.printAction(item: item)
            sheetAlert.dismiss(animated: true)
        }
        let exportpdfAction = UIAlertAction(title: "Export to PDF", style: .default) { (action) in
            self.exportAction(item: item)
            sheetAlert.dismiss(animated: true)
        }
        let shareAction = UIAlertAction(title: "Share", style: .default) { (action) in
            self.shareAction(item: item)
            sheetAlert.dismiss(animated: true)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteAction(item: item)
            sheetAlert.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheetAlert.addAction(renameAction)
        sheetAlert.addAction(printAction)
        if let urltypeStr = PDfMakTool.default.extractFileType(from: item.pdfFilePath), urltypeStr.lowercased() == "pdf" {
            
        } else {
            sheetAlert.addAction(exportpdfAction)
        }
        
        sheetAlert.addAction(shareAction)
        sheetAlert.addAction(deleteAction)
        sheetAlert.addAction(cancelAction)
        self.present(sheetAlert, animated: true, completion: nil)
        
    }
    
    func printAction(item: HistoryItem) {
        
        let printInVC = UIPrintInteractionController.shared
        printInVC.showsPaperSelectionForLoadedPapers = true
        let info = UIPrintInfo(dictionary: nil)
        info.jobName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Sample Print"
        printInVC.printInfo = info
        printInVC.printingItems = [item.pdfPathUrl()] //array of NSData, NSURL, UIImage.
        printInVC.present(animated: true) {
            controller, completed, error in
            debugPrint("completed = \(completed)")
            if completed {
                KRProgressHUD.showSuccess(withMessage: "Print complete!")
            }
        }
        printInVC.delegate = self
    }
    func shareAction(item: HistoryItem) {
        let vc = UIActivityViewController(activityItems: [item.pdfPathUrl()], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view
        self.present(vc, animated: true)
    }
    func exportAction(item: HistoryItem) {
        
    }
    func renameAction(item: HistoryItem) {
        
    }
    func deleteAction(item: HistoryItem) {
        
    }
}

extension PDfHistoryRecentVC: UIPrintInteractionControllerDelegate {
    func printInteractionControllerWillStartJob(_ printInteractionController: UIPrintInteractionController) {
        
    }
    
}
