//
//  PDfScanCAmeraVC.swift
//  PDfMaker
//
//  Created by JOJO on 2023/4/27.
//

import UIKit

class UserImgItem: NSObject {
    var originImg: UIImage
    var processedImg: UIImage
    init(originImg: UIImage, processedImg: UIImage? = nil) {
        self.originImg = originImg
        self.processedImg = processedImg ?? originImg
        super.init()
    }
}

enum ScanType {
    case scanDoc
    case scanPhoto
    case scanIDCard
}

class PDfScanCAmeraVC: UIViewController {
    let topBanner = UIView()
    let bottomBanner = UIView()
    let toolBtnBar = UIView()
    let scanDocBtn = UIButton()
    let scanPhotoBtn = UIButton()
    let scanCardBtn = UIButton()
    let toolBtnIndicateView = UIView()
    let centerBgV = UIView()
    let lightBtn = UIButton()
    let filterBtn = UIButton()
    let autoBtn = UIButton()
    let singleFloatV = PDfCameraSinglePageControlView()
    let boundFloatV = PDfCameraBoundDetectControlView()
    let speedFloatV = PDfCameraSpeedControlView()
    var idcardFloatV: PDfCameraIdCardControlView!
    let multiPhotoAreaView = UIImageView()
    let multiPhotoAreaCountLabel = UILabel()
    
    var userImageItemList: [UserImgItem] = []
    
    var onceLayout = Once()
    
    var currentScanType: ScanType = .scanDoc
    
    lazy var captureCameraView: MADCameraCaptureView = {
        
        let cameraView = MADCameraCaptureView(frame: centerBgV.bounds)
        cameraView.isBorderDetectionEnabled = true
        cameraView.backgroundColor = .black
        
        return cameraView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupContentV()
        updateDefaultMultiPhotoAreaStatus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        onceLayout.run {
            [weak self] in
            guard let `self` = self else {return}
            if centerBgV.frame.size.width == UIScreen.main.bounds.size.width {
                //
                self.addCaptureView()
                self.addControlFloatView()
                self.updateDefaultAutoBtnStatus()
                self.scanPhotoBtnClick(sender: scanPhotoBtn)
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 关闭闪光灯
        self.captureCameraView.isTorchEnabled = false
        // 停止捕获图像
        self.captureCameraView.stop()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.captureCameraView.start()
        
    }
    
    
    func setupContentV() {
        
        view.addSubview(topBanner)
        topBanner.backgroundColor = .black
        topBanner.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(100)
        }
        //
        let cancelBtn = UIButton()
        topBanner.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(15)
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.setTitleColor(.white, for: .normal)
        cancelBtn.titleLabel?.font = FontCusNames.SFProSemiBold.font(sizePoint: 17)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick(sender: )), for: .touchUpInside)
        //
        
        topBanner.addSubview(autoBtn)
        autoBtn.snp.makeConstraints {
            $0.centerY.equalTo(cancelBtn.snp.centerY)
            $0.right.equalToSuperview().offset(-15)
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }
        
