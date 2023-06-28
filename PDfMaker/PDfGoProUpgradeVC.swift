//
//  PDfGoProUpgradeVC.swift
//  PDfMaker
//
//  Created by Joe on 2023/6/28.
//

import UIKit
import KRProgressHUD

class PDfGoProUpgradeVC: UIViewController {

    
    let gopremiumBtn = UIButton()
    let subsTitleLabel = UILabel()
    let subsDesLabel = UILabel()
    
    let monthProBtn = PDfGoProUpgradeStoreBtn(frame: .zero, productType: .month)
    let weekProBtn = PDfGoProUpgradeStoreBtn(frame: .zero, productType: .week)
    let yearProBtn = PDfGoProUpgradeStoreBtn(frame: .zero, productType: .year)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContentV()
        setupBottomPrivacyBtns()
        setupIapBtns()
        
    }
    
    func setupContentV() {
        view.backgroundColor = UIColor(hexString: "#AE0000")
        view.clipsToBounds = true
        //
        //
//        let backBtn = UIButton()
//        backBtn.setImage(UIImage(named: "subsbackX"), for: .normal)
//        view.addSubview(backBtn)
//        backBtn.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
//            $0.width.height.equalTo(44)
//        }
//        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        //
        let restoreBtn = UIButton()
        restoreBtn.setTitle("Restore", for: .normal)
        restoreBtn.setTitleColor(UIColor(hexString: "#1C1E37"), for: .normal)
        restoreBtn.titleLabel?.font = FontCusNames.SFProSemiBold.font(sizePoint: 16)
        view.addSubview(restoreBtn)
        restoreBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
//            $0.centerY.equalTo(backBtn.snp.centerY).offset(0)
            $0.width.equalTo(84)
            $0.height.equalTo(44)
        }
        restoreBtn.addTarget(self, action: #selector(restoreBtnClick), for: .touchUpInside)
        //

        view.addSubview(subsTitleLabel)
        subsTitleLabel.text = "GO PREMIUM"
        subsTitleLabel.font = FontCusNames.SFProBold.font(sizePoint: 40)
        subsTitleLabel.textColor = UIColor(hexString: "#FFFFFF")
        subsTitleLabel.textAlignment = .center
        subsTitleLabel.adjustsFontSizeToFitWidth = true
        subsTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalTo(backBtn.snp.bottom).offset(14)
            $0.left.equalToSuperview().offset(27)
        }
        //
        
        view.addSubview(subsDesLabel)
        subsDesLabel.text = "Upgrade to Premium for all services"
        subsDesLabel.font = FontCusNames.SFProSemiBold.font(sizePoint: 16)
        subsDesLabel.textColor = UIColor(hexString: "#FFFFFF")?.withAlphaComponent(0.7)
        subsDesLabel.textAlignment = .center
        subsDesLabel.adjustsFontSizeToFitWidth = true
        subsDesLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
            $0.top.equalTo(subsTitleLabel.snp.bottom).offset(5)
            $0.left.equalTo(subsTitleLabel.snp.left)
        }
        
        //
        
        
        
    }

    func setupBottomPrivacyBtns() {
        let btnColor = UIColor(hexString: "#AE0000")
        
        let termsBtn = UIButton()
        let privacyBtn = UIButton()
        
        // 添加privacyBtn
        privacyBtn.setTitle("Privacy Policy", for: .normal)
        privacyBtn.setTitleColor(btnColor, for: .normal)
        privacyBtn.titleLabel?.font = FontCusNames.SFProMedium.font(sizePoint: 12)
        privacyBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        view.addSubview(privacyBtn)
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick), for: .touchUpInside)
        // 添加termsBtn
        termsBtn.setTitle("Terms of use", for: .normal)
        termsBtn.setTitleColor(btnColor, for: .normal)
        termsBtn.titleLabel?.font = FontCusNames.SFProMedium.font(sizePoint: 12)
        termsBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        view.addSubview(termsBtn)
        termsBtn.addTarget(self, action: #selector(termBtnClick), for: .touchUpInside)
        
        privacyBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            $0.right.equalTo(view.snp.centerX).offset(-8)
            $0.height.equalTo(15)
            $0.width.equalTo(80)
        }
        
        termsBtn.snp.makeConstraints {
            $0.centerY.equalTo(privacyBtn.snp.centerY)
            $0.left.equalTo(view.snp.centerX).offset(7)
            $0.height.equalTo(15)
            $0.width.equalTo(80)
        }
        
        //
        let viewline = UIView()
        viewline.backgroundColor = UIColor(hexString: "#E0E3EA")
        view.addSubview(viewline)
        viewline.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(8)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(termsBtn.snp.centerY)
        }
        
        //
        
        bottomPurchaseTextView.isEditable = false
        bottomPurchaseTextView.textColor = UIColor(hexString: "#B6BAC8")
        bottomPurchaseTextView.font = FontCusNames.SFProMedium.font(sizePoint: 10)
        bottomPurchaseTextView.textAlignment = .center
        
        view.addSubview(bottomPurchaseTextView)
        bottomPurchaseTextView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(viewline.snp.bottom).offset(8)
        }
        
    }
    
    func setupIapBtns() {
        
        view.addSubview(gopremiumBtn)
        gopremiumBtn.backgroundColor = UIColor(hexString: "#FFFFFF")
        gopremiumBtn.layer.cornerRadius = 30
        gopremiumBtn.clipsToBounds = true
        gopremiumBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-94)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(60)
        }
        gopremiumBtn.setTitle("Subscribe", for: .normal)
        gopremiumBtn.setTitleColor(UIColor(hexString: "#AE0000"), for: .normal)
        gopremiumBtn.titleLabel?.font = FontCusNames.SFProBold.font(sizePoint: 18)
        gopremiumBtn.addTarget(self, action: #selector(subNowBtnClick), for: .touchUpInside)
        //
        let backBtn = UIButton()
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(gopremiumBtn.snp.bottom).offset(5)
            $0.width.equalTo(200)
            $0.height.equalTo(34)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        let attriStr = NSAttributedString(string: "Cancel anytime Or continue with limited version", attributes: [NSAttributedString.Key.font : UIFont(name: UIFont.SFProTextMedium, size: 12) ?? UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#FFFFFF")!.withAlphaComponent(0.5), NSAttributedString.Key.underlineStyle : 1, NSAttributedString.Key.underlineColor : UIColor(hexString: "#FFFFFF")!.withAlphaComponent(0.5)])
        backBtn.setAttributedTitle(attriStr, for: .normal)
        //

        view.addSubview(monthProBtn)
        monthProBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            if UIScreen.isDevice8SEPaid() {
                $0.bottom.equalTo(gopremiumBtn.snp.top).offset(-20)
            } else {
                $0.bottom.equalTo(gopremiumBtn.snp.top).offset(-40)
            }
            $0.width.equalTo(120)
            $0.height.equalTo(137)
        }
        monthProBtn.addTarget(self, action: #selector(monthProBtnClick), for: .touchUpInside)
        
        //
        view.addSubview(weekProBtn)
        weekProBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            if UIScreen.isDevice8SEPaid() {
                $0.bottom.equalTo(gopremiumBtn.snp.top).offset(-20)
            } else {
                $0.bottom.equalTo(gopremiumBtn.snp.top).offset(-40)
            }
            $0.width.equalTo(120)
            $0.height.equalTo(137)
        }
        weekProBtn.addTarget(self, action: #selector(weekProBtnClick), for: .touchUpInside)
        
        //
        view.addSubview(yearProBtn)
        yearProBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            if UIScreen.isDevice8SEPaid() {
                $0.bottom.equalTo(gopremiumBtn.snp.top).offset(-20)
            } else {
                $0.bottom.equalTo(gopremiumBtn.snp.top).offset(-40)
            }
            $0.width.equalTo(120)
            $0.height.equalTo(137)
        }
        yearProBtn.addTarget(self, action: #selector(yearProBtnClick), for: .touchUpInside)
        
        
        //
        monthProBtnClick()
        
        
        //
        let centerBgV = UIView()
        view.addSubview(centerBgV)
        centerBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(subsDesLabel.snp.bottom).offset(20)
            $0.top.equalTo(monthProBtn.snp.top).offset(-20)
        }
        
        //
        
        let bestImgV3 = UIImageView()
        bestImgV3.image = UIImage(named: "prodiandian")
        centerBgV.addSubview(bestImgV3)
        
        let bestImgV2 = UIImageView()
        bestImgV2.image = UIImage(named: "proguangmang")
        centerBgV.addSubview(bestImgV2)
        
        let bestImgV1 = UIImageView()
        bestImgV1.image = UIImage(named: "prohuojian")
        centerBgV.addSubview(bestImgV1)
        
        
        bestImgV1.snp.makeConstraints {
            $0.center.equalToSuperview()
            if UIScreen.isDevice8SEPaid() {
                $0.width.height.equalTo(340/2 - 40)
            } else {
                $0.width.height.equalTo(340/2)
            }
        }
        
        bestImgV2.snp.makeConstraints {
            $0.center.equalToSuperview()
            if UIScreen.isDevice8SEPaid() {
                $0.width.height.equalTo(560/2 - 50)
            } else {
                $0.width.height.equalTo(560/2)
            }
        }
        
        
        bestImgV3.snp.makeConstraints {
            $0.center.equalToSuperview()
            if UIScreen.isDevice8SEPaid() {
                $0.width.height.equalTo(780/2 - 50)
            } else {
                $0.width.height.equalTo(780/2)
            }
        }
        
        
        
        
        
        
    }
    
    
    @objc func weekProBtnClick() {
        
        weekProBtn.isSelected = true
        monthProBtn.isSelected = false
        yearProBtn.isSelected = false
        PDfSubscribeStoreManager.default.currentIapType = .week
    }
    
    @objc func monthProBtnClick() {
        
        weekProBtn.isSelected = false
        monthProBtn.isSelected = true
        yearProBtn.isSelected = false
        PDfSubscribeStoreManager.default.currentIapType = .month
    }
    
    @objc func yearProBtnClick() {
        
        weekProBtn.isSelected = false
        monthProBtn.isSelected = false
        yearProBtn.isSelected = true
        PDfSubscribeStoreManager.default.currentIapType = .year
    }
    
    @objc func proContinueBtnClick() {
        
        PDfSubscribeStoreManager.default.subscribeIapOrder(iapType: PDfSubscribeStoreManager.default.currentIapType, source: "shop") {[weak self] subSuccess, errorStr in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if subSuccess {
                    KRProgressHUD.showSuccess(withMessage: "The subscription was successful!")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.backButtonClick()
                    }
                } else {
                    KRProgressHUD.showError(withMessage: errorStr ?? "The subscription failed")
                }
            }
        }
    }
    
    @objc func backButtonClick() {
        
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}



