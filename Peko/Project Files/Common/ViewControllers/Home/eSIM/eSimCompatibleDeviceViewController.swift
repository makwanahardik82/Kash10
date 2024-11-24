//
//  eSimCompatibleDeviceViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 14/04/24.
//

import UIKit

class eSimCompatibleDeviceViewController: MainViewController {
    @IBOutlet weak var deviceTableView: UITableView!
    
    var deviceListArray = [MobileDeviceModel]()
    
    static func storyboardInstance() -> eSimCompatibleDeviceViewController? {
        return AppStoryboards.eSim.instantiateViewController(identifier: "eSimCompatibleDeviceViewController") as? eSimCompatibleDeviceViewController
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Travel eSIM")
        self.view.backgroundColor = .white
     
        self.deviceTableView.delegate = self
        self.deviceTableView.dataSource = self
     //   self.deviceTableView.register(UINib(nibName: <#T##String#>, bundle: <#T##Bundle?#>), forCellReuseIdentifier: <#T##String#>)
        
        self.getDevice()
        // Do any additional setup after loading the view.
    }
    // MARK: - Device
    func getDevice(){
        HPProgressHUD.show()
        eSimViewModel().getSupportedDevice { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    
                    self.deviceListArray = response?.data?.deviceList ?? [MobileDeviceModel]()
                    self.deviceTableView.reloadData()
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

// MARK: - TableView

extension eSimCompatibleDeviceViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        
        let model = self.deviceListArray[indexPath.row]
        cell.textLabel?.text = (model.name ?? "") + "\n" + (model.brand ?? "")
        cell.detailTextLabel?.text = model.model
        
        return cell
    }
}
