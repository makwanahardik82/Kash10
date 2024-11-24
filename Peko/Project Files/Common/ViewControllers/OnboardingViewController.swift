//
//  OnboardingViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 03/01/23.
//

import UIKit

class OnboardingViewController: UIViewController {
   // @IBOutlet weak var pageControlView: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
//    @IBOutlet weak var prevButton: UIButton!
//    @IBOutlet weak var startButton: UIButton!
//    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var pageControlView: PageControlView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var pageIndex = 0
    
    var onbaordingArray = [
        [
            "title":"Simplify, manage and pay all your business expenses",
            "image":"onboarding_bg_1"
        ],
        [
            "title":"Earn rewards and cashback on every transactions",
            "image":"onboarding_bg_2"
        ],
        [
            "title":"Become 100% carbon neutral with Peko",
            "image":"onboarding_bg_3"
        ]
    ]
    
    
    static func storyboardInstance() -> OnboardingViewController? {
        return AppStoryboards.Onboarding.instantiateViewController(identifier: "OnboardingViewController") as? OnboardingViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.onboardingCollectionView.delegate = self
//        self.onboardingCollectionView.dataSource = self
//        self.onboardingCollectionView.register(UINib(nibName: "OnbaordingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnbaordingCollectionViewCell")
        
        self.navigationController?.isNavigationBarHidden = true
     
        //self.pageControlView.numberOfPages = self.onbaordingArray.count
        //self.pageControlView.currentPage = 0
        
        self.pageControlView.currentPage = pageIndex
        
        self.nextButton.titleLabel?.font = .medium(size: 16)
    }
    
    // MARK: - Prev Button Click
    @IBAction func prevButtonClick(_ sender: Any) {
        DispatchQueue.main.async {
            self.onboardingCollectionView.isPagingEnabled = false
            self.onboardingCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.onboardingCollectionView.isPagingEnabled = true
            
        }
    }
    
    // MARK: - Next Button Click
    @IBAction func nextButtonClick(_ sender: Any) {
        DispatchQueue.main.async {
           
            if self.pageIndex == 2 {
                self.startButtonClick(UIButton())
            }else{
                self.pageIndex = self.pageIndex + 1
                self.pageControlView.currentPage = self.pageIndex
                
                if self.pageIndex == 2 {
                    self.nextButton.setTitle("Let’s go", for: .normal)
                }else{
                    self.nextButton.setTitle("Next", for: .normal)
                }
                self.nextButton.setTitleColor(.redButtonColor, for: .normal)
                self.nextButton.backgroundColor = UIColor(red: 212/255.0, green: 237/255.0, blue: 216/255.0, alpha: 1.0)
                
                self.scrollView.setContentOffset(CGPoint(x: Int(screenWidth) * self.pageIndex, y: 0), animated: true)
            }
            
            
//            self.onboardingCollectionView.isPagingEnabled = false
//            self.onboardingCollectionView.scrollToItem(at: IndexPath(row: self.pageIndex + 1, section: 0), at: .centeredHorizontally, animated: true)
//            self.onboardingCollectionView.isPagingEnabled = true
            
           // self.onboardingCollectionView.setContentOffset(CGPoint(x: self.pageControlView.currentPage * Int(screenWidth), y: 0), animated: true)
        }
    }
    
    
    @IBAction func startButtonClick(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: "Is_App_Open_First_Time")
        UserDefaults.standard.synchronize()
        
        objShareManager.navigateToViewController = .LoginVC
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    // MARK: - Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
extension OnboardingViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.onbaordingArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenHeight)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnbaordingCollectionViewCell", for: indexPath) as! OnbaordingCollectionViewCell
        cell.backgroundColor = .clear
        
        let dic = self.onbaordingArray[indexPath.row]
        
        cell.titleLabel.text =  dic["title"]
        cell.titleLabel.font = .medium(size: 28)
        cell.bgImgView.image = UIImage(named: dic["image"]!)
  
       // if let imageName =  as? String {
      // }
        
       
       
//        if indexPath.row == 2{
//            cell.earthImgView.isHidden = false
//        }else{
//            cell.earthImgView.isHidden = true
//        }
//
        return cell
    }
}
extension OnboardingViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2

        /*
        self.pageIndex = Int(offSet + horizontalCenter) / Int(width)
        self.pageControlView.currentPage = self.pageIndex
        //self.setPageNumber()
        
        if self.pageIndex == 0 {
            self.startButton.isHidden = true
            self.prevButton.isHidden = true
            self.nextButton.isHidden = false
            self.pageControlView.isHidden = false
        }else if self.pageIndex == 1 {
            self.startButton.isHidden = true
            self.prevButton.isHidden = false
            self.nextButton.isHidden = false
            self.pageControlView.isHidden = false
        }else{
            self.startButton.isHidden = false
            self.prevButton.isHidden = true
            self.nextButton.isHidden = true
          self.pageControlView.isHidden = true
        }
        */
    }

}
