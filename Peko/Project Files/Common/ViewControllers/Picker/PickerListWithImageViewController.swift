//
//  PickerListWithImageViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 18/12/23.
//

import UIKit

class PickerListWithImageViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerTableView: UITableView!
   
    var completionBlock:((_ selectedString: String) -> Void)?
    var completionIndexBlock:((_ index: Int) -> Void)?
   
    var titleArray = [String]()
    var imageArray = [String]()
    
    var titleString:String = ""
   
    var selectedString: String = ""
    var selectedIndex = 0
    
    
    static func storyboardInstance() -> PickerListWithImageViewController? {
        return PickerListWithImageViewController(nibName: "PickerListWithImageViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = AppColors.blackThemeColor?.withAlphaComponent(0.8)
//        
//        self.bottomConstraint.constant = self.view.bounds.height
//     
        self.pickerTableView.register(UINib(nibName: "PickerListWithImageTableViewCell", bundle: nil), forCellReuseIdentifier: "PickerListWithImageTableViewCell")
        self.pickerTableView.delegate = self
        self.pickerTableView.dataSource = self
//        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       // self.animation()
    }
    
}
extension PickerListWithImageViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerListWithImageTableViewCell") as! PickerListWithImageTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        if (self.imageArray.count != 0) {
            cell.imgView.image = UIImage(named: self.imageArray[indexPath.row])
        }else{
            cell.imgView.isHidden = true
        }
        cell.titleLabel.text = self.titleArray[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.com
        
        if self.completionBlock != nil {
            let str = self.titleArray[indexPath.row]
            self.completionBlock!(str)
        }
        if self.completionIndexBlock != nil {
            self.completionIndexBlock!(indexPath.row)
        }
        self.dismiss(animated: true)
    }
}