        autoBtn.setTitle("Auto", for: .normal)
        autoBtn.setTitle("Manual", for: .selected)
        autoBtn.setTitleColor(.white, for: .normal)
        autoBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        autoBtn.titleLabel?.font = FontCusNames.SFProSemiBold.font(sizePoint: 17)
        autoBtn.addTarget(self, action: #selector(autoBtnClick(sender: )), for: .touchUpInside)
        //
        let btnPadding: CGFloat = (UIScreen.main.bounds.size.width - 75 * 2 - 40 * 2) / 3
        //
        
        lightBtn.backgroundColor = .clear
        topBanner.addSubview(lightBtn)
        lightBtn.snp.makeConstraints {
            $0.centerY.equalTo(cancelBtn.snp.centerY)
            $0.left.equalTo(cancelBtn.snp.right).offset(btnPadding)
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
        lightBtn.setImage(UIImage(named: "light_n"), for: .normal)
        lightBtn.setImage(UIImage(named: "light_s"), for: .selected)
        lightBtn.addTarget(self, action: #selector(lightBtnClick(sender: )), for: .touchUpInside)
        
        //
        
        filterBtn.backgroundColor = .clear
        topBanner.addSubview(filterBtn)
        filterBtn.snp.makeConstraints {
            $0.centerY.equalTo(cancelBtn.snp.centerY)
            $0.right.equalTo(autoBtn.snp.left).offset(-btnPadding)
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
        filterBtn.setImage(UIImage(named: "filter_n"), for: .normal)
        filterBtn.setImage(UIImage(named: "filter_s"), for: .selected)
        filterBtn.addTarget(self, action: #selector(filterBtnClick(sender: )), for: .touchUpInside)
        
        
        //
        
        view.addSubview(bottomBanner)
        bottomBanner.backgroundColor = .black
        bottomBanner.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(150)
        }
        //
        
        bottomBanner.addSubview(toolBtnBar)
        toolBtnBar.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(46)
        }
        //
        let toolBtnWidth: CGFloat = UIScreen.main.bounds.size.width/3
        //

        toolBtnBar.addSubview(scanDocBtn)
        scanDocBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo(toolBtnWidth)
            $0.height.equalToSuperview()
        }
        scanDocBtn.addTarget(self, action: #selector(scanDocBtnClick(sender: )), for: .touchUpInside)
        scanDocBtn.setTitle("Scan Document", for: .normal)
        scanDocBtn.setTitleColor(.white, for: .normal)
        scanDocBtn.titleLabel?.font = FontCusNames.MontMedium.font(sizePoint: 16)
        
        //

        toolBtnBar.addSubview(scanPhotoBtn)
        scanPhotoBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(scanDocBtn.snp.right)
            $0.width.equalTo(toolBtnWidth)
            $0.height.equalToSuperview()
        }
        scanPhotoBtn.addTarget(self, action: #selector(scanPhotoBtnClick(sender: )), for: .touchUpInside)
        scanPhotoBtn.setTitle("Take Photo", for: .normal)
        scanPhotoBtn.setTitleColor(.white, for: .normal)
        scanPhotoBtn.titleLabel?.font = FontCusNames.MontMedium.font(sizePoint: 16)
        //

        toolBtnBar.addSubview(scanCardBtn)
        scanCardBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(scanPhotoBtn.snp.right)
            $0.width.equalTo(toolBtnWidth)
            $0.height.equalToSuperview()
        }
        scanCardBtn.addTarget(self, action: #selector(scanCardBtnClick(sender: )), for: .touchUpInside)
        scanCardBtn.setTitle("Scan Card", for: .normal)
        scanCardBtn.setTitleColor(.white, for: .normal)
        scanCardBtn.titleLabel?.font = FontCusNames.MontMedium.font(sizePoint: 16)
        
        //
        
        toolBtnBar.addSubview(toolBtnIndicateView)
        toolBtnIndicateView.backgroundColor = .white
        toolBtnIndicateView.snp.makeConstraints {
            $0.centerX.equalTo(scanPhotoBtn)
            $0.top.equalToSuperview()
            $0.width.equalTo(115)
            $0.height.equalTo(3)
        }
        
        //
        let captureTakeBtn = UIButton()
        captureTakeBtn.setImage(UIImage(named: "takephoto"), for: .normal)
        captureTakeBtn.backgroundColor = .clear
        bottomBanner.addSubview(captureTakeBtn)
        captureTakeBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(toolBtnBar.snp.bottom).offset(10)
            $0.width.height.equalTo(72)
        }
        captureTakeBtn.addTarget(self, action: #selector(captureTakeBtnClick(sender: )), for: .touchUpInside)
         
        //
        multiPhotoAreaView.contentMode = .scaleAspectFill
        multiPhotoAreaView.clipsToBounds = true
        multiPhotoAreaView.layer.cornerRadius = 5
        multiPhotoAreaView.backgroundColor = .lightGray
        bottomBanner.addSubview(multiPhotoAreaView)
        multiPhotoAreaView.snp.makeConstraints {
            $0.centerY.equalTo(captureTakeBtn.snp.centerY)
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(60)
        }
        
        bottomBanner.addSubview(multiPhotoAreaCountLabel)
        multiPhotoAreaCountLabel.snp.makeConstraints {
            $0.top.equalTo(multiPhotoAreaView.snp.top).offset(-8)
            $0.right.equalTo(multiPhotoAreaView.snp.right).offset(10)
            $0.width.height.equalTo(24)
        }
        multiPhotoAreaCountLabel.textAlignment = .center
        multiPhotoAreaCountLabel.layer.cornerRadius = 12
        multiPhotoAreaCountLabel.clipsToBounds = true
        multiPhotoAreaCountLabel.backgroundColor = .white
        multiPhotoAreaCountLabel.font = FontCusNames.MontSemiBold.font(sizePoint: 17)
        multiPhotoAreaCountLabel.textColor = UIColor(hexString: "#AE0000")
        multiPhotoAreaCountLabel.adjustsFontSizeToFitWidth = true
        
        
        //
        let saveBtn = UIButton()
        bottomBanner.addSubview(saveBtn)
        saveBtn.snp.makeConstraints {
            $0.centerY.equalTo(captureTakeBtn.snp.centerY)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(89)
            $0.height.equalTo(32)
        }
        saveBtn.backgroundColor = UIColor.white
        saveBtn.setTitle("Save", for: .normal)
        saveBtn.setTitleColor(UIColor(hexString: "#1C1E37"), for: .normal)
        
        saveBtn.titleLabel?.font = FontCusNames.SFProMedium.font(sizePoint: 17)
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender: )), for: .touchUpInside)
        saveBtn.layer.cornerRadius = 16
        
