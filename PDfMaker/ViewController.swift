//
//  ViewController.swift
//  PDfMaker
//
//  Created by JOJO on 2023/4/27.
//

import UIKit
import SnapKit
import SwifterSwift


enum FontCusNames: String {
    case SFProRegular = "SFProText-Regular"
    case SFProMedium = "SFProText-Medium"
    case SFProSemiBold = "SFProText-Semibold"
    case SFProBold = "SFProText-Bold"
    case MontLight = "Montserrat-Light"
    case MontRegular = "Montserrat-Regular"
    case MontMedium = "Montserrat-Medium"
    case MontSemiBold = "Montserrat-SemiBold"
    case MontBold = "Montserrat-Bold"
    
    
    func font(sizePoint: CGFloat) -> UIFont {
        return UIFont(name: rawValue, size: sizePoint) ?? UIFont.systemFont(ofSize: sizePoint)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        // Do any additional setup after loading the view.
        let scaneBtn = UIButton()
        view.addSubview(scaneBtn)
        scaneBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-100)
            $0.width.height.equalTo(60)
        }
        scaneBtn.backgroundColor = .lightGray
        scaneBtn.addTarget(self, action: #selector(scaneBtnClick(sender: )), for: .touchUpInside)
        
         
        
        
        
        
    }

    @objc func scaneBtnClick(sender: UIButton) {
//        let vc = PDfScanCAmeraVC()
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let item = UserImgItem(originImg: UIImage(named: "test1")!)
        let rotatevc = PDfPhotoRotateVC(imgItem: item)
        self.navigationController?.pushViewController(rotatevc, animated: true)

        
//        editwescan(image: UIImage(named: "test1")!)
        
        
        
    }
    
   
    
    func editwescan(image: UIImage) {
        let item = UserImgItem(originImg: image)
        WeScanCropManager.default.detect(image: image) { [weak self] detectedQuad in
            guard let self else { return }
            
            let editViewController = PDfPhotoCropVC(imgItem: item, quad: detectedQuad, rotateImage: false)
            self.navigationController?.pushViewController(editViewController, animated: true)
//            EditScanViewController
            // PDfPhotoCropVC
        }
        
        
    }
    

    
}





extension ViewController: DDPerspectiveTransformProtocol {
    func perspectiveTransformingDidFinish(controller: DDPerspectiveTransformViewController, croppedImage: UIImage) {
        debugPrint("cropedImg = \(croppedImage)")
    }
    
    func perspectiveTransformingDidCancel(controller: DDPerspectiveTransformViewController) {
        _ = controller.navigationController?.popViewController(animated: true)
    }
}
