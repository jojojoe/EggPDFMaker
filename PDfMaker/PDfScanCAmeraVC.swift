//
//  PDfScanCAmeraVC.swift
//  PDfMaker
//
//  Created by JOJO on 2023/4/27.
//

import UIKit
import KRProgressHUD

class UserImgItem: NSObject {
    var originImg: UIImage
    var processedImg: UIImage
    var quad: Quadrilateral
    init(originImg: UIImage, processedImg: UIImage? = nil, quad: Quadrilateral? = nil) {
        self.originImg = originImg
        if let quad_m = quad {
            self.quad = quad_m
        } else {
            self.quad = WeScanCropManager.default.defaultQuad(forImage: originImg)
        }
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
    let saveBtn = UIButton()
    
    var userImageItemList: [UserImgItem] = []
//    var userIdCardImageList: [UIImage] = []
    var onceLayout = Once()
    
    var currentScanType: ScanType = .scanDoc
    var isCaptureing = false
    
    
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
        scanDocBtn.titleLabel?.font = FontCusNames.MontMedium.font(sizePoint: 15)
        
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
        scanPhotoBtn.titleLabel?.font = FontCusNames.MontMedium.font(sizePoint: 15)
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
        scanCardBtn.titleLabel?.font = FontCusNames.MontMedium.font(sizePoint: 15)
        
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
        multiPhotoAreaView.isUserInteractionEnabled = true
        multiPhotoAreaView.clipsToBounds = true
        multiPhotoAreaView.layer.cornerRadius = 5
        multiPhotoAreaView.backgroundColor = .clear
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
        let multiPhotoAreaBtn = UIButton()
        multiPhotoAreaView.addSubview(multiPhotoAreaBtn)
        multiPhotoAreaBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalTo(multiPhotoAreaView)
        }
        multiPhotoAreaBtn.addTarget(self, action: #selector(multiPhotoAreaBtnClick), for: .touchUpInside)
        //
        
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
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        saveBtn.layer.cornerRadius = 16
        saveBtn.isHidden = true
        
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
        captureCameraView.setupCameraView(false)
        captureCameraView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(captureCameraViewTapGesture(sender: )))
        captureCameraView.addGestureRecognizer(tapGestureRecognizer)
    }
     
    func updateCaptureCameraViewPhotoSession(isHigh: Bool) {
        captureCameraView.stop()
        captureCameraView.setupCameraView(isHigh)
        captureCameraView.start()
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
        boundFloatV.valueChangeBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {

                if self.boundFloatV.currentDetectType == .auto {
                    self.captureCameraView.isBorderDetectionEnabled = true
                    self.autoBtn.isSelected = false
                } else {
                    self.captureCameraView.isBorderDetectionEnabled = false
                    self.autoBtn.isSelected = true
                }
            }
        }
        //
        
        view.addSubview(speedFloatV)
        speedFloatV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topBanner.snp.bottom).offset(-34)
            $0.width.equalTo(160)
            $0.height.equalTo(100)
        }
        speedFloatV.valueChangeBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if self.speedFloatV.currentDetectType == .speed {
                    self.updateCaptureCameraViewPhotoSession(isHigh: false)
                } else {
                    self.updateCaptureCameraViewPhotoSession(isHigh: true)
                }
                
            }
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
    
    func applySharpeningEffect(to image: UIImage) -> UIImage? {
        // 定义锐化滤镜 //CIUnsharpMask
        //
        let sharpness = 1
        let filter = CIFilter(name: "CIColorMonochrome")!
        let ciImage = CIImage(image: image)!
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(CIColor.black, forKey: kCIInputColorKey)
        filter.setValue(sharpness, forKey: kCIInputIntensityKey)
        // 应用滤镜并生成输出图像
        let outputImage = filter.outputImage!
        let context = CIContext(options: nil)
        let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent)!
        // 将输出图像转换为 UIImage
        let sharpenedImage = UIImage(cgImage: outputCGImage)
        return sharpenedImage
    }
}

extension PDfScanCAmeraVC {
    
