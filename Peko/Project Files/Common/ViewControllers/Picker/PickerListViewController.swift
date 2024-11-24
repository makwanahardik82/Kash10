//
//  PickerListViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 23/01/23.
//

import UIKit

class PickerListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var completionBlock:((_ selectedString: String) -> Void)?
    var completionIndexBlock:((_ index: Int) -> Void)?
    var array = [String]()
    var titleString:String = ""
   
    var selectedString: String = ""
    var selectedIndex = 0
    /*
     {
        get{
            return self.selectedString
        }
        set{
            if newValue.count == 0 {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }else{
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
   */
    static func storyboardInstance() -> PickerListViewController? {
        return PickerListViewController(nibName: "PickerListViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.titleString 
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonCLick))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonClick))
        
        if self.selectedString.count == 0 {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        // Do any additional setup after loading the view.
    }
    @objc func cancelButtonCLick(){
        self.dismiss(animated: true)
    }
    @objc func doneButtonClick(){
        if self.completionBlock != nil {
            self.completionBlock!(selectedString)
        }
        if self.completionIndexBlock != nil {
            self.completionIndexBlock!(self.selectedIndex)
        }
        self.dismiss(animated: true)
    }
    
    // MARK: -
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}
extension PickerListViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        let title = self.array[indexPath.row]
        cell.textLabel?.text = title
        
        if title == self.selectedString {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = self.array[indexPath.row]
        self.selectedString = title
        self.selectedIndex = indexPath.row
        tableView.reloadData()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
