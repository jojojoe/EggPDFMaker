//
//  PDfWePreviewVC.swift
//  PDfMaker
//
//  Created by JOJO on 2023/5/15.
//

import UIKit
import WebKit
import KRProgressHUD

class PDfWePreviewVC: UIViewController {
    var webUrl: URL
    let sharebtn = UIButton()
    init(webUrl: URL) {
        self.webUrl = webUrl
        super.init(nibName: nil, bundle: nil)
        KRProgressHUD.show()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupC()
    }
    

    func setupC() {
        view.backgroundColor = UIColor(hexString: "#EFEFEF")
        view.clipsToBounds = true
        //
        let backbtn = UIButton()
        view.addSubview(backbtn)
        backbtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.width.height.equalTo(44)
        }
        backbtn.setImage(UIImage(named: "ArrowLeft"), for: .normal)
        backbtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        //
        
        view.addSubview(sharebtn)
        sharebtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(44)
        }
        sharebtn.setImage(UIImage(named: "Shareb"), for: .normal)
        sharebtn.addTarget(self, action: #selector(shareBtnClick), for: .touchUpInside)
        
        //
        let titLB = UILabel()
        titLB.textColor = UIColor(hexString: "#1C1E37")
        titLB.font = FontCusNames.MontSemiBold.font(sizePoint: 20)
        view.addSubview(titLB)
        titLB.snp.makeConstraints {
            $0.centerY.equalTo(backbtn.snp.centerY).offset(0)
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        titLB.text = "Previews"
        
        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}"
        let script = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(script)
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        
        let webV = WKWebView(frame: .zero, configuration: wkWebConfig)
        view.addSubview(webV)
        webV.snp.makeConstraints {
            $0.top.equalTo(backbtn.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        webV.navigationDelegate = self
        //
        
        if webUrl.absoluteString.lowercased().contains("txt") || webUrl.absoluteString.lowercased().contains("md") {
            do {
                let data = try Data(contentsOf: webUrl)
                webV.load(data, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: webUrl)
            } catch {
                
            }
        } else {
            let request = URLRequest(url: webUrl)
            webV.load(request)
        }
        
        
        //
        
        
        
    }

}



extension PDfWePreviewVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("webView: WKWebView, didFinish")
        KRProgressHUD.dismiss()
    }
}
extension PDfWePreviewVC {
    @objc func backBtnClick() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func shareBtnClick() {
        let vc = UIActivityViewController(activityItems: [webUrl], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.sharebtn
        self.present(vc, animated: true)
    }
    
}
