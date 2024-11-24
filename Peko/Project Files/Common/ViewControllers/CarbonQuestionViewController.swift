//
//  CarbonQuestionViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 06/03/24.
//

import UIKit

class CarbonQuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: PekoLabel!
    @IBOutlet weak var questionTableView: UITableView!
   
    var questionDataModel:CarbonQuestionDataModel?
    var questionModel:CarbonQuestionModel?
    
//    var answerDictionary = [String:Any]()
//    var answersArray = [Dictionary<String, Any>]()
    var optionDictionary = [String:[String:Any]]()
    
    static func storyboardInstance() -> CarbonQuestionViewController? {
        return AppStoryboards.Carbon.instantiateViewController(identifier: "CarbonQuestionViewController") as? CarbonQuestionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        if questionDataModel?.questions != nil || questionDataModel?.questions?.count != 0 {
            self.questionModel = questionDataModel?.questions?.first
            self.questionLabel.text = questionModel?.question ?? ""
            
            /*
            self.answerDictionary = [
                "category": questionDataModel?.category ?? "",
                "type": questionDataModel?.type ?? "",
                "answers": []
            ]
            */
          
            
//            answerDictinary = [
//                "\(self.questionDataModel?.id ?? 0)"
//            ]
            
        }
        
        questionTableView.backgroundColor = .clear
        questionTableView.separatorStyle = .none
        questionTableView.delegate = self
        questionTableView.dataSource = self
        
        
//            let dic = [
//                "selectedUnitId":123,
//                "values":"xyz"
//            ] as [String : Any]
//        self.optionDictionary["123456"] = dic
    }

}
extension CarbonQuestionViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionModel?.options?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell") as! AnswerTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let dic = questionModel?.options![indexPath.row]
        
        cell.valueView.placeholder = dic?.title ?? ""
        
        cell.valueView.tag = indexPath.row
        cell.unitView.tag = indexPath.row
        
        cell.valueView.delegate = self
        cell.unitView.delegate = self
        
        
        return cell
    }
}
extension CarbonQuestionViewController:PekoFloatingTextFieldViewDelegate{
    func textChange(textView: PekoFloatingTextFieldView) {
        
        if textView.placeholder == "Select Unit" {
            return
        }
        
        if textView.text?.count == 0 {
            return
        }
        
        let optionsDic = questionModel?.options![textView.tag]
        
        let keysID = "\(optionsDic?.id ?? 0)"
        var dic = self.optionDictionary[keysID]
        let value = Int(textView.text!) ?? 0
        if dic == nil {
            dic = [
                "value":value
            ]
        }else{
            dic!["value"] = value
        }
        self.optionDictionary[keysID] = dic
        
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
      
        let optionsDic = questionModel?.options![textView.tag]
      //  print(optionsDic)
        let pickerVC = PickerListViewController.storyboardInstance()
        let arrayTitle = optionsDic?.units?.compactMap({ $0.unit ?? "" }) ?? [String]()
        let arrayIds = optionsDic?.units?.compactMap({ $0.id ?? 0 }) ?? [Int]()
        
        pickerVC?.array = arrayTitle
        pickerVC?.selectedString = textView.text!
        pickerVC?.titleString = "Units"
        pickerVC?.completionIndexBlock = { indx in
            textView.text = arrayTitle[indx]
            let ids = arrayIds[indx]
            let keysID = "\(optionsDic?.id ?? 0)"
            var dic = self.optionDictionary[keysID]
            
            if dic == nil {
                dic = [
                    "selectedUnitId":ids
                ]
            }else{
                dic!["selectedUnitId"] = ids
            }
            self.optionDictionary[keysID] = dic
            
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let nav = UINavigationController(rootViewController: pickerVC!)
        nav.modalPresentationStyle = .fullScreen
        appDelegate.window?.rootViewController!.present(nav, animated: true)
//
    }
    
    
}
class AnswerTableViewCell:UITableViewCell {
    @IBOutlet weak var unitView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var valueView: PekoFloatingTextFieldView!
}
