//
//  CarbonAllProjectsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 05/03/24.
//

import UIKit

class CarbonAllProjectsViewController: MainViewController {

    @IBOutlet weak var tableView: UITableView!
   
    var offset = 1
    var limit = 10
 
    var isPageRefreshing:Bool = false
   
    var isSkeletonView:Bool = true
 
    var allProjectArray = [CarbonProjectModel]()
   
    static func storyboardInstance() -> CarbonAllProjectsViewController? {
        return AppStoryboards.Carbon.instantiateViewController(identifier: "CarbonAllProjectsViewController") as? CarbonAllProjectsViewController
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Zero Carbon")
      
      //  segmentControl.delegate = self
        
      
        tableView.register(UINib(nibName: "CarbonProjectsTableViewCell", bundle: nil), forCellReuseIdentifier: "CarbonProjectsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        self.tableView.isUserInteractionEnabled = false
       
        self.getAllProjects()
        // Do any additional setup after loading the view.
    }
    // MARK: - Get Hotel Booking
    func getAllProjects(){
     //   HPProgressHUD.show()
        CarbonViewModel().getAllProjects(page: offset) { response, error in
          //  HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
              
                    self.allProjectArray.append(contentsOf: response??.data?.data ?? [CarbonProjectModel]())
                    
                    if self.allProjectArray.count < response??.data?.count ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                    self.isSkeletonView = false
                    self.tableView.isUserInteractionEnabled = true
                    self.tableView.reloadData()
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

   
}
// MARK: - UITableView
extension CarbonAllProjectsViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return self.allProjectArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarbonProjectsTableViewCell") as! CarbonProjectsTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if self.isSkeletonView {
            cell.view_1.showAnimatedGradientSkeleton()
        }else{
            cell.view_1.hideSkeleton()
            let projectModel = self.allProjectArray[indexPath.row]
            
            cell.titleLabel.text = projectModel.name ?? ""
            cell.imgView.sd_setImage(with: URL(string: projectModel.logo ?? ""))
            cell.descriptionLabel.text = projectModel.description ?? ""
            cell.addressLabel.text = (projectModel.city ?? "") + ", " + (projectModel.country ?? "")
            
            let str = projectModel.body?.html?.html2AttributedString ?? ""
            cell.descriptionLabel.text = str
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let allVC = CarbonProjectDetailViewController.storyboardInstance() {
            objCarbonManager?.selectedProjectModel = self.allProjectArray[indexPath.row]
            self.navigationController?.pushViewController(allVC, animated: true)
        }
    }
}
// MARK: -
extension CarbonAllProjectsViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                self.offset += 1
                self.getAllProjects()
            }
        }
    }
}
