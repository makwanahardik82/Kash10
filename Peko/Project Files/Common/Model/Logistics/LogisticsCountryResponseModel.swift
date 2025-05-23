//
//  LogisticsCountryResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 11/09/23.
//

import UIKit

struct LogisticsCountryResponseDataModel: Codable {
  
    let countries:[LogisticsCountryModel]?
   // let HasErrors:Bool?
}

struct LogisticsCountryModel: Codable {
  
    let name:String?
  
    let alpha2Code:String?
   
//    let IsoCode:String?
//    let InternationalCallingNumber:String?
//    let StateRequired:Bool?
//    let PostCodeRequired:Bool?
}
/*
{
                "name": "United Arab Emirates",
                "topLevelDomain": [
                    ".ae"
                ],
                "alpha2Code": "AE",
                "alpha3Code": "ARE",
                "callingCodes": [
                    "971"
                ],
                "capital": "Abu Dhabi",
                "altSpellings": [
                    "AE",
                    "UAE"
                ],
                "region": "Asia",
                "subregion": "Western Asia",
                "population": 9856000,
                "latlng": [
                    24,
                    54
                ],
                "demonym": "Emirati",
                "area": 83600,
                "gini": null,
                "timezones": [
                    "UTC+04"
                ],
                "borders": [
                    "OMN",
                    "SAU"
                ],
                "nativeName": "دولة الإمارات العربية المتحدة",
                "numericCode": "784",
                "currencies": [
                    {
                        "code": "AED",
                        "name": "United Arab Emirates dirham",
                        "symbol": "د.إ"
                    }
                ],
                "languages": [
                    {
                        "iso639_1": "ar",
                        "iso639_2": "ara",
                        "name": "Arabic",
                        "nativeName": "العربية"
                    }
                ],
                "translations": {
                    "de": "Vereinigte Arabische Emirate",
                    "es": "Emiratos Árabes Unidos",
                    "fr": "Émirats arabes unis",
                    "ja": "アラブ首長国連邦",
                    "it": "Emirati Arabi Uniti",
                    "br": "Emirados árabes Unidos",
                    "pt": "Emirados árabes Unidos",
                    "nl": "Verenigde Arabische Emiraten",
                    "hr": "Ujedinjeni Arapski Emirati",
                    "fa": "امارات متحده عربی"
                },
                "flag": "https://restcountries.eu/data/are.svg",
                "regionalBlocs": [
                    {
                        "acronym": "AL",
                        "name": "Arab League",
                        "otherAcronyms": [],
                        "otherNames": [
                            "جامعة الدول العربية",
                            "Jāmiʻat ad-Duwal al-ʻArabīyah",
                            "League of Arab States"
                        ]
                    }
                ],
                "cioc": "UAE"
            }
*/
