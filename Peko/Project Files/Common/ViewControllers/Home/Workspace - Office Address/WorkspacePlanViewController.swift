//
//  WorkspacePlanViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 09/07/23.
//

import UIKit


class WorkspacePlanViewController: MainViewController {

    @IBOutlet weak var planNameLabel: PekoLabel!
    @IBOutlet weak var amountLabel: PekoLabel!
    
    @IBOutlet weak var existingLicenseButton: UIButton!
    @IBOutlet weak var newLicenseButton: UIButton!
    
    @IBOutlet weak var companyNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var expiryDateView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var uploadLicenseView: DashedView!
    @IBOutlet weak var photoLicenseView: UIView!
    
    @IBOutlet weak var uploadVisaView: DashedView!
    @IBOutlet weak var photoVisaView: UIView!
    
    
    
    
    var imagePicker = UIImagePickerController()
    
    var imageUploadType:ImageUpload = .Trade_License
    
    var tradeLicenseBaseString:String = ""
    var visaCopyBaseString:String = ""
    var licenseType = ""
    
    static func storyboardInstance() -> WorkspacePlanViewController? {
        return AppStoryboards.Workspace.instantiateViewController(identifier: "WorkspacePlanViewController") as? WorkspacePlanViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Office Address")
        self.view.backgroundColor = .white
        
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
           
        self.planNameLabel.text = objOfficeAddressManager?.selectedPlanModel?.name ?? ""
        let color = UIColor(red: 123/255.0, green: 123/255.0, blue: 123/255.0, alpha: 1.0)
        
        self.amountLabel.attributedText = NSMutableAttributedString().color(.redButtonColor, objUserSession.currency + (objOfficeAddressManager?.selectedPlanModel?.price ?? "0.0").toDouble().withCommas()).color(color, " / " + (objOfficeAddressManager?.selectedPlanModel?.billingCycle ?? "").capitalized)
       
        self.expiryDateView.minimumDate = Date()
        // Do any additional setup after loading the view.
    }
    
    // MARK: -
    @IBAction func existingLicenseButtonClick(_ sender: Any) {
        
        existingLicenseButton.isSelected = true
        newLicenseButton.isSelected = false
        licenseType = "existing"
    }
    @IBAction func newLicenseButtonClick(_ sender: Any) {
        existingLicenseButton.isSelected = false
        newLicenseButton.isSelected = true
        licenseType = "new"
    }
    
    // MARK: - Trade License
    @IBAction func tradeLicenseButtonClick(_ sender: Any) {
        self.imageUploadType = .Trade_License
        self.imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func removePhotoLicenseButtonClick(_ sender: Any) {
        self.uploadLicenseView.isHidden = false
        self.photoLicenseView.isHidden = true
    }
    // MARK: - Visa Copy
    @IBAction func visaCopyButtonClick(_ sender: Any) {
        self.imageUploadType = .VisaCopy
        self.imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func removePhotoVisaButtonClick(_ sender: Any) {
        self.uploadVisaView.isHidden = false
        self.photoVisaView.isHidden = true
    }
    //    // MARK: -
//    @IBAction func initialArrrovalButtonClick(_ sender: Any) {
//        self.imageUploadType = .InitialArrroval
//        self.imagePicker.allowsEditing = false
//        present(imagePicker, animated: true, completion: nil)
//    }
    
    // MARK: - Book Now Button
    @IBAction func bookNowButtonClick(_ sender: Any) {

        
        let request = WorkspaceRequest(licenseType: self.licenseType, companyName: self.companyNameView.text, expiryDate: self.expiryDateView.selectedDate, tradeLicenseBase64: self.tradeLicenseBaseString, ownerVisaBase64: self.visaCopyBaseString)
        
        let validationResult = WorkspaceValidation().Validate(request: request)

        if validationResult.success {
            self.view.endEditing(true)
            DispatchQueue.main.async {
                objOfficeAddressManager?.request = request
                if let reviewPaymentVC = PaymentReviewViewController.storyboardInstance() {
                    reviewPaymentVC.paymentPayNow = .OfficeAddress
                    self.navigationController?.pushViewController(reviewPaymentVC, animated: true)
                }
            }
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
    }
    
}
extension WorkspacePlanViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // self.workspaceArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkspaceTableViewCell") as! WorkspaceTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
            // cell.selectButtonContainerView.isHidden = true
         let planModel = objOfficeAddressManager?.selectedPlanModel
        
       //  cell.planIconImgView.sd_setImage(with: URL(string: (planModel?.logo ?? "")), placeholderImage: nil)
        cell.planNameLabel.text = planModel?.name ?? ""
       
        let price = Double(planModel?.price ?? "0.0") ?? 0.0
        
        cell.planPriceLabel.attributedText = NSMutableAttributedString().color(.black, objUserSession.currency, font: AppFonts.Medium.size(size: 10), 0, .center).color(.black, (price.withCommas()), font: AppFonts.Medium.size(size: 14), 0, .center).color(.black, "/y", font: AppFonts.Medium.size(size: 10), 0, .center)
        
        cell.planDescLabel.attributedText = NSMutableAttributedString().color(.black, planModel?.description ?? "", font: AppFonts.Regular.size(size: 8), 5, .center)
        
        cell.highlightsLabel.attributedText = NSMutableAttributedString().color(.black, planModel?.highlights ?? "", font: AppFonts.Regular.size(size: 10), 5, .center)
        
      //  planModel. ?? ""
        return cell
        
    }
}

// MARK: -
extension WorkspacePlanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
           uplodaImage(image: image)
        }
//        if imageUploadType == .Trade_License {
//            if let image = info[.originalImage] as? UIImage {
//                
//                
//            }
//        }else if imageUploadType == .VisaCopy {
//            
//        }
    }
    
    // MARK: -
    func uplodaImage(image:UIImage) {
        HPProgressHUD.show()
    
        let base64 = image.compressTo(800)?.toBase64() ?? ""
        
        WorkspaceViewModel().uploadImage(base64: base64) { response, error in
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
                    if self.imageUploadType == .Trade_License {
                        self.uploadLicenseView.isHidden = true
                        self.photoLicenseView.isHidden = false
                        self.tradeLicenseBaseString = response??.data?.initialApprovalUrl ?? ""
                    }else if self.imageUploadType == .VisaCopy {
                        self.uploadVisaView.isHidden = true
                        self.photoVisaView.isHidden = false
                        self.visaCopyBaseString = response??.data?.initialApprovalUrl ?? ""
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
