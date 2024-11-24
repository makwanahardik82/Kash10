//
//  DatePickerViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 21/05/23.
//

import UIKit
import FSCalendar

class DatePickerViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    var completionBlock:((_ selectedDate: Date) -> Void)?
    
    var minimumDate:Date?
    
    static func storyboardInstance() -> DatePickerViewController? {
        return DatePickerViewController(nibName: "DatePickerViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.calendar.delegate = self
        self.calendar.dataSource = self
        // Do any additional setup after loading the view.
    }
}
extension DatePickerViewController:FSCalendarDelegate, FSCalendarDataSource {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.minimumDate!
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if self.completionBlock != nil {
            self.completionBlock!(date)
        }
        self.dismiss(animated: true)
    }
}
