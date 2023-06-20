//
//  PDfGoPremiumVC.swift
//  PDfMaker
//
//  Created by JOJO on 2023/5/25.
//

import UIKit
import KRProgressHUD
import SnapKit



class PDfGoPremiumVC: UIViewController {

    let bottomBar = UIView()
    let gopremiumBtn = UIButton()
    let yearBtn = PPfSubscribeIapBtn(frame: .zero, iapItem: .year)
    let monthBtn = PPfSubscribeIapBtn(frame: .zero, iapItem: .month)
    let subsTitleLabel = UILabel()
    let subsDesLabel = UILabel()
    let bottomPurchaseTextView = UITextView()
    var pageDisappearBlock: (()->Void)?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pageDisappearBlock?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContentV()
        setupIapBtns()
        setupInfoListView()
        fetchPriceLabels()
        monthBtnClick()
    }
    

    func setupContentV() {
        view.backgroundColor = .white
        view.clipsToBounds = true
        //
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "subsbackX"), for: .normal)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        //
        let restoreBtn = UIButton()
        restoreBtn.setTitle("Restore", for: .normal)
        restoreBtn.setTitleColor(UIColor(hexString: "#1C1E37"), for: .normal)
        restoreBtn.titleLabel?.font = FontCusNames.SFProSemiBold.font(sizePoint: 16)
        view.addSubview(restoreBtn)
        restoreBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(backBtn.snp.centerY).offset(0)
            $0.width.equalTo(84)
            $0.height.equalTo(44)
        }
        restoreBtn.addTarget(self, action: #selector(restoreBtnClick), for: .touchUpInside)
        //

        view.addSubview(subsTitleLabel)
        subsTitleLabel.text = "GO PREMIUM"
        subsTitleLabel.font = FontCusNames.SFProBold.font(sizePoint: 40)
        subsTitleLabel.textColor = UIColor(hexString: "#1C1E37")
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
        subsDesLabel.textColor = UIColor(hexString: "#1C1E37")?.withAlphaComponent(0.7)
        subsDesLabel.textAlignment = .center
        subsDesLabel.adjustsFontSizeToFitWidth = true
        subsDesLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
            $0.top.equalTo(subsTitleLabel.snp.bottom).offset(5)
            $0.left.equalTo(subsTitleLabel.snp.left)
        }
        
    }
    
    
    func setupIapBtns() {
        
        view.addSubview(gopremiumBtn)
        gopremiumBtn.backgroundColor = UIColor(hexString: "#AE0000")
        gopremiumBtn.layer.cornerRadius = 30
        gopremiumBtn.clipsToBounds = true
        gopremiumBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-74)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(60)
        }
        gopremiumBtn.setTitle("Subscribe", for: .normal)
        gopremiumBtn.setTitleColor(.white, for: .normal)
        gopremiumBtn.titleLabel?.font = FontCusNames.SFProBold.font(sizePoint: 18)
        gopremiumBtn.addTarget(self, action: #selector(subNowBtnClick), for: .touchUpInside)
        
        //

        view.addSubview(yearBtn)
        yearBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(gopremiumBtn.snp.top).offset(-30)
            $0.height.equalTo(72)
        }
        yearBtn.addTarget(self, action: #selector(yearBtnClick), for: .touchUpInside)
        
        //
        
        view.addSubview(monthBtn)
        monthBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(yearBtn.snp.top).offset(-15)
            $0.height.equalTo(72)
        }
        monthBtn.addTarget(self, action: #selector(monthBtnClick), for: .touchUpInside)
        let bestImgV = UIImageView()
        bestImgV.image = UIImage(named: "storebest")
        view.addSubview(bestImgV)
        bestImgV.snp.makeConstraints {
            $0.right.equalTo(monthBtn.snp.right).offset(-7)
            $0.centerY.equalTo(monthBtn.snp.top)
            $0.width.equalTo(101)
            $0.height.equalTo(24)
        }
        
        
        
        
        setupBottomPrivacyBtns()
        
    }
 
    
    func setupInfoListView() {
        let infoScrollV = UIScrollView()
        view.addSubview(infoScrollV)
        infoScrollV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(subsDesLabel.snp.bottom).offset(20)
            $0.bottom.equalTo(monthBtn.snp.top).offset(-20)
        }
        infoScrollV.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 240)
        let stackV = UIStackView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 240))
        infoScrollV.addSubview(stackV)
        stackV.axis = .vertical
        stackV.spacing = 0
        stackV.alignment = .fill
        stackV.distribution = .fillEqually
        let btnH: CGFloat = 40
        let btnW: CGFloat = UIScreen.main.bounds.size.width
        let info1 = PPfSubsInfoLabel(frame: CGRect(x: 0, y: 0, width: btnW, height: btnH), contentStr: "Unlimited Scans")
        let info2 = PPfSubsInfoLabel(frame: CGRect(x: 0, y: 0, width: btnW, height: btnH), contentStr: "Unlimited number of PDF")
        let info3 = PPfSubsInfoLabel(frame: CGRect(x: 0, y: 0, width: btnW, height: btnH), contentStr: "Keep all historical files")
        let info4 = PPfSubsInfoLabel(frame: CGRect(x: 0, y: 0, width: btnW, height: btnH), contentStr: "Free Cloud & Backup")
        let info5 = PPfSubsInfoLabel(frame: CGRect(x: 0, y: 0, width: btnW, height: btnH), contentStr: "Print using AirPrint")
        let info6 = PPfSubsInfoLabel(frame: CGRect(x: 0, y: 0, width: btnW, height: btnH), contentStr: "No Ads No Limits")
        stackV.addArrangedSubview(info1)
        stackV.addArrangedSubview(info2)
        stackV.addArrangedSubview(info3)
        stackV.addArrangedSubview(info4)
        stackV.addArrangedSubview(info5)
        stackV.addArrangedSubview(info6)
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
    
    
}

