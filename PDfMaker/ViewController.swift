//
//  ViewController.swift
//  PDfMaker
//
//  Created by JOJO on 2023/4/27.
//

import UIKit
import SnapKit
import SwifterSwift
import YPImagePicker
import Photos
import AVFoundation



class ViewController: UIViewController {

    let proBtn = UIButton()
    let homePageV = UIView()
    let fileCollection = PDfHomeRecentListView()
    let homeBottomBtn = HomeBottomSettingBtn(frame: .zero, iconStrS: "tab_home_s", iconStrN: "tab_home_n", nameStr: "Home")
    let settingBottomBtn = HomeBottomSettingBtn(frame: .zero, iconStrS: "tab_sett_s", iconStrN: "tab_setting_n", nameStr: "Setting")
    let scaneCameraBtn = UIButton()
    
    var isSearchingStr: String? = nil
 
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#EFEFEF")
        PDfMakTool.default.loadHistoryItem()
        addnoti()
        setupHomePage()
        setupSettingPage()
        setupScaneCamera()
        
        
    }
    
    
    func addnoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateContentProStatus(noti: )), name: NSNotification.Name(rawValue: PDfMakTool.default.k_historyItemChange), object: nil)
    }

    @objc func updateContentProStatus(noti: Notification) {
        DispatchQueue.main.async {
            self.updateHistoryStatus()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func updateHistoryStatus() {
        if isSearchingStr == nil {
            fileCollection.updateContent(fileList: PDfMakTool.default.historyItems)
        }
    }
    
}


extension ViewController {
    func setupScaneCamera() {
        view.addSubview(scaneCameraBtn)
        scaneCameraBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(homeBottomBtn.snp.top).offset(10)
            $0.width.height.equalTo(60)
        }
        scaneCameraBtn.setImage(UIImage(named: "home_camera"), for: .normal)
        scaneCameraBtn.addTarget(self, action: #selector(scaneBtnClick(sender: )), for: .touchUpInside)
    }
    
    func setupHomePage() {
        view.addSubview(homePageV)
        homePageV.backgroundColor = UIColor(hexString: "#EFEFEF")
        homePageV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        let topMaskV = UIView()
        topMaskV.backgroundColor = UIColor(hexString: "#AE0000")
        homePageV.addSubview(topMaskV)
        topMaskV.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
        }
        //
        let topBannerBgV = UIView()
        homePageV.addSubview(topBannerBgV)
        topBannerBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topMaskV.snp.bottom)
            $0.height.equalTo(64)
        }
        let topBannerImgV = UIImageView()
        topBannerBgV.addSubview(topBannerImgV)
        topBannerImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        topBannerImgV.image = UIImage(named: "hometop_banner")
        //
        let pdfLabel = UILabel()
        topBannerBgV.addSubview(pdfLabel)
        pdfLabel.text = "PDF"
        pdfLabel.font = FontCusNames.MontBold.font(sizePoint: 32)
        pdfLabel.textColor = .white
        pdfLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        let searchBgV = UIView()
        topBannerBgV.addSubview(searchBgV)
        searchBgV.backgroundColor = UIColor.white
        searchBgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(104)
            $0.right.equalToSuperview().offset(-58)
            $0.height.equalTo(34)
        }
        searchBgV.layer.cornerRadius = 34/2
        //
        let searchIconImgV = UIImageView()
        searchBgV.addSubview(searchIconImgV)
        searchIconImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.width.height.equalTo(20)
        }
        searchIconImgV.image = UIImage(named: "MagnifyingGlass")
        
        //
        let searchTextField = UITextField()
        searchBgV.addSubview( searchTextField)
        searchTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(36)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalToSuperview()
        }
        searchTextField.textColor = .black
        searchTextField.returnKeyType = .done
        searchTextField.placeholder = "Search"
        searchTextField.font = FontCusNames.MontMedium.font(sizePoint: 14)
        searchTextField.delegate = self
        searchTextField.clearButtonMode = .whileEditing
        
        //
        
        topBannerBgV.addSubview(proBtn)
        proBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-14)
            $0.width.height.equalTo(44)
        }
        proBtn.setImage(UIImage(named: "tarawangguan"), for: .normal)
        proBtn.addTarget(self, action: #selector(proBtnClick), for: .touchUpInside)
        
        //
        let photoBtn = HomeTypeBtn(frame: .zero, iconStr: "home_photo", nameStr: "Import Image")
        homePageV.addSubview(photoBtn)
        photoBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalTo(view.snp.centerX).offset(-10)
            $0.top.equalTo(topBannerBgV.snp.bottom).offset(29)
            $0.height.equalTo(120)
        }
        photoBtn.addTarget(self, action: #selector(photoBtnClick), for: .touchUpInside)
        
        //
        let fileBtn = HomeTypeBtn(frame: .zero, iconStr: "home_file", nameStr: "Import File")
        homePageV.addSubview(fileBtn)
        fileBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-24)
            $0.left.equalTo(view.snp.centerX).offset(10)
            $0.top.equalTo(topBannerBgV.snp.bottom).offset(29)
            $0.height.equalTo(120)
        }
        fileBtn.addTarget(self, action: #selector(fileBtnClick), for: .touchUpInside)
        
        //
        let recentLabel = UILabel()
        homePageV.addSubview(recentLabel)
        recentLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalTo(fileBtn.snp.bottom).offset(30)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        recentLabel.font = FontCusNames.MontBold.font(sizePoint: 20)
        recentLabel.textColor = UIColor(hexString: "#1C1E37")
        recentLabel.text = "Recent files"
        
        //
        let recentEnterBtn = UIButton()
        homePageV.addSubview(recentEnterBtn)
        recentEnterBtn.snp.makeConstraints {
            $0.centerY.equalTo(recentLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-14)
            $0.width.height.equalTo(44)
        }
        recentEnterBtn.setImage(UIImage(named: "ArrowRightrecent"), for: .normal)
        recentEnterBtn.addTarget(self, action: #selector(recentEnterBtnClick), for: .touchUpInside)
        
        //
        
        homePageV.addSubview(fileCollection)
        fileCollection.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(recentLabel.snp.bottom).offset(30)
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
        
        
        //
        let bottomMaskLeftImgV = UIImageView()
        homePageV.addSubview(bottomMaskLeftImgV)
        bottomMaskLeftImgV.snp.makeConstraints {
            $0.left.bottom.equalToSuperview()
            $0.right.equalTo(homePageV.snp.centerX)
            $0.height.equalTo(236/2)
        }
        bottomMaskLeftImgV.image = UIImage(named: "homeBottombar1")
        
        //
        let bottomMaskRightImgV = UIImageView()
        homePageV.addSubview(bottomMaskRightImgV)
        bottomMaskRightImgV.snp.makeConstraints {
            $0.right.bottom.equalToSuperview()
            $0.left.equalTo(homePageV.snp.centerX)
            $0.height.equalTo(236/2)
        }
        bottomMaskRightImgV.image = UIImage(named: "homeBottombar2")
        
        //

        view.addSubview(homeBottomBtn)
        homeBottomBtn.snp.makeConstraints {
            $0.centerX.equalTo(bottomMaskLeftImgV.snp.centerX).offset(-30)
            $0.centerY.equalTo(bottomMaskLeftImgV.snp.centerY)
            $0.width.equalTo(60)
            $0.height.equalTo(48)
        }
        homeBottomBtn.addTarget(self, action: #selector(homeBottomBtnClick), for: .touchUpInside)
        homeBottomBtn.isSelected = true
        //

        view.addSubview(settingBottomBtn)
        settingBottomBtn.snp.makeConstraints {
            $0.centerX.equalTo(bottomMaskRightImgV.snp.centerX).offset(30)
            $0.centerY.equalTo(bottomMaskRightImgV.snp.centerY)
            $0.width.equalTo(60)
            $0.height.equalTo(48)
        }
        settingBottomBtn.addTarget(self, action: #selector(settingBottomBtnClick), for: .touchUpInside)
        settingBottomBtn.isSelected = false
        
        
        
    }
    
    
    
    func setupSettingPage() {
        
    }
    
   
    
}

extension ViewController {
    
    func showURLPreviewVC(url: URL) {
        let _ = PDfMakTool.default.saveHistoryFile(originFileUrl: url)
        let previewVC = PDfWePreviewVC(webUrl: url)
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    func showItemMoreSheetAlert(item: HistoryItem) {
        
    }
    
    func startSearching(contentStr: String) {
        let searchingItemList = PDfMakTool.default.searchingHistory(contnetStr: contentStr)
        self.fileCollection.updateContent(fileList: searchingItemList)
    }
    
    
}

extension ViewController {
    @objc func proBtnClick() {
        
    }
    
    @objc func photoBtnClick() {
        checkAlbumAuthorization()
    }
    
    @objc func fileBtnClick() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc", "com.microsoft.excel.xls", "com.adobe.pdf", "public.text"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        self.present(documentPicker, animated: true)
    }
    
    @objc func recentEnterBtnClick() {
        
    }
    
    @objc func homeBottomBtnClick() {
        
    }
    
    @objc func settingBottomBtnClick() {
        
    }
    
    @objc func scaneBtnClick(sender: UIButton) {
        checkCameraAuthorizatino {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                let vc = PDfScanCAmeraVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

    }
    
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        TaskDelay.default.taskDelay(afterTime: 1) {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                
                if let textStr = textField.text, textStr != "" {
                    self.isSearchingStr = textStr
                    self.startSearching(contentStr: textStr)
                } else {
                    self.isSearchingStr = nil
                    self.updateHistoryStatus()
                }
                
            }
            
        }
        
        return true
    }
    
}

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if controller.documentPickerMode == .import {
            // What should be the line below?
            for (ind, url) in urls.enumerated() {
                debugPrint("documentURLs - \(ind) path - \(url)")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                if let targetUrl = urls.first {
                    self.showURLPreviewVC(url: targetUrl)
                }
            }
        }
    }
   
}

