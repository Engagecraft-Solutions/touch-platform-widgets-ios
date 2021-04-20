//
//  Widget.swift
//  Touch
//
//  Copyright (c) 2021 EngageCraft. All rights reserved.
//

import Foundation
import UIKit
import WebKit

public class Widget: UIViewController{
    private(set) var widgetId: String = ""
    private var preview = false
    private var language: String? = nil
    private var location: String = ""
    
    // executed after widget loads and the heigth of widget is defined
    public var onLoaded: ((CGFloat)->Void)?
    
    // MARK: Init
    
    private let availability: AvailabilityCall
    
    public init(_ id:String, location: String, language:String? = nil, preview: Bool = true){
        self.widgetId = id
        self.language = language
        self.preview = preview
        self.location = location
        availability = AvailabilityCall(widgetId: id)
        super.init(nibName: nil, bundle: nil)
        self.registerForLogin()
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
    
    private let jsShowLogin = "showLogin"
    private let jsShare = "share"

    override public func loadView() {
        view = UIView()
        view.backgroundColor = .clear
        
        let webConfiguration = WKWebViewConfiguration()
        
        let contentController = WKUserContentController()
        contentController.add(self,name:jsShowLogin)
        contentController.add(self, name: jsShare)
        webConfiguration.userContentController = contentController
        
        webView = WKWebView(frame: view.bounds, configuration: webConfiguration)
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
    
    private var apiHeight:CGFloat = 0.0
    
    public var height: CGFloat{
        if autoResize && !isLoaded { return 0.0 }
        guard !widgetId.isEmpty else { return 0.0 }
        return apiHeight > 0 ? apiHeight : defaultHeight
    }
    
    private var defaultHeight: CGFloat{
  //      return 0.0
        let c  = widgetId.prefix(1)
        switch c {
            case "1": return 700.0 // PICK_11
            case "3": return 375.0 // MOTM
            case "4": return 535.0 // PRE_MATCH_PREDICTOR
            case "5": return 515.0 // HALF_TIME_TEAM_TACTICS
            case "6": return 535.0 // SPIN_TO_WIN
            case "7": return 535.0 // PRE_MATCH_OUTCOME_POLL
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
                self.view.setNeedsLayout()
                //self.view.superview?.layoutIfNeeded()
            }
        }
    }
    
    // forced refresh
    public func refresh(){
        availability.fetch { [weak self](response) in
            let isAvailable = response?.available ?? self?.preview ?? false
            if let h = response?.params.height {
                self?.apiHeight = CGFloat(h)
            }
            if (isAvailable ){
                self?.reload()
            }
        }
    }
    
    private func reload(){
        guard  let url =  Touch.shared.widgetURL(for: widgetId, location: location, language: language, preview: preview) else{
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
    
    // MARK: SSO Helpers
    
    private func registerForLogin(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onLogin(_:)),
                                               name: NSNotification.Name(rawValue: TouchLoginEvent),
                                               object: nil)
    }
    
    @objc private func onLogin(_ notification: Notification){
        guard isLoaded else { return }
        let userId = notification.userInfo?["userID"] as? String
        let event = userId != nil ? "onLogin" : "onLogout"
        let userInfo = userId != nil ? ",{userID:'\(userId!)'}" : ""
        webView.evaluateJavaScript("(function() { window.ecTouchPlatform.events.emit('\(event)'\(userInfo)); })();")
    }
}

// MARK: WKNavigationDelegate

extension Widget: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.isHidden = false
        // disable long press menu
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';")
        isLoaded = true
        onLoaded?(height)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        isLoaded = false
    }
    
    public func share(text:String?){
        guard let text = text else { return }
        var items = [Any]()
        if let url = URL(string: text){
            items.append(url)
        }else{
            items.append(text)
        }
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension Widget: WKScriptMessageHandler{
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("scriptMessage \(message.name)")
        switch message.name {
            case jsShowLogin: Touch.shared.requestLogin()
            case jsShare: share(text:(message.body as? Dictionary<String,String>)?["url"])
            default: break
        }
    }
}
