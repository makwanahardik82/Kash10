//
//  NotificationViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 07/01/23.
//

import UIKit

class NotificationViewController: MainViewController {

    
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    var isSkeletonView:Bool = true
    
    var notificationArray = [NotificationModel]()
    
    static func storyboardInstance() -> NotificationViewController? {
        return AppStoryboards.Notification.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        
        self.setTitle(title: "Notifications")
        
        self.view.backgroundColor = .white
//        self.isBackNavigationBarView = true
//        self.setTitle(title: "Notifications")
//        
        self.noDataView.isHidden = true
        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        self.notificationTableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        self.notificationTableView.backgroundColor = .clear
        self.notificationTableView.separatorStyle = .none
        self.notificationTableView.isUserInteractionEnabled = false
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 20))
        self.notificationTableView.tableFooterView = footerView
        
        self.tabBarItem.badgeValue = nil
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.getNotifications()
    }
    // MARK: - Notifications
    func getNotifications(){
        
        NotificationViewModel().getAllNotifications() { response, error in
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    
                    self.notificationArray = response?.data?.data ?? [NotificationModel]()
                    
                    self.notificationTableView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
                    self.notificationTableView.reloadData()
                    
                    if self.notificationArray.count == 0 {
                        self.noDataView.isHidden = false
                    }else{
                        self.noDataView.isHidden = true
                    }
                    
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
extension NotificationViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return self.notificationArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        cell.selectionStyle = .none
        
        if self.isSkeletonView {
            cell.view_1.showAnimatedGradientSkeleton()
        }else{
            cell.hideSkeleton()
            
            let notificationModel = self.notificationArray[indexPath.row]
            
            cell.titleLabel.attributedText = NSMutableAttributedString().color(.black, (notificationModel.notificationBrief ?? ""), font: .medium(size: 12), 4)
            cell.dateLabel.text = notificationModel.createdAt?.dateFromISO8601()?.formate(format: "EEEE, dd MMM, yy at hh:mm a")
            
            if notificationModel.flag ?? false {
                
            }else{
                
            }
        }
        return cell
    }
}
