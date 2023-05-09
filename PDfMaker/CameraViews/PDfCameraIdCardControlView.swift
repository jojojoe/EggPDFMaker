//
//  PDfCameraIdCardControlView.swift
//  PDfMaker
//
//  Created by JOJO on 2023/5/8.
//

import UIKit

class PDfCameraIdCardControlView: UIView {

    
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
        controlBtn.titleLabel?.font = PDfFontNames.SFProRegular.font(sizePoint: 11)
        controlBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        controlBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(212)
            $0.height.equalTo(25)
        }
        controlBtn.layer.cornerRadius = 4
        
        //
        
        
    }
}
