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
    }

}

