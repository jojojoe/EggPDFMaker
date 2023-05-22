//
//  PDfHistoryRecentVC.swift
//  PDfMaker
//
//  Created by JOJO on 2023/5/22.
//

import UIKit

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
         
        //
        let titLB = UILabel()
        titLB.textColor = UIColor(hexString: "#1C1E37")
        titLB.font = FontCusNames.MontMedium.font(sizePoint: 20)
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
            $0.top.equalTo(recentLabel.snp.bottom).offset(22)
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
    
    
}