        //
        let line1 = UIView()
        line1.backgroundColor = UIColor(hexString: "#1E2738")
        bottomBanner.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(toolBtnBar.snp.bottom).offset(0)
        }
        
        //
        
        view.addSubview(centerBgV)
        centerBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topBanner.snp.bottom)
            $0.bottom.equalTo(bottomBanner.snp.top)
        }
        
    }

    func addCaptureView() {
        centerBgV.addSubview(captureCameraView)
        captureCameraView.setupCameraView()
        captureCameraView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(captureCameraViewTapGesture(sender: )))
        captureCameraView.addGestureRecognizer(tapGestureRecognizer)
    }
     
    
    
    
}

extension PDfScanCAmeraVC {
    func addControlFloatView() {

        view.addSubview(singleFloatV)
        singleFloatV.snp.makeConstraints {
            $0.width.equalTo(140)
            $0.height.equalTo(100)
            $0.right.equalTo(view.snp.centerX).offset(-5)
            $0.bottom.equalTo(bottomBanner.snp.top).offset(-15)
        }
        
        //
        view.addSubview(boundFloatV)
        boundFloatV.snp.makeConstraints {
            $0.width.equalTo(140)
            $0.height.equalTo(100)
            $0.left.equalTo(view.snp.centerX).offset(5)
            $0.bottom.equalTo(bottomBanner.snp.top).offset(-15)
        }
        
        //
        
        view.addSubview(speedFloatV)
        speedFloatV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topBanner.snp.bottom).offset(-34)
            $0.width.equalTo(160)
            $0.height.equalTo(100)
        }
        
        //
        idcardFloatV = PDfCameraIdCardControlView(frame: centerBgV.frame)
        view.addSubview(idcardFloatV)
      
        
    }
    
    func hiddenFloatPop() {
        if speedFloatV.isshowStatus {
            speedFloatV.hiddenTopContentV()
        }
        if singleFloatV.isshowStatus {
            singleFloatV.hiddenTopContentV()
        }
        if boundFloatV.isshowStatus {
            boundFloatV.hiddenTopContentV()
        }
    }
    
    
    func updateDefaultAutoBtnStatus() {
        autoBtn.isSelected = false
        boundFloatV.currentDetectType = .auto
        
    }
    
    func updateBoundFloatStatus() {
        autoBtn.isSelected = !autoBtn.isSelected
        if autoBtn.isSelected {
            boundFloatV.currentDetectType = .manu
            captureCameraView.isBorderDetectionEnabled = false
        } else {
            boundFloatV.currentDetectType = .auto
            captureCameraView.isBorderDetectionEnabled = true
        }
    }
}

extension PDfScanCAmeraVC {
    
