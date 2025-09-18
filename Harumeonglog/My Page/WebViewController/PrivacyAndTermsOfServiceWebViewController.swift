//
//  PrivacyAndTermsOfServiceWebViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 9/18/25.
//

import UIKit
import WebKit

class PrivacyAndTermsOfServiceWebViewController: UIViewController {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        
        if let termsURL = URL(string: "https://dazzling-myth-cd2.notion.site/26a7c67ff1e680df83effad6638aee75?source=copy_link") {
           let request = URLRequest(url: termsURL)
           webView.load(request)
       }
    }

}
