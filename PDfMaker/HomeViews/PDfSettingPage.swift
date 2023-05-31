//
//  PDfSettingPage.swift
//  PDfMaker
//
//  Created by Joe on 2023/5/20.
//

import UIKit
import SwifterSwift
import SnapKit
import KRProgressHUD

class PDfSettingPage: UIView {

    let appName: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Fast Print"
    let versionName: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    let feedEmail = "zhangyangzi0101@aliyun.com"
    let termsUrlStr: String = "https://sites.google.com/view/fast-print-terms-of-use/home"
    let privacyUrlStr: String = "https://sites.google.com/view/fast-print-privacy-policy/home"
    let appstoreShareUrl: String = "itms-apps://itunes.apple.com/cn/app/id\("6446986870")?mt=8"
    
    let subscribeBanner = UIView()
    let titLB = UILabel()
    let supportFeedBtn = PDfSettingItemBtn(frame: .zero, iconStr: "star", nameStr: "Customer support")
    let restoreBtn = PDfSettingItemBtn(frame: .zero, iconStr: "restore", nameStr: "Restore purchase")
    let shareappBtn = PDfSettingItemBtn(frame: .zero, iconStr: "share 1", nameStr: "Share our app")
    let termsBtn = PDfSettingItemBtn(frame: .zero, iconStr: "file-text", nameStr: "Terms of use")
    let privacyBtn = PDfSettingItemBtn(frame: .zero, iconStr: "lock", nameStr: "Privacy policy")
    
    var fahterViewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        setupSubscribeBanner()
        setupSettingInfoItem()
        updateSubBannerStatus()
        
        restoreBtn.isHidden = true
        
