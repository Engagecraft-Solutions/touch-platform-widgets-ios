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
    
    private var heightConstraint = NSLayoutConstraint()
    private var contraints = [NSLayoutConstraint]()
    private var allConstraints:[NSLayoutConstraint] {
        var allC = contraints.map{$0}
        allC.append(heightConstraint)
        return allC
    }
    
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
        heightConstraint = webView.heightAnchor.constraint(equalToConstant: height)
        contraints = [webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                      webView.topAnchor.constraint(equalTo: view.topAnchor),
                      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(allConstraints)
        webView.isHidden = true
        webView.scrollView.isScrollEnabled = false
    }
    
    public var height: CGFloat{
        if autoResize && !isLoaded { return 0.0 }
        guard !widgetId.isEmpty else { return 0.0 }
        let c  = widgetId.prefix(1)
        switch c {
            case "1": return 700.0 // PICK_11
            case "3": return 375.0 // MOTM
            case "4": return 768.0 // PRE_MATCH_PREDICTOR
            case "5": return 768.0 // HALF_TIME_TEAM_TACTICS
            default: return 0.0
        }
    }
    
    // MARK: Refresh
    
    // tells if widget is already loaded
    public private(set) var isLoaded = false {
        didSet{
            if autoResize{
                NSLayoutConstraint.deactivate([heightConstraint])
                heightConstraint = webView.heightAnchor.constraint(equalToConstant: height)
                NSLayoutConstraint.activate([self.heightConstraint])
                self.view.superview?.layoutIfNeeded()
            }
        }
    }
    
    // forced refresh
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
    
    // MARK: ViewController life cycle
    
    public var autoloadOnViewWillAppear = true
    public var autoloadOnViewDidAppear = false
    public var autoResize = true
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isLoaded && autoloadOnViewWillAppear{
            refresh()
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isLoaded && autoloadOnViewDidAppear{
            refresh()
        }
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
        isLoaded = true
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        isLoaded = false
    }
    
}
