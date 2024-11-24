//
//  InvoiceHistoryViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 18/03/24.
//

import UIKit
import SkeletonView


class InvoiceHistoryViewController: MainViewController {

    @IBOutlet weak var historyTableView: UITableView!
    
    var isPageRefreshing = true
    var fromDate = Date().last30Day()
    var toDate = Date()
    
    var isSkeletonView:Bool = true
    
    var offset = 1
    var limit = 10
    
    var invoiceHistoryArray = [InvoiceGeneratorHistoryModel]()
    
    static func storyboardInstance() -> InvoiceHistoryViewController? {
        return AppStoryboards.InvoiceGenerator.instantiateViewController(identifier: "InvoiceHistoryViewController") as? InvoiceHistoryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Invoice History")
     
        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self
        self.historyTableView.backgroundColor = .clear
        self.historyTableView.separatorStyle = .none
        self.historyTableView.isUserInteractionEnabled = false
    
        self.getInvoiceHistory()
        // Do any additional setup after loading the view.
    }
  // MARK: - Invoice Data
    func getInvoiceHistory() {
        InvoiceGeneratorViewModel().getAllInvoice(fromDate: self.fromDate!, toDate: self.toDate, offset: self.offset, limit:self.limit) { response, error in
            
            if error != nil {
                
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
                    self.historyTableView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
                    self.invoiceHistoryArray.append(contentsOf: response??.data?.invoiceData ?? [InvoiceGeneratorHistoryModel]())
                   // self.searchArray = self.transactionArray // .reversed()
                  //  self.transactionTableView.reloadData()
                    
                    if self.invoiceHistoryArray.count < response??.data?.recordsTotal ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                    self.historyTableView.reloadData()
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
    
    // MARK: - Download PDF
    
    func downloadPdfFromServer(order_id:Int){
       
        HPProgressHUD.show()
        InvoiceGeneratorViewModel().getDownloadInvoice(o_id: order_id) { response, error in
           // HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.createPDF(with: response?.data?.pdfBuffer?.data ?? [UInt8](), order_id: order_id)
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
    
    /// This will creates a PDF file
    func createPDF(with byte: [UInt8], order_id:Int) {
        let data = Data(byte)
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = "\(documentsPath)/Invoice_Payments_\(order_id).pdf"
        
        let url = URL(fileURLWithPath: filePath)
        do{
            try data.write(to: url, options: .atomic)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.viewPDF(order_id: order_id)
            }
            
        }catch let failedError {
            HPProgressHUD.hide()
            print("Failed to write the pdf data due to \(failedError.localizedDescription)")
            self.showAlert(title: "", message: "Failed to write the pdf data due to \(failedError.localizedDescription)")
        }
    }

    /// Verify your created PDF file
    func viewPDF(order_id:Int) {
        HPProgressHUD.hide()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = "\(documentsPath)/Invoice_Payments_\(order_id).pdf"
        if FileManager.default.fileExists(atPath: filePath) {
            let url = URL(fileURLWithPath: filePath)
            
            if let webVC = WebViewController.storyboardInstance() {
                webVC.pdfURL = url
                self.navigationController?.pushViewController(webVC, animated: true)
            }
        }else{
            self.downloadPdfFromServer(order_id: order_id)
        }
    }
    
}
extension InvoiceHistoryViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return self.invoiceHistoryArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceHistoryTableViewCell") as! InvoiceHistoryTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        if self.isSkeletonView {
            cell.containerView.showAnimatedGradientSkeleton()
        }else{
            cell.containerView.hideSkeleton()
            
            let history = self.invoiceHistoryArray[indexPath.row]
            
            let invoiceDetails = history.invoiceDetails?.convertToDictionary()
            if let invoiceNo = invoiceDetails!["invoiceNo"] as? String {
                cell.invoiceNumberLabel.text = "Invoice ID : " + invoiceNo
            }
            if let invoiceDate = invoiceDetails!["invoiceDate"] as? String {
                cell.invoiceDateLabel.text = "Invoice Date : " + invoiceDate
            }
            
            let recipientDetails = history.recipientDetails?.convertToDictionary()
            if let billerName = recipientDetails!["billerName"] as? String {
                cell.billerNameLabel.text = "Bill To : " + billerName
            }
            
            let paymentDetails = history.paymentDetails?.convertToDictionary()
            if let amountDue = paymentDetails!["amountDue"] as? String {
                cell.amountLabel.text = "Amount : " + objUserSession.currency + amountDue.toDouble().withCommas()
            }
            
            cell.viewButton.addAction {
                self.viewPDF(order_id: history.id ?? 0)
            }
        }
        
        return cell
    }
}

class InvoiceHistoryTableViewCell:UITableViewCell {
    
    @IBOutlet weak var invoiceDateLabel: PekoLabel!
    @IBOutlet weak var billerNameLabel: PekoLabel!
    @IBOutlet weak var amountLabel: PekoLabel!
    @IBOutlet weak var invoiceNumberLabel: PekoLabel!
    
    @IBOutlet weak var viewButton: PekoButton!
    
    @IBOutlet weak var containerView: UIView!
    
}
extension InvoiceHistoryViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.self.historyTableView.contentOffset.y >= (self.historyTableView.contentSize.height - self.historyTableView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                self.offset += 1
                self.getInvoiceHistory()
            }
        }
    }
    
}
