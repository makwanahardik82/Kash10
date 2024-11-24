//
//  ApiEnds.swift
//  SMAT
//
//  Created by Hardik Makwana on 06/10/22.
//

import UIKit

class ApiEnd {
    
  //  static let BASE_URL =  "https://uatae.peko.one/" // stagging
    
    var BASE_URL:String {
        
        if objShareManager.appTarget == .PekoUAE {
            if is_live {
                return "https://aeapi.peko.one/"
            }else{
                return "https://api-gateway.salmonflower-b84cd6b0.westus2.azurecontainerapps.io/" //https://api-gateway.orangeocean-fa607906.uaenorth.azurecontainerapps.io/" // "https://sitae.peko.one/"
            }
        }else if objShareManager.getAppTarget() == .PekoIndia {
            if is_live {
                return "https://in.peko.one/"
            }else{
                return "https://api-gateway.greencliff-35dd2bc5.centralindia.azurecontainerapps.io/" //"https://in.peko.one/"
            }
        }
        return ""
    }
    
//    static let BASE_URL =  "https://uae.peko.one/"

    var LOGIN_URL:String {
        get{
            if objShareManager.appTarget == .PekoUAE {
                return "api/v1/user/login"
            }else{
                return "api/v1/user/login" //"api/v1/login"
            }
           
        }
    }
    var LOGOUT_URL:String {
        get{
                return "api/v1/user/logout"
        }
    }
    
    var REGISTER_URL:String {
        get{
            if objShareManager.appTarget == .PekoUAE {
                return "api/v1/user/signUp"
            }else{
                return "api/v1/signUp"
            }
        }
    }// =  ""
    
    var FORGOT_PASSWORD_URL:String {
        get{
            if objShareManager.appTarget == .PekoUAE {
                return "api/v1/user/forgotPassword"
            }else{
                return "api/v1/forgotPassword"
            }
        }
    }
    var REGISTER_OTP_URL:String {
        get{
            if objShareManager.appTarget == .PekoUAE {
                return "api/v1/user/otp"
            }else{
                return "api/v1/otp"
            }
        }
    }
    
