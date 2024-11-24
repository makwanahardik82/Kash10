//
//  TicketsDetailsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 22/02/24.
//

import UIKit

class TicketsDetailsViewController: MainViewController {

    @IBOutlet weak var descLabel: PekoLabel!
    @IBOutlet weak var datelabel: PekoLabel!
    
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var issueTypeLabel: PekoLabel!
    @IBOutlet weak var moduleLabel: PekoLabel!
   // @IBOutlet weak var screenhotsLabel: PekoLabel!
    
    @IBOutlet weak var chatTableView: UITableView!
  
    @IBOutlet weak var msgView: UITextField!
    
    var ticketModel:SupportTicketModel?
    var chatArray = [SupportTicketChatModel]()
    
    static func storyboardInstance() -> TicketsDetailsViewController? {
        return AppStoryboards.Help.instantiateViewController(identifier: "TicketsDetailsViewController") as? TicketsDetailsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
      
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.backgroundColor = .clear
        chatTableView.separatorStyle = .none
        
        self.msgView.delegate = self
        self.getTicketDteail()
      
        self.setData()
    }
    func setData(){
        self.descLabel.text = self.ticketModel?.description ?? ""
     
        let dateString = ticketModel?.createdAt?.replacingOccurrences(of: ".000Z", with: "")
       
        let tmp = (dateString?.replacingOccurrences(of: "T", with: " "))! + "  #\(self.ticketModel?.id ?? 0)"
        self.setTitle(title: tmp)
        self.datelabel.text = tmp
//
        self.issueTypeLabel.text = (self.ticketModel?.issueType ?? "")
        self.moduleLabel.text = (self.ticketModel?.module ?? "")
        // cell.statusView.isHidden = false
        
        self.statusImgView.image = UIImage(named: "icon_support_ticket_\(self.ticketModel?.status ?? "")".lowercased())
       
    }
    func getTicketDteail(){
        HPProgressHUD.show()
        SupportViewModel().getTicketsDetails(t_id: ticketModel?.id ?? 0) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print()
                    
                    self.chatArray = response?.data?.chats ?? [SupportTicketChatModel]()
                    self.chatTableView.reloadData()
//
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
    // MARK: -
    
    @IBAction func editButtonClick(_ sender: Any) {
        if let raiseVC = RaiseTicketViewController.storyboardInstance() {
            raiseVC.isEdit = true
            raiseVC.ticketModel = self.ticketModel
            raiseVC.completionBlock = { model in
                DispatchQueue.main.async {
                    self.ticketModel = model
                    self.setData()
                }
            }
            self.navigationController?.pushViewController(raiseVC, animated: true)
        }
    }
    
    
    // MARK: -
    @IBAction func viewScreenshotButtonClick(_ sender: Any) {
        self.openURL(urlString: self.ticketModel?.screenshotImage ?? "", inSideApp: true)
    }
    
    // MARK: -
    @IBAction func photoButtonClick(_ sender: Any) {
 
    }
    
    func sendMSG() {
        HPProgressHUD.show()
        SupportViewModel().sendMSG(supportID: self.ticketModel?.id ?? 0, msg: self.msgView.text!){ response, error in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print(response)
                    self.chatArray = response?.data?.chats ?? [SupportTicketChatModel]()
                    self.chatTableView.reloadData()
                    self.msgView.text = ""
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
// MARK: -
extension TicketsDetailsViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TicketChatTableViewCell!
        
        let chatModel = self.chatArray[indexPath.row]
        
        if chatModel.admin ?? false
        {
            cell = (tableView.dequeueReusableCell(withIdentifier: "TicketReceiverChatTableViewCell") as! TicketChatTableViewCell)
        }else{
            cell = (tableView.dequeueReusableCell(withIdentifier: "TicketSenderChatTableViewCell") as! TicketChatTableViewCell)
        }
        
        cell.messageLabel.text = chatModel.message ?? ""
   //     cell = (tableView.dequeueReusableCell(withIdentifier: "TicketSenderChatTableViewCell") as! TicketChatTableViewCell)
   
        cell!.backgroundColor = .clear
        cell!.selectionStyle = .none
        
        return cell!
    }
}
extension TicketsDetailsViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.count != 0 {
            self.sendMSG()
        }
       
        textField.resignFirstResponder()
        return true
    }
}
// MARK: -
class TicketChatTableViewCell:UITableViewCell {
    @IBOutlet weak var receiverContainerView: UIView!
    @IBOutlet weak var senderContainerView: UIView!
    
    @IBOutlet weak var messageLabel: PekoLabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        if self.receiverContainerView != nil {
            self.receiverContainerView.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 10.0)
            
        }
        if self.senderContainerView != nil {
            self.senderContainerView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 10.0)
        }
    }
    
}

