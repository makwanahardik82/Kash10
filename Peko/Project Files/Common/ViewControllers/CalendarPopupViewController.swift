//
//  CalendarPopupViewController.swift
//  Retail
//
//  Created by Hardik Makwana on 15/06/20.
//  Copyright © 2020 Hardik Makwana. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarPopupViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
  
   // @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
   // @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var pickerView: DatePickerView!
    
//    var xPosition:CGFloat = 0
//    var yPosition:CGFloat = 0
//    
    var completionBlock:((_ selectedDate: Date) -> Void)?
    var selectedDate = Date()
    
    var maximumDate:Date? = nil
    var minimumDate:Date? = nil
    
    static func storyboardInstance() -> CalendarPopupViewController? {
        let alert = CalendarPopupViewController(nibName: "CalendarPopupViewController", bundle: nil)
        return alert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black.withAlphaComponent(0.3)
        
    
        self.calendar.appearance.headerTitleFont = AppFonts.Regular.size(size: 12)
        // RobotoRegularFont(with: 9)
        self.calendar.appearance.weekdayFont = AppFonts.Regular.size(size: 10)
        self.calendar.appearance.titleFont = AppFonts.Regular.size(size: 12)
     //   self.calendar.appearance.todayColor = .green
       // self.calendar.appearance.borderRadius = 0
        self.calendar.delegate = self
        
        self.calendar.select(self.selectedDate)
        
        if self.maximumDate != nil {
            self.pickerView.maxYear = Int(self.maximumDate?.formate(format: "yyyy") ?? "2024")!
        }else if self.minimumDate != nil {
            self.pickerView.minYear = Int(self.minimumDate?.formate(format: "yyyy") ?? "2024")! // Int(self.minimumDate?.year() ?? 1990)
        }
        
        self.pickerView.selectedDate = self.selectedDate
        self.pickerView.selectToday()
    
        /*
        self.pickerView.yearSelectedTextColor = Constant.lightThemeColor
        self.pickerView.monthSelectedTextColor = Constant.lightThemeColor
        self.pickerView.yearTextColor = Constant.lightThemeColor
        self.pickerView.monthTextColor = Constant.lightThemeColor
        
        */
        self.yearView.isHidden = true
        
        
       
        
        
        /*
        if self.maximumDate != nil {
            self.calendar.maximumDate = self.maximumDate
        }
        
        if self.minimumDate != nil {
            self.calendar.minimumDate = self.minimumDate
        }
        */
        // Do any additional setup after loading the view.
    }

    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    // MARK: - Year 
    @IBAction func yearButtoClick(_ sender: Any) {
        yearView.isHidden = false
    }
    // MARK: - Tool Box
    @IBAction func cancelButtonClick(_ sender: Any) {
        yearView.isHidden = true
    }
    @IBAction func doneButtonClick(_ sender: Any) {
        yearView.isHidden = true
        self.calendar.select(self.pickerView.date)
    }
    // MARK: - Buttons
    
    @IBAction func previosButtonClick(_ sender: Any) {
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendar.currentPage)
        self.calendar.setCurrentPage(previousMonth!, animated: true)
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        
        let nextsMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendar.currentPage)
        self.calendar.setCurrentPage(nextsMonth!, animated: true)
    }
}
extension CalendarPopupViewController:FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        if self.maximumDate != nil {
            if date >= self.maximumDate!{
                return false
            }
        }else if self.minimumDate != nil {
            if date <= self.minimumDate!{
                return false
            }
        }
        return true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if self.completionBlock != nil{
            self.completionBlock!(date)
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        if self.maximumDate != nil {
            if date > maximumDate! {
                return .gray
            }
        }
        if self.minimumDate != nil {
            if date < minimumDate! {
                return .gray
            }
        }
        return AppColors.blackThemeColor
    }
}
