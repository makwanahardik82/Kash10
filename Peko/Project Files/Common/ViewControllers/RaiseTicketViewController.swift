//
//  RaiseTicketViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 22/02/24.
//

import UIKit

class RaiseTicketViewController: MainViewController {

    @IBOutlet weak var issueView: PekoFloatingTextFieldView!
    @IBOutlet weak var modulesView: PekoFloatingTextFieldView!
    @IBOutlet weak var descView: PekoFloatingTextView!
    
    @IBOutlet weak var raiseTableView: UITableView!
    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var screenshotsUploadView: DashedView!
    @IBOutlet weak var screenshotsPhotoView: UIView!
    
    var imagePicker = UIImagePickerController()
    var issueTypeArray = [SupportTicketRaiseOptionsModel]()
    var moduleArray = [SupportTicketRaiseOptionsModel]()
    
    var imageBase64String = ""
    var issueType = ""
    var module = ""
    
    var isEdit = false
    var ticketModel:SupportTicketModel?
    var completionBlock:((_ ticketModel: SupportTicketModel) -> Void)?
   
    static func storyboardInstance() -> RaiseTicketViewController? {
        return AppStoryboards.Help.instantiateViewController(identifier: "RaiseTicketViewController") as? RaiseTicketViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Raise a Ticket")
        self.view.backgroundColor = .white
        
        self.raiseTableView.backgroundColor = .clear
        self.raiseTableView.tableHeaderView = self.headerView
        
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
      
        self.getOptions()
        
        self.issueView.delegate = self
        self.modulesView.delegate = self
        
        if self.isEdit {
            self.issueType = self.ticketModel?.issueType ?? ""
            self.module = self.ticketModel?.module ?? ""
            
            self.issueView.text = self.issueType
            self.modulesView.text = self.module
            self.descView.text = self.ticketModel?.description ?? ""
            
            self.screenshotsUploadView.isHidden = true
            self.screenshotsPhotoView.isHidden = false
        }
        
        // Do any additional setup after loading the view.
    }
    func getOptions(){
        HPProgressHUD.show()
        SupportViewModel().getIssueTyoe() { response, error in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print(response)
                    self.issueTypeArray = response?.data?.issueType ?? [SupportTicketRaiseOptionsModel]()
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
        SupportViewModel().getModules() { response, error in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print(response)
                    self.moduleArray = response?.data?.modules ?? [SupportTicketRaiseOptionsModel]()
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

    @IBAction func screenshotsButtonClick(_ sender: Any) {
        self.imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func removeScreenshitsButtonClick(_ sender: Any) {
        self.screenshotsUploadView.isHidden = false
        self.screenshotsPhotoView.isHidden = true
    }
    
    
    // MARK: -
    @IBAction func submitButtonClick(_ sender: Any) {
        
        self.view.endEditing(true)
        let request = SupportRaiseTicketRequest(issueType: self.issueType, module: self.module, imageBase64String: self.imageBase64String, description: self.descView.text, isEdit: self.isEdit)
        
        let result = SupportRaiseTicketValidation().Validate(request: request)
        
        if result.success {
            self.addTicket(request: request)
        }else{
            self.showAlert(title: "", message: result.error ?? "")
        }
    }
    func addTicket(request:SupportRaiseTicketRequest) {
        HPProgressHUD.show()
        SupportViewModel().addSuport(request: request) { response, error in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    
                    if self.isEdit {
                       // self.ticketModel =
                        if self.completionBlock != nil {
                            self.completionBlock!((response?.data!)!)
                        }
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        if let vc = TicketsDetailsViewController.storyboardInstance() {
                            vc.ticketModel = response?.data!
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
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
extension RaiseTicketViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        dismiss(animated: true, completion: nil)
        
    //    let imageData = image.jpegData(compressionQuality: 0.5)
            if let image = info[.editedImage] as? UIImage {
                self.imageBase64String = image.toBase64() ?? ""
                
                self.screenshotsUploadView.isHidden = true
                self.screenshotsPhotoView.isHidden = false
            }
      
    }
}

// MARK: -
extension RaiseTicketViewController:PekoFloatingTextFieldViewDelegate {
    func textChange(textView: PekoFloatingTextFieldView) {
        
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        
        var value = [String]()
        var label = [String]()
        var title = ""
        var selectedString = ""
        
        if textView == self.issueView {
            value = self.issueTypeArray.compactMap({ $0.value })
            label = self.issueTypeArray.compactMap({ $0.label })
            title = "Issue Type"
            selectedString = self.issueView.text!
        }else if textView == self.modulesView {
            value = self.moduleArray.compactMap({ $0.value })
            label = self.moduleArray.compactMap({ $0.label })
            title = "Module"
            selectedString = self.modulesView.text!
        }
        
        let pickerVC = PickerListViewController.storyboardInstance()
        pickerVC?.array = label
        pickerVC?.selectedString = selectedString
        pickerVC?.titleString = title
        pickerVC?.completionIndexBlock = { index in
            if textView == self.issueView {
                self.issueView.text = label[index]
                self.issueType = value[index]
            }else if textView == self.modulesView {
                self.modulesView.text = label[index]
                self.module = value[index]
            }
        }
        let nav = UINavigationController(rootViewController: pickerVC!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
        
        
        
    }
    
    
}