class PDfGoProUpgradeStoreBtn: UIButton {
    var productType: PDfSubscribeStoreManager.IAPType
    let typeLabel = UILabel()
    let priceLabel = UILabel()
    let priceTypeLabel = UILabel()
    let bgImgV = UIImageView()
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self
                    .borderColor(UIColor(hexString: "#FFFFFF")!.withAlphaComponent(0.7), width: 1)
                bgImgV.isHidden = false
                let colorStrS = "#FFFFFF"
                typeLabel.textColor = UIColor(hexString: colorStrS)
                priceLabel.textColor = UIColor(hexString: colorStrS)
                priceTypeLabel.textColor = UIColor(hexString: colorStrS)
            } else {
                self
                .borderColor(UIColor(hexString: "#595F97")!, width: 1)
                bgImgV.isHidden = true
                let colorStrN = "#595F97"
                typeLabel.textColor = UIColor(hexString: colorStrN)
                priceLabel.textColor = UIColor(hexString: colorStrN)
                priceTypeLabel.textColor = UIColor(hexString: colorStrN)
            }
        }
    }
    
    init(frame: CGRect, productType: PDfSubscribeStoreManager.IAPType) {
        self.productType = productType
        super.init(frame: frame)
        //
        self
            .backgroundColor(UIColor(hexString: "#F1F4FF")!)
            .borderColor(UIColor(hexString: "#595F97")!, width: 1)
            .cornerRadius(16, masksToBounds: true)
        //
        
        bgImgV.image("selectbgstore")
            .adhere(toSuperview: self) {
                $0.left.right.top.bottom.equalToSuperview()
            }
        //
        priceLabel
            .adhere(toSuperview: self) {
                $0.centerY.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(10)
                $0.height.equalTo(20)
            }
            .textAlignment(.center)
            .font(UIFont.SFProTextRegular, 14)
            .color(UIColor(hexString: "#595F97")!)
        //
        
        priceTypeLabel
            .adhere(toSuperview: self) {
                $0.top.equalTo(priceLabel.snp.bottom).offset(4)
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(2)
                $0.height.equalTo(18)
            }
            .textAlignment(.center)
            .font(UIFont.SFProTextRegular, 12)
            .color(UIColor(hexString: "#595F97")!)
        
        //
        var typeStr: String = ""
        switch productType {
        case .week:
            typeStr = "Weekly"
        case .month:
            typeStr = "Monthly"
        case .year:
            typeStr = "Annual"
        }
        
        //
        
        typeLabel
            .adhere(toSuperview: self) {
                $0.bottom.equalTo(priceLabel.snp.top).offset(-4)
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(10)
                $0.height.equalTo(18)
            }
            .textAlignment(.center)
            .font(UIFont.SFProTextBold, 18)
            .color(UIColor(hexString: "#595F97")!)
            .text(typeStr)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePrice(str: String) {
        priceLabel.text(str)
        var typeStr: String = ""
        switch productType {
        case .week:
            typeStr = "week"
        case .month:
            typeStr = "month"
        case .year:
            typeStr = "year"
        }
        priceTypeLabel.text("\(str) / \(typeStr)")
    }
    
    
}
