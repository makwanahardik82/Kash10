//
//  eSimOrderHistoryViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 17/04/24.
//

import UIKit

class eSimOrderHistoryViewController: MainViewController {

    @IBOutlet weak var historyTableView: UITableView!
    var historyArray = [eSimHistoryModel]()
    
    var offset = 1
    var isPageRefreshing:Bool = false

    static func storyboardInstance() -> eSimOrderHistoryViewController? {
        return AppStoryboards.eSim.instantiateViewController(identifier: "eSimOrderHistoryViewController") as? eSimOrderHistoryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Order History")
        self.view.backgroundColor = .white
     
        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self
        self.historyTableView.backgroundColor = .clear
        self.historyTableView.register(UINib(nibName: "eSimHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "eSimHistoryTableViewCell")
        
        self.getHistroy()
        // Do any additional setup after loading the view.
    }
    // MARK: -
    func getHistroy(){
        HPProgressHUD.show()
        eSimViewModel().getHistory(offset: self.offset) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    let arr = response?.data?.data ?? [eSimHistoryModel]()
                    self.historyArray.append(contentsOf: arr)
                    if self.historyArray.count < response?.data?.recordsTotal ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                    self.historyTableView.reloadData()
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
}
// MARK: - UITableView
extension eSimOrderHistoryViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eSimHistoryTableViewCell") as! eSimHistoryTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let model = self.historyArray[indexPath.row]
        
        cell.imgView.sd_setImage(with: URL(string: model.packageDetails?.operatorImage ?? ""))
        
        let plan = "Plan : \(model.packageDetails?.package ?? "")"
        let type = "eSIM type : \(model.packageDetails?.esim_type ?? "")"
        let transactionID = "Transaction ID : \(model.transaction?.corporateTxnId ?? "")"
        let amount = "Amount : " + objUserSession.currency + (model.amount?.value.withCommas(decimalPoint: 1) ?? "0")
        
        let str = "\n" + plan + "\n" + type  + "\n" + transactionID  + "\n" + amount
        
        cell.titleLabel.attributedText = NSMutableAttributedString().color(.black, model.packageDetails?.operatorName ?? "", font: .bold(size:16), 5).color(.darkGray, str, font: .regular(size: 10), 5)
        
        cell.viewButton.tag = indexPath.row
        cell.viewButton.addTarget(self, action: #selector(viewButtonClick(sender: )), for: .touchUpInside)
        return cell
    }
    
    @objc func viewButtonClick(sender:UIButton)
    {
        let model = self.historyArray[sender.tag]
        
        if let vc = eSimOrderHistoryDetailsViewController.storyboardInstance() {
            vc.historyModel = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// MARK: -
extension eSimOrderHistoryViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.historyTableView.contentOffset.y >= (self.historyTableView.contentSize.height - self.historyTableView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                self.offset += 1
                self.getHistroy()
            }
        }
    }
}
