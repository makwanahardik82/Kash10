//
//  CarbonCalculatorDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 06/03/24.
//

import UIKit

class CarbonCalculatorDetailViewController: MainViewController {

    @IBOutlet weak var barChartCollectionView: UICollectionView!
    // @IBOutlet weak var barChartContainerView: UIView!
  //  @IBOutlet weak var barChartView: StackViewBarChart!
    //    @IBOutlet weak var barCHartView: BarChartView!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var calculateButton: PekoButton!
  
    var calculateResponseModel:CarbonCalculateResponseModel?
    
    let barChartView = StackViewBarChart(frame: CGRect(x: 0, y: 0, width: screenWidth - 40, height: 200))

    var groupedByCategory =  [CarbonCalculateDataGroupedCategoryModel]()
    var maxValue = 0.0
    var selectedIndex = -1
    
    static func storyboardInstance() -> CarbonCalculatorDetailViewController? {
        return AppStoryboards.Carbon.instantiateViewController(identifier: "CarbonCalculatorDetailViewController") as? CarbonCalculatorDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Zero Carbon")
      
        self.barChartCollectionView.delegate = self
        self.barChartCollectionView.dataSource = self
        self.barChartCollectionView.register(UINib(nibName: "CarbonChartCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CarbonChartCollectionViewCell")
        self.barChartCollectionView.backgroundColor = .clear
        
       // self.barChartContainerView.addSubview(barChartView)
        
        /*
                        [
                            "category": "Energy and Utilities",
                            "totalCo2Usage": 35.27148
                        ],
                        [
                            "category": "Fleet Management",
                            "totalCo2Usage": 0.04909072
                        ],
                        [
                            "category": "Employee Driving Habits",
                            "totalCo2Usage": 0.0276195
                        ],
                        [
                            "category": "Electricity",
                            "totalCo2Usage": 0.014079947699999998
                        ],
                        [
                            "category": "Business Travel",
                            "totalCo2Usage": 0.040074705
                        ],
                        [
                            "category": "Logistics",
                            "totalCo2Usage": 0.01215291
                        ],
                        [
                            "category": "Waste Management",
                            "totalCo2Usage": 256.06224000000003
                        ],
                        [
                            "category": "Online Presence",
                            "totalCo2Usage": 0.0021974860000000002
                        ],
                        [
                            "category": "Remote Work",
                            "totalCo2Usage": 0.072239
                        ]
                    ]
        */
        
        
        
//        barCHartView.chartDescription.enabled = false
//                
//        barCHartView.dragEnabled = true
//        barCHartView.setScaleEnabled(true)
//        barCHartView.pinchZoomEnabled = false
//        
//        // ChartYAxis *leftAxis = chartView.leftAxis;
//        
//       // barCHartView.maker
//        
//        let xAxis = barCHartView.xAxis
//        xAxis.labelPosition = .bottom
//        
//        barCHartView.rightAxis.enabled = false
//        
        
        
        if let url = Bundle.main.url(forResource: "Seat_Map", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let res = try decoder.decode(CarbonCalculateResponseModel.self, from: data)
                print(res)
                
                self.calculateResponseModel = res
                self.setData()
               //print(self.response)
            } catch {
                print("error:\(error)")
            }
        }
        // Do any additional setup after loading the view.
    }
    func setData() {
        self.totalLabel.attributedText = NSMutableAttributedString().color(AppColors.blackThemeColor!, "\((self.calculateResponseModel?.data?.totalCo2Usage?.value ?? "0.0").toDouble().withCommas()) Ton CO", font: .bold(size: 16)).subscriptString(AppColors.blackThemeColor!, _subscriptString: "2", font: .bold(size: 16)).color(AppColors.blackThemeColor!, " eq/year", font: .regular(size: 16))
        
        self.groupedByCategory = self.calculateResponseModel?.data?.groupedByCategory ?? [CarbonCalculateDataGroupedCategoryModel]()
        
        let valueArray = self.groupedByCategory.compactMap { $0.totalCo2Usage?.value ?? 0.0 }
        print(valueArray)
        self.maxValue = valueArray.max() ?? 0.0
        self.barChartCollectionView.reloadData()
        
//        for cat in self.calculateResponseModel!.data!.groupedByCategory! {
//            
//            self.barChartView.dataList.append(.init(legend: cat.category ?? "", number: UInt(cat.totalCo2Usage?.value ?? 0.0)))
//        }
        
        
//        self.barChartView.dataList = [
//            ,
//            .init(legend: "T", number: UInt.random(in: 0...10)),
//            .init(legend: "W", number: UInt.random(in: 0...10)),
//            .init(legend: "T", number: UInt.random(in: 0...10)),
//            .init(legend: "F", number: UInt.random(in: 0...10)),
//            .init(legend: "S", number: UInt.random(in: 0...10)),
//            .init(legend: "S", number: UInt.random(in: 0...10))
//        ]
      
    }
    // MARK: - Calculate
    @IBAction func calculateButtonClick(_ sender: Any) {
        if let calcVC = CarbonCalculatorViewController.storyboardInstance() {
            calcVC.type = "ADVANCE"
            self.navigationController?.pushViewController(calcVC, animated: true)
        }
    }
    
    // MARK: -
    @IBAction func buyButtonClick(_ sender: Any) {
        if let allVC = CarbonAllProjectsViewController.storyboardInstance() {
            self.navigationController?.pushViewController(allVC, animated: true)
        }
    }
}
extension CarbonCalculatorDetailViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groupedByCategory.count 
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 270)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarbonChartCollectionViewCell", for: indexPath) as! CarbonChartCollectionViewCell
        
        let model = self.groupedByCategory[indexPath.row]
        
        cell.titleLabel.text = model.category ?? ""
        let value = model.totalCo2Usage?.value ?? 0.0 //
        cell.valueLabel.text = value.decimalPoints(point: 0)
        
        let per = (value * 100) / maxValue
        cell.barViewHeightConstraint.constant = per * 2
        
        if self.selectedIndex == indexPath.row {
            cell.valueContainerView.isHidden = false
            cell.barView.backgroundColor = UIColor(red: 255/255.0, green: 175/255.0, blue: 175/255.0, alpha: 1.0)
        }else{
            cell.valueContainerView.isHidden = true
            cell.barView.backgroundColor = UIColor(red: 205/255.0, green: 213/255.0, blue: 235/255.0, alpha: 1.0)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        collectionView.reloadData()
    }
}
