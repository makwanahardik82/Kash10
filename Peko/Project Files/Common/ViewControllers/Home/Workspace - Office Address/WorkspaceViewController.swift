//
//  WorkspaceViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 09/07/23.
//

import UIKit
import SkeletonView

class WorkspaceViewController: MainViewController {

    @IBOutlet weak var workspaceTableView: UITableView!
    
    var planArray = [WorkspacePlanModel]()
    
    var isSkeletonView = true
    
    static func storyboardInstance() -> WorkspaceViewController? {
        return AppStoryboards.Workspace.instantiateViewController(identifier: "WorkspaceViewController") as? WorkspaceViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isBackNavigationBarView = true
        self.setTitle(title: "Office Address")
        self.view.backgroundColor = .white
        
        self.workspaceTableView.delegate = self
        self.workspaceTableView.dataSource = self
        self.workspaceTableView.backgroundColor = .clear
        self.workspaceTableView.separatorStyle = .none
        self.workspaceTableView.register(UINib(nibName: "WorkspaceTableViewCell", bundle: nil), forCellReuseIdentifier: "WorkspaceTableViewCell")
         
        objOfficeAddressManager = OfficeAddressManager.sharedInstance
        
        self.getAllPlans()
       
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Get All Plan
    func getAllPlans(){
        WorkspaceViewModel().getAllPlans { response, error in
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
                    print(response)
                    self.planArray = response??.data?.data ?? [WorkspacePlanModel]()
                    self.isSkeletonView = false
                    self.workspaceTableView.reloadData()
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
extension WorkspaceViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return self.planArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkspaceTableViewCell") as! WorkspaceTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.offerConatinerView.isHidden = true
        
        if self.isSkeletonView {
            cell.view_1.showAnimatedGradientSkeleton()
        }else{
            cell.hideSkeleton()
            let planModel = self.planArray[indexPath.row]
            
      //      cell.planIconImgView.sd_setImage(with: URL(string: (planModel.logo ?? "")), placeholderImage: nil)
            cell.planNameLabel.text = planModel.name ?? ""
         
            let price = Double(planModel.price ?? "0.0") ?? 0.0
            
            cell.planPriceLabel.text = objUserSession.currency + price.withCommas()
            cell.durationLabel.text = (planModel.billingCycle ?? "").capitalized
            
       //     let color = UIColor(red: 123/255.0, green: 123/255.0, blue: 123/255.0, alpha: 1.0)
            
            cell.planDescLabel.text = (planModel.highlights ?? "") // NSMutableAttributedString().color(color, (planModel.highlights ?? ""), font: .regular(size: 14), 1, .left)
            cell.highlightsLabel.text = (planModel.description ?? "") // NSMutableAttributedString().color(color, (planModel.description ?? ""), font: .regular(size: 12), 1, .left)
         
        }
        
      //  planModel. ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let workVC = WorkspacePlanViewController.storyboardInstance() {
            objOfficeAddressManager?.selectedPlanModel = self.planArray[indexPath.row]
            self.navigationController?.pushViewController(workVC, animated: true)
        }
    }
}

// MARK: - UITableView Cell

//class WorkspaceTableViewCell:UITableViewCell {
//    
//    @IBOutlet weak var planIconImgView: UIImageView!
//    
//    @IBOutlet weak var planNameLabel: UILabel!
//    
//    @IBOutlet weak var planPriceLabel: UILabel!
//    
//    @IBOutlet weak var planDescLabel: UILabel!
//    
//    @IBOutlet weak var highlightsLabel: UILabel!
//    
//    
//}