    var BENEFICIARY_OTP_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/beneficiary/otp"
        }
    } // "api/v1/beneficiary/get-otp"
  
    var UPDATE_OTP_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/profile/get-otp-update"
        }
    }
    var BANK_DETAILS_OTP_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/profile/otp-bank-details"
        }
    }
    
    // "api/v1/beneficiary/get-otp"
  
    
    // MARK: - Phone Bills
    // MARK: - DU PREPAID & POSTPAID
   
    var DU_PREPAID_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/duTopUp/limits"
        }
    } // "api/v1/duTopUp/limits"
    var DU_PREPAID_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/duTopUp/balance"
        }
    } // "api/v1/duTopUp/balance"
    var DU_PREPAID_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/duTopUp/payment"
        }
    } // "api/v1/duTopUp/payment"
    
    var DU_POSTPAID_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/duBill/limits"
        }
    } // "api/v1/duBill/limits"
    var DU_POSTPAID_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/duBill/balance"
        }
    } // "api/v1/duBill/balance"
    var DU_POSTPAID_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/duBill/payment"
        }
    } // "api/v1/duBill/payment"
   
    // MARK: - ETISALAT PREPAID & POSTPAID
  
    var ETISALAT_PREPAID_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/etisalatTu/limits"
        }
    }// "api/v1/etisalatTu/limits"
    var ETISALAT_PREPAID_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/etisalatTu/balance"
        }
    }// "api/v1/etisalatTu/balance"
    var ETISALAT_PREPAID_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/etisalatTu/payment"
        }
    }// "api/v1/etisalatTu/payment"
  
    var ETISALAT_POSTPAID_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/etisalatBill/limits"
        }
    }// "api/v1/etisalatBill/limits"
    var ETISALAT_POSTPAID_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/etisalatBill/balance"
        }
    }// "api/v1/etisalatBill/balance"
    var ETISALAT_POSTPAID_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/etisalatBill/payment"
        }
    }// "api/v1/etisalatBill/payment"
   
    var GET_BENEFICIARY:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/beneficiary/fetchBeneficiary"
        }
    }// "api/v1/beneficiary/fetchBeneficiary"
    var ADD_BENEFICIARY:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/beneficiary/"
        }
    }// "api/v1/beneficiary/"
    var DELETE_BENEFICIARY:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/beneficiary/"
        }
    }// "api/v1/beneficiary/delete/"
  
    // MARK: - Utility Payments
    // MARK: - DU PREPAID & POSTPAID
   
    var FEWA_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/fewa/limits"
        }
    }// "api/v1/fewa/limits"
    var FEWA_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/fewa/balance"
        }
    }// "api/v1/fewa/balance"
    var FEWA_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/fewa/payment"
        }
    }// "api/v1/fewa/payment"

    var AADC_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/aadc/limits"
        }
    }// "api/v1/aadc/limits"
    var AADC_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/aadc/balance"
        }
    }// "api/v1/aadc/balance"
    var AADC_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/aadc/payment"
        }
    }// "api/v1/aadc/payment"

    var ADDC_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/addc/limits"
        }
    }// "api/v1/addc/limits"
    var ADDC_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/addc/balance"
        }
    }// "api/v1/addc/balance"
    var ADDC_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/addc/payment"
        }
    }// "api/v1/addc/payment"
  
    var AJMAN_SEWERANGE_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/ajman/limits"
        }
    }// "api/v1/ajman/limits"
    var AJMAN_SEWERANGE_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/ajman/balance"
        }
    }// "api/v1/ajman/balance"
    var AJMAN_SEWERANGE_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/ajman/payment"
        }
    }// "api/v1/ajman/payment"
    
    var LOOTAH_GAS_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/lootah/limits"
        }
    }// "api/v1/lootah/limits"
    var LOOTAH_GAS_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/lootah/balance"
        }
    }// "api/v1/lootah/balance"
    var LOOTAH_GAS_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/lootah/payment"
        }
    }// "api/v1/lootah/payment"
    
