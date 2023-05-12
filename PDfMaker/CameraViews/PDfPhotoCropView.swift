//
//  PDfPhotoCropView.swift
//  PDfMaker
//
//  Created by JOJO on 2023/5/12.
//

import UIKit

class PDfPhotoCropView: UIView {
    var originImg: UIImage
    
    init(frame: CGRect, originImg: UIImage) {
        self.originImg = originImg
        super.init(frame: frame)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    func setupContent() {
        
    }

}
