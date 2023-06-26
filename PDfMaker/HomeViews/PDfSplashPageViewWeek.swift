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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        let bgImgV = UIImageView()
        self.addSubview(bgImgV)
        bgImgV.image = UIImage(named: "")
        bgImgV.contentMode = .scaleAspectFill
        
        //
        let centerBgV = UIView()
        self.addSubview(centerBgV)
        centerBgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(265)
            $0.width.equalTo(320)
        }
        centerBgV.backgroundColor = .white
        centerBgV.layer.cornerRadius = 24
        centerBgV.clipsToBounds = true
        //
        let centerBgImgV = UIImageView()
        centerBgV.addSubview(centerBgImgV)
        centerBgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        centerBgImgV.image = UIImage(named: "")
        
        //
        let purchaseBtn = UIButton()
        centerBgV.addSubview(purchaseBtn)
        purchaseBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
            $0.width.equalTo(160)
            $0.height.equalTo(38)
        }
        purchaseBtn.setBackgroundImage(UIImage(named: ""), for: .normal)
        purchaseBtn.addTarget(self, action: #selector(purchaseBtnClick), for: .touchUpInside)
        
        //
        
        centerBgV.addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
        closeBtn.setImage(UIImage(named: ""), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        
        closeBtn.alpha = 0
        
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