extension PDfGoPremiumVC {
    
    func updatePrice(productsm: [PDfSubscribeStoreManager.IAPProduct]?) {
        if let products = productsm {
            let product0 = products[0]
            let product1 = products[1]
            
            PDfSubscribeStoreManager.default.currentSymbol = product0.priceLocale.currencySymbol ?? "$"
            
            if product0.iapID == PDfSubscribeStoreManager.IAPType.month.rawValue {
                PDfSubscribeStoreManager.default.currentMonthPrice = product0.price.accuracyToString(position: 2)
                PDfSubscribeStoreManager.default.currentYearPrice = product1.price.accuracyToString(position: 2)
            } else {
                PDfSubscribeStoreManager.default.currentYearPrice = product0.price.accuracyToString(position: 2)
                PDfSubscribeStoreManager.default.currentMonthPrice = product1.price.accuracyToString(position: 2)
            }
        }
        monthBtn.priceLabe.text = "\(PDfSubscribeStoreManager.default.currentSymbol)\(PDfSubscribeStoreManager.default.currentMonthPrice)"
        yearBtn.priceLabe.text = "\(PDfSubscribeStoreManager.default.currentSymbol)\(PDfSubscribeStoreManager.default.currentYearPrice)"
        
        
        bottomPurchaseTextView.text = "You can subscribe to Picture Scan VIP to get all the background effects provided in the app. \nPicture Scan VIP provides an annual subscription. The subscription price is: \(PDfSubscribeStoreManager.default.currentMonthPrice)/month, \(PDfSubscribeStoreManager.default.currentYearPrice)/year. \nPayment will be charged to iTunes Account at confirmation of purchase. \nSubscriptions will automatically renew unless auto-renew is turned off at least 24 hours before the end of the current subscription period. \nYour account will be charged for renewal 24 hours before the end of the current period, and the renewal fee will be determined. \nSubscriptions may be managed by the user and auto-renewal may also be turned off in the user's Account Settings after purchase. \nIf any portion of the offered free trial period is unused, the unused portion will be forfeited if the user purchases a subscription for that portion, where applicable. \nIf you do not purchase an auto-renewing subscription, you can still use our app as normal, and any unlocked content will work normally after the subscription expires."
        //"\(currentSymbol)\(Double(defaultYearPrice/12).accuracyToString(position: 2))/mo"
    }
    
    func fetchPriceLabels() {
        
        if PDfSubscribeStoreManager.default.currentProducts.count == PDfSubscribeStoreManager.default.iapTypeList.count {
            updatePrice(productsm: PDfSubscribeStoreManager.default.currentProducts)
        } else {
            updatePrice(productsm: nil)
            PDfSubscribeStoreManager.default.fetchPurchaseInfo {[weak self] productList in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    if productList.count == PDfSubscribeStoreManager.default.iapTypeList.count {
                        self.updatePrice(productsm: productList)
                    }
                }
            }
        }
    }
    
}

extension PDfGoPremiumVC {
    @objc func backBtnClick() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: PDfMakTool.default.k_subscribeVCback),
            object: nil,
            userInfo: nil)
    }
    
    @objc func termBtnClick() {
        //
        PDfMakTool.default.openSafiPrivacyURL(str: PDfMakTool.termsUrl)
    }
    
    @objc func privacyBtnClick() {
        //
        PDfMakTool.default.openSafiPrivacyURL(str: PDfMakTool.privacyUrl)
    }
    
    @objc func restoreBtnClick() {
        
        
        if PDfSubscribeStoreManager.default.inSubscription {
            KRProgressHUD.showSuccess(withMessage: "You are already in the subscription period!")
        } else {
            PDfSubscribeStoreManager.default.restore { success in
                if success {
                    KRProgressHUD.showSuccess(withMessage: "The subscription was restored successfully")
                } else {
                    KRProgressHUD.showMessage("Nothing to Restore")
                }
            }
        }
        
    }
    
    @objc func yearBtnClick() {
        PDfSubscribeStoreManager.default.currentIapType = .year
        yearBtn.isSelected = true
        monthBtn.isSelected = false
    }
    @objc func monthBtnClick() {
        PDfSubscribeStoreManager.default.currentIapType = .month
        yearBtn.isSelected = false
        monthBtn.isSelected = true
    }
    @objc func subNowBtnClick() {
         
        PDfSubscribeStoreManager.default.subscribeIapOrder(iapType: PDfSubscribeStoreManager.default.currentIapType, source: "") {[weak self] success, errorstr in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if success {
                    KRProgressHUD.showSuccess(withMessage: "Subscribe Successful!")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                        KRProgressHUD.dismiss()
                        if self.navigationController != nil {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    KRProgressHUD.showInfo(withMessage: errorstr)
                }
            }
        }
    }
}