//    static let MAWAQiF_LIMIT_URL = "api/v1/duBill/limits"
//    static let MAWAQiF_BALANCE_URL = "api/v1/duBill/balance"
//    static let MAWAQiF_PAYMENT_URL = "api/v1/duBill/payment"
    
    var SALIK_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/salik/limits"
        }
    }// "api/v1/salik/limits"
    var SALIK_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/salik/balance"
        }
    }// "api/v1/salik/balance"
    var SALIK_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/salik/payment"
        }
    }// "api/v1/salik/payment"
    
    var NOL_CARD_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/nol/limits"
        }
    }// "api/v1/nol/limits"
    var NOL_CARD_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/nol/balance"
        }
    }// "api/v1/nol/balance"
    var NOL_CARD_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/nol/payment"
        }
    }// "api/v1/nol/payment"
  
    var SEWA_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/sewa/limits"
        }
    }
    var SEWA_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/sewa/balance"
        }
    }// "api/v1/sewa/balance"
    var SEWA_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/sewa/payment"
        }
    }
  
    var DUBAI_POLICE_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/dubaipolice/limits"
        }
    }
    var DUBAI_POLICE_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/dubaipolice/balance"
        }
    }// "api/v1/sewa/balance"
    var DUBAI_POLICE_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/dubaipolice/payment"
        }
    }
    
    var DARB_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/darb/limits"
        }
    }
    var DARB_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/darb/balance"
        }
    }// "api/v1/sewa/balance"
    var DARB_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/darb/payment"
        }
    }
    var HAFILAT_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/hafilat/limits"
        }
    }
    var HAFILAT_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/hafilat/balance"
        }
    }// "api/v1/sewa/balance"
    var HAFILAT_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/hafilat/payment"
        }
    }
    
    
    // MARK: -
    // MARK: - License Renewal
    var LICENSE_RENEWAL_LIMIT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/licenseRenewal/limits"
        }
    }
    var LICENSE_RENEWAL_BALANCE_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/licenseRenewal/balance"
        }
    }
    // licenseRenewal/balance?accountNo=20554148&flexiKey=BP49&typeKey=1
    //= "api/v1/licenseRenewal/balance"
    var LICENSE_RENEWAL_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/licenseRenewal/payment"
        }
    }
    //= "api/v1/licenseRenewal/payment"
   
    
    // MARK: - Gift Card
    static let GIFT_CARD_CATEGORIES_URL = "api/v1/giftCards/categories"
    var GIFT_CARD_PRODUCTS_URL:String {
        get{
            if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/giftcards/all"
            }else{
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/giftcards/"
                
            }
            
        }
    }// = "api/v1/giftCards/"
  //  static let GIFT_CARD_PRODUCTS_DETAILS_URL = "api/v1/giftCards/product/"
    var GIFT_CARD_ORDER_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/giftcards/payment"
        }
    }// = "api/v1/giftCards/payment"
    
    var GIFT_CARD_HISTORY_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/giftcards/transactions"
        
        }
    }
    
    
    // MARK: - PEKO STORE
    var PEKO_STORE_CATEGORIES_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/ecommerce/categories"
        }
    }
    var PEKO_STORE_PRODUCTS_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/ecommerce/products"
        }
    }
    var PEKO_STORE_PRODUCTS_DETAILS_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/ecommerce/product/details"
        }
    }
    var PEKO_STORE_GET_CART_DETAILS_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/ecommerce/cartDetails"
        }
    }
    var PEKO_STORE_ADD_TO_CART_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/ecommerce/addToCart"
        }
    }
    var PEKO_STORE_UPDATE_CART_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/ecommerce/"
        }
    }
   
    var PEKO_STORE_DELETE_FROM_CART_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/ecommerce"
        }
    }
    var PEKO_STORE_PAYMENT_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/ecommerce/payment"
        }
    }
   
    var PEKO_STORE_HISTORY_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/ecommerce/latestTransactions"
        }
    }
    var PEKO_STORE_HISTORY_DETAIL_URL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/ecommerce/orderDetails/"
        }
    }
    
    // MARK: - Payment Link
    static let PAYMENT_LINK_GETLINK_URL = "api/v1/paymentLinks/getLink"
    
    var  PAYMENT_LINK_HISTORY_URL:String {
        get{
            return "api/v1/paymentLinks/\(objUserSession.user_id)/history"
        }
    }
    
    // MARK: -
    var PEKO_CONNECT_GET_ALL_URL:String {
        get{
           // if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/pekoConnect/providers"
//            }else{
//                return "api/v1/subscriptionPayments/getAll"
//            }
        }
    } // "api/v1/pekoConnect/getAll"
    var PEKO_CONNECT_DETAIL_URL:String {
        get{
          //  if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/pekoConnect/details/"
//            }else{
//                return "api/v1/subscriptionPayments/getAll"
//            }
        }
    }
    
    var PEKO_CONNECT_URL:String {
        get{
          //  if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/pekoConnect"
//            }else{
//                return "api/v1/subscriptionPayments/getAll"
//            }
        }
    } // "api/v1/pekoConnect"
   
    // MARK: -
    // MARK: - AIR TICKET
    
     var AIR_TICKET_SEARCH_TICKET_URL :String {
        get{
        //    if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/flight/searchTicket"
//            }else{
//                return "api/v1/airline/searchTicket"
//            }
        }
    } // "api/v1/airline/searchTicket"
    
    var AIR_TICKET_BOOK_TICKET_URL :String {
        get{
       //     if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/flight/payment"
//            }else{
//                return "api/v1/airline/payment"
//            }
        }
    } //
    static let AIR_TICKET_FARE_RULE_URL = "api/v1/airline/fareRules"
  
    var AIR_TICKET_PROVISIONAL_BOOK_URL :String {
        get{
           // if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/flight/provBook"
//            }else{
//                return "api/v1/airline/provisionalBook"
//            }
        }
    }
    var AIR_TICKET_HISTORY_BOOK_URL :String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/flight/list-all-bookings"
        }
    }
    var AIR_TICKET_DOWNLOAD_TICKET_URL :String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/flight/download-bookingTicket"
        }
    }
    var AIR_TICKET_CANCEL_TICKET_URL :String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/flight/cancellation-charge"
        }
    }
    var AIR_TICKET_ANC_SEARCH_URL :String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/flight/ancSearch"
        }
    }
    
    var AIR_TICKET_ANC_PRO_BOOK_URL :String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/flight/ancProBook"
        }
    }
    
    // MARK: -
    // MARK: - Invoice Generator
    var CREATE_INVOICE:String {
        get{
          //  if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/invoices/"
//            }else{
//                return "api/v1/invoices"
//            }
        }
    } // = "api/v1/invoices"
    var GET_ALL_INVOICE:String {
        get{
//            if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/invoices/all"
//            }else{
//                return "api/v1/invoices/allInvoices"
//            }
        }
    } // "api/v1/invoices/allInvoices"
    
    var GET_INVOICE_DOWNLOAD:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/invoices/downloadInvoice"
        }
    }
    
    // MARK: - Workspace
    var WORKSPACE_GET_ALL_PLAN:String {
        get{
            // if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/workspaces/allPlans"
//            }else{
//                return "api/v1/subscriptionPayments/getAll"
//            }
        }
    } // = "api/v1/workspaces/allPlans"
    var WORKSPACE_PAYMENT :String {
        get{
           // if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/workspaces/payment"
//            }else{
//                return  "api/v1/workspaces/allWorkspaces"
//            }
        }
    }
    var WORKSPACE_UPLOAD_FILE :String {
        return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/workspaces/fileUpload"
    }
    
    
    // MARK: - SUBSCRIPTION
    var SUBSCRIPTION_GET_ALL_PRODUCT:String {
        get{
//            if objShareManager.appTarget == .PekoUAE {
//                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/subscriptionPayments/subscriptions"
//            }else{
//                return  "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/softwares/subscriptions"
//            }
            return  "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/softwares/subscriptions"
        }
    }
    var SUBSCRIPTION_GET_ALL_PLAN:String {
        get{
//            if objShareManager.appTarget == .PekoUAE {
//
//                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/subscriptionPayments/plans"
//            }else{
                return  "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/softwares/plans"
          //  }
        }
    }
    var SUBSCRIPTION_GET_PRODUCT_DETAIL:String {
        get{
//            if objShareManager.appTarget == .PekoUAE {
//                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/subscriptionPayments/details"
//            }else{
                return  "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/softwares/details"
           // }
        }
    }
    var SUBSCRIPTION_GET_ORDER_HISTORY:String {
        get{
//            if objShareManager.appTarget == .PekoUAE {
//                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/subscriptionPayments/allSubscriptions"
//            }else{
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/softwares/allSubscriptions"
          //  }
        }
    }
    var SUBSCRIPTION_PAYMENT:String {
        get{
//            if objShareManager.appTarget == .PekoUAE {
//                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/subscriptionPayments/payment"
//            }else{
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/softwares/payment"
           // }
        }
    }
    
    // MARK: - Logistics
    var LOGISTICS_GET_ALL_COUNTRY:String {
        get{
          //  if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/logistics/fetchCountries"
//            }else{
//                return "api/v1/logistics/fetchCountry"
//            }
        }
    } // = "api/v1/logistics/fetchCountry"
    var LOGISTICS_GET_CITIES  :String {
        get{
         //   if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/logistics/fetchCities"
//            }else{
//                return "api/v1/logistics/fetchCities"
//            }
        }
    } //= "api/v1/logistics/fetchCities"
    
    var LOGISTICS_GET_SAVED_ADDRESS :String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/logistics/fetchAddresses"
        }
    } // = "api/v1/logistics/fetchAddresses"
    var LOGISTICS_ADD_ADDRESS :String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/logistics/addAddress"
        }
    } // "api/v1/logistics/addAddress"
    var LOGISTICS_CALCULATE_RATE:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/logistics/calculateRate"
        }
    } // = "api/v1/logistics/calculateRate"
    var LOGISTICS_CREATE_SHIPMENT:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/logistics/payment"
        }
    } // = "api/v1/logistics/payment"
   
    var LOGISTICS_HISTORY:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/logistics/orders"
        }
    }
    var LOGISTICS_TRACK_SHIPMENTS:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/logistics/trackShipments"
        }
    }
    var LOGISTICS_CHECK_PINCODE:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/logistics/checkPincode"
        }
    }
    var LOGISTICS_CREATE_MERCHANT:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/logistics/createMerchant"
        }
    }
    
    
    
    // MARK: - Business Docs
    var BUSINESS_GET_CATEGORIES:String {
        get{
          //  if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/edocs/categories"
//            }else{
//                return "api/v1/profile/profileDetails/\(objUserSession.user_id)"
//            }
        }
    } //  "api/v1/docs/categories"
    var BUSINESS_GET_DOCUMENT:String {
        get{
           // if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/edocs/documents"
//            }else{
//                return "api/v1/profile/profileDetails/\(objUserSession.user_id)"
//            }
        }
    } //  "api/v1/docs/documents"
   
    
    // MARK: - Hotel Booking
    var HOTEL_BOOKING_SEARCH_HOTELS:String {
        get{
         //   if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/hotels/searchHotels"
//            }else{
//                return "api/v1/hotels/searchHotels"
//            }
        }
    }//  = "api/v1/hotels/searchHotels"
    var HOTEL_BOOKING_HOTEL_ROOMS_DETAILS:String {
        get{
           // if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/hotels/hotelAndRoomDetails"
//            }else{
//                return "api/v1/hotels/hotelAndRoomDetails"
//            }
        }
    }//  = "api/v1/hotels/hotelAndRoomDetails"
    
    var HOTEL_BOOKING_HOTEL_PRE_BOOK:String {
        get{
           // if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/hotels/preBook"
//            }else{
//                return "api/v1/hotels/preBook"
//            }
        }
    }
    
    var HOTEL_BOOKING_HOTEL_BOOK:String {
        get{
           // if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/hotels/book"
//            }else{
//                return "api/v1/hotels/book"
//            }
        }
    }
    var HOTEL_BOOKING_HISTORY:String {
        get{
           // if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/hotels/list-all-bookings"
//            }else{
//                return "api/v1/hotels/list-all-bookings"
//            }
        }
    }
    
    var HOTEL_BOOKING_CANCEL_BOOKING:String {
        get{
           // if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/hotels/hotel-cancel"
//            }else{
//                return "api/v1/hotels/hotel-cancel"
//            }
        }
    }
    
    var HOTEL_BOOKING_DOWNLOAD_TICKET:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/hotels/download-bookingTicket"
        }
    }
    
    static let HOTEL_BOOKING_HOTEL_CANCELLATION_POLICY = "api/v1/hotels/cancellationPolicy"
  
    
    
    // MARK: - PROFILE
    var GET_PROFILE_DETAILS:String {
        get{
          //  if objShareManager.appTarget == .PekoUAE {
              //  return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/profile/profileDetails"
            //}else{
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/profile/profileDetails"
                
                //w"api/v1/profile/profileDetails/\(objUserSession.user_id)"
//            }
        }
    }
    
    var GET_BASIC_PROFILE_DETAILS:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/profile/profileDetails/basic"
            
        }
    }
    
    var GET_PROFILE_WALLET_DETAILS:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/profile/walletDetails"
            
        }
    }
    
    
    var UPDATE_PROFILE_DETAILS:String {
        get{
           // if objShareManager.appTarget == .PekoUAE {
                return "/api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/profile"
//            }else{
//                return "api/v1/profile/\(objUserSession.user_id)"
//            }
        }
    }
    
    var DELETE_ACCOUNT:String {
        get{
           // return "api/v1/profile/deleteAccount/\(objUserSession.user_id)"
            return "api/v1/profile/deleteAccount/22"
        }
    }
    
    var CHANGE_PASSWORD:String {
        get{
         //   if objShareManager.appTarget == .PekoUAE {
                return "/api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/profile/changePassword"
//            }else{
//                return "api/v1/profile/changePassword/change"
//            }
        }
    }
    
    // MARK: -
   // static let ADD_SUPPORT = "api/v1/support/"
    
    static let GET_FAQ_SUPPORT = "api/v1/user/general/support/faq"
    var GET_TICKETS_LIST:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/support/tickets"
        }
    }
    var GET_TICKETS_DETAIL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/support/ticketDetials/"
        }
    }
    static let GET_ISSUE_TYPE = "api/v1/user/general/support/issueType"
    static let GET_MODULES = "api/v1/user/general/support/modules"
    
    var ADD_SUPPORT:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/support"
        }
    }
    var SEND_SUPPORT_MSG:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/support/create"
        }
    }
    var GET_LATEST_BENEFICIARY:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/beneficiary/latestBeneficiaries"
        }
    }
    
    
    
    
    
    // MARK: - Get Address
    var GET_ADDRESS_LIST:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/profile/addressDetails"
        }
    }
    var ADD_ADDRESS:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/profile/address"
        }
    }
    
    var GET_BANKS_LIST:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/profile/bank"
        }
    }
    var ADD_BANK:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/profile/bank"
        }
    }
    
    var UPDATE_MFA_Setting:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/profile/mfaSetting"
        }
    }
    
    
    // MARK: - Dashboard
    
    var GET_DASHBOARD_DETAILS:String {
        get{
            if objShareManager.appTarget == .PekoUAE {
                return "/api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/dashboard/details"
            }else{
                return "/api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/dashboard/details" // "api/v1/dashboard/details/\(objUserSession.user_id)"
            }
        }
    }
    var GET_TRANSACTION:String {
        get{
            //if objShareManager.appTarget == .PekoUAE {
                return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/transactions/orders"
//            }else{
//                return "api/v1/transactions/\(objUserSession.user_id)/reports"
//            }
        }
    }
    //MARK: - Zero Carbon
    
    var GET_CARBON_QUESTIONS:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/carbonFootprint/questions"
        }
    }
    var GET_CARBON_DASHBOARD_DETAILS:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/carbonFootprint/dashboard"
        }
    }
    var GET_CARBON_ALL_PROJECTS:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/carbonFootprint/projects"
        }
    }
    var GET_CARBON_NEUTRALIZE_DETAILS:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/carbonFootprint/neutralize/"
        }
    }
    var CARBON_PAYMENT:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/carbonFootprint/payment"
        }
    }
    
