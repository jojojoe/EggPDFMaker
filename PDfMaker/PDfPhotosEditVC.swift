//
//  PDfPhotosEditVC.swift
//  PDfMaker
//
//  Created by Joe on 2023/5/14.
//

import UIKit
import KRProgressHUD

class PDfPhotosEditVC: UIViewController {
    
    var imgItems: [UserImgItem]
    
    var collection: UICollectionView!
    let canvasV = UIView()
    var currentIndexP: IndexPath = IndexPath(item: 0, section: 0)
    let moveLeftBtn = UIButton()
    let moveRightBtn = UIButton()
    let pageLabel = UILabel()
    var clickScrollEnd: Bool = true
    
    
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
        moveLeftBtn.isEnabled = false
        if currentIndexP.item == imgItems.count - 1 {
            moveRightBtn.isEnabled = false
        } else {
            moveRightBtn.isEnabled = true
        }
        pageLabel.text = "\(currentIndexP.item + 1)/\(imgItems.count)"
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
        let shareBtn = UIButton()
        view.addSubview(shareBtn)
        shareBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(44)
        }
        shareBtn.setImage(UIImage(named: "Share"), for: .normal)
        shareBtn.setTitleColor(UIColor.white, for: .normal)
        shareBtn.titleLabel?.font = FontCusNames.MontSemiBold.font(sizePoint: 16)
        shareBtn.addTarget(self, action: #selector(shareBtnClick), for: .touchUpInside)

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
        
        bottomV.addSubview(pageLabel)
        pageLabel.adjustsFontSizeToFitWidth = true
        pageLabel.textColor = .white
        pageLabel.font = FontCusNames.MontSemiBold.font(sizePoint: 14)
        pageLabel.textAlignment = .center
        //

        bottomV.addSubview(moveLeftBtn)
        moveLeftBtn.setImage(UIImage(named: "CaretCircleLeft"), for: .normal)
        moveLeftBtn.setImage(UIImage(named: "CaretCircleLeft_d"), for: .disabled)
        
        moveLeftBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        moveLeftBtn.addTarget(self, action: #selector(moveLeftBtnClick), for: .touchUpInside)
        //
        
        bottomV.addSubview(moveRightBtn)
        moveRightBtn.setImage(UIImage(named: "CaretCircleRight"), for: .normal)
        moveRightBtn.setImage(UIImage(named: "CaretCircleRight_d"), for: .disabled)
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
        let item = imgItems[currentIndexP.item]
        let rotatevc = PDfPhotoRotateVC(imgItem: item)
        self.navigationController?.pushViewController(rotatevc, animated: true)
        rotatevc.saveBlock = {
            [weak self] imgItem in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
    }
    
    @objc func cropBtnClick() {
        let item = imgItems[currentIndexP.item]
        let editViewController = PDfPhotoCropVC(imgItem: item, rotateImage: false)
        editViewController.modalPresentationStyle = .fullScreen
        self.present(editViewController, animated: true)
        editViewController.cropRefreshBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
    }
    
    @objc func backBtnClick() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func shareBtnClick() {
        let sheetAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let printAction = UIAlertAction(title: "Print", style: .default) { (action) in
            self.printAction()
            sheetAlert.dismiss(animated: true)
        }
        let exportpdfAction = UIAlertAction(title: "Export to PDF", style: .default) { (action) in
            self.exportAction()
            sheetAlert.dismiss(animated: true)
        }
        let shareAction = UIAlertAction(title: "Share", style: .default) { (action) in
            self.shareAction()
            sheetAlert.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheetAlert.addAction(printAction)
        sheetAlert.addAction(exportpdfAction)
        sheetAlert.addAction(shareAction)
        sheetAlert.addAction(cancelAction)
        self.present(sheetAlert, animated: true, completion: nil)
        
        sheetAlert.title = "Export"
        
        
    }
    
    @objc func moveLeftBtnClick() {
        clickScrollEnd = false
        if currentIndexP.item > 0 {
            theContinueBtnClick(add: -1)
            
        }
        if currentIndexP.item == 0 {
            moveLeftBtn.isEnabled = false
        }
        if currentIndexP.item < imgItems.count - 1 {
            moveRightBtn.isEnabled = true
        }
        
    }
    
    @objc func moveRightBtnClick() {
        clickScrollEnd = false
        if currentIndexP.item < imgItems.count - 1 {
            theContinueBtnClick(add: 1)
        }
        if currentIndexP.item == imgItems.count - 1 {
            moveRightBtn.isEnabled = false
        }
        if currentIndexP.item > 0 {
            moveLeftBtn.isEnabled = true
        }
        
    }
    
    func theContinueBtnClick(add: Int) {
        collection.isPagingEnabled = false
        
        currentIndexP = IndexPath(item: currentIndexP.item + add, section: 0)
        collection.selectItem(at: currentIndexP, animated: true, scrollPosition: .centeredHorizontally)
        debugPrint("currentIndexP = \(currentIndexP.item)")
        collection.isPagingEnabled = true
        
        pageLabel.text = "\(currentIndexP.item + 1)/\(imgItems.count)"
    }

}

extension PDfPhotosEditVC {
    func printAction() {
        
        let imgs = imgItems.compactMap {
            $0.processedImg
        }
        
        let printInVC = UIPrintInteractionController.shared
        printInVC.showsPaperSelectionForLoadedPapers = true
        let info = UIPrintInfo(dictionary: nil)
        info.jobName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Sample Print"
//        info.orientation = .portrait // Portrait or Landscape
//        info.outputType = .general //ContentType
        printInVC.printInfo = info
        printInVC.printingItems = imgs //array of NSData, NSURL, UIImage.
        printInVC.present(animated: true) {
            controller, completed, error in
            debugPrint("completed = \(completed)")
            if completed {
                KRProgressHUD.showSuccess(withMessage: "Print complete!")
            }
        }
        printInVC.delegate = self
    }
    
    func exportAction() {
        
        if !PDfSubscribeStoreManager.default.inSubscription {
            PDfMakTool.default.showSubscribeStoreVC(contentVC: self)
            return
        }
        
        
        KRProgressHUD.show()
        let imgs = imgItems.compactMap {
            $0.processedImg
        }
        
        PDfMakTool.default.saveHistoryImgsToPDF(images: imgs) {[weak self] hisItem in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                KRProgressHUD.dismiss()
                let pdfURL = hisItem.pdfPathUrl()
                debugPrint("pdfurl = \(pdfURL)")
                KRProgressHUD.dismiss()
                let previewVc = PDfWePreviewVC(webUrl: pdfURL)
                self.navigationController?.pushViewController(previewVc, animated: true)
                //
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    KRProgressHUD.showSuccess(withMessage: "Export PDF successfully!")
                }

            }
            
        }
        
         
//        let item = PDfMakTool.default.saveHistoryImgsToPDF(images: imgs)
//        let pdfURL = item.pdfPathUrl()
//        debugPrint("pdfurl = \(pdfURL)")
//        KRProgressHUD.dismiss()
//        let previewVc = PDfWePreviewVC(webUrl: pdfURL)
//        self.navigationController?.pushViewController(previewVc, animated: true)
//        //
//        KRProgressHUD.showSuccess(withMessage: "Export PDF successfully!")
        
    }
    
    
    
    func shareAction() {
        
        if !PDfSubscribeStoreManager.default.inSubscription {
            PDfMakTool.default.showSubscribeStoreVC(contentVC: self)
            return
        }
        
        
        let imgs = imgItems.compactMap {
            $0.processedImg
        }
        let vc = UIActivityViewController(activityItems: imgs, applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view
        self.present(vc, animated: true)
    }
    
}

extension PDfPhotosEditVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PDfPhotosEditCell.self, for: indexPath)
        let item = imgItems[indexPath.item]
        cell.contentImgV.image = item.processedImg
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
     
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        debugPrint("ScrollingAnimation")
        clickScrollEnd = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        debugPrint("scrollViewDidScroll")
        if clickScrollEnd {
            if scrollView == collection {
                if let indexP = collection.indexPathForItem(at: CGPoint(x: view.bounds.width/2 + collection.contentOffset.x, y: 50)) {
                    if indexP.item != currentIndexP.item {

                        currentIndexP = indexP
                        pageLabel.text = "\(currentIndexP.item + 1)/\(imgItems.count)"
                        if currentIndexP.item == 0 {
                            moveLeftBtn.isEnabled = false
                        } else if currentIndexP.item < imgItems.count - 1 {
                            moveLeftBtn.isEnabled = true
                        }
                        if currentIndexP.item == imgItems.count - 1 {
                            moveRightBtn.isEnabled = false
                        } else if currentIndexP.item > 0 {
                            moveRightBtn.isEnabled = true
                        }
                        
                    }

                }
            }
        }
        
    }
}

extension PDfPhotosEditVC: UIPrintInteractionControllerDelegate {
    func printInteractionControllerWillStartJob(_ printInteractionController: UIPrintInteractionController) {
        
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
        titLabel.font = FontCusNames.MontMedium.font(sizePoint: 12)
        titLabel.textColor = .white
        titLabel.textAlignment = .center
        titLabel.text = titName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
