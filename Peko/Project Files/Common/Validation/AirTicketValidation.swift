//
//  AirTicketValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 15/06/23.
//

import UIKit


struct AirTicketValidation {

    func Validate(request: AirTicketSearchRequestModel) -> AppValidationResult
    {
       // DispatchQueue.main.async {
            if(request.origin == nil)
            {
                return AppValidationResult(success: false, error: "Please select origin")
            }
            if(request.destination == nil)
            {
                return AppValidationResult(success: false, error: "Please select destination")
            }
            if(request.departure_date == nil)
            {
                return AppValidationResult(success: false, error: "Please select departure date")
            }
            
            if objAirTicketManager?.airTicketWayType == .RoundTrip {
                if(request.return_date == nil)
                {
                    return AppValidationResult(success: false, error: "Please select return date")
                }
            }
           
            if objAirTicketManager?.airTicketWayType == .MultiCity {
                if(request.multi_origin == nil)
                {
                    return AppValidationResult(success: false, error: "Please select 2nd origin")
                }
                if(request.multi_destination == nil)
                {
                    return AppValidationResult(success: false, error: "Please select 2nd destination")
                }
            }
            
            if(request.passengersCount!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please select adult")
            }
            if(request.travel_class!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please select travel class")
            }
            return AppValidationResult(success: true, error: nil)
     //   }
        
    }
    
    // MARK: -
    func ValidatePassangerDetails(passanger: AirTicketPassangerDetailsModel) -> AppValidationResult
    {
        
        //   for j in 0..<passangerDetailsArray.count {
        //  let passanger = passangerDetailsArray[j]
        
        if(passanger.first_name.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the first name")
        }
        if(passanger.last_name.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the second name")
        }
        if(passanger.dateOfBirth == nil)
        {
            return AppValidationResult(success: false, error: "Please enter select the date of birth")
        }
        
        
        if(passanger.passportNumber.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the passport number")
        }
        if(passanger.passportIssueDate == nil)
        {
            return AppValidationResult(success: false, error: "Please enter select the passport issue date")
        }
        if(passanger.passportExpiryDate == nil)
        {
            return AppValidationResult(success: false, error: "Please enter select the passport expiry date")
        }
        if(passanger.passportIssueCountry.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select the passport issue country")
        }
        if(passanger.nationality.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select the nationality")
        }
        return AppValidationResult(success: true, error: nil)
    }
}
