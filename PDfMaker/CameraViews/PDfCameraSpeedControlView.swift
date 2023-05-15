//
//  PDfCameraSpeedControlView.swift
//  PDfMaker
//
//  Created by JOJO on 2023/5/8.
//

import UIKit
 

enum BoundSpeedControlType: String {
    case speed = "Camera speed priority"
    case quality = "Image quality priority"
}

class PDfCameraSpeedControlView: UIView {

    let controlLabel = UILabel()
    let topContentV = UIView()
    var isshowStatus = false
    var currentDetectType: BoundSpeedControlType = .speed {
        didSet {
            controlLabel.text = currentDetectType.rawValue
        }
    }
    
    var valueChangeBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
        topContentV.alpha = 0
        topContentV.transform = CGAffineTransform(translationX: 0, y: -30).scaledBy(x: 0.1, y: 0.1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func setupContent() {
        backgroundColor = .clear
        //
        let controlBtn = UIButton()
        controlBtn.backgroundColor = UIColor(hexString: "#292929")?.withAlphaComponent(0.8)
        addSubview(controlBtn)
        controlBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(160)
            $0.height.equalTo(25)
        }
        controlBtn.layer.cornerRadius = 4
        controlBtn.addTarget(self, action: #selector(controlBtnClick), for: .touchUpInside)
        //
        
        controlBtn.addSubview(controlLabel)
        controlLabel.text = BoundSpeedControlType.speed.rawValue
        controlLabel.textColor = .white
        controlLabel.font = FontCusNames.SFProRegular.font(sizePoint: 11)
        controlLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-5)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(20)
        }
        controlLabel.textAlignment = .center
        controlLabel.adjustsFontSizeToFitWidth = true
        
        //
        let controlArrowImgV = UIImageView()
        controlBtn.addSubview(controlArrowImgV)
        controlArrowImgV.image = UIImage(named: "jiantou")
        controlArrowImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-6)
            $0.width.equalTo(8)
            $0.height.equalTo(4)
        }
        
        //
        
        topContentV.backgroundColor = .white
        addSubview(topContentV)
        topContentV.snp.makeConstraints {
            $0.top.equalTo(controlBtn.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
        }
        topContentV.layer.cornerRadius = 4
        //
        let topBgImgV = UIImageView()
        topBgImgV.image = UIImage(named: "Polygon1")
        topContentV.addSubview(topBgImgV)
        topBgImgV.contentMode = .scaleToFill
        topBgImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(topContentV.snp.top)
            $0.width.equalTo(10)
            $0.height.equalTo(5)
        }
        //
        let fengeLine = UIView()
        fengeLine.backgroundColor = UIColor(hexString: "#E0E3EA")
        topContentV.addSubview(fengeLine)
        fengeLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(1)
        }
        //
        let speedBtn = UIButton()
        speedBtn.setTitle(BoundSpeedControlType.speed.rawValue, for: .normal)
        speedBtn.setTitleColor(UIColor(hexString: "#1C1E37"), for: .normal)
        speedBtn.titleLabel?.font = FontCusNames.SFProMedium.font(sizePoint: 12)
        topContentV.addSubview(speedBtn)
        speedBtn.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(fengeLine.snp.top)
        }
        speedBtn.addTarget(self, action: #selector(speedBtnClick), for: .touchUpInside)
        
        //
        let qualityBtn = UIButton()
        qualityBtn.setTitle(BoundSpeedControlType.quality.rawValue, for: .normal)
        qualityBtn.setTitleColor(UIColor(hexString: "#1C1E37"), for: .normal)
        qualityBtn.titleLabel?.font = FontCusNames.SFProMedium.font(sizePoint: 12)
        topContentV.addSubview(qualityBtn)
        qualityBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(fengeLine.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        qualityBtn.addTarget(self, action: #selector(qualityBtnClick), for: .touchUpInside)
        
        //
        
    }

    @objc func controlBtnClick() {
        if isshowStatus {
            hiddenTopContentV()
        } else {
            showTopContentV()
        }
    }
    @objc func speedBtnClick() {
        hiddenTopContentV()
        currentDetectType = .speed
        valueChangeBlock?()
    }
    @objc func qualityBtnClick() {
        hiddenTopContentV()
        currentDetectType = .quality
        valueChangeBlock?()
    }
    
    func showTopContentV() {
        isshowStatus = true
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.topContentV.alpha = 1
            self.topContentV.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 1, y: 1)
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    func hiddenTopContentV() {
        isshowStatus = false
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.topContentV.alpha = 0
            self.topContentV.transform = CGAffineTransform(translationX: 0, y: -30).scaledBy(x: 0.1, y: 0.1)
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
}
