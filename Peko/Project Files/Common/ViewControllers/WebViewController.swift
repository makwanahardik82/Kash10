//
//  WebViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 15/03/24.
//

import UIKit
import WebKit

class WebViewController: MainViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var pdfURL:URL?
    
    static func storyboardInstance() -> WebViewController? {
        return AppStoryboards.Common.instantiateViewController(identifier: "WebViewController") as? WebViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: pdfURL?.lastPathComponent ?? "")
        self.view.backgroundColor = .white
    
        let data = try! Data(contentsOf: pdfURL!)
        self.webView.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: pdfURL!.deletingLastPathComponent())
        
        
    }
    


}
