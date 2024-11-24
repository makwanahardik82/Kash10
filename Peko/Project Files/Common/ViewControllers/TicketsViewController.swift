//
//  TicketsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 22/02/24.
//

import UIKit
import SkeletonView

class TicketsViewController: MainViewController {

    @IBOutlet weak var ticketTableView: UITableView!
    
    var fromDate = Date().last30Day()
    var toDate = Date()
    
    var isSkeletonView:Bool = true
    
    var offset = 0
    var limit = 10
 //   var categoryName = ""
    var isPageRefreshing:Bool = false
    
    var ticketArray = [SupportTicketModel]()
    
    static func storyboardInstance() -> TicketsViewController? {
        return AppStoryboards.Help.instantiateViewController(identifier: "TicketsViewController") as? TicketsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Tickets")
        self.view.backgroundColor = .white
      
        self.ticketTableView.delegate = self
          self.ticketTableView.dataSource = self
        self.ticketTableView.backgroundColor = .clear
        self.ticketTableView.separatorStyle  = .none
        self.ticketTableView.isUserInteractionEnabled = false
       // self.ticketTableView.register(UINib(nibName: "TicketsListTableViewCell", bundle: nil), forCellReuseIdentifier: "TicketsListTableViewCell")
        // Do any additional setup after loading the view.
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getAllTicket()
    }
   // MARK: - Get All Ticket
    func getAllTicket(){
       // HPProgressHUD.show()
        SupportViewModel().getTickets(fromDate: self.fromDate!, toDate: self.toDate, moduleName: "", searchText: "") { response, error in
   //         HPProgressHUD.hide()
            if error != nil {
                
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.ticketTableView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
                    self.ticketArray.append(contentsOf: response?.data?.data ?? [SupportTicketModel]())
                   // self.searchArray = self.transactionArray // .reversed()
                  //  self.transactionTableView.reloadData()
                    self.isSkeletonView = false
                    if self.ticketArray.count < response?.data?.recordsTotal ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                    self.ticketTableView.reloadData()
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
extension TicketsViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSkeletonView{
            return 10
        }
        return self.ticketArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketsListTableViewCell") as! TicketsListTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.viewButton.removeTarget(self, action: nil, for: .allEvents)
        
        if self.isSkeletonView {
            cell.view_1.showAnimatedGradientSkeleton()
        }else{
            cell.view_1.hideSkeleton()
            
            let model = self.ticketArray[indexPath.row]
            
            let dateString = model.createdAt?.replacingOccurrences(of: ".000Z", with: "")
            
            // 2024-03-09T06:39:41.000Z
            cell.dateLabel.text = (dateString?.replacingOccurrences(of: "T", with: " "))! + "  #\(model.id ?? 0)"
            cell.titleLabel.text = model.description
            cell.issueLabel.text = (model.issueType ?? "") + " | " + (model.module ?? "")
            cell.statusView.isHidden = false
            
            //cell.statusLabel.text = model.status ?? ""
         
            cell.statusImgView.image = UIImage(named: "icon_support_ticket_\(model.status ?? "")".lowercased())
            
            if model.screenshotImage == nil {
                cell.attachmentImgView.isHidden = true
                cell.stackViewWidthConstraint.constant = 0
            }else{
                cell.attachmentImgView.isHidden = false
                cell.stackViewWidthConstraint.constant = 16
            }
            cell.viewButton.tag = indexPath.row
            cell.viewButton.addTarget(self, action: #selector(viewTicketButtonClick(sender: )), for: .touchUpInside)
            
        }
        
        return cell
    }
    @objc func viewTicketButtonClick(sender:UIButton){
        let model = self.ticketArray[sender.tag]
      
        if let vc = TicketsDetailsViewController.storyboardInstance() {
            vc.ticketModel = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
class TicketsListTableViewCell:UITableViewCell {
    
    @IBOutlet weak var view_1: UIView!
    @IBOutlet weak var dateLabel: PekoLabel!
    @IBOutlet weak var titleLabel: PekoLabel!
    
    @IBOutlet weak var attachmentImgView: UIImageView!
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var issueLabel: PekoLabel!
    
    @IBOutlet weak var stackViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var statusView: UIView!
}
