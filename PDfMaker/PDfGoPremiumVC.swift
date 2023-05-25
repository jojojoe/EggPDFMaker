//
//  PDfGoPremiumVC.swift
//  PDfMaker
//
//  Created by JOJO on 2023/5/25.
//

import UIKit
import KRProgressHUD
 
class PDfGoPremiumVC: UIViewController {

    let bottomBar = UIView()
   
    var currentIapType: PDfSubscribeStoreManager.IAPType = .month
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContentV()
        setupIapBtns()
        setupInfoListView()
        
        yearBtnClick()
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
        let subsTitleLabel = UILabel()
        view.addSubview(subsTitleLabel)
        subsTitleLabel.text = "GO PREMIUM"
        subsTitleLabel.font = FontCusNames.SFProBold.font(sizePoint: 40)
        subsTitleLabel.textColor = UIColor(hexString: "#1C1E37")
        subsTitleLabel.textAlignment = .center
        subsTitleLabel.adjustsFontSizeToFitWidth = true
        subsTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalTo(backBtn.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(27)
        }
        //
        let subsDesLabel = UILabel()
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
        
        
        
        
//
//        //
//        let proImgV = UIImageView()
//        view.addSubview(proImgV)
//        proImgV.snp.makeConstraints {
//            $0.centerY.equalTo(subsLabel2.snp.centerY)
//            $0.left.equalTo(subsLabel2.snp.right).offset(4)
//            $0.width.equalTo(142/2)
//            $0.height.equalTo(54/2)
//        }
//        proImgV.image = UIImage(named: "pro_money")
//        //
//        let infoLabel1 = FMontInfoLabel(frame: .zero, contentStr: "Remove Watermark")
//        view.addSubview(infoLabel1)
//        infoLabel1.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(38)
//            $0.right.equalTo(view.snp.centerX).offset(-7)
//            $0.height.equalTo(32)
//            $0.top.equalTo(subsLabel2.snp.bottom).offset(24)
//        }
//        //
//        let infoLabel2 = FMontInfoLabel(frame: .zero, contentStr: "Various Font Choices")
//        view.addSubview(infoLabel2)
//        infoLabel2.snp.makeConstraints {
//            $0.right.equalToSuperview().offset(-38)
//            $0.left.equalTo(view.snp.centerX).offset(7)
//            $0.height.equalTo(32)
//            $0.top.equalTo(infoLabel1.snp.top)
//        }
//
//        //
//        let infoLabel3 = FMontInfoLabel(frame: .zero, contentStr: "Use three different styles of stickers")
//        view.addSubview(infoLabel3)
//        infoLabel3.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(38)
//            $0.right.equalToSuperview().offset(-38)
//            $0.height.equalTo(32)
//            $0.top.equalTo(infoLabel2.snp.bottom).offset(8)
//        }
//
//        //
//        let infoLabel4 = FMontInfoLabel(frame: .zero, contentStr: "Use three different styles of filters")
//        view.addSubview(infoLabel4)
//        infoLabel4.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(38)
//            $0.right.equalToSuperview().offset(-38)
//            $0.height.equalTo(32)
//            $0.top.equalTo(infoLabel3.snp.bottom).offset(8)
//        }
//
//        //
//
//        view.addSubview(bottomBar)
//        bottomBar.backgroundColor = UIColor(hexString: "#FFFFFF")
//        bottomBar.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.bottom.equalToSuperview().offset(60)
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(320)
//
//        }
//        bottomBar.layer.cornerRadius = 30
//
//        //
//        let subscriNBtn = UIButton()
//        bottomBar.addSubview(subscriNBtn)
//        subscriNBtn.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-48)
//            $0.width.equalTo(327)
//            $0.height.equalTo(60)
//        }
//        subscriNBtn.backgroundColor = UIColor(hexString: "#0A1E24")
//        subscriNBtn.layer.cornerRadius = 9
//        subscriNBtn.addTarget(self, action: #selector(subNowBtnClick), for: .touchUpInside)
//        subscriNBtn.setTitle("Subscription Now", for: .normal)
//        subscriNBtn.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 16)
//        subscriNBtn.setTitleColor(UIColor(hexString: "#FDFDFD")!, for: .normal)
//        //
//        setupBottomBtns()
//        //
//        let autorenewbel = UILabel()
//        bottomBar.addSubview(autorenewbel)
//        autorenewbel.text = "Auto-renewable. Cancel anytime."
//        autorenewbel.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.width.greaterThanOrEqualTo(10)
//            $0.height.greaterThanOrEqualTo(14)
//            $0.bottom.equalTo(subscriNBtn.snp.top).offset(-10)
//        }
//        autorenewbel.font = UIFont(name: "PingFangSC-Medium", size: 14)
//        autorenewbel.textColor = UIColor(hexString: "#939393")
//
//        //
//        let btnBgV = UIView()
//        bottomBar.addSubview(btnBgV)
//        btnBgV.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.top.equalToSuperview().offset(30)
//            $0.bottom.equalTo(autorenewbel.snp.top).offset(-20)
//        }
//        //
//
//        btnBgV.addSubview(subYearBtn)
//        subYearBtn.snp.makeConstraints {
//            $0.bottom.equalTo(btnBgV.snp.centerY).offset(-8)
//            $0.width.equalTo(343)
//            $0.height.equalTo(76)
//            $0.centerX.equalToSuperview()
//        }
//        subYearBtn.addTarget(self, action: #selector(yearBtnClick), for: .touchUpInside)
//        //
//        btnBgV.addSubview(subMonthBtn)
//        subMonthBtn.snp.makeConstraints {
//            $0.top.equalTo(subYearBtn.snp.bottom).offset(16)
//            $0.width.equalTo(343)
//            $0.height.equalTo(76)
//            $0.centerX.equalToSuperview()
//        }
//        subMonthBtn.addTarget(self, action: #selector(monthBtnClick), for: .touchUpInside)
        
    }
    
    
    func setupIapBtns() {
        let gopremiumBtn = UIButton()
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
        
        
        
        
    }
    
    func setupInfoListView() {
        
    }
    
    func setupBottomBtns() {
        let btnColor = UIColor(hexString: "#939393")
        
        let termsBtn = UIButton()
        let privacyBtn = UIButton()
        
        
        // 添加termsBtn
        termsBtn.setTitle("Terms of use", for: .normal)
        termsBtn.setTitleColor(btnColor, for: .normal)
        termsBtn.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 12)
        termsBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        bottomBar.addSubview(termsBtn)
        termsBtn.addTarget(self, action: #selector(termBtnClick), for: .touchUpInside)
        // 添加privacyBtn
        privacyBtn.setTitle("Privacy Policy", for: .normal)
        privacyBtn.setTitleColor(btnColor, for: .normal)
        privacyBtn.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 12)
        privacyBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        bottomBar.addSubview(privacyBtn)
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick), for: .touchUpInside)
         
        
        privacyBtn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
            make.width.equalTo(80)
        }
        
        termsBtn.snp.makeConstraints { make in
            make.centerY.equalTo(privacyBtn.snp.centerY)
            make.right.equalTo(privacyBtn.snp.left).offset(-20)
            make.height.equalTo(22)
            make.width.equalTo(80)
        }
        
        //
        let viewline1 = UIView()
        viewline1.backgroundColor = btnColor
        bottomBar.addSubview(viewline1)
        viewline1.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(8)
            $0.right.equalTo(privacyBtn.snp.left).offset(-9.5)
            $0.centerY.equalTo(termsBtn.snp.centerY)
        }
        //
        let viewline2 = UIView()
        viewline2.backgroundColor = btnColor
        bottomBar.addSubview(viewline2)
        viewline2.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(8)
            $0.left.equalTo(privacyBtn.snp.right).offset(9.5)
            $0.centerY.equalTo(termsBtn.snp.centerY)
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
        PDfSubscribeStoreManager.default.restore()
    }
    
    @objc func yearBtnClick() {
        currentIapType = .year
    }
    @objc func monthBtnClick() {
        currentIapType = .month
    }
    @objc func subNowBtnClick() {
         
        PDfSubscribeStoreManager.default.subscribeIapOrder(iapType: currentIapType, source: "") {[weak self] success, errorstr in
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



class SubscribeIapBtn: UIButton {
    var iapItem: PDfSubscribeStoreManager.IAPType
    let titleLabe = UILabel()
    let priceLabe = UILabel()
    let deletePriceLabe = UILabel()
    
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
        layer.borderWidth = 1
        
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
        priceLabe.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(snp.centerY).offset(4)
            $0.width.greaterThanOrEqualTo(24)
            $0.height.equalTo(24)
        }
        priceLabe.textColor = UIColor(hexString: "#1C1E37")
        priceLabe.font = FontCusNames.SFProSemiBold.font(sizePoint: 16)
        priceLabe.textAlignment = .center
        
        //
        let monthBeforeStr = "$99.99"
        addSubview(deletePriceLabe)
        deletePriceLabe.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(snp.centerY).offset(4)
            $0.width.greaterThanOrEqualTo(24)
            $0.height.equalTo(24)
        }
        deletePriceLabe.textAlignment = .center
        let attriStr = NSAttributedString(string: monthBeforeStr, attributes: [NSAttributedString.Key.font : FontCusNames.SFProSemiBold.font(sizePoint: 16), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#B6BAC8")!, NSAttributedString.Key.strikethroughStyle : 1, NSAttributedString.Key.strikethroughColor : UIColor(hexString: "#B6BAC8")!])
        deletePriceLabe.attributedText = attriStr
        
        
    }
    
    
    
    
}

class SubsInfoLabel: UIView {
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
        let duiImgV = UIImageView()
        addSubview(duiImgV)
        duiImgV.image = UIImage(named: "sub_duihao")
        duiImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo(17)
            $0.height.equalTo(12)
        }
        addSubview(infolabel)
        infolabel.textColor = .black
        infolabel.textAlignment = .left
        infolabel.adjustsFontSizeToFitWidth = true
        infolabel.font = UIFont(name: "PingFangSC-Regular", size: 14)
        infolabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview()
            $0.height.greaterThanOrEqualTo(10)
        }
        infolabel.adjustsFontSizeToFitWidth = true
        infolabel.text = contentStr
    }
}