extension ViewController {
    func checkCameraAuthorizatino(authorizationBlock: (()->Void)?) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authStatus == .restricted || authStatus == .denied {
            // no
            showCameraDeniedAlert()
        } else if authStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if (!granted) {
                        //不允许
                        self.showCameraDeniedAlert()
                    } else {
                        //开启
                        authorizationBlock?()
                    }
                }
            }
        } else {
            // yes
            authorizationBlock?()
        }
        
        
    }
    
    
    func showCameraDeniedAlert() {
        let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Camera.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
            DispatchQueue.main.async {
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:])
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) {[weak self] status in
                    guard let `self` = self else {return}
                    DispatchQueue.main.async {
                        switch status {
                        case .authorized:
                            self.presentPhotoPickerController()
                        case .limited:
                            self.presentPhotoPickerController()
                        case .notDetermined:
                            if status == PHAuthorizationStatus.authorized {
                                self.presentPhotoPickerController()
                            } else if status == PHAuthorizationStatus.limited {
                                self.presentPhotoPickerController()
                            }
                        case .denied:
                            self.showPhotoDeniedAlert()
                        case .restricted:
                            self.showPhotoDeniedAlert()
                        default: break
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    PHPhotoLibrary.requestAuthorization { status in
                        switch status {
                        case .authorized:
                            self.presentPhotoPickerController()
                        case .limited:
                            self.presentPhotoPickerController()
                        case .denied:
                            self.showPhotoDeniedAlert()
                        case .restricted:
                            self.showPhotoDeniedAlert()
                        default: break
                        }
                    }
                }
            }
        }
    }
    
    func showPhotoDeniedAlert() {
        let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
            DispatchQueue.main.async {
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:])
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func presentPhotoPickerController() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 50
        config.screens = [.library]
        config.library.skipSelectionsGallery = true
        config.library.defaultMultipleSelection = true
        config.library.preselectedItems = nil
        config.showsPhotoFilters = false
        let picker = YPImagePicker(configuration: config)
        picker.view.backgroundColor = UIColor.white
        picker.didFinishPicking { [weak self] items, cancelled in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                var imgItems: [UserImgItem] = []
                for item in items {
                    switch item {
                    case .photo(let photo):
                        if let img = photo.image.scaled(toWidth: 1200) {
                            let item = UserImgItem(originImg: img)
                            imgItems.append(item)
                        }
                        debugPrint(photo)
                    case .video(let video):
                        debugPrint(video)
                    }
                }
                picker.dismiss(animated: true, completion: nil)
                if !cancelled {
                    self.showPreviewVC(imageItems: imgItems)
                }
            }
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func showPreviewVC(imageItems: [UserImgItem]) {
        
        let editVC = PDfPhotosEditVC(imgItems: imageItems)
        self.navigationController?.pushViewController(editVC, animated: true)
        
    }
}


