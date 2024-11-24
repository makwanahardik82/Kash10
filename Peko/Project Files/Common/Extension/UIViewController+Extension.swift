//
//  UIViewController+Extension.swift
//  SMAT
//
//  Created by Hardik Makwana on 06/10/22.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func showAlert(title:String, message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    func showAlertWithCompletion(title:String, message:String, completion: @escaping ((UIAlertAction)->Void)){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: completion))
        self.present(alert, animated: true)
    }
    
    func openURL(urlString:String, inSideApp:Bool = true){
        
        if inSideApp {
            if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = false
                let vc = SFSafariViewController(url: url, configuration: config)
                present(vc, animated: true)
            }
        }else{
            if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
    }
    
    // MARK: - Back Button
    @IBAction func backButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
