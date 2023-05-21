//
//  PDfPhotoRotateVC.swift
//  PDfMaker
//
//  Created by Joe on 2023/5/13.
//

import UIKit
import CoreImage

class PDfPhotoRotateVC: UIViewController {
    
    var imgItem: UserImgItem
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.image = processingImg
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let canvasV = UIView()
    var saveBlock: ((UserImgItem)->Void)?
    private var rotationAngle = Measurement<UnitAngle>(value: 0, unit: .degrees)
    
    var processingImg: UIImage
    
    init(imgItem: UserImgItem) {
        self.imgItem = imgItem
        self.processingImg = imgItem.processedImg
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContent()
    }
   
    func setupContent() {
        view.backgroundColor = .black
        //
        let backBtn = UIButton()
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.width.height.equalTo(44)
        }
        backBtn.setImage(UIImage(named: "close"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        //
        let saveBtn = UIButton()
        view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(44)
        }
        saveBtn.setTitle("Save", for: .normal)
        saveBtn.setTitleColor(UIColor.white, for: .normal)
        saveBtn.titleLabel?.font = FontCusNames.MontSemiBold.font(sizePoint: 16)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)

        //
        let bottomV = UIView()
        view.addSubview(bottomV)
        bottomV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(90)
        }
        //
        let btnWi: CGFloat = 90
        let btnHe: CGFloat = 44
        let offsetp: CGFloat = CGFloat(Int((UIScreen.main.bounds.size.width - btnWi * 4) / 3))
        
        //
        let rotateRightBtn = UIButton()
        bottomV.addSubview(rotateRightBtn)
        rotateRightBtn.setImage(UIImage(named: "Rotateright"), for: .normal)
        rotateRightBtn.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalTo(bottomV)
            $0.width.equalTo(btnWi)
            $0.height.equalTo(btnHe)
        }
        rotateRightBtn.addTarget(self, action: #selector(rotateRightBtnClick), for: .touchUpInside)
        //
        let rotateLeftBtn = UIButton()
        bottomV.addSubview(rotateLeftBtn)
        rotateLeftBtn.setImage(UIImage(named: "Rotateleft"), for: .normal)
        rotateLeftBtn.snp.makeConstraints {
            $0.left.equalTo(rotateRightBtn.snp.right).offset(offsetp)
            $0.centerY.equalTo(bottomV)
            $0.width.equalTo(btnWi)
            $0.height.equalTo(btnHe)
        }
        rotateLeftBtn.addTarget(self, action: #selector(rotateLeftBtnClick), for: .touchUpInside)
        //
        let flipHorBtn = UIButton()
        bottomV.addSubview(flipHorBtn)
        flipHorBtn.setImage(UIImage(named: "filphor"), for: .normal)
        
        flipHorBtn.snp.makeConstraints {
            $0.left.equalTo(rotateLeftBtn.snp.right).offset(offsetp)
            $0.centerY.equalTo(bottomV)
            $0.width.equalTo(btnWi)
            $0.height.equalTo(btnHe)
        }
        flipHorBtn.addTarget(self, action: #selector(flipHorBtnClick), for: .touchUpInside)
        //

        let flipVerBtn = UIButton()
        bottomV.addSubview(flipVerBtn)
        flipVerBtn.setImage(UIImage(named: "flipver"), for: .normal)
        flipVerBtn.snp.makeConstraints {
            $0.left.equalTo(flipHorBtn.snp.right).offset(offsetp)
            $0.centerY.equalTo(bottomV)
            $0.width.equalTo(btnWi)
            $0.height.equalTo(btnHe)
        }
        flipVerBtn.addTarget(self, action: #selector(flipVerBtnClick), for: .touchUpInside)
        
        //
        
        view.addSubview(canvasV)
        canvasV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomV.snp.top)
            $0.top.equalTo(backBtn.snp.bottom).offset(10)
        }
        //
        canvasV.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
    }

    func rotateRightImage() {
        rotationAngle.value = 90
        reloadImage()
    }
    
    func rotateLeftImage() {
        rotationAngle.value = -90
        reloadImage()
    }

    @objc private func reloadImage() {
        imageView.image = processingImg.rotated(by: rotationAngle) ?? processingImg
        processingImg = imageView.image ?? processingImg
    }
    
    @objc func rotateRightBtnClick() {
        rotateRightImage()
    }
    @objc func rotateLeftBtnClick() {
        rotateLeftImage()
    }
    @objc func flipHorBtnClick() {
        let img = processingImg.flipHorizontally()
        imageView.image = img
        processingImg = imageView.image ?? processingImg
    }
    @objc func flipVerBtnClick() {
        let img = processingImg.flipVerzontally()
        imageView.image = img
        processingImg = imageView.image ?? processingImg
    }
    @objc func backBtnClick() {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func saveBtnClick() {
        backBtnClick()
        imgItem.processedImg = processingImg
        saveBlock?(imgItem)
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        return nil
    }
}


extension UIImage {
    func flipHorizontally() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, true, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        context.translateBy(x: self.size.width/2, y: self.size.height/2)
        context.scaleBy(x: -1.0, y: 1.0)
        context.translateBy(x: -self.size.width/2, y: -self.size.height/2)

        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    func flipVerzontally() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, true, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        context.translateBy(x: self.size.width/2, y: self.size.height/2)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: -self.size.width/2, y: -self.size.height/2)

        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
