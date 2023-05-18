//
//  PDfPhotoCropView.swift
//  PDfMaker
//
//  Created by JOJO on 2023/5/12.
//

import UIKit
import AVFoundation
import KRProgressHUD

class PDfPhotoCropView: UIView {
//    var originImg: UIImage
    var imgItem: UserImgItem
    
    
    private var quad: Quadrilateral
    var closeClickBlock: (()->Void)?
    var saveClickBlock: ((UserImgItem)->Void)?
    let ra34Btn = UIButton()
    let ra23Btn = UIButton()
    let resetBtn = UIButton()
    let ra11Btn = UIButton()
    let canvasV = UIView()
    
    private var quadViewWidthConstraint = NSLayoutConstraint()
    private var quadViewHeightConstraint = NSLayoutConstraint()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.image = imgItem.processedImg
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var quadView: QuadrilateralView = {
        let quadView = QuadrilateralView()
        quadView.editable = true
        quadView.translatesAutoresizingMaskIntoConstraints = false
        return quadView
    }()

    private var zoomGestureController: ZoomGestureController!
    
    init(frame: CGRect, imgItem: UserImgItem, rotateImage: Bool = true) {
        self.imgItem = imgItem
        self.quad = WeScanCropManager.default.defaultQuad(forImage: imgItem.processedImg)
        
        super.init(frame: frame)
        setupContent()
        setupCropCanvas()
        zoomGestureController = ZoomGestureController(image: imgItem.processedImg, quadView: quadView)
        let touchDown = UILongPressGestureRecognizer(target: zoomGestureController, action: #selector(zoomGestureController.handle(pan:)))
        touchDown.minimumPressDuration = 0
        canvasV.addGestureRecognizer(touchDown)
        zoomGestureController.touchMoveBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.resetBtn.isEnabled = true
            }
        }
        resetBtn.isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustQuadViewConstraints()
        displayQuad()
    }
    
    func setupCropCanvas() {
        
        canvasV.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        canvasV.addSubview(quadView)
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        quadViewWidthConstraint = quadView.widthAnchor.constraint(equalToConstant: 0.0)
        quadViewHeightConstraint = quadView.heightAnchor.constraint(equalToConstant: 0.0)
        let quadViewConstraints = [
            quadView.centerXAnchor.constraint(equalTo: canvasV.centerXAnchor),
            quadView.centerYAnchor.constraint(equalTo: canvasV.centerYAnchor),
            quadViewWidthConstraint,
            quadViewHeightConstraint
        ]
        NSLayoutConstraint.activate(quadViewConstraints)
    }
    
    func setupContent() {
        backgroundColor = .black
        //
        let backBtn = UIButton()
        addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.width.height.equalTo(44)
        }
        backBtn.setImage(UIImage(named: "close"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        //
        let saveBtn = UIButton()
        addSubview(saveBtn)
        saveBtn.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(44)
        }
        saveBtn.setTitle("Save", for: .normal)
        saveBtn.setTitleColor(UIColor.white, for: .normal)
        saveBtn.titleLabel?.font = FontCusNames.MontSemiBold.font(sizePoint: 16)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)

        //
        let bottomV = UIView()
        addSubview(bottomV)
        bottomV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(90)
        }
        //
        let btnWi: CGFloat = 90
        let btnHe: CGFloat = 44
        let offsetp: CGFloat = CGFloat(Int((UIScreen.main.bounds.size.width - btnWi * 4) / 3))
        
        //

        bottomV.addSubview(resetBtn)
        resetBtn.setImage(UIImage(named: "ArrowsOutSimple"), for: .disabled)
        resetBtn.setImage(UIImage(named: "croprest"), for: .normal)
        resetBtn.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalTo(bottomV)
            $0.width.equalTo(btnWi)
            $0.height.equalTo(btnHe)
        }
        resetBtn.addTarget(self, action: #selector(resetBtnClick), for: .touchUpInside)
        //
        
        bottomV.addSubview(ra11Btn)
        ra11Btn.setTitle("1 : 1", for: .normal)
        ra11Btn.setTitleColor(UIColor.white, for: .normal)
        ra11Btn.titleLabel?.font = FontCusNames.MontSemiBold.font(sizePoint: 16)
        ra11Btn.snp.makeConstraints {
            $0.left.equalTo(resetBtn.snp.right).offset(offsetp)
            $0.centerY.equalTo(bottomV)
            $0.width.equalTo(btnWi)
            $0.height.equalTo(btnHe)
        }
        ra11Btn.addTarget(self, action: #selector(ra11BtnClick), for: .touchUpInside)
        //

        bottomV.addSubview(ra23Btn)
        ra23Btn.setTitle("2 : 3", for: .normal)
        ra23Btn.setTitleColor(UIColor.white, for: .normal)
        ra23Btn.titleLabel?.font = FontCusNames.MontSemiBold.font(sizePoint: 16)
        ra23Btn.snp.makeConstraints {
            $0.left.equalTo(ra11Btn.snp.right).offset(offsetp)
            $0.centerY.equalTo(bottomV)
            $0.width.equalTo(btnWi)
            $0.height.equalTo(btnHe)
        }
        ra23Btn.addTarget(self, action: #selector(ra23BtnClick), for: .touchUpInside)
        //

        bottomV.addSubview(ra34Btn)
        ra34Btn.setTitle("3 : 4", for: .normal)
        ra34Btn.setTitleColor(UIColor.white, for: .normal)
        ra34Btn.titleLabel?.font = FontCusNames.MontSemiBold.font(sizePoint: 16)
        ra34Btn.snp.makeConstraints {
            $0.left.equalTo(ra23Btn.snp.right).offset(offsetp)
            $0.centerY.equalTo(bottomV)
            $0.width.equalTo(btnWi)
            $0.height.equalTo(btnHe)
        }
        ra34Btn.addTarget(self, action: #selector(ra34BtnClick), for: .touchUpInside)
        
        
        //
        
        addSubview(canvasV)
        canvasV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(bottomV.snp.top)
            $0.top.equalTo(backBtn.snp.bottom).offset(10)
        }
        
    }

    
    @objc func backBtnClick() {
        closeClickBlock?()
    }
    
    @objc func resetBtnClick() {
        resetBtn.isEnabled = false
        self.quad = WeScanCropManager.default.defaultQuad(forImage: imgItem.processedImg)
        displayQuad()
    }
    @objc func ra11BtnClick() {
        resetBtn.isEnabled = true
        self.quad = WeScanCropManager.default.defaultQuad11(forImage: imgItem.processedImg)
        displayQuad()
    }
    @objc func ra23BtnClick() {
        resetBtn.isEnabled = true
        self.quad = WeScanCropManager.default.defaultQuad23(forImage: imgItem.processedImg)
        displayQuad()
    }
    @objc func ra34BtnClick() {
        resetBtn.isEnabled = true
        self.quad = WeScanCropManager.default.defaultQuad34(forImage: imgItem.processedImg)
        displayQuad()
    }
    
    @objc func saveBtnClick() {
        guard let quad = quadView.quad,
            let ciImage = CIImage(image: imgItem.processedImg) else {
            KRProgressHUD.showInfo(withMessage: "Something wrong!")
            return
        }
        let cgOrientation = CGImagePropertyOrientation(imgItem.processedImg.imageOrientation) // 图像方向
        let orientedImage = ciImage.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
        let scaledQuad = quad.scale(quadView.bounds.size, imgItem.processedImg.size)
        self.quad = scaledQuad

        // Cropped Image
        var cartesianScaledQuad = scaledQuad.toCartesian(withHeight: imgItem.processedImg.size.height)
        cartesianScaledQuad.reorganize()

        let filteredImage = orientedImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
        ])

        let croppedImage = UIImage.from(ciImage: filteredImage)
        // Enhanced Image
//        let enhancedImage = filteredImage.applyingAdaptiveThreshold()?.withFixedOrientation()
//        let enhancedScan = enhancedImage.flatMap { ImageScannerScan(image: $0) }

//        let results = ImageScannerResults(
//            detectedRectangle: scaledQuad,
//            originalScan: ImageScannerScan(image: imgItem.processedImg),
//            croppedScan: ImageScannerScan(image: croppedImage),
//            enhancedScan: enhancedScan
//        )
        
        imgItem.processedImg = croppedImage

        saveClickBlock?(imgItem)
    }
    
}

extension PDfPhotoCropView {
    private func displayQuad() {
        let imageSize = imgItem.processedImg.size
        let imageFrame = CGRect(
            origin: quadView.frame.origin,
            size: CGSize(width: quadViewWidthConstraint.constant, height: quadViewHeightConstraint.constant)
        )

        let scaleTransform = CGAffineTransform.scaleTransform(forSize: imageSize, aspectFillInSize: imageFrame.size)
        let transforms = [scaleTransform]
        let transformedQuad = quad.applyTransforms(transforms)

        quadView.drawQuadrilateral(quad: transformedQuad, animated: false)
    }
    
    private func adjustQuadViewConstraints() {
        let imgViewBound: CGRect = CGRect(x: 0, y: 0, width: canvasV.bounds.size.width, height: canvasV.bounds.size.height)
        let frame = AVMakeRect(aspectRatio: imgItem.processedImg.size, insideRect: imgViewBound)
        quadViewWidthConstraint.constant = frame.size.width
        quadViewHeightConstraint.constant = frame.size.height
    }
    
}
