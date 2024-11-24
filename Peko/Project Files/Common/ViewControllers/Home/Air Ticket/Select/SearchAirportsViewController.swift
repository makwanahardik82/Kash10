//
//  SearchAirportsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 10/06/23.
//

import UIKit

class SearchAirportsViewController: MainViewController {
 
    @IBOutlet weak var searchView: PekoFloatingTextFieldView!
   // @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
//    @IBOutlet var searchView: UIView!
   
    var airportArray = [AirportModel]()
    var searchAirportArray = [AirportModel]()
    
    var completionBlock:((_ airport: AirportModel) -> Void)?
    
    static func storyboardInstance() -> SearchAirportsViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "SearchAirportsViewController") as? SearchAirportsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.isBackNavigationBarView = true
//        self.view.backgroundColor = .white
//        self.setTitle(title: "Select City")
//      
        self.view.backgroundColor = .white
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.backgroundColor = .clear
        self.searchTableView.separatorStyle = .none
        
        if let url = Bundle.main.url(forResource: "Airport_List", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.airportArray = try decoder.decode([AirportModel].self, from: data)
                
                self.searchAirportArray = self.airportArray
                self.searchTableView.reloadData()
            } catch {
                print("error:\(error)")
            }
        }
        
        searchView.delegate = self
      //  self.searchTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
//    }
    // MARK: - Seatch Textfield
//    @objc func textFieldDidChange(_ textField: UITextField) {
//
//       
//    }
//    
//    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
    // MARK: -
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
extension SearchAirportsViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchAirportArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelCityTableViewCell") as! HotelCityTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let airport = self.searchAirportArray[indexPath.row]

        cell.titleLabel.text = (airport.city_name ?? "") + ", " + (airport.country ?? "")
        cell.detailLabel.text = airport.airport_name ?? ""
        cell.shortNameLabel.text = airport.iata_code ?? ""
      //  cell.textLabel?.text = airport.airport_name
        
      //  cell.nameLabel.attributedText = NSMutableAttributedString().color(.black, "\(airport.city_name ?? ""), \(airport.iata_code ?? "")".uppercased() + "\n", font: AppFonts.SemiBold.size(size: 12)).color(.black, airport.city_name ?? "", font: AppFonts.Regular.size(size: 12))
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.completionBlock != nil {
            self.completionBlock!(self.searchAirportArray[indexPath.row])
        }
        self.closeButtonClick(UIButton())
    }
}
// MARK: -
extension SearchAirportsViewController:PekoFloatingTextFieldViewDelegate {
    func textChange(textView: PekoFloatingTextFieldView) {
        if self.searchView.text?.count == 0 {
            self.searchAirportArray = self.airportArray
        }else{
            
            let searchString = self.searchView.text?.lowercased() ?? ""
            
            let array = self.airportArray.filter { ($0.airport_name?.lowercased() ?? "").contains(searchString) || ($0.city_name?.lowercased() ?? "").contains(searchString) }
            
            // $0.airport_name?.lowercased().contains(textField.text?.lowercased() ?? "")
            self.searchAirportArray = array
        }
        self.searchTableView.reloadData()
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        
    }
}