//    var CARBON_CALCULATE:String {
//        get{
//            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/carbonFootprint/questions"
//        }
//    }
    // MARK: - Payroll
    var GET_PAYROLL_DASHBOARD_PROGRESS:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/dashBoard/progress"
        }
    }
    var GET_PAYROLL_HR_SETTING:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/hr-settings/payroll-settings"
        }
    }
    var GET_PAYROLL_HR_SETTING_LEAVE:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/hr-settings/leave-settings"
        }
    }
    var GET_PAYROLL_WPS_SETTINGS:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/hr-settings/wps-settings"
        }
    }
    
    
    
    
    var GET_PAYROLL_ALL_EMPLOYEE:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/employee"
        }
    }
    
    var GET_PAYROLL_EMPLOYEES:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/employee/current-employees"
        }
    }
    
    
    var GET_PAYROLL_ALL_DEPARTMENT:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/department"
        }
    }
    
    var GET_PAYROLL_DASHBOARD_DETAILS:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/dashBoard"
        }
    }
    
    var GET_PAYROLL_DASHBOARD_CHART:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/dashBoard/chart"
        }
    }
    
    var GET_PAYROLL_ALL_LEAVES:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/leave-application/all-leaves"
        }
    }
    var GET_PAYROLL_LEAVES_APPLICATION:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/leave-application"
        }
    }
    
    var GET_PAYROLL_AVAILABLE_LEAVES:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/leave-application/available-leaves/"
        }
    }
    
    var GET_PAYROLL_SALARY_STATEMENT:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/salary/statement"
        }
    }
    var GET_PAYROLL_SALARY_PROFILE:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/salary/profile"
        }
    }
    var GET_PAYROLL_SALARY_SLIPES:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/salary/all-payroll-slips/"
        }
    }
    
    var GET_PAYROLL_CALENDAR_UPCOMING_ACTIVITIES:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/calendarActivities/upcoming"
        }
    }
