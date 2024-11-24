//
//  HotelBookingValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 11/01/24.
//

import UIKit


struct HotelBookingValidation {
    
    func ValidateSearch(request: HotelBookingSearchRequest) -> AppValidationResult
    {
        if(request.city!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select city")
        }
        if(request.checkInDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select check in date")
        }
        if(request.checkOutDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select check out date")
        }
        
        if(request.noOfRooms!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select no. of rooms")
        }
        if(request.noOfTravellers!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select no. of traveller")
        }
        
        return AppValidationResult(success: true, error: nil)
    }
    
    
    // // MARK: -
    func ValidateGuestDetails(passanger: HotelBookingGuestModel) -> AppValidationResult
    {
        if(passanger.first_name.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the first & middle name")
        }
        if(passanger.last_name.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the last name")
        }
        if(passanger.email.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter email")
        }
        if !(passanger.email.isValidEmail ) {
            return AppValidationResult(success: false, error: "Please enter valid email")
        }
        if(passanger.phone_number.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the phone number")
        }
        if(passanger.country.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the country")
        }
        
        /*
        if(passanger.day.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter a day of birth date of a \(passanger.pan_card)")
        }
        if(passanger.month.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter a month of birth date of a \(passanger.pan_card)")
        }
        if(passanger.year.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter a year of birth date of a \(passanger.pan_card)")
        }
        
        var components = DateComponents()
        components.month = Int(passanger.month)
        components.year = Int(passanger.year)
        components.day = Int(passanger.day)
        components.calendar = Calendar.current
        
        if !(components.isValidDate) {
            return AppValidationResult(success: false, error: "Please enter the valid birthdate of a \(passanger.pan_card)")
        }
        */
        
        
        return AppValidationResult(success: true, error: nil)
    }
}
