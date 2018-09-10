//
//  TermConditionView.swift
//  Kyc
//
//  Created by Lai Trung Tien on 8/1/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import WebKit

class TermConditionView: UIView, WKNavigationDelegate{
    var delegate: TermConditionViewDelegate?
    var webView: WKWebView!
    
    @IBOutlet weak var webContainer: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TermConditionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        layer.cornerRadius = 10
        clipsToBounds = true
        
        webView = WKWebView(frame: webContainer.bounds)
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.contentMode = .scaleToFill
        webContainer.addSubview(webView)
        activityIndicator.layer.zPosition = 100
        activityIndicator.layer.cornerRadius = 5
    }
    
    func loadContent(_ link: String) {
        let url = URL.init(string: link)
        webView.load(URLRequest.init(url: url!))
        activityIndicator.startAnimating()
    }
    
    @IBAction func close(_ sender: Any) {
        if let delegate = delegate {
            delegate.closeDialog()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}

protocol TermConditionViewDelegate {
    func closeDialog()
}
