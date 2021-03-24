//
//  Widget.swift
//  Touch
//
//  Created by Aurimas Petrevicius on 2021-03-23.
//

import Foundation
import UIKit
import WebKit

public class Widget: UIViewController{
    private(set) var widgetId: String = ""

    // MARK: Init
    
    public init(with id:String){
        self.widgetId = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, use Widget(with id:) in code.")
    }
    
    // MARK: loadView
    
    private var webView: WKWebView!
    
    override public func loadView() {
        view = UIView()
        view.backgroundColor = .clear
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        //webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.frame = view.bounds
        webView.backgroundColor = .clear
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     webView.topAnchor.constraint(equalTo: view.topAnchor),
                                     webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     webView.heightAnchor.constraint(equalToConstant: height)])
        webView.isHidden = true
        webView.scrollView.isScrollEnabled = false
    }
    
    public var height: CGFloat{
        guard !widgetId.isEmpty else { return 0.0 }
        return 700.0
    }
    
    public func refresh(){
        guard  let url = URL(string: "https://widgets.touch.global/js/vendor/static/app.html?hash=\(widgetId)") else{
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: hierarchy helpers
    
    @discardableResult
    public func add(to viewController: UIViewController? = nil, on containerView: UIView? = nil)->Bool{
        guard  let toView =  containerView ?? viewController?.view else {
            return false
        }
        
        viewController?.addChild(self)
        toView.addSubview(self.view)
        didMove(toParent: self)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.view.leadingAnchor.constraint(equalTo: toView.leadingAnchor),
            self.view.topAnchor.constraint(equalTo: toView.topAnchor),
            self.view.trailingAnchor.constraint(equalTo: toView.trailingAnchor),
            self.view.bottomAnchor.constraint(equalTo: toView.bottomAnchor)
        ])
    
        return true
    }
}

extension Widget: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.isHidden = false
        //activityIndicator.stopAnimating()
        // disable long press menu
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';")
    }
}
