//
//  PDfPhotoCropVC.swift
//  PDfMaker
//
//  Created by Joe on 2023/5/12.
//

import UIKit

class PDfPhotoCropVC: UIViewController {

    /// The image the quadrilateral was detected on.
    private let imgItem: UserImgItem

    /// The detected quadrilateral that can be edited by the user. Uses the image's coordinates.
    
    var cropRefreshBlock: (()->Void)?
    
    init(imgItem: UserImgItem, rotateImage: Bool = true) {
        self.imgItem = imgItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentV()
        
        
    }
    
    func setupContentV() {
        let cropV = PDfPhotoCropView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), imgItem: imgItem)
        view.addSubview(cropV)
        cropV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        cropV.closeClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.closeAction()
            }
        }
        cropV.saveClickBlock = {
            [weak self] imgResult in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.closeAction()
                self.cropRefreshBlock?()
            }
        }
    }

    func closeAction() {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    

}
