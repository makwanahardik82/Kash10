//
//  CountryViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 14/09/23.
//

import UIKit

class CountryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var completionBlock:((_ selectedString: String) -> Void)?
   
    var countryArray = [CountryModel]()
    
    static func storyboardInstance() -> CountryViewController? {
        return AppStoryboards.Common.instantiateViewController(identifier: "CountryViewController") as? CountryViewController
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let url = Bundle.main.url(forResource: "Countries", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.countryArray = try decoder.decode([CountryModel].self, from: data)
               
            } catch {
                print("error:\(error)")
            }
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }

}
extension CountryViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell") as! CountryTableViewCell
        cell.backgroundColor = .clear
        
        let country = self.countryArray[indexPath.row]
        
        cell.titleLabel?.text = country.name
      //  cell.imgView?.sd_setImage(with: URL(string: country.flag!), placeholderImage: nil)
        let url = URL(string: country.flag!)
        cell.imgView?.sd_setImage(with: url)

        return cell
    }
}
class CountryTableViewCell:UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
}


struct CountryModel: Codable {
    
    let name:String?
    let alpha2Code:String?
    let alpha3Code:String?
    let flag:String?
    
    let callingCodes:[String]?
    let currencies:[CurrenciesModel]?
    
}
struct CurrenciesModel: Codable {
    let code:String?
    let name:String?
    let symbol:String?
}