class PPfSubscribeIapBtn: UIButton {
    var iapItem: PDfSubscribeStoreManager.IAPType
    let titleLabe = UILabel()
    let priceLabe = UILabel()
    let deletePriceLabe = UILabel()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabe.textColor = UIColor(hexString: "#AE0000")
                priceLabe.textColor = UIColor(hexString: "#AE0000")
                layer.borderColor = UIColor(hexString: "#AE0000")?.cgColor
            } else {
                titleLabe.textColor = UIColor(hexString: "#1C1E37")
                priceLabe.textColor = UIColor(hexString: "#1C1E37")
                layer.borderColor = UIColor(hexString: "#E0E3EA")?.cgColor
            }
        }
    }
    
    
    init(frame: CGRect, iapItem: PDfSubscribeStoreManager.IAPType) {
        self.iapItem = iapItem
        super.init(frame: frame)
        setupCon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCon() {
        backgroundColor = .white
        layer.borderColor = UIColor(hexString: "#E0E3EA")?.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 20
        
        //
        addSubview(titleLabe)
        titleLabe.adjustsFontSizeToFitWidth = true
        titleLabe.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(snp.centerY).offset(0)
            $0.width.greaterThanOrEqualTo(10)
            $0.height.equalTo(25)
        }
        titleLabe.textColor = UIColor(hexString: "#1C1E37")
        titleLabe.font = FontCusNames.SFProBold.font(sizePoint: 20)
        titleLabe.textAlignment = .center
        
        //
        addSubview(priceLabe)
        
        priceLabe.textColor = UIColor(hexString: "#1C1E37")
        priceLabe.font = FontCusNames.SFProMedium.font(sizePoint: 16)
        priceLabe.textAlignment = .center
        priceLabe.text = "$9.99/month"
        //
        let monthBeforeStr = "$99.99"
        addSubview(deletePriceLabe)
        
        deletePriceLabe.textAlignment = .center
        let attriStr = NSAttributedString(string: monthBeforeStr, attributes: [NSAttributedString.Key.font : FontCusNames.SFProMedium.font(sizePoint: 16), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#B6BAC8")!, NSAttributedString.Key.strikethroughStyle : 1, NSAttributedString.Key.strikethroughColor : UIColor(hexString: "#B6BAC8")!])
        deletePriceLabe.attributedText = attriStr
        
        if iapItem == .month {
            titleLabe.text = "Monthly"
            deletePriceLabe.isHidden = true
            priceLabe.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(snp.centerY).offset(4)
                $0.width.greaterThanOrEqualTo(24)
                $0.height.greaterThanOrEqualTo(24)
            }
        } else {
            titleLabe.text = "Annual"
            deletePriceLabe.isHidden = false
            priceLabe.snp.makeConstraints {
                $0.left.equalTo(snp.centerX).offset(8)
                $0.top.equalTo(snp.centerY).offset(4)
                $0.width.greaterThanOrEqualTo(24)
                $0.height.greaterThanOrEqualTo(24)
            }
            deletePriceLabe.snp.makeConstraints {
                $0.right.equalTo(snp.centerX).offset(-8)
                $0.centerY.equalTo(priceLabe.snp.centerY).offset(0)
                $0.width.greaterThanOrEqualTo(24)
                $0.height.greaterThanOrEqualTo(24)
            }
        }
    }
    
    
    
    
}

class PPfSubsInfoLabel: UIView {
    var contentStr: String
    let infolabel = UILabel()
    
    init(frame: CGRect, contentStr: String) {
        self.contentStr = contentStr
        super.init(frame: frame)
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        backgroundColor = UIColor.clear
        
        addSubview(infolabel)
        infolabel.textColor = .black
        infolabel.textAlignment = .left
        infolabel.adjustsFontSizeToFitWidth = true
        infolabel.font = FontCusNames.SFProMedium.font(sizePoint: 16)
        infolabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(100)
            $0.right.equalToSuperview().offset(-20)
            $0.height.greaterThanOrEqualTo(10)
        }
        infolabel.adjustsFontSizeToFitWidth = true
        infolabel.text = contentStr
        
        //
        let duiImgV = UIImageView()
        addSubview(duiImgV)
        duiImgV.image = UIImage(named: "subinfoicon")
        duiImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(infolabel.snp.left).offset(-10)
            $0.width.equalTo(22)
            $0.height.equalTo(22)
        }
    }
}
