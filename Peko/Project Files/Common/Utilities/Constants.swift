//
//  Constants.swift
//  Peko
//
//  Created by Hardik Makwana on 03/01/23.
//

import UIKit


let is_live = false
class Constants: NSObject {
    
    static let TERMS_CONDITIONS = "https://peko.one/index.php/terms-of-use/"
    
    static let sectorArray = ["Sector 1", "Sector 2", "Sector 3", "Sector 4", "Sector 5", "Sector 6"]
 
    static let companySizeArray = ["1-10", "11-30", "31-75", "75-100", "100 & Above"]

    
    var DAPI_SDK_APP_KEY:String {
        if is_live {
            return "976f7b2b90b06b871d43c2d950c8940f07edb614dcbe45f4a5a820fe3fc979cb"
        }else{
            return "80f928a1e94b72f93a00a11ce6ad63adb9eb3fff74b956c9a57033f6c5619991"
        }
    }
    var DAPI_SDK_APP_SECRET:String {
        if is_live {
            return "eaef08b860877229e0ec79e2b3756d1c60693e32bf783d910d76b9b774a38695"
        }else{
            return "2265fec45c59b9e00baec52001f78d596209c46754045baff3d052b21c59f0f6"
        }
    }
    
    
    // MARK: - SHipment Services
    static let logisticsDomesticParcelServiceType = [
        [
            "name":"Overnight (Parcel)",
            "code":"ONP"
        ],
        [
            "name":"Same Day (Parcel)",
            "code":"SDD"
        ]
    ]
    
    static let logisticsDomesticDocumentServiceType = [
        [
            "name":"Overnight (Document)",
            "code":"OND"
        ]
    ]
    
    static let logisticsIntenationalParcelServiceType =  [
        [
            "name":"Parcel Express",
            "code":"GPX"
        ],
        [
            "name":"Priority Parcel",
            "code":"PPX"
        ]
    ]
    static let logisticsIntenationalDocumentServiceType =  [
        [
            "name":"Priority Document Express",
            "code":"PDX"
        ]
    ]
    
    static let OTP_SCOPE = "mobile" // "both" // //"phone"
    
    
    // Office Address / Workspace
    
    static let officeAddress_LicenseType = ["Existing License", "New License"]
    
    /*
    static let DAPI_SDK_APP_KEY = "80f928a1e94b72f93a00a11ce6ad63adb9eb3fff74b956c9a57033f6c5619991"

   // DEMO ACCOUNT
   // static let DAPI_SDK_APP_KEY = "77181420253c90f71d77be89e59bf30c2f3a1222ece25e0436e4e34058ba5996"
    
    static let DAPI_SDK_APP_SECRET = "af476957e49f9d88a40a03a37194a73258d35f34e62c46419ed1d7b2cbb0d776"
    */
    static let paymentServicesArray = [
        [
            "title":"Mobile Top-Up",
            "icon":"icon_mobile_top_up"
        ],
        [
            "title":"Bill Payments",
            "icon":"icon_bill_payments"
        ],
        [
            "title":"Air Tickets",
            "icon":"icon_air_ticket"
        ],
        [
            "title":"Hotels",
            "icon":"icon_hotels"
        ],
        [
            "title":"Zero Carbon",
            "icon":"icon_zero_carbon"
        ],
        [
            "title":"Gift Cards",
            "icon":"icon_gift_cards"
        ],
        [
            "title":"Rewards",
            "icon":"icon_rewards"
        ],
        [
            "title":"Vouchers",
            "icon":"icon_voucher"
        ]
    ]
    
}

enum AppStoryboards {
    
    static let Splash = UIStoryboard(name: "Splash", bundle: nil)
    
    static let Base = UIStoryboard(name: "Base", bundle: nil)

    static let Main = UIStoryboard(name: "Main", bundle: nil)
    static let Onboarding = UIStoryboard(name: "Onboarding", bundle: nil)
    static let Login = UIStoryboard(name: "Login", bundle: nil)
    static let SignUp = UIStoryboard(name: "SignUp", bundle: nil)
    static let CreateAccount = UIStoryboard(name: "CreateAccount", bundle: nil)
    static let FaceID = UIStoryboard(name: "FaceID", bundle: nil)
   
    
    static let Home = UIStoryboard(name: "Home", bundle: nil)
    static let Transactions = UIStoryboard(name: "Transactions", bundle: nil)
    static let Bills = UIStoryboard(name: "Bills", bundle: nil)
  
    
    static let Settings = UIStoryboard(name: "Settings", bundle: nil)
    static let About = UIStoryboard(name: "About", bundle: nil)
    static let Account = UIStoryboard(name: "Account", bundle: nil)
   
