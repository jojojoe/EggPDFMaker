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
    
    func setupV() {
        
        for imN in imgNames {
            let contentImgV = UIImageView()
            addSubview(contentImgV)
            contentImgV.contentMode = .scaleAspectFill
            contentImgV.clipsToBounds = true
            contentImgV.image = UIImage(named: imN)
            imgVList.append(contentImgV)
        }
    }

}