class HomeTypeBtn: UIButton {
    var iconStr: String
    var nameStr: String
    
    init(frame: CGRect, iconStr: String, nameStr: String) {
        self.iconStr = iconStr
        self.nameStr = nameStr
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 20
        //
        let iconImgV = UIImageView()
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(snp.centerY).offset(0)
            $0.width.height.equalTo(32)
        }
        iconImgV.image = UIImage(named: iconStr)
        //
        let nameL = UILabel()
        addSubview(nameL)
        nameL.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImgV.snp.bottom).offset(10)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        nameL.font = FontCusNames.MontBold.font(sizePoint: 14)
        nameL.textColor = UIColor(hexString: "#1C1E37")
        nameL.text = nameStr
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class HomeBottomSettingBtn: UIButton {
    var iconStrS: String
    var iconStrN: String
    var nameStr: String
    let iconImgV = UIImageView()
    let nameL = UILabel()
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                iconImgV.image = UIImage(named: iconStrS)
                nameL.textColor = UIColor(hexString: "#AE0000")
            } else {
                iconImgV.image = UIImage(named: iconStrN)
                nameL.textColor = UIColor(hexString: "#A6A7B8")
            }
        }
    }
    
    init(frame: CGRect, iconStrS: String, iconStrN: String, nameStr: String) {
        self.iconStrS = iconStrS
        self.iconStrN = iconStrN
        self.nameStr = nameStr
        super.init(frame: frame)
        backgroundColor = .clear
        //

        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(snp.top).offset(0)
            $0.width.height.equalTo(56/2)
        }
        
        //
        
        addSubview(nameL)
        nameL.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(snp.bottom).offset(0)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        nameL.font = FontCusNames.MontSemiBold.font(sizePoint: 10)
        nameL.textColor = UIColor(hexString: "#AE0000")
        nameL.text = nameStr
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



