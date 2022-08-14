//
//  ViewController.swift
//  WEB Browser
//
//  Created by Александр Пархамович on 13.08.22.
//
import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com","bobr.by", "onliner.by"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
      let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        // MARK: Spase between progress and refresh
        
        let spacerplace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // MARK: refresh button(to reload web-site)
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // MARK: goBack button
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        
        // MARK: goForward button
        
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        // MARK: Progress web-site loading
        
       progressView = UIProgressView(progressViewStyle: .default)
         progressView.sizeToFit()
         let progressButton = UIBarButtonItem(customView: progressView)
       
        // MARK: Adding toolBar items
    
        toolbarItems = [backButton,forwardButton,progressButton,spacerplace,refresh]
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        navigationController?.isToolbarHidden = false
    }
    
    // MARK: Open web-site AllertController
    
       @objc func openTapped(){
        let AC = UIAlertController(title: "Open Page...", message: nil, preferredStyle: .actionSheet)
        for website in websites{
            AC.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
           AC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
           AC.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(AC,animated: true)
              }
    
    func openPage(action:UIAlertAction){
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
        
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
   override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?)
    {

        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

   func webView(_ webView: WKWebView,
                decidePolicyFor navigationAction: WKNavigationAction,
                decisionHandler:
                @escaping (WKNavigationActionPolicy) -> Void)
    {

    let url = navigationAction.request.url
    if let host = url?.host{
        for website in websites {
            if host.contains(website){
                decisionHandler(.allow)
                return
            }
        }

    }
    decisionHandler(.cancel)

  
}
    

}



