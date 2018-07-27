//
//  AboutUsWebViewController.swift
//  pinwork
//
//  Created by Pouyan on 7/19/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
import WebKit
class AboutUsWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var webView: WKWebView!
    var animationView : UIView!
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero , configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self

        view = webView
    }
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        self.removeSpinner(spinner: animationView)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        animationView = self.displaySpinner(onView: self.view)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let myURL = URL(string: "https://pinwork.co/aboutUs.php")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
    }}

    



