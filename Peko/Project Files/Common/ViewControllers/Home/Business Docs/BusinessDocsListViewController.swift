//
//  BusinessDocsListViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 10/10/23.
//

import UIKit


class BusinessDocsListViewController: MainViewController {

    @IBOutlet weak var listTableView: UITableView!
   
    var categoryModel:BusinessDocsCategoryModel?
    var documentArray = [BusinessDocsDocumentModel]()
    
    static func storyboardInstance() -> BusinessDocsListViewController? {
        return AppStoryboards.BusinessDocs.instantiateViewController(identifier: "BusinessDocsListViewController") as? BusinessDocsListViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Business Docs")
     
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        self.listTableView.backgroundColor = .clear
        self.listTableView.separatorStyle = .none
        
        self.getDocument()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Document
    func getDocument(){
        HPProgressHUD.show()
        BusinessDocsViewModel().getDocument(categoryName:self.categoryModel?.categoryName ?? "" ) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
              //      print(response)
                    self.documentArray = response??.data?.documents ?? [BusinessDocsDocumentModel]()
                    self.listTableView.reloadData()
                }
            }else{
                var msg = ""
                if response??.message != nil {
                    msg = response??.message ?? ""
                }else if response??.error?.count != nil {
                    msg = response??.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }

}
extension BusinessDocsListViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.documentArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessDocsListCell") as! BusinessDocsListCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let model = self.documentArray[indexPath.row]
        
        cell.titleLabel.text = model.documentName
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.documentArray[indexPath.row]
        
        self.openURL(urlString: model.documentUrl ?? "", inSideApp: false)
    }
}

// MARK: -
class BusinessDocsListCell:UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var downloadButton: UIButton!
}
