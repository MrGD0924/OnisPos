//
//  Constants.swift
//  OnisPos
//
//  Created by MG on 4/13/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

let myBlackColor = UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.00) // 5A5A5A
let myOrangeColor = UIColor(red:0.97, green:0.63, blue:0.09, alpha:1.00) //F7A116
let myPeachColor = UIColor(red:0.98, green:0.85, blue:0.76, alpha:1.00) //FBD8C2

let BASE_URL = "https://onis.datacare.mn"
//let BASE_URL = "http://10.0.10.45:9009"

//GET
let API_GET_DISTRICT = "/api/District/Districts"
let API_GET_CLASS = "/api/GoodsClass/GoodsClasslist/"
let API_GET_REPORT_DAY = "/api/Sales/DayReport/";
let API_GET_REPORT_DAY_DETAIL = "/api/Sales/DayDetailReport/"
let API_GET_REPORT_MONTH = "/api/Sales/MonthReport/"
let API_GET_REPORT_YEAR = "/api/Sales/YearReport/"
let API_CHECK_REGISTER = "/api/Store/CheckRegnum/";
let API_CHECK_REGISTER_COMPANY = "/api/Store/CheckRegnumOnis/"
let API_GET_STORE_INFO = "/api/Store/StoreInfo/"
let API_LICENSE_DURATION = "/api/License/getDuration"
let API_CONFIRM_PHONE = "/api/License/GetConfirmPhoneNum/"

//POST
let API_LOGIN = "/Login/Login"
let API_SALES = "/api/Sales/Sales"
let API_RETURN_SALE = "/api/Returns/ReturnSale/"
let API_RETURN_SALE_INFO = "/api/Returns/GetSaleInformation/"
let API_CHANGE_PASSWORD = "/api/User/ChangePassword/"
let API_INSERT_LICENSE_BY_QR_CODE = "/api/License/InsertLicenseByQrCode/"
let API_CONFIRM_NUMBER = "/api/License/SendConfirmNum/"
let API_VERIFY_TAN = "/api/License/ApproveConfirmNum/"
let API_LICENCE_MOBILE = "/api/License/LicenseMobile/"
let API_GET_ALL_USER = "/api/User/GetAllPosUsers/"
let API_SEND_RESET_PASS = "/api/User/ResetPassword/"

//PUT
let API_LOGOUT = "/Login/Login/Logout"
let API_CHECK_REG_NUM = "/api/Store/CheckRegnum/"
let API_UPDATE_STORE = "/api/Store/UpdateStore/"
let API_INSERT_STORE = "/api/Store/InsertStore/"

//DELETE



//String API_REST_PASSWORD = "/api/User/ResetPassword/";
//String API_GET_USERS = "/api/User/GetAllUsers/";
//String API_USER_CHECK_PHONE = "/api/User/CheckPhoneNum/";
