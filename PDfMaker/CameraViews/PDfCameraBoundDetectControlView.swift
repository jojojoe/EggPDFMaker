//
//  PDfCameraBoundDetectControlView.swift
//  PDfMaker
//
//  Created by JOJO on 2023/5/8.
//

import UIKit
 

enum BoundDetectControlType: String {
    case auto = "Boundary detection"
    case manu = "Manual cutting"
}

class PDfCameraBoundDetectControlView: UIView {
    var faVC: UIViewController?
    let controlLabel = UILabel()
    let topContentV = UIView()
    var isshowStatus = false
    var currentDetectType: BoundDetectControlType = .auto {
        didSet {
            controlLabel.text = currentDetectType.rawValue
        }
    }
    
    var valueChangeBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
        topContentV.alpha = 0
        topContentV.transform = CGAffineTransform(translationX: 0, y: 30).scaledBy(x: 0.1, y: 0.1)
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
            $0.bottom.equalToSuperview()
            $0.width.equalTo(130)
            $0.height.equalTo(25)
        }
        controlBtn.layer.cornerRadius = 4
        controlBtn.addTarget(self, action: #selector(controlBtnClick), for: .touchUpInside)
        //
        
        controlBtn.addSubview(controlLabel)
        controlLabel.text = BoundDetectControlType.auto.rawValue
        controlLabel.textColor = .white
        controlLabel.font = FontCusNames.SFProRegular.font(sizePoint: 11)
        controlLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-5)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(110)
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
        topContentV.clipsToBounds = false
        topContentV.backgroundColor = .white
        topContentV.layer.cornerRadius = 4
        addSubview(topContentV)
        topContentV.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(controlBtn.snp.top).offset(-10)
        }
        
        //
        let topBgImgV = UIImageView()
        topContentV.addSubview(topBgImgV)
        topBgImgV.image = UIImage(named: "Polygon2")
        topBgImgV.contentMode = .scaleToFill
        topBgImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topContentV.snp.bottom).offset(0)
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
        let autoBtn = UIButton()
        autoBtn.setTitle(BoundDetectControlType.auto.rawValue, for: .normal)
        autoBtn.setTitleColor(UIColor(hexString: "#1C1E37"), for: .normal)
        
        autoBtn.titleLabel?.font = FontCusNames.SFProMedium.font(sizePoint: 12)
        topContentV.addSubview(autoBtn)
        autoBtn.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(fengeLine.snp.top)
        }
        autoBtn.addTarget(self, action: #selector(autoBtnClick), for: .touchUpInside)
        
        //
        let manuBtn = UIButton()
        manuBtn.setTitle(BoundDetectControlType.manu.rawValue, for: .normal)
        manuBtn.setTitleColor(UIColor(hexString: "#1C1E37"), for: .normal)
        manuBtn.titleLabel?.font = FontCusNames.SFProMedium.font(sizePoint: 12)
        topContentV.addSubview(manuBtn)
        manuBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(fengeLine.snp.bottom)
            $0.bottom.equalToSuperview().offset(-4)
        }
        manuBtn.addTarget(self, action: #selector(manuBtnClick), for: .touchUpInside)
        
        //
        
    }

    @objc func controlBtnClick() {
        if isshowStatus {
            hiddenTopContentV()
        } else {
            if !PDfSubscribeStoreManager.default.inSubscription {
                if let vc = faVC {
                    PDfMakTool.default.showSubscribeStoreVC(contentVC: vc)
                }
                return
            } else {
                showTopContentV()
            }
        }
    }
    @objc func autoBtnClick() {
        hiddenTopContentV()
        currentDetectType = .auto
        valueChangeBlock?()
    }
    @objc func manuBtnClick() {
        hiddenTopContentV()
        currentDetectType = .manu
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
        if isshowStatus {
            isshowStatus = false
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.topContentV.alpha = 0
                self.topContentV.transform = CGAffineTransform(translationX: 0, y: 30).scaledBy(x: 0.1, y: 0.1)
                
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
        
    }
    
}
