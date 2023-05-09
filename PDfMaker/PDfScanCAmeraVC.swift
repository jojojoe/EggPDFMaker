//
//  PDfScanCAmeraVC.swift
//  PDfMaker
//
//  Created by JOJO on 2023/4/27.
//

import UIKit

class PDfScanCAmeraVC: UIViewController {

    
    let scanDocBtn = UIButton()
    let scanPhotoBtn = UIButton()
    let scanCardBtn = UIButton()
    let toolBtnIndicateView = UIView()
    let centerBgV = UIView()
    let lightBtn = UIButton()
    let filterBtn = UIButton()
    var onceLayout = Once()
    
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        onceLayout.run {
            [weak self] in
            guard let `self` = self else {return}
            if centerBgV.frame.size.width == UIScreen.main.bounds.size.width {
                //
                self.addCaptureView()
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
        
        let topBanner = UIView()
        view.addSubview(topBanner)
        topBanner.backgroundColor = .black
        topBanner.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(80)
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
        cancelBtn.titleLabel?.font = PDfFontNames.SFProSemiBold.font(sizePoint: 17)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick(sender: )), for: .touchUpInside)
        //
        let autoBtn = UIButton()
        topBanner.addSubview(autoBtn)
        autoBtn.snp.makeConstraints {
            $0.centerY.equalTo(cancelBtn.snp.centerY)
            $0.right.equalToSuperview().offset(-15)
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }
        autoBtn.setTitle("Auto", for: .normal)
        autoBtn.setTitleColor(.white, for: .normal)
        
        autoBtn.titleLabel?.font = PDfFontNames.SFProSemiBold.font(sizePoint: 17)
        autoBtn.addTarget(self, action: #selector(autoBtnClick(sender: )), for: .touchUpInside)
        //
        let btnPadding: CGFloat = (UIScreen.main.bounds.size.width - 75 * 2 - 40 * 2) / 3
        //
        
        lightBtn.backgroundColor = .lightGray
        topBanner.addSubview(lightBtn)
        lightBtn.snp.makeConstraints {
            $0.centerY.equalTo(cancelBtn.snp.centerY)
            $0.left.equalTo(cancelBtn.snp.right).offset(btnPadding)
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
        lightBtn.setImage(UIImage(named: "filter_n"), for: .normal)
        lightBtn.setImage(UIImage(named: "filter_s"), for: .selected)
        lightBtn.addTarget(self, action: #selector(lightBtnClick(sender: )), for: .touchUpInside)
        
        //
        
        filterBtn.backgroundColor = .lightGray
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
        let bottomBanner = UIView()
        view.addSubview(bottomBanner)
        bottomBanner.backgroundColor = .black
        bottomBanner.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(150)
        }
        //
        let toolBtnBar = UIView()
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
        scanDocBtn.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 16)
        
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
        scanPhotoBtn.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 16)
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
        scanCardBtn.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 16)
        
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
        let multiPhotoAreaView = UIView()
        multiPhotoAreaView.backgroundColor = .lightGray
        bottomBanner.addSubview(multiPhotoAreaView)
        multiPhotoAreaView.snp.makeConstraints {
            $0.centerY.equalTo(captureTakeBtn.snp.centerY)
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(80)
        }
     
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
        saveBtn.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 17)
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
    
    
    func onFlashLigthToggle() {
        let enable = !captureCameraView.isTorchEnabled
        captureCameraView.isTorchEnabled = enable
        lightBtn.isSelected = enable
    }
    
    
    func captureImgAction() {
        
        captureCameraView.captureImage {[weak self] img, borderDetectFeature in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                
            }
        }
         
    }
}


extension PDfScanCAmeraVC {
    @objc func cancelBtnClick(sender: UIButton) {
        
    }
    @objc func lightBtnClick(sender: UIButton) {
        
    }
    @objc func filterBtnClick(sender: UIButton) {
        
    }
    @objc func autoBtnClick(sender: UIButton) {
        
    }
    @objc func captureTakeBtnClick(sender: UIButton) {
        
    }
    @objc func saveBtnClick(sender: UIButton) {
        
    }
    @objc func scanDocBtnClick(sender: UIButton) {
        
    }
    @objc func scanPhotoBtnClick(sender: UIButton) {
        
    }
    @objc func scanCardBtnClick(sender: UIButton) {
        
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
