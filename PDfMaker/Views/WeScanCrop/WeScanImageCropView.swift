//
//  WeScanImageCropView.swift
//  PDfMaker
//
//  Created by JOJO on 2023/5/12.
//

import UIKit

class WeScanImageCropView: UIView {
    
    var originImage: UIImage
    
    init(frame: CGRect, originImage: UIImage) {
        self.originImage = originImage
        
        super.init(frame: frame)
        setupContentV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentV() {
        
    }
}
