//
//  PDfGoSplashGuideVC.swift
//  PDfMaker
//
//  Created by Jbai go on 2023/5/31.
//

import UIKit
import DeviceKit
import KRProgressHUD

class PDfGoSplashGuideVC: UIViewController {
    var collection: UICollectionView!
    var currentIndexP: IndexPath = IndexPath(item: 0, section: 0)
    let theContinueBtn = UIButton()
    var continueCloseBlock:(()->Void)?
    var splashPage1: PDfSplashPageViewOne!
    var splashPage2: PDfSplashPageViewOne!
    var splashPage3: PDfSplashPageViewOne!
    var splashPage4: PDfSplashPageViewOne!
    var splashPage5: PDfSplashPageViewWeek!
    var splashPageList: [UIView] = []
    
    var sp_list = ["sp01", "sp02", "sp03", "sp05", "sp06", "sp07"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Device.current.diagonal <= 4.7 || Device.current.diagonal >= 7 || Device.current.diagonal == 5.5 {
            sp_list = ["sp8_01", "sp8_02", "sp8_03", "sp8_05", "sp8_06", "sp8_07"]
        }
        
        splashPage1 = PDfSplashPageViewOne(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), imgNames: [sp_list[0], sp_list[1], sp_list[2]])
        splashPage2 = PDfSplashPageViewOne(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), imgNames: [sp_list[3]])
        splashPage3 = PDfSplashPageViewOne(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), imgNames: [sp_list[4]])
        splashPage4 = PDfSplashPageViewOne(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), imgNames: [sp_list[5]])
        
        splashPage5 = PDfSplashPageViewWeek(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        splashPage5.closeBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.theContinueBtnClick()
            }
        }
        splashPage5.purchaseBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                PDfSubscribeStoreManager.default.subscribeIapOrder(iapType: .week, source: "week") { success, errorStr in
                    if success {
                        self.theContinueBtnClick()
                    } else {
                        KRProgressHUD.showInfo(withMessage: errorStr)
                    }
                }
            }
        }
        
        splashPageList = [splashPage1, splashPage2, splashPage3, splashPage4, splashPage5]
        
        setupV()
        
        splashPage1.startAnimation()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func setupV() {
        view.backgroundColor = .black
        view.clipsToBounds = true
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset(0)
            $0.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: BSiegSplashCell.self)
        
        //
//        view.addSubview(theContinueBtn)
//        theContinueBtn.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
//            $0.left.equalToSuperview().offset(45)
//            $0.height.equalTo(72)
//        }
//        theContinueBtn.layer.cornerRadius = 72/2
//        theContinueBtn.backgroundColor = UIColor(hexString: "#3971FF")
//        theContinueBtn.setTitle("Continue", for: .normal)
//        theContinueBtn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
//        theContinueBtn.setTitleColor(.white, for: .normal)
//        theContinueBtn.addTarget(self, action: #selector(theContinueBtnClick(sender: )), for: .touchUpInside)
//        theContinueBtn.addShadow(ofColor: UIColor(hexString: "#3971FF")!, radius: 15, offset: CGSize(width: 0, height: 5), opacity: 0.3)
    }

    @objc func theContinueBtnClick() {
        if currentIndexP.item == splashPageList.count - 1 {
            continueCloseBlock?()
            debugPrint("currentIndexP = close")
        } else {
            collection.isPagingEnabled = false
            currentIndexP = IndexPath(item: currentIndexP.item + 1, section: 0)
            collection.selectItem(at: currentIndexP, animated: true, scrollPosition: .centeredHorizontally)
            debugPrint("currentIndexP = \(currentIndexP.item)")
            collection.isPagingEnabled = true
        }
    }
}

extension PDfGoSplashGuideVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: BSiegSplashCell.self, for: indexPath)
        
//        var titName: String = ""
//        var imgName: String = ""
//        var iconimgName: String = ""
//        if indexPath.item == 0 {
//            titName = "Track Your\nDevices"
//            imgName = "yin01"
//            iconimgName = "dao1"
//        } else if indexPath.item == 1 {
//            titName = "Get Pinpoint\nLocation"
//            imgName = "yin02"
//            iconimgName = "dao2"
//        } else if indexPath.item == 2 {
//            titName = "Never Lose\nYour Device Again"
//            imgName = "yin03"
//            iconimgName = "dao3"
//        }
//        let imgName = sp_list[indexPath.item]
//        cell.contentImgV.image = UIImage(named: imgName)
//        cell.titLabelV.text = titName
//        cell.iconImgV.image = UIImage(named: iconimgName)
        
        cell.bgContentV.removeSubviews()
        let page = splashPageList[indexPath.item]
        cell.bgContentV.addSubview(page)
//
//        if indexPath.item == 0 {
//            cell.bgContentV.addSubview(splashPage1)
//        } else if indexPath.item == 1 {
//            cell.bgContentV.addSubview(splashPage2)
//        } else if indexPath.item == 2 {
//            cell.bgContentV.addSubview(splashPage3)
//        } else if indexPath.item == 3 {
//            cell.bgContentV.addSubview(splashPage4)
//        } else if indexPath.item == 4 {
//            cell.bgContentV.addSubview(splashPage5)
//        }
//
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return splashPageList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PDfGoSplashGuideVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension PDfGoSplashGuideVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == splashPageList.count - 1 {
            
        } else {
            theContinueBtnClick()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collection {
            if let indexP = collection.indexPathForItem(at: CGPoint(x: view.bounds.width/2 + collection.contentOffset.x, y: 50)) {
                if indexP.item != currentIndexP.item {

                    currentIndexP = indexP
                    if indexP.item == splashPageList.count - 1 {
                        splashPage5.showCloseBtnStatus()
//                        splashPage1.startAnimation()
                    }
//                    pagecontrol.currentPage = currentInfoIndex
//                    infoLabel.text = infoList[currentInfoIndex]["name"]
                }

            }
        }
    }
    
}


class BSiegSplashCell: UICollectionViewCell {
//    let contentImgV = UIImageView()
//    let titLabelV = UILabel()
//    let iconImgV = UIImageView()
    
    let bgContentV: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .black
        contentView.backgroundColor = .black
        //
        contentView.addSubview(bgContentV)
        bgContentV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
//        contentImgV.contentMode = .scaleAspectFill
//        contentImgV.clipsToBounds = true
//        contentView.addSubview(contentImgV)
//        contentImgV.snp.makeConstraints {
//            $0.top.right.bottom.left.equalToSuperview()
//        }
        //
//        iconImgV.contentMode = .scaleAspectFit
//        iconImgV.clipsToBounds = true
//        contentView.addSubview(iconImgV)
//
//        //
//        titLabelV.numberOfLines = 0
//        titLabelV.font = UIFont(name: "Poppins-Bold", size: 32)
//        titLabelV.textAlignment = .left
//        titLabelV.textColor = UIColor(hexString: "#242766")
//        contentView.addSubview(titLabelV)
//        titLabelV.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(40)
//            $0.top.equalToSuperview().offset(80)
//            $0.width.height.greaterThanOrEqualTo(96)
//        }
//        //
//        iconImgV.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.bottom.equalToSuperview().offset(-177)
//            $0.left.equalToSuperview().offset(50)
//            $0.top.equalToSuperview().offset(144)
//        }
        
    }
}

