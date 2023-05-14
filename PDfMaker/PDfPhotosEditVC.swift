//
//  PDfPhotosEditVC.swift
//  PDfMaker
//
//  Created by Joe on 2023/5/14.
//

import UIKit

class PDfPhotosEditVC: UIViewController {
    
    var imgItems: [UserImgItem]
    
    var collection: UICollectionView!
    let canvasV = UIView()
    var currentIndexP: IndexPath = IndexPath(item: 0, section: 0)
    
    
    init(imgItems: [UserImgItem]) {
        self.imgItems = imgItems
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContent()
    }
   
    func setupContent() {
        view.backgroundColor = .black
        //
        let backBtn = UIButton()
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.width.height.equalTo(44)
        }
        backBtn.setImage(UIImage(named: "close"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        //
        let saveBtn = UIButton()
        view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(44)
        }
        saveBtn.setTitle("Save", for: .normal)
        saveBtn.setTitleColor(UIColor.white, for: .normal)
        saveBtn.titleLabel?.font = FontCusNames.MontSemiBold.font(sizePoint: 16)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)

        //
        let bottomV = UIView()
        view.addSubview(bottomV)
        bottomV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(90)
        }
        
        //
        let cropBtn = PDfPhotoEditBtn(frame: .zero, iconName: "Crop", titName: "Crop")
        bottomV.addSubview(cropBtn)
        cropBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(bottomV)
            $0.width.equalTo(50)
            $0.height.equalTo(52)
        }
        cropBtn.addTarget(self, action: #selector(cropBtnClick), for: .touchUpInside)
        //
        let rotateBtn = PDfPhotoEditBtn(frame: .zero, iconName: "rotatepho", titName: "Rotate")
        bottomV.addSubview(rotateBtn)
        rotateBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-90)
            $0.centerY.equalTo(bottomV)
            $0.width.equalTo(50)
            $0.height.equalTo(52)
        }
        rotateBtn.addTarget(self, action: #selector(rotateBtnClick), for: .touchUpInside)
         
        //
        let pageLabel = UILabel()
        bottomV.addSubview(pageLabel)
        pageLabel.adjustsFontSizeToFitWidth = true
        pageLabel.textColor = .white
        pageLabel.font = FontCusNames.MontSemiBold.font(sizePoint: 14)
        pageLabel.textAlignment = .center
        //
        let moveLeftBtn = UIButton()
        bottomV.addSubview(moveLeftBtn)
        moveLeftBtn.setImage(UIImage(named: "CaretCircleLeft"), for: .normal)
        moveLeftBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        moveLeftBtn.addTarget(self, action: #selector(moveLeftBtnClick), for: .touchUpInside)
        //
        let moveRightBtn = UIButton()
        bottomV.addSubview(moveRightBtn)
        moveRightBtn.setImage(UIImage(named: "CaretCircleRight"), for: .normal)
        moveRightBtn.snp.makeConstraints {
            $0.left.equalTo(moveLeftBtn.snp.right).offset(40)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        moveRightBtn.addTarget(self, action: #selector(moveRightBtnClick), for: .touchUpInside)
        
        //
        pageLabel.snp.makeConstraints {
            $0.left.equalTo(moveLeftBtn.snp.right).offset(-5)
            $0.right.equalTo(moveRightBtn.snp.left).offset(5)
            $0.centerY.equalTo(moveRightBtn.snp.centerY)
            $0.height.equalTo(40)
        }
        
        
        //
        
        view.addSubview(canvasV)
        canvasV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomV.snp.top)
            $0.top.equalTo(backBtn.snp.bottom).offset(10)
        }
        
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        canvasV.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: PDfPhotosEditCell.self)
        
    }
    
    @objc func rotateBtnClick() {
        
    }
    
    @objc func cropBtnClick() {
        
    }
    
    @objc func moveLeftBtnClick() {
        theContinueBtnClick(add: -1)
    }
    
    @objc func moveRightBtnClick() {
        theContinueBtnClick(add: 1)
    }
    
    func theContinueBtnClick(add: Int) {
        if currentIndexP.item == 2 {
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

extension PDfPhotosEditVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PDfPhotosEditCell.self, for: indexPath)
        let item = imgItems[indexPath.item]
        cell.contentImgV = item.processedImg
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PDfPhotosEditVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
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

extension PDfPhotosEditVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class PDfPhotoEditBtn: UIButton {
    var iconName: String
    var titName: String
    init(frame: CGRect, iconName: String, titName: String) {
        self.iconName = iconName
        self.titName = titName
        super.init(frame: frame)
        let iconImgV = UIImageView()
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        iconImgV.image = UIImage(named: iconName)
        //
        let titLabel = UILabel()
        addSubview(titLabel)
        titLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(iconImgV.snp.bottom)
            $0.left.equalToSuperview()
        }
        titLabel.font = FontCusNames.MontMedium
        titLabel.textColor = .white
        titLabel.textAlignment = .center
        titLabel.text = titName
    }
}


class PDfPhotosEditCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        
    }
}
