//
//  PDfSplashPageViewWeek.swift
//  PDfMaker
//
//  Created by Joe on 2023/6/24.
//

import UIKit

class PDfSplashPageViewWeek: UIView {
    
    let closeBtn = UIButton()
    var closeBtnClickBlock: (()->Void)?
    var purchaseBtnClickBlock: (()->Void)?
    let centerInfoLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupV()
        fetchPriceLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        let bgImgV = UIImageView()
        self.addSubview(bgImgV)
        bgImgV.image = UIImage(named: "splashweekbg")
        bgImgV.contentMode = .scaleAspectFill
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        let centerBgV = UIView()
        self.addSubview(centerBgV)
        centerBgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(330)
            $0.height.equalTo(395)
        }
        centerBgV.backgroundColor = .white
        centerBgV.layer.cornerRadius = 20
        centerBgV.clipsToBounds = true
        //
        let centerBgImgV = UIImageView()
        centerBgV.addSubview(centerBgImgV)
        centerBgImgV.snp.makeConstraints {
            $0.top.equalToSuperview().offset(102)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(120)
        }
        centerBgImgV.image = UIImage(named: "splashlihua")
        //
        let centerTopLabel = UILabel()
        centerBgV.addSubview(centerTopLabel)
        centerTopLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(30)
            $0.bottom.equalTo(centerBgImgV.snp.top).offset(-20)
        }
        centerTopLabel.textAlignment = .center
        centerTopLabel.font = FontCusNames.MontBold.font(sizePoint: 18)
        centerTopLabel.textColor = UIColor(hexString: "#333333")
        centerTopLabel.text = "New user guidance completed!"
        centerTopLabel.numberOfLines = 0
        //
        
        //
        let purchaseBtn = UIButton()
        centerBgV.addSubview(purchaseBtn)
        purchaseBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
            $0.width.equalTo(130)
            $0.height.equalTo(50)
        }
        purchaseBtn.backgroundColor = UIColor(hexString: "#AE0000")
        purchaseBtn.layer.cornerRadius = 25
        purchaseBtn.setTitle("Continue", for: .normal)
        purchaseBtn.setTitleColor(.white, for: .normal)
        purchaseBtn.titleLabel?.font = FontCusNames.MontSemiBold.font(sizePoint: 16)
        purchaseBtn.addTarget(self, action: #selector(purchaseBtnClick), for: .touchUpInside)
        //
        
        centerBgV.addSubview(centerInfoLabel)
        centerInfoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
            $0.top.equalTo(centerBgImgV.snp.bottom).offset(20)
            $0.bottom.equalTo(purchaseBtn.snp.top).offset(-20)
        }
        centerInfoLabel.textAlignment = .center
        centerInfoLabel.font = FontCusNames.MontMedium.font(sizePoint: 12)
        centerInfoLabel.textColor = UIColor(hexString: "#666666")
        centerInfoLabel.text = "Unlimited access to all features and future updates only for $9.99 per week, auto renewable, cancel anytime."
        centerInfoLabel.numberOfLines = 0
        centerInfoLabel.adjustsFontSizeToFitWidth = true
        //
        centerBgV.addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(5)
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
        closeBtn.setImage(UIImage(named: "splashclose"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        
        closeBtn.alpha = 0
        
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
    
    func updatePrice() {
        let weekpri = "\(PDfSubscribeStoreManager.default.currentSymbol)\(PDfSubscribeStoreManager.default.currentWeekPrice)"
        centerInfoLabel.text = "Unlimited access to all features and future updates only for \(weekpri) per week, auto renewable, cancel anytime."
        
    }
    
    func showCloseBtnStatus() {
        UIView.animate(withDuration: 0.3, delay: 1.5) {
            self.closeBtn.alpha = 1
        }
    }
    
    @objc func purchaseBtnClick() {
        purchaseBtnClickBlock?()
    }
    
    @objc func closeBtnClick() {
        closeBtnClickBlock?()
    }
    
}

extension PDfSplashPageViewWeek {
    
}
