//
//  FAQViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 22/02/24.
//

import UIKit

class FAQViewController: MainViewController {

    @IBOutlet weak var faqTableView: UITableView!
    
    var selectedSectionArray:[Int] = [Int]()
    var selectedIndexPathArray:[Int] = [Int]()
    
    var faqDictionary = [String:Any]()
    var titleArray = [String]()
    
    static func storyboardInstance() -> FAQViewController? {
        return AppStoryboards.Help.instantiateViewController(identifier: "FAQViewController") as? FAQViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "FAQ")
        self.view.backgroundColor = .white
      
        self.faqTableView.delegate = self
        self.faqTableView.dataSource = self
        self.faqTableView.backgroundColor = .clear
        // Do any additional setup after loading the view.
        
        self.getFAQ()
    }
// MARK: - Get FAQ
    func getFAQ(){
        HPProgressHUD.show()
        SupportViewModel().getFAQ { response, error in
            HPProgressHUD.hide()
            if error! {
               // print(res)
                if let data = response!["data"] as? [String:Any] {
                    print(data)
                    self.faqDictionary = data
                    self.titleArray = Array(self.faqDictionary.keys)
                    self.faqTableView.reloadData()
                }
            }else{
                
            }
        }
    }
}
// MARK: -
extension FAQViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titleArray.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableCell(withIdentifier: "FAQHeaderCell") as! FAQHeaderCell
        view.backgroundColor = .clear
        
        view.titleLabel.text = self.titleArray[section]
    
//        if self.selectedSectionArray.contains(section) {
//            view.arrowImgView.image = UIImage(named: "icon_faq_arrow_up")
//        }else{
//            view.arrowImgView.image = UIImage(named: "icon_faq_arrow_down")
//        }
        
        //view.button.addAction(for: .touchUpInside) {
//            if self.selectedSectionArray.contains(section) {
//                let index = self.selectedSectionArray.firstIndex(of: section)
//                self.selectedSectionArray.remove(at: index!)
//            }else{
//                self.selectedSectionArray.append(section)
//            }
//            tableView.reloadData()
//           // tableView.reloadSections(IndexSet(integer: section), with: .automatic)
//        }
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = self.titleArray[section]
        
        if let array = self.faqDictionary[key] as? [[String:String]] {
            return array.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell") as! FAQTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.titleLabel.numberOfLines = 0
        cell.detailLabel.numberOfLines = 0
        
        let color = UIColor(red: 79/255.0, green: 93/255.0, blue: 100/255.0, alpha: 1.0)
        
        let key = self.titleArray[indexPath.section]
        
        if let array = self.faqDictionary[key] as? [[String:String]] {
            let dic = array[indexPath.row]
            
            cell.titleLabel.text = dic["question"]
            cell.detailLabel.attributedText = NSMutableAttributedString().color(color, dic["answer"]!, font: .regular(size: 10), 5)
            
            if self.selectedSectionArray.contains(indexPath.section) && self.selectedIndexPathArray.contains(indexPath.row) {
                cell.detailLabel.isHidden = false
                cell.arrowImgView.image = UIImage(named: "icon_faq_arrow_up")
            }else{
                cell.detailLabel.isHidden = true
                cell.arrowImgView.image = UIImage(named: "icon_faq_arrow_down")
            }
        }
            
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.selectedSectionArray.contains(indexPath.section) && self.selectedIndexPathArray.contains(indexPath.row) {
            
            let section = self.selectedSectionArray.firstIndex(of: indexPath.section)
            self.selectedSectionArray.remove(at: section!)
            
            let index = self.selectedIndexPathArray.firstIndex(of: indexPath.row)
            self.selectedIndexPathArray.remove(at: index!)
            
        }else{
            self.selectedSectionArray.append(indexPath.section)
            self.selectedIndexPathArray.append(indexPath.row)
        }
        tableView.reloadData()
    }
}

// MARK:
class FAQHeaderCell:UITableViewCell {
    
    @IBOutlet weak var titleLabel: PekoLabel!
    
    
   // @IBOutlet weak var button: UIButton!
}

class FAQTableViewCell:UITableViewCell {
    
    @IBOutlet weak var detailLabel: PekoLabel!
    @IBOutlet weak var titleLabel: PekoLabel!
    @IBOutlet weak var arrowImgView: UIImageView!
   
}
