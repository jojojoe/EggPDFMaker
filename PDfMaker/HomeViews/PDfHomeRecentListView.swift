//
//  PDfHomeRecentListView.swift
//  PDfMaker
//
//  Created by Joe on 2023/5/20.
//

import UIKit
import QuickLook

class PDfHomeRecentListView: UIView {

    var itemSelectBlock: ((HistoryItem)->Void)?
    var itemMoreClickBlock: ((HistoryItem)->Void)?
    
    var collection: UICollectionView!
    var fileList: [HistoryItem] = []
    
    var nodoucV = UIView()
    
    func updateContent(fileList: [HistoryItem]) {
        self.fileList = fileList
        self.collection.reloadData()
        if fileList.count == 0 {
            nodoucV.isHidden = false
            collection.isHidden = true
        } else {
            nodoucV.isHidden = true
            collection.isHidden = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupV()
        setupNodoc()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupNodoc() {
        addSubview(nodoucV)
        nodoucV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(50)
            $0.width.equalTo(160)
            $0.height.equalTo(160+22)
        }
        let nodocImgV = UIImageView()
        nodoucV.addSubview(nodocImgV)
        nodocImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalTo(160)
        }
        nodocImgV.image = UIImage(named: "nodocImg")
        //
        let nodocLabel = UILabel()
        nodoucV.addSubview(nodocLabel)
        nodocLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(22)
            $0.left.right.equalToSuperview()
        }
        nodocLabel.textAlignment = .center
        nodocLabel.adjustsFontSizeToFitWidth = true
        nodocLabel.font = FontCusNames.MontSemiBold.font(sizePoint: 14)
        nodocLabel.text = "No Documents Yet."
        nodocLabel.textColor = UIColor(hexString: "#B6BAC8")
    }
    
    func setupV() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: PDfRecentFileCell.self)
    }

}

extension PDfHomeRecentListView {
    
}

extension PDfHomeRecentListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PDfRecentFileCell.self, for: indexPath)
        let item = fileList[indexPath.item]
        
        cell.updateContentStatus(item: item)
        cell.moreBtnBlock = {
            [weak self] fileitem in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if let fileitem_m = fileitem {
                    self.itemMoreClickBlock?(fileitem_m)
                }
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PDfHomeRecentListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wid: CGFloat = UIScreen.main.bounds.size.width - 40
        return CGSize(width: wid, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

extension PDfHomeRecentListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = fileList[indexPath.item]
        itemSelectBlock?(item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class PDfRecentFileCell: UICollectionViewCell {
    let coverImgV = UIImageView()
    let fileNameL = UILabel()
    let timeLb = UILabel()
    let moreBtn = UIButton()
    var moreBtnBlock: ((HistoryItem?)->Void)?
    var histroyItem: HistoryItem?
    
    func updateContentStatus(item: HistoryItem) {
        self.histroyItem = item
        fileNameL.text = item.displayName
        timeLb.text = item.timeStr
        
        let request = QLThumbnailGenerator.Request(
          fileAt: item.pdfPathUrl(),
          size: CGSize(width: 120, height: 160),
          scale: 1,
          representationTypes: .all)

        // 2
        let generator = QLThumbnailGenerator.shared
        generator.generateRepresentations(for: request) {[weak self] thumbnail,
            _, error in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if let thumbnail = thumbnail {
                    debugPrint("thumbnail generated")
                    self.coverImgV.image = thumbnail.uiImage
                } else if let error = error {
                    self.coverImgV.image = UIImage(named: "fileimagecover")
                    debugPrint(" - \(error)")
                }
            }
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        coverImgV.contentMode = .scaleAspectFill
        coverImgV.clipsToBounds = true
        contentView.addSubview(coverImgV)
        coverImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.width.equalTo(60)
            $0.height.equalTo(80)
        }
        
        //
        
        contentView.addSubview(fileNameL)
        fileNameL.snp.makeConstraints {
            $0.bottom.equalTo(contentView.snp.centerY).offset(-5)
            $0.left.equalTo(coverImgV.snp.right).offset(15)
            $0.right.equalToSuperview().offset(-54)
            $0.height.greaterThanOrEqualTo(10)
        }
        fileNameL.textAlignment = .left
        fileNameL.font = FontCusNames.MontBold.font(sizePoint: 16)
        fileNameL.textColor = UIColor(hexString: "#1C1E37")
        
        //

        contentView.addSubview(timeLb)
        timeLb.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.centerY).offset(5)
            $0.left.equalTo(coverImgV.snp.right).offset(15)
            $0.right.equalToSuperview().offset(-54)
            $0.height.greaterThanOrEqualTo(10)
        }
        timeLb.textAlignment = .left
        timeLb.font = FontCusNames.MontRegular.font(sizePoint: 14)
        timeLb.textColor = UIColor(hexString: "#1C1E37")
        
        //
        
        contentView.addSubview(moreBtn)
        moreBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        moreBtn.setImage(UIImage(named: "DotsThreeOutlineVertical"), for: .normal)
        moreBtn.addTarget(self, action: #selector(moreBtnClick), for: .touchUpInside)
        
    }
    
    @objc func moreBtnClick() {
        
        moreBtnBlock?(histroyItem)
    }
}
