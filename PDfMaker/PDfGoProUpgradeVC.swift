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
    let bottomPurchaseTextView = UITextView()
    let monthProBtn = PDfGoProUpgradeStoreBtn(frame: .zero, productType: .month)
    let weekProBtn = PDfGoProUpgradeStoreBtn(frame: .zero, productType: .week)
    let yearProBtn = PDfGoProUpgradeStoreBtn(frame: .zero, productType: .year)
    var pageDisappearBlock: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContentV()
        setupBottomPrivacyBtns()
        setupIapBtns()
        fetchPriceLabels()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pageDisappearBlock?()
    }
    
    func updatePrice() {
        weekProBtn.updatePrice(str: "\(PDfSubscribeStoreManager.default.currentSymbol)\(PDfSubscribeStoreManager.default.currentWeekPrice)")
        monthProBtn.updatePrice(str: "\(PDfSubscribeStoreManager.default.currentSymbol)\(PDfSubscribeStoreManager.default.currentMonthPrice)")
        yearProBtn.updatePrice(str: "\(PDfSubscribeStoreManager.default.currentSymbol)\(PDfSubscribeStoreManager.default.currentYearPrice)")
        
        //
        bottomPurchaseTextView.text = "You can subscribe to Picture Scan VIP to get all the background effects provided in the app. \nPicture Scan VIP provides an annual subscription. The subscription price is: \(PDfSubscribeStoreManager.default.currentWeekPrice)/week, \(PDfSubscribeStoreManager.default.currentMonthPrice)/month, \(PDfSubscribeStoreManager.default.currentYearPrice)/year. \nPayment will be charged to iTunes Account at confirmation of purchase. \nSubscriptions will automatically renew unless auto-renew is turned off at least 24 hours before the end of the current subscription period. \nYour account will be charged for renewal 24 hours before the end of the current period, and the renewal fee will be determined. \nSubscriptions may be managed by the user and auto-renewal may also be turned off in the user's Account Settings after purchase. \nIf any portion of the offered free trial period is unused, the unused portion will be forfeited if the user purchases a subscription for that portion, where applicable. \nIf you do not purchase an auto-renewing subscription, you can still use our app as normal, and any unlocked content will work normally after the subscription expires."
        //"\(currentSymbol)\(Double(defaultYearPrice/12).accuracyToString(position: 2))/mo"
    }
    
    func fetchPriceLabels() {
        
        if PDfSubscribeStoreManager.default.currentProducts.count == PDfSubscribeStoreManager.default.iapTypeList.count {
            updatePrice()
        } else {
            updatePrice()
            PDfSubscribeStoreManager.default.fetchPurchaseInfo {[weak self] productList in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    if productList.count == PDfSubscribeStoreManager.default.iapTypeList.count {
                        self.updatePrice()
                    }
                }
            }
        }
    }
    
    func setupContentV() {
        view.backgroundColor = UIColor(hexString: "#AE0000")
        view.clipsToBounds = true
        //
        let restoreBtn = UIButton()
        restoreBtn.setTitle("Restore", for: .normal)
        restoreBtn.setTitleColor(UIColor(hexString: "#1C1E37"), for: .normal)
        restoreBtn.titleLabel?.font = FontCusNames.SFProSemiBold.font(sizePoint: 16)
        view.addSubview(restoreBtn)
        restoreBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
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
            $0.top.equalTo(restoreBtn.snp.bottom).offset(14)
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
        
    }

    func setupBottomPrivacyBtns() {
        let btnColor = UIColor(hexString: "#FFFFFF")?.withAlphaComponent(0.7)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
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
        viewline.backgroundColor = btnColor
        view.addSubview(viewline)
        viewline.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(8)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(termsBtn.snp.centerY)
        }
        
        //
        bottomPurchaseTextView.backgroundColor = .clear
        bottomPurchaseTextView.isEditable = false
        bottomPurchaseTextView.textColor = btnColor
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-104)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(60)
        }
        gopremiumBtn.setTitle("Subscribe", for: .normal)
        gopremiumBtn.setTitleColor(UIColor(hexString: "#AE0000"), for: .normal)
        gopremiumBtn.titleLabel?.font = FontCusNames.SFProBold.font(sizePoint: 18)
        gopremiumBtn.addTarget(self, action: #selector(proContinueBtnClick), for: .touchUpInside)
        
        //
        let backBtn = UIButton()
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(gopremiumBtn.snp.bottom).offset(8)
            $0.width.equalTo(280)
            $0.height.equalTo(34)
        }
        backBtn.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        let attriStr = NSAttributedString(string: "Cancel anytime Or continue with limited version", attributes: [NSAttributedString.Key.font : FontCusNames.SFProMedium.font(sizePoint: 12), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#FFFFFF")!.withAlphaComponent(0.5), NSAttributedString.Key.underlineStyle : 1, NSAttributedString.Key.underlineColor : UIColor(hexString: "#FFFFFF")!.withAlphaComponent(0.5)])
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
        monthProBtn.titleNameLabel.font = FontCusNames.SFProSemiBold.font(sizePoint: 16)
        monthProBtn.priceTypeLabel.font = FontCusNames.SFProRegular.font(sizePoint: 12)
        monthProBtn.priceLabel.font = FontCusNames.SFProSemiBold.font(sizePoint: 20)
        monthProBtn.addTarget(self, action: #selector(monthProBtnClick), for: .touchUpInside)
        monthProBtn.layer.cornerRadius = 20
        monthProBtn.bestVLabel.isHidden = false
        //
        view.addSubview(weekProBtn)
        weekProBtn.snp.makeConstraints {
            $0.right.equalTo(monthProBtn.snp.left).offset(-12)
            if UIScreen.isDevice8SEPaid() {
                $0.bottom.equalTo(gopremiumBtn.snp.top).offset(-20)
            } else {
                $0.bottom.equalTo(gopremiumBtn.snp.top).offset(-40)
            }
            $0.width.equalTo(102)
            $0.height.equalTo(122)
        }
        weekProBtn.titleNameLabel.font = FontCusNames.SFProRegular.font(sizePoint: 14)
        weekProBtn.priceTypeLabel.font = FontCusNames.SFProRegular.font(sizePoint: 12)
        weekProBtn.priceLabel.font = FontCusNames.SFProSemiBold.font(sizePoint: 16)
        weekProBtn.addTarget(self, action: #selector(weekProBtnClick), for: .touchUpInside)
        weekProBtn.layer.cornerRadius = 17
        weekProBtn.bestVLabel.isHidden = true
        weekProBtn.titleNameLabel.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(weekProBtn.priceTypeLabel.snp.top).offset(-3)
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(20)
        }
        
        //
        view.addSubview(yearProBtn)
        yearProBtn.snp.makeConstraints {
            $0.left.equalTo(monthProBtn.snp.right).offset(12)
            if UIScreen.isDevice8SEPaid() {
                $0.bottom.equalTo(gopremiumBtn.snp.top).offset(-20)
            } else {
                $0.bottom.equalTo(gopremiumBtn.snp.top).offset(-40)
            }
            $0.width.equalTo(102)
            $0.height.equalTo(122)
        }
        yearProBtn.titleNameLabel.font = FontCusNames.SFProRegular.font(sizePoint: 14)
        yearProBtn.priceTypeLabel.font = FontCusNames.SFProRegular.font(sizePoint: 12)
        yearProBtn.priceLabel.font = FontCusNames.SFProSemiBold.font(sizePoint: 16)
        yearProBtn.addTarget(self, action: #selector(yearProBtnClick), for: .touchUpInside)
        yearProBtn.layer.cornerRadius = 17
        yearProBtn.bestVLabel.isHidden = true
        yearProBtn.titleNameLabel.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(yearProBtn.priceTypeLabel.snp.top).offset(-3)
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(20)
        }
        //
        monthProBtnClick()
        
        //
        let centerBgV = UIView()
        view.addSubview(centerBgV)
        centerBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(subsDesLabel.snp.bottom).offset(20)
            $0.bottom.equalTo(monthProBtn.snp.top).offset(-20)
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
    
}

extension PDfGoProUpgradeVC {
    
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
    
    @objc func restoreBtnClick() {
        
    }
    
    @objc func privacyBtnClick() {
        
    }
    
    @objc func termBtnClick() {
        
    }
    
   
    
    
}


class PDfGoProUpgradeStoreBtn: UIButton {
    var productType: PDfSubscribeStoreManager.IAPType
    let selectImgV = UIImageView()
    let titleNameLabel = UILabel()
    let priceTypeLabel = UILabel()
    let priceLabel = UILabel()
    
    let bestVLabel = UILabel()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectImgV.isHighlighted = true
                titleNameLabel.alpha = 1
                priceTypeLabel.alpha = 1
            } else {
                selectImgV.isHighlighted = false
                titleNameLabel.alpha = 0.7
                priceTypeLabel.alpha = 0.7

            }
        }
    }
    
    init(frame: CGRect, productType: PDfSubscribeStoreManager.IAPType) {
        self.productType = productType
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.3)
        clipsToBounds = true
        
        //

        selectImgV.contentMode = .scaleToFill
        self.addSubview(selectImgV)
        selectImgV.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        selectImgV.image = nil
        selectImgV.highlightedImage = UIImage(named: "icon_setlect")
        selectImgV.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        //
        let bgImgV = UIImageView()
        self.addSubview(bgImgV)
        bgImgV.contentMode = .scaleToFill
        bgImgV.image = UIImage(named: "Subscription_n")
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        addSubview(bestVLabel)
        bestVLabel.text = "Best Value"
        bestVLabel.textColor = UIColor(hexString: "#AE0000")
        bestVLabel.font = FontCusNames.SFProSemiBold.font(sizePoint: 14)
        bestVLabel.textAlignment = .center
        bestVLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(32)
        }
        //
        priceTypeLabel.textColor = .white
        addSubview(priceTypeLabel)
        priceTypeLabel.textAlignment = .center
        priceTypeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(snp.centerY)
            $0.height.equalTo(16)
        }
        //
        titleNameLabel.textColor = .white
        addSubview(titleNameLabel)
        titleNameLabel.textAlignment = .center
        titleNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(priceTypeLabel.snp.top).offset(-8)
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(20)
        }
        //
        priceLabel.textColor = .white
        addSubview(priceLabel)
        priceLabel.textAlignment = .center
        priceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(priceTypeLabel.snp.bottom).offset(5)
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(25)
        }
        
        //
        var typeStr: String = ""
        switch productType {
        case .week:
            typeStr = "Weekly"
        case .month:
            typeStr = "Monthly"
        case .year:
            typeStr = "Yearly"
        }
        //
        titleNameLabel.text = typeStr
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePrice(str: String) {

        var typeStr: String = ""
        switch productType {
        case .week:
            typeStr = "week"
        case .month:
            typeStr = "month"
        case .year:
            typeStr = "year"
        }
        priceLabel.text(str)
        priceTypeLabel.text("\(str) / \(typeStr)")
    }
    
    
}
