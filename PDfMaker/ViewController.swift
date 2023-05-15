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
        let vc = PDfScanCAmeraVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let item = UserImgItem(originImg: UIImage(named: "test1")!)
//        let rotatevc = PDfPhotoRotateVC(imgItem: item)
//        self.navigationController?.pushViewController(rotatevc, animated: true)
        
        
//        editwescan(image: UIImage(named: "test1")!)
        
        
//        let item1 = UserImgItem(originImg: UIImage(named: "test1")!)
//        let item2 = UserImgItem(originImg: UIImage(named: "test2")!)
//        let item3 = UserImgItem(originImg: UIImage(named: "test1")!)
//        let item4 = UserImgItem(originImg: UIImage(named: "test2")!)
//        let itemList: [UserImgItem] = [item1, item2, item3, item4]
//        let editVC = PDfPhotosEditVC(imgItems: itemList)
//        self.navigationController?.pushViewController(editVC, animated: true)
        
    }
    
   
    
    func editwescan(image: UIImage) {
        let item = UserImgItem(originImg: image)
        WeScanCropManager.default.detect(image: image) { [weak self] detectedQuad in
            guard let self else { return }
            
            let editViewController = PDfPhotoCropVC(imgItem: item, rotateImage: false)
            self.navigationController?.pushViewController(editViewController, animated: true)

        }
        
        
    }
    

    
}




 
