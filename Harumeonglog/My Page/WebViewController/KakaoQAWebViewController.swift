//
//  KakaoQAWebViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 9/18/25.
//

import UIKit
import WebKit

class KakaoQAWebViewController: UIViewController {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        
        if let termsURL = URL(string: "https://open.kakao.com/o/syxosHSh") {
           let request = URLRequest(url: termsURL)
           webView.load(request)
       }
    }

}

