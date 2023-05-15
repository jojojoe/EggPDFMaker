//
//  PDfCameraIdCardControlView.swift
//  PDfMaker
//
//  Created by JOJO on 2023/5/8.
//

import UIKit

class PDfCameraIdCardControlView: UIView {

    let contentImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func setupContent() {
        //
        let controlBtn = UIButton()
        controlBtn.backgroundColor = UIColor(hexString: "#292929")?.withAlphaComponent(0.8)
        addSubview(controlBtn)
        controlBtn.setTitle("Put the ID Card in the view frame", for: .normal)
        controlBtn.setTitleColor(.white, for: .normal)
        controlBtn.titleLabel?.font = FontCusNames.SFProRegular.font(sizePoint: 11)
        controlBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        controlBtn.layer.cornerRadius = 4
        controlBtn.isUserInteractionEnabled = false
        //
        let imgH = bounds.size.height - 70
        let imgW = imgH * (30.0/45.0)
        
        addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.width.equalTo(Int(imgW))
            $0.height.equalTo(Int(imgH))
            $0.centerY.equalToSuperview().offset(25)
            $0.centerX.equalToSuperview()
        }
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.image = UIImage(named: "idcard")
        contentImgV.highlightedImage = UIImage(named: "idcard_2")
        //
        controlBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(contentImgV.snp.top).offset(-10)
            $0.width.equalTo(212)
            $0.height.equalTo(25)
        }
        
    }
}