    func captureImgAction() {
        
        captureCameraView.captureImage {[weak self] img, borderDetectFeature in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if self.currentScanType == .scanDoc {
                    if self.boundFloatV.currentDetectType == .auto {
                        
                    } else {
                        
                    }
                    if self.singleFloatV.currentSingleType == .single {
                        
                    } else {
                        
                    }
                    
                } else if self.currentScanType == .scanPhoto {
                    if self.singleFloatV.currentSingleType == .single {
                        
                    } else {
                        
                    }
                    if self.speedFloatV.currentDetectType == .quality {
                        
                    } else {
                        
                    }
                    
                } else if self.currentScanType == .scanIDCard {
                    
                }
                
            }
        }
         
    }
    
    
    func addNewCapturePhoto(img: UIImage) {
        let imgItem = UserImgItem(originImg: img)
        userImageItemList.append(imgItem)
        if let img = userImageItemList.last {
            multiPhotoAreaView.image = img.processedImg
            multiPhotoAreaCountLabel.text = "\(userImageItemList.count)"
            multiPhotoAreaView.isHidden = false
            multiPhotoAreaCountLabel.isHidden = false
        }
    }
    
    func updateDefaultMultiPhotoAreaStatus() {
        multiPhotoAreaView.isHidden = true
        multiPhotoAreaCountLabel.isHidden = true
    }
}

extension PDfScanCAmeraVC {
    @objc func cancelBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    @objc func lightBtnClick(sender: UIButton) {
        hiddenFloatPop()
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            self.captureCameraView.isTorchEnabled = true
        } else {
            self.captureCameraView.isTorchEnabled = false
        }
        
    }
    @objc func filterBtnClick(sender: UIButton) {
        hiddenFloatPop()
        sender.isSelected = !sender.isSelected
    }
    @objc func autoBtnClick(sender: UIButton) {
        hiddenFloatPop()
        updateBoundFloatStatus()
    }
    @objc func captureTakeBtnClick(sender: UIButton) {
        hiddenFloatPop()
        captureImgAction()
    }
    @objc func saveBtnClick(sender: UIButton) {
        hiddenFloatPop()
        
    }
    @objc func scanDocBtnClick(sender: UIButton) {
        currentScanType = .scanDoc
        hiddenFloatPop()
        toolBtnIndicateView.snp.remakeConstraints {
            $0.centerX.equalTo(scanDocBtn)
            $0.top.equalToSuperview()
            $0.width.equalTo(115)
            $0.height.equalTo(3)
        }
        singleFloatV.snp.remakeConstraints {
            $0.width.equalTo(140)
            $0.height.equalTo(100)
            $0.right.equalTo(centerBgV.snp.centerX).offset(-5)
            $0.bottom.equalTo(centerBgV.snp.bottom).offset(-15)
        }
        
        singleFloatV.isHidden = false
        boundFloatV.isHidden = false
        speedFloatV.isHidden = true
        idcardFloatV.isHidden = true
        
    }
    @objc func scanPhotoBtnClick(sender: UIButton) {
        currentScanType = .scanPhoto
        hiddenFloatPop()
        toolBtnIndicateView.snp.remakeConstraints {
            $0.centerX.equalTo(scanPhotoBtn)
            $0.top.equalToSuperview()
            $0.width.equalTo(115)
            $0.height.equalTo(3)
        }
        singleFloatV.snp.remakeConstraints {
            $0.width.equalTo(140)
            $0.height.equalTo(100)
            $0.centerX.equalTo(centerBgV.snp.centerX)
            $0.bottom.equalTo(centerBgV.snp.bottom).offset(-15)
        }
        
        singleFloatV.isHidden = false
        boundFloatV.isHidden = true
        speedFloatV.isHidden = false
        idcardFloatV.isHidden = true
    }
    @objc func scanCardBtnClick(sender: UIButton) {
        currentScanType = .scanIDCard
        hiddenFloatPop()
        toolBtnIndicateView.snp.remakeConstraints {
            $0.centerX.equalTo(scanCardBtn)
            $0.top.equalToSuperview()
            $0.width.equalTo(115)
            $0.height.equalTo(3)
        }
        
        singleFloatV.isHidden = true
        boundFloatV.isHidden = true
        speedFloatV.isHidden = true
        idcardFloatV.isHidden = false
        
    }
     
    
    @objc func captureCameraViewTapGesture(sender: UIGestureRecognizer) {
        if sender.state == .recognized {
            let location = sender.location(in: centerBgV)
            self.captureCameraView.focus(at: location) {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    
                }
            }
        }
    }
}