        addNotifi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addNotifi() {
        NotificationCenter.default.addObserver(self, selector: #selector(subscribeSuccessAction(notification: )), name: NSNotification.Name(rawValue: PDfSubscribeStoreManager.PurchaseNotificationKeys.success), object: nil)
        
    }
    
    @objc func subscribeSuccessAction(notification: Notification) {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            self.updateSubBannerStatus()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateSubBannerStatus() {
        subscribeBanner.isHidden = true
        supportFeedBtn.snp.remakeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
            $0.top.equalTo(titLB.snp.bottom).offset(34 + 5)
        }
//        if PDfSubscribeStoreManager.default.inSubscription {
//            subscribeBanner.isHidden = true
//            supportFeedBtn.snp.remakeConstraints {
//                $0.left.right.equalToSuperview()
//                $0.height.equalTo(60)
//                $0.top.equalTo(titLB.snp.bottom).offset(34 + 25)
//            }
//        } else {
//            subscribeBanner.isHidden = false
//            supportFeedBtn.snp.remakeConstraints {
//                $0.left.right.equalToSuperview()
//                $0.height.equalTo(60)
//                $0.top.equalTo(titLB.snp.bottom).offset(34 + 89 + 25)
//            }
//        }
    }
    
    
    func setupContentView() {
        backgroundColor = UIColor(hexString: "#EFEFEF")
        //
        titLB.textColor = UIColor(hexString: "#1C1E37")
        titLB.font = FontCusNames.MontSemiBold.font(sizePoint: 20)
        addSubview(titLB)
        titLB.snp.makeConstraints {
            $0.centerY.equalTo(safeAreaLayoutGuide.snp.top).offset(32)
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        titLB.text = "Setting"
           
    }
    
    func setupSubscribeBanner() {
        addSubview(subscribeBanner)
        subscribeBanner.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titLB.snp.bottom).offset(34)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(89)
        }
        subscribeBanner.layer.cornerRadius = 20
        subscribeBanner.clipsToBounds = true
        //
        let subImgV = UIImageView()
        subImgV.image = UIImage(named: "subsprobanner")
        subImgV.contentMode = .scaleToFill
        subscribeBanner.addSubview(subImgV)
        subImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        
        let guanImgV = UIImageView()
        guanImgV.image = UIImage(named: "guanGroup")
        guanImgV.contentMode = .scaleAspectFit
        subscribeBanner.addSubview(guanImgV)
        guanImgV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(64/2)
        }
        //
        let subsArrowImgV = UIImageView()
        subsArrowImgV.image = UIImage(named: "CaretRight")
        subsArrowImgV.contentMode = .scaleAspectFit
        subscribeBanner.addSubview(subsArrowImgV)
        subsArrowImgV.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(16)
        }
        //
        let subscriTitleLabel = UILabel()
        subscribeBanner.addSubview(subscriTitleLabel)
        subscriTitleLabel.text = "GO PREMIUM"
        subscriTitleLabel.textColor = UIColor(hexString: "#FFFFFF")
        subscriTitleLabel.font = FontCusNames.MontBold.font(sizePoint: 18)
        subscriTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(subscribeBanner.snp.centerY)
            $0.left.equalTo(guanImgV.snp.right).offset(14)
            $0.width.height.greaterThanOrEqualTo(20)
        }
        //
        let subscriInfoLabel = UILabel()
        subscribeBanner.addSubview(subscriInfoLabel)
        subscriInfoLabel.text = "Unlimited access to all features"
        subscriInfoLabel.textColor = UIColor(hexString: "#FFFFFF")
        subscriInfoLabel.font = FontCusNames.MontSemiBold.font(sizePoint: 14)
        subscriInfoLabel.snp.makeConstraints {
            $0.top.equalTo(subscribeBanner.snp.centerY).offset(3)
            $0.left.equalTo(guanImgV.snp.right).offset(14)
            $0.width.height.greaterThanOrEqualTo(20)
        }
    }
    
    func setupSettingInfoItem() {
        
        
        addSubview(supportFeedBtn)
        addSubview(shareappBtn)
        addSubview(termsBtn)
        addSubview(privacyBtn)
        addSubview(restoreBtn)
        
        supportFeedBtn.addTarget(self, action: #selector(supportFeedBtnClick), for: .touchUpInside)
        shareappBtn.addTarget(self, action: #selector(shareappBtnClick), for: .touchUpInside)
        termsBtn.addTarget(self, action: #selector(termsBtnClick), for: .touchUpInside)
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick), for: .touchUpInside)
        restoreBtn.addTarget(self, action: #selector(restoreBtnClick), for: .touchUpInside)
        supportFeedBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
            $0.top.equalTo(titLB.snp.bottom).offset(34 + 89 + 25)
            
        }
        privacyBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
            $0.top.equalTo(supportFeedBtn.snp.bottom).offset(4)
        }
        shareappBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
            $0.top.equalTo(privacyBtn.snp.bottom).offset(4)
        }
        termsBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
            $0.top.equalTo(shareappBtn.snp.bottom).offset(4)
        }
        restoreBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
            $0.top.equalTo(termsBtn.snp.bottom).offset(4)
        }
        
    }
    
    @objc func supportFeedBtnClick() {
        if let vc = self.fahterViewController {
            PDfMakTool.default.showFeedbcak(fatherViewController: vc)
        }
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
    
    @objc func shareappBtnClick() {
        if let vc = self.fahterViewController {
            PDfMakTool.default.openShareApp(fatherViewController: vc)
        }
    }
    @objc func termsBtnClick() {
        PDfMakTool.default.openSafiPrivacyURL(str: PDfMakTool.termsUrl)
    }
    
    @objc func privacyBtnClick() {
        PDfMakTool.default.openSafiPrivacyURL(str: PDfMakTool.privacyUrl)
    }
    
}



class PDfSettingItemBtn: UIButton {
    var iconStr: String
    var nameStr: String
    
    init(frame: CGRect, iconStr: String, nameStr: String) {
        self.iconStr = iconStr
        self.nameStr = nameStr
        super.init(frame: frame)
        //
        let iconImgV = UIImageView()
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(32)
            $0.width.height.equalTo(24)
        }
        iconImgV.image = UIImage(named: iconStr)
        iconImgV.contentMode = .center
        //
        let nameLab = UILabel()
        addSubview(nameLab)
        nameLab.text = nameStr
        nameLab.textColor = UIColor(hexString: "#1C1E37")
        nameLab.font = FontCusNames.MontBold.font(sizePoint: 16)
        nameLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(iconImgV.snp.right).offset(14)
            $0.width.height.greaterThanOrEqualTo(20)
        }
        //
        let arrowImgV = UIImageView()
        addSubview(arrowImgV)
        arrowImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-35)
            $0.width.equalTo(5)
            $0.height.equalTo(10)
        }
        arrowImgV.image = UIImage(named: "setVector")
        arrowImgV.contentMode = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


