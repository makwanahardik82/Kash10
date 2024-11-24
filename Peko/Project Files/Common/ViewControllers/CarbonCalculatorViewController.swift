//
//  CarbonCalculatorViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 03/01/24.
//

import UIKit


class CarbonCalculatorViewController: MainViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var questionNumberLabel: PekoLabel!
    
    @IBOutlet weak var backButton: PekoButton!
   
    @IBOutlet weak var nextButton: PekoButton!
    
    var type = "BASIC"
    
    var questionAnswerModel:CarbonQuestionAnswerArrayModel?
    
    var questionIndex = 0
    var totalQuestion = 0
    
    var viewArray = [CarbonQuestionViewController]()
    var answerSheetDictionary = [String:Any]()
    
    static func storyboardInstance() -> CarbonCalculatorViewController? {
        return AppStoryboards.Carbon.instantiateViewController(identifier: "CarbonCalculatorViewController") as? CarbonCalculatorViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Zero Carbon")
      
        self.getQuestions()
        
        self.backButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    func getQuestions(){
        HPProgressHUD.show()
        CarbonViewModel().getQuestions(type: self.type) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
                    print(response)
                    self.questionAnswerModel = response??.data?.data!
                    self.totalQuestion = response??.data?.recordsTotal ?? 0
                    self.setData()
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
    func setData(){
        self.questionNumberLabel.text = "Question \(self.questionIndex + 1)/\(self.totalQuestion)"
        
        self.scrollView.delegate = self
        
        let views:NSDictionary = ["containerView": self.containerView]
        //Width
        
        self.scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView(\(screenWidth * CGFloat(self.totalQuestion)))]|", options: [], metrics: nil, views: views as! [String : Any]))
        self.scrollView.isScrollEnabled = true
        
     ///   var idx = 0
        for element in self.questionAnswerModel!.questionSheet! {
            if let qVC = CarbonQuestionViewController.storyboardInstance() {
                qVC.questionDataModel = element
                viewArray.append(qVC)
                addChild(qVC)

                self.stackView.addArrangedSubview(qVC.view)
                qVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                qVC.didMove(toParent: self)
            
            }
        }
    }
    
    // MARK: -
    @IBAction func previousButtonClick(_ sender: Any) {
        
        
        if (questionIndex - 1) >= 0 {
            self.questionIndex -= 1
            self.scrollView.setContentOffset(CGPoint(x:Int(screenWidth) * self.questionIndex, y: 0), animated:true)
            self.questionNumberLabel.text = "Question \(self.questionIndex + 1)/\(self.totalQuestion)"
        }else{
            self.questionIndex = 0
        }
        if questionIndex == 0 {
            self.backButton.isHidden = true
        }
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        
        let vc = viewArray[questionIndex]
       
        let options = vc.questionModel?.options
        let optionDictionary = vc.optionDictionary
      
        for opt in options! {
            let ids = opt.id ?? 0
            let dic = optionDictionary["\(ids)"]
            if dic == nil {
                self.showAlert(title: "", message: "Please enter value")
                return
            }
            if (dic!["selectedUnitId"] == nil) {
                self.showAlert(title: "", message: "Please select unit")
                return
            }
            if (dic!["value"] == nil) {
                self.showAlert(title: "", message: "Please enter value")
                return
            }
        }
        
        let ids = vc.questionModel?.id ?? 0
        
        let ansDic = [
            "\(ids)":optionDictionary
        ]
        
        let ans = [
            "category": vc.questionDataModel?.category ?? "",
            "type": vc.questionDataModel?.type ?? "",
            "answers":[ansDic]
        ] as [String : Any]
        answerSheetDictionary["\(vc.questionDataModel?.id ?? 0)"] = ans
        
        if (questionIndex + 1) < self.totalQuestion {
           self.questionIndex += 1
            self.scrollView.setContentOffset(CGPoint(x:Int(screenWidth) * self.questionIndex, y: 0), animated:true)
            self.questionNumberLabel.text = "Question \(self.questionIndex + 1)/\(self.totalQuestion)"
            
            self.backButton.isHidden = false
        }else{
            print("OVER")
            self.calculate()
        }
    }
    func calculate(){
      //  print(answerSheetDictionary.toJSON())
        HPProgressHUD.show()
       
        CarbonViewModel().calculate(answer: answerSheetDictionary) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
                    print(response)
                    if let detailVC = CarbonCalculatorDetailViewController.storyboardInstance() {
                        detailVC.calculateResponseModel = response??.data
                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }
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
// MARK: - UIScrollViewDelegate
extension CarbonCalculatorViewController:UIScrollViewDelegate{
    
}
