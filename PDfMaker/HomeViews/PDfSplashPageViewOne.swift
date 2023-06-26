//
//  PDfSplashPageViewOne.swift
//  PDfMaker
//
//  Created by Joe on 2023/6/24.
//

import UIKit

class PDfSplashPageViewOne: UIView {
    var imgNames: [String]
    var imgVList: [UIImageView] = []
    
    init(frame: CGRect, imgNames: [String]) {
        self.imgNames = imgNames
        super.init(frame: frame)
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        
        for imN in imgNames {
            let contentImgV = UIImageView()
            addSubview(contentImgV)
            sendSubviewToBack(contentImgV)
            contentImgV.contentMode = .scaleAspectFill
            contentImgV.clipsToBounds = true
            contentImgV.image = UIImage(named: imN)
            imgVList.append(contentImgV)
            contentImgV.snp.makeConstraints {
                $0.left.right.top.bottom.equalToSuperview()
            }
        }
    }
    
    func startAnimation() {
        if imgVList.count == 3 {
            let imgV1 = imgVList[0]
            let imgV2 = imgVList[1]
            let imgV3 = imgVList[2]
            imgV1.alpha = 1
            imgV2.alpha = 1
            imgV3.alpha = 1
            
            
            UIView.animate(withDuration: 0.15, delay: 1, options: .curveEaseInOut) {
                let imgV = self.imgVList[0]
                imgV.alpha = 0
            } completion: { finished in
                if finished {
                    UIView.animate(withDuration: 0.15, delay: 1, options: .curveEaseInOut) {
                        let imgV = self.imgVList[1]
                        imgV.alpha = 0
                    } completion: { finished in
                        if finished {
                            
                        }
                    }
                }
            }

        }
    }

}