//    var GET_PAYROLL_CALENDAR_UPCOMING_ACTIVITIES:String {
//        get{
//            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payroll/calendarActivities/upcoming"
//        }
//    }
    
    
    
    //MARK: - NOTIFICATIONS
    
    var GET_ALL_NOTIFICATION:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/others/notification"
        }
    }
    
    //MARK: - SURCHARGE
    var GET_SURCHARGE:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/purchase/surcharge"
        }
    }
    //MARK: - CREATE STRIPE ORDER
    var GET_CREATE_STRIPE_ORDER:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/paymentGateway/stripePayments/create"
        }
    }
    //MARK: - SURCHARGE
    var GET_STRIPE_ORDER_DETAILS:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/paymentGateway/stripePayments/"
        }
    }
    
    // MARK: - eSIM
    //MARK: - SURCHARGE
    var GET_ESIM_COMPATIBLE_DEVICE:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/eSIM/compatibleDevice"
        }
    }
    var GET_ESIM_PACKAGE:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/eSIM/packages"
        }
    }
    var GET_ESIM_PAYMENT:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/eSIM/payment"
        }
    }
    var GET_ESIM_HISTORY:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/eSIM/packageList"
        }
    }
    var GET_ESIM_HISTORY_ORDER_DETAIL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/travel/eSIM/packages/details"
        }
    }
    
    // MARK: -
    var GET_DOCUMENT_ATTESTATION_COUNTRIES:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/attestation/countries"
        }
    }
    var GET_DOCUMENT_ATTESTATION_CATEGORY_TYPE:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/attestation/categoryType"
        }
    }
    var GET_DOCUMENT_ATTESTATION_FILESAVE:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/attestation/fileSave"
        }
    }
    var GET_DOCUMENT_ATTESTATION_CHECK_PRICE:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/attestation/checkPrice"
        }
    }
    var GET_DOCUMENT_ATTESTATION_PAYMENT:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/officeAndBusiness/attestation/payment"
        }
    }
    
    
    
    // MARK: - Mobile Recharge
    
    var GET_MOBILE_RECHARGE_OPERATORS_LIST:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/catalog/products"
        }
    }
    
    var GET_MOBILE_RECHARGE_PLANS_LIST:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/catalog/skus"
        }
    }
    var GET_MOBILE_RECHARGE_PAYMENT:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/transaction/topup"
        }
    }
    
    
//    static let GET_MOBILE_PREPAID_PLANS = "api/v1/prepaid/plans"
   
    static var GET_STATES = "api/v1/user/general/states"
    
    var GET_MOBILE_PREPAID_PLANS:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/prepaid/plans"
        }
    }
    var MOBILE_PREPAID_PAYMENT:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/prepaid/payment"
        }
    }
    
   // static let  = "api/v1/postpaid/fetchBill"
    
//    static let MOBILE_POSTPAID_PAYMENT = "api/v1/postpaid/payment"
    
    var GET_BBPS_BILLERS_LIST:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/bbps/billers"
        }
    }
    var GET_MOBILE_POSTPAID_BILL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/postpaid/fetchBill"
        }
    }
    var MOBILE_POSTPAID_PAYMENT:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/postpaid/payment"
        }
    }
    
    var GET_UTILITY_BILL:String {
        get{
            return "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/payment/electricity/fetchBill"
        }
    }
    
    
    // MARK: - UTILITY
  //  static let GET_UTILITY_BILL = "api/v1/electricity/fetchBill"
    
   
    
//    static let GET_ELECTRICITY_BILL = "api/v1/electricity/fetchBill"
    
    
}
  