    static let Offers = UIStoryboard(name: "Offers", bundle: nil)
    static let Notification = UIStoryboard(name: "Notification", bundle: nil)
    static let Help = UIStoryboard(name: "Help", bundle: nil)
    static let Profile = UIStoryboard(name: "Profile", bundle: nil)
    static let ManageBeneficiary = UIStoryboard(name: "ManageBeneficiary", bundle: nil)
    
    
    
    static let PekoClub = UIStoryboard(name: "PekoClub", bundle: nil)
  
    static let Phone_Bill = UIStoryboard(name: "Phone_Bill", bundle: nil)
    static let Pay_Later = UIStoryboard(name: "Pay_Later", bundle: nil)
    static let Air_Ticket = UIStoryboard(name: "Air_Ticket", bundle: nil)
  
    static let Beneficiary = UIStoryboard(name: "Beneficiary", bundle: nil)
  
    static let Utility = UIStoryboard(name: "Utility", bundle: nil)
    static let GiftCards = UIStoryboard(name: "GiftCards", bundle: nil)
    static let PekoStore = UIStoryboard(name: "PekoStore", bundle: nil)
    static let PaymentsLinks = UIStoryboard(name: "PaymentsLinks", bundle: nil)
    static let PekoConnect = UIStoryboard(name: "PekoConnect", bundle: nil)
    static let InvoiceGenerator = UIStoryboard(name: "InvoiceGenerator", bundle: nil)
    static let Carbon = UIStoryboard(name: "Carbon", bundle: nil)
    static let Workspace = UIStoryboard(name: "Workspace", bundle: nil)
    static let SubscriptionPayments = UIStoryboard(name: "SubscriptionPayments", bundle: nil)
    
    static let HotelBooking = UIStoryboard(name: "HotelBooking", bundle: nil)
    static let CorporateTravel = UIStoryboard(name: "CorporateTravel", bundle: nil)
    static let eSim = UIStoryboard(name: "eSIM", bundle: nil)
    
    static let DocumentAttestation = UIStoryboard(name: "DocumentAttestation", bundle: nil)
  
    static let Payroll = UIStoryboard(name: "Payroll", bundle: nil)
    static let PayrollEmpDept = UIStoryboard(name: "PayrollEmpDept", bundle: nil)
    static let PayrollWPS = UIStoryboard(name: "PayrollWPS", bundle: nil)
    static let PayrollLeave = UIStoryboard(name: "PayrollLeave", bundle: nil)
    static let PayrollSalary = UIStoryboard(name: "PayrollSalary", bundle: nil)
    static let PayrollCalendar = UIStoryboard(name: "PayrollCalendar", bundle: nil)
   
    
    static let Common = UIStoryboard(name: "Common", bundle: nil)
    static let OTP = UIStoryboard(name: "OTP", bundle: nil)
  
    
    static let License = UIStoryboard(name: "License", bundle: nil)
   
    static let Logistics = UIStoryboard(name: "Logistics", bundle: nil)
    static let BusinessDocs = UIStoryboard(name: "BusinessDocs", bundle: nil)
   
    
    static let MobileRecharge = UIStoryboard(name: "MobileRecharge", bundle: nil)
    static let Electricity = UIStoryboard(name: "Electricity", bundle: nil)
   
    static let ForgotPassword = UIStoryboard(name: "ForgotPassword", bundle: nil)
   
    
    static let Payment = UIStoryboard(name: "Payment", bundle: nil)
    static let PaymentIndia = UIStoryboard(name: "PaymentIndia", bundle: nil)
    static let PaymentUAE = UIStoryboard(name: "PaymentUAE", bundle: nil)
   
    
    /*
    
    
    
    
    */
}
enum AppFonts : String{
    
    case Light = "Roboto-Light"
    case Regular = "Roboto-Regular"
    case Medium = "Roboto-Medium"
    case SemiBold = "Inter-SemiBold"
    case Bold = "Roboto-Bold"
    case ExtraBold = "Inter-ExtraBold"
    
    func size(size:Float) -> UIFont {
        return UIFont(name: self.rawValue, size: CGFloat(size))!
    }
}

struct AppColors {
    
    static let borderThemeColor = UIColor(named: "BorderThemeColor")
    static let blackThemeColor = UIColor(named: "BlackThemeColor")
    static let backgroundThemeColor = UIColor(named: "BackgroundThemeColor")

    //    static let blueThemeColor = UIColor(named: "BlueThemeColor")
   static let darkThemeColor = UIColor(named: "DarkThemeColor")
//
    static let greenThemeColor = UIColor(named: "GreenThemeColor")
   
    static let color_EA4C36 = UIColor(named: "EA4C36")
    static let color_8A8A8A = UIColor(named: "8A8A8A")
   
}
    
// Screen width.
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

// Screen height.
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}


enum FontStyle: String {
    case Light // 300
    case Regular // 400
    case Medium // 500
    case SemiBold // 600
    case Bold // 700
    case ExtraBold // 800
}