    func processBlackFilter(img: UIImage) -> UIImage {
        if filterBtn.isSelected {
            return self.applySharpeningEffect(to: img) ?? img
        } else {
            return img
        }
    }
    
//    func cropFixBoundViewImg(originImg: UIImage, cropImgOffsetYBili: CGFloat) -> UIImage {
//        if cropImgOffsetYBili == 0 {
//            return originImg
//        }
//        let offsetX: CGFloat = 0
//        let offsetY = originImg.size.height * cropImgOffsetYBili
//        let croW = originImg.size.width
//        let croH = originImg.size.height - offsetY * 2
//
//        let cropRect = CGRect(x: offsetX, y: offsetY, width: croW, height: croH)
//
//        if let croppedCGImage = originImg.cgImage?.cropping(to: cropRect) {
//            let croppedImage = UIImage(cgImage: croppedCGImage, scale: originImg.scale, orientation: originImg.imageOrientation)
//            return croppedImage
//        } else {
//            return originImg
//        }
//
//
//    }
    
    func captureImgAction() {
        
        captureCameraView.captureImage {[weak self] originImg, detectCropImg, borderDetectFeature, cropImgOffsetYBili in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                guard var imgOrigin_m = originImg else { return }
                guard var imgDetect_m = detectCropImg else { return }
                imgOrigin_m = imgOrigin_m.fixOrientation()
                imgDetect_m = imgDetect_m.fixOrientation()
                let filteredOriginImg = self.processBlackFilter(img: imgOrigin_m)
                let filteredDetectImg = self.processBlackFilter(img: imgDetect_m)
                //
                var quad: Quadrilateral?
                if let borderDetectFeature_m = borderDetectFeature {
                    let topLeft: CGPoint = CGPoint(x: borderDetectFeature_m.topLeft.y, y: borderDetectFeature_m.topLeft.x)
                    let bottomLeft: CGPoint = CGPoint(x: borderDetectFeature_m.bottomLeft.y, y: borderDetectFeature_m.bottomLeft.x)
                    let topRight: CGPoint = CGPoint(x: borderDetectFeature_m.topRight.y, y: borderDetectFeature_m.topRight.x)
                    let bottomRight: CGPoint = CGPoint(x: borderDetectFeature_m.bottomRight.y, y: borderDetectFeature_m.bottomRight.x)
                    
                    quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
                }
                
                //
                var itemfilteredOriginImg = filteredOriginImg
                var itemfilteredDetectImg = filteredDetectImg
                if self.speedFloatV.currentDetectType == .speed {
                    if let dataimg = PDfMakTool.default.compressImage(filteredOriginImg, maxLength: 1024 * 1024 / 2), let img = UIImage(data: dataimg) {
                        itemfilteredOriginImg = img
                    }
                } else {
                    if let dataimg = PDfMakTool.default.compressImage(filteredDetectImg, maxLength: 1024 * 1024 * 2), let img = UIImage(data: dataimg) {
                        itemfilteredDetectImg = img
                    }
                }
                let item = UserImgItem(originImg: itemfilteredOriginImg, processedImg: itemfilteredDetectImg, quad: quad)
                
                if self.currentScanType == .scanDoc {
                    if self.singleFloatV.currentSingleType == .single {
                        let photoEditVC = PDfPhotosEditVC(imgItems: [item])
                        self.navigationController?.pushViewController(photoEditVC, animated: true)
                    } else {
                        if self.boundFloatV.currentDetectType == .auto {
                            self.addNewCapturePhoto(imgItem: item)
                        } else {
                            let boundDetectCropView = PDfPhotoCropView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), imgItem: item, quad: quad)
                            self.view.addSubview(boundDetectCropView)
                            boundDetectCropView.closeClickBlock = {
                                [weak self] in
                                guard let `self` = self else {return}
                                DispatchQueue.main.async {
                                    boundDetectCropView.removeFromSuperview()
                                }
                            }
                            boundDetectCropView.saveClickBlock = {
                                [weak self] imgI in
                                guard let `self` = self else {return}
                                DispatchQueue.main.async {
                                    self.addNewCapturePhoto(imgItem: imgI)
                                    boundDetectCropView.removeFromSuperview()
                                }
                            }
                        }
                    }
                    
                } else if self.currentScanType == .scanPhoto {
                    if self.singleFloatV.currentSingleType == .single {
                        
                        let photoEditVC = PDfPhotosEditVC(imgItems: [item])
                        self.navigationController?.pushViewController(photoEditVC, animated: true)
                    } else {
                        self.addNewCapturePhoto(imgItem: item)
                    }
                    
                } else if self.currentScanType == .scanIDCard {
                    
                    if let originImg_m = originImg {
                        let boundDetectCropView = PDfPhotoCropView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), imgItem: item, quad: quad)
                        self.view.addSubview(boundDetectCropView)
                        boundDetectCropView.closeClickBlock = {
                            [weak self] in
                            guard let `self` = self else {return}
                            DispatchQueue.main.async {
                                boundDetectCropView.removeFromSuperview()
                            }
                        }
                        boundDetectCropView.saveClickBlock = {
                            [weak self] imgI in
                            guard let `self` = self else {return}
                            DispatchQueue.main.async {
                                //
                                self.processAddCardImg(filteredImg: imgI.processedImg)
                                boundDetectCropView.removeFromSuperview()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func processAddCardImg(filteredImg: UIImage) {
        
        let pageWidth: CGFloat = 210 * 5
        let pageHeight: CGFloat = 297 * 5
        let imgWidth: CGFloat = pageWidth/10 * 4
        let imgHieght: CGFloat = imgWidth * (3.0/4.0)
        let verpadding: CGFloat = (pageHeight - imgHieght) / 2
        let imgV1Frame = CGRect(x: (pageWidth - imgWidth)/2, y: verpadding, width: imgWidth, height: imgHieght)
        let whiterPage = UIView(frame: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
        whiterPage.backgroundColor = .white
        let imgV1 = UIImageView(frame: imgV1Frame)
        let img = self.fixIDcardImg(cardImg: filteredImg)
        imgV1.image = img
        whiterPage.addSubview(imgV1)
        imgV1.contentMode = .scaleAspectFit
        imgV1.clipsToBounds = false
        if let cardpageImg = whiterPage.screenshot {
            let item = UserImgItem(originImg: cardpageImg)
            let photoEditVC = PDfPhotosEditVC(imgItems: [item])
            self.navigationController?.pushViewController(photoEditVC, animated: true)
        }
        
    }
    
    
//    func processAddCardImg(filteredImg: UIImage) {
//
//        if self.userIdCardImageList.count == 0 {
//            self.idcardFloatV.contentImgV.isHighlighted = true
//            self.idcardFloatV.controlBtn.isSelected = true
//            self.userIdCardImageList.append(filteredImg)
//        } else if self.userIdCardImageList.count == 1 {
//            self.userIdCardImageList.append(filteredImg)
//            let pageWidth: CGFloat = 210 * 5
//            let pageHeight: CGFloat = 297 * 5
//            let imgWidth: CGFloat = pageWidth/10 * 4
//            let imgHieght: CGFloat = imgWidth * (3.0/4.0)
//            let verpadding: CGFloat = (pageHeight - imgHieght * 2) / 3
//
//
//            let imgV1Frame = CGRect(x: (pageWidth - imgWidth)/2, y: verpadding, width: imgWidth, height: imgHieght)
//            let imgV2Frame = CGRect(x: (pageWidth - imgWidth)/2, y: verpadding + imgHieght + verpadding, width: imgWidth, height: imgHieght)
//
//
//            let whiterPage = UIView(frame: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
//            whiterPage.backgroundColor = .white
//            let imgV1 = UIImageView(frame: imgV1Frame)
//            if let firstImg = self.userIdCardImageList.first {
//                let img = self.fixIDcardImg(cardImg: firstImg)
//                imgV1.image = img
//            }
//
//            whiterPage.addSubview(imgV1)
//            let imgV2 = UIImageView(frame: imgV2Frame)
//            if let lastImg = self.userIdCardImageList.last {
//                let img = self.fixIDcardImg(cardImg: lastImg)
//                imgV2.image = img
//            }
//            whiterPage.addSubview(imgV2)
//
//            imgV1.contentMode = .scaleAspectFit
//            imgV1.clipsToBounds = false
//            imgV2.contentMode = .scaleAspectFit
//            imgV2.clipsToBounds = false
//
//
//            if let cardpageImg = whiterPage.screenshot {
//                let item = UserImgItem(originImg: cardpageImg)
//                let photoEditVC = PDfPhotosEditVC(imgItems: [item])
//                self.navigationController?.pushViewController(photoEditVC, animated: true)
//                self.userIdCardImageList = []
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//                self.idcardFloatV.contentImgV.isHighlighted = false
//                self.idcardFloatV.controlBtn.isSelected = false
//            }
//
//        }
//    }
    
    func fixIDcardImg(cardImg: UIImage) -> UIImage {
        // 获取拍照图片
        var transform = CGAffineTransform.identity
        
        transform = transform.translatedBy(x: cardImg.size.height, y: 0)
        transform = transform.rotated(by: .pi / 2)
        
//        transform = transform.translatedBy(x: 0, y: cardImg.size.height)
//        transform = transform.rotated(by: -.pi / 2)
        
        
        let ctx = CGContext(data: nil, width: Int(cardImg.size.height), height: Int(cardImg.size.width), bitsPerComponent: cardImg.cgImage!.bitsPerComponent, bytesPerRow: 0, space: cardImg.cgImage!.colorSpace!, bitmapInfo: cardImg.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        ctx?.draw(cardImg.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(cardImg.size.width), height: CGFloat(cardImg.size.height)))
        
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        
        return img
    }
    
    
    func addNewCapturePhoto(imgItem: UserImgItem) {
        
        userImageItemList.append(imgItem)
        if let img = userImageItemList.last {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.multiPhotoAreaView.image = img.processedImg
            }
            
            multiPhotoAreaCountLabel.text = "\(userImageItemList.count)"
            multiPhotoAreaView.isHidden = false
            multiPhotoAreaCountLabel.isHidden = false
        }
        
        saveBtn.isHidden = false
        
        addMoveAnimation(img: imgItem.processedImg)
        
    }
    
    func addMoveAnimation(img: UIImage) {
        let firstImgV = UIImageView()
        firstImgV.frame = CGRect(x: 0, y: 0, width: captureCameraView.bounds.size.width/3 * 2, height: captureCameraView.bounds.size.height/3 * 2)
        centerBgV.addSubview(firstImgV)
        firstImgV.center = CGPoint(x: centerBgV.bounds.size.width/2, y: centerBgV.bounds.size.height/2)
        firstImgV.contentMode = .scaleAspectFill
        firstImgV.alpha = 1
        firstImgV.image = img
        
//        let targetFrame
        
        let targetCenter = bottomBanner.convert(multiPhotoAreaView.center, to: centerBgV)
        debugPrint("targetCenter - \(targetCenter)")
        //
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
            firstImgV.frame = CGRect(x: targetCenter.x - 30, y: targetCenter.y - 30, width: 60, height: 60)
            firstImgV.alpha = 0.2
        } completion: { finished in
            if finished {
                firstImgV.removeFromSuperview()
            }
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
        if userImageItemList.count == 25 {
            KRProgressHUD.showInfo(withMessage: "Limit up to 50 images")
            return
        }
        if isCaptureing == false {
            isCaptureing = true
            hiddenFloatPop()
            captureImgAction()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
                [weak self] in
                guard let `self` = self else {return}
                self.isCaptureing = false
            }
        }
        
        
    }
    @objc func saveBtnClick() {
        hiddenFloatPop()
        
        let photoEditVC = PDfPhotosEditVC(imgItems: userImageItemList)
        self.navigationController?.pushViewController(photoEditVC, animated: true)
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
        
        if boundFloatV.currentDetectType == .auto {
            captureCameraView.isBorderDetectionEnabled = true
        } else {
            captureCameraView.isBorderDetectionEnabled = false
        }
        
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
        
        //
        captureCameraView.isBorderDetectionEnabled = false
        
        
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
        
        //
        captureCameraView.isBorderDetectionEnabled = true
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
    
    @objc func multiPhotoAreaBtnClick() {
        saveBtnClick()
    }
}


extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
            
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        default:
            break
        }
        
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
            break
            
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            break
        }
        
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        
        return img
    }
}
