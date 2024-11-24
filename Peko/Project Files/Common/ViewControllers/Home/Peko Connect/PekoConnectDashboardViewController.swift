//
//  PekoConnectDashboardViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 22/05/23.
//

import UIKit
// 
import SkeletonView

class PekoConnectDashboardViewController: MainViewController {

    @IBOutlet weak var connectTableView: UITableView!
    
    var connectArray = [PekoConnectModel]()
    var isSkeletonView = true
    
    static func storyboardInstance() -> PekoConnectDashboardViewController? {
        return AppStoryboards.PekoConnect.instantiateViewController(identifier: "PekoConnectDashboardViewController") as? PekoConnectDashboardViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Peko Connect")
        self.view.backgroundColor = .white
        
        self.connectTableView.delegate = self
        self.connectTableView.dataSource = self
        self.connectTableView.backgroundColor = .clear
        self.connectTableView.register(UINib(nibName: "PekoConnectTableViewCell", bundle: nil), forCellReuseIdentifier: "PekoConnectTableViewCell")
        self.connectTableView.separatorStyle = .none
        self.connectTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 15))
        self.connectTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 15))
        // Do any additional setup after loading the view.
        
        self.connectTableView.isUserInteractionEnabled = false
        self.getAllConnet()
    }
    // MARK: -
    func getAllConnet(){
        
        PekoConnectViewModel().getAllConnect { response, error in
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.isSkeletonView = false
                    self.connectTableView.isUserInteractionEnabled = true
                    self.connectArray = response?.data?.data ?? [PekoConnectModel]()
                    self.connectTableView.reloadData()
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
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
}
extension PekoConnectDashboardViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return self.connectArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PekoConnectTableViewCell") as! PekoConnectTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if self.isSkeletonView {
            cell.view_1.showAnimatedGradientSkeleton()
           
        }else{
            cell.view_1.hideSkeleton()
            let connectModel = self.connectArray[indexPath.row]
            
            cell.nameLabel.text = connectModel.serviceProvider ?? ""
            cell.detailLabel.text = (connectModel.tagline ?? "") // + " " + (connectModel.rewards ?? "")
           
            // cell.discountLabel.text = connectModel.rewards ?? ""
            
            cell.logoImgView.sd_setImage(with: URL(string: (connectModel.logo ?? "")), placeholderImage: nil)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSkeletonView {
            
        }else{
            if let connectVC = PekoConnectContactViewController.storyboardInstance(){
                connectVC.connectModel = self.connectArray[indexPath.row]
                self.navigationController?.pushViewController(connectVC, animated: true)
            }
        }
        
    }
}
