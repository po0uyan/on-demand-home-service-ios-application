//
//  ServiceDetailesViewController.swift
//  pinwork
//
//  Created by Pouyan on 7/22/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//
import SwiftyJSON
import UIKit

class ServiceDetailesViewController: UIViewController {
    
    @IBOutlet weak var rateButton: UIButton!
    
    @IBOutlet weak var workersStackView: UIStackView!
    
    @IBOutlet weak var firstWorkerView: UIView!
    @IBOutlet weak var secondWorkerView: UIView!
    
    
    @IBOutlet weak var thirdWorkerView: UIView!
    
    @IBOutlet weak var callForSupportButton: UIButton!
    
    @IBOutlet weak var showInvoiceButton: UIButton!
    
    @IBOutlet weak var serviceType: UILabel!
    
    @IBOutlet weak var neededServices: UILabel!
    
    @IBOutlet weak var serviceDate: UILabel!
    
    var animationView: UIView!

    @IBOutlet weak var serviceStartTime: UILabel!
    
    @IBOutlet weak var phonePlace: UILabel!
    
    @IBOutlet weak var serviceAddress: UILabel!
    
    @IBOutlet weak var payPrice: UILabel!
    
    @IBOutlet weak var serviceImage: UIImageView!
    let orderImages = ["home":"home2","office":"work3","garage":"windows2","carwash":"carwash2"]
    var service = JSON()
    override func viewDidLoad() {
        super.viewDidLoad()
       secondWorkerView.isHidden = true
       thirdWorkerView.isHidden = true
        firstWorkerView.isHidden = true
        rateButton.isHidden = true
        
        callForSupportButton.layer.cornerRadius = 8
        showInvoiceButton.layer.borderWidth = 1
        showInvoiceButton.layer.borderColor = getPinworkColors(color: 1).cgColor
        showInvoiceButton.layer.cornerRadius = 8

        self.navigationItem.title = service["service_code"].stringValue
        preFillContents()
        fillContents()
        

    }
    func preFillContents(){ //fill components from service type provided from previouse viewController
        serviceImage.image = UIImage(named: self.getProperImageName(for: self.service))
        serviceType.text = getProperOrderLabel(for: service)
        serviceAddress.text = service["address"].stringValue
        payPrice.text = service["price"].stringValue.convertEngNumToPersianNum() + " " + "تومان  "
        serviceDate.text = getProperDate(inputStringDate: service["default_start_date"].stringValue)
        serviceStartTime.text = String(service["default_start_date"].stringValue.components(separatedBy: " ")[1].dropLast(3)).convertToPersian()
        phonePlace.text = service["service_number"].stringValue.convertToPersian()
        neededServices.text = getProperNeededService(for: service).convertToPersian()
    }
    
    func fillContents(){ // get complete details from api get service details
        animationView = self.displaySpinner(onView: self.view)
        APIClient.serviceDatailes(rememberToken: self.getData(key: "rememberToken") as! String, requestParams: ["service_code":service["service_code"].stringValue, "service_type":getProperServiceName()]) { (respond, error) in
            debugPrint(respond)
            
            let labels = self.secondWorkerView.subviews.compactMap { $0 as? UILabel }
            debugPrint(labels)
            
            for label in labels {
                debugPrint(label.text)
                //Do something with label
            }
            
            
//            debugPrint(respond,error)
            self.removeSpinner(spinner: self.animationView)

        }
        
    }
    func getProperImageName(for service:JSON)->String{
        switch service["service_type"].stringValue {
        case "cleaning_work": //means just cleaning not cleaning work office
            if service["cleaning_type"] == "work"{
                return orderImages["office"]!
            }
            else{
                return orderImages["home"]!
            }
        case "carwash":
            return orderImages["carwash"]!
        case "joints":
            return orderImages["garage"]!
        default:
            break
        }
        return orderImages["home"]!
        
    }
        func getProperOrderLabel(for service:JSON)->String{
            switch service["service_type"] {
            case "cleaning_work": //means just cleaning not cleaning work office
                if service["cleaning_type"] == "work"{
                    return "سرویس نظافت دفتر کار"
                }
                else{
                    return "سرویس نظافت منزل"
                }
            case "carwash":
                return "سرویس کارواش"
            case "joints":
                return "سرویس نظافت راه‌پله و پارکینگ"
            default:
                break
            }
            return "سرویس نظافت"
        }
    func getProperServiceName()->String{
        switch service["service_type"].stringValue {
        case "cleaning_work": //means just cleaning not cleaning work office
           return "cleaning"
        case "carwash":
            return "carwash"
        case "joints":
            return "joints"
        default:
            break
        }
        return "cleaning"
    }
        
    
    
    func getProperNeededService(for service:JSON)->String{
        switch service["service_type"] {
        case "cleaning_work": //means just cleaning not cleaning work office
            if service["cleaning_type"] == "work"{
                return "سرویس نظافت دفتر کار"
            }
            else{
                return "نظافت داخل منزل\n" + calculateworkDuration(for:service)
            }
        case "carwash":
            return "سرویس کارواش"
        case "joints":
            return "سرویس نظافت راه‌پله و پارکینگ"
        default:
            break
        }
        return "سرویس نظافت"
    }
    func calculateworkDuration(for service:JSON)->String{
        let time1 = String(service["default_start_date"].stringValue.components(separatedBy: " ")[1].dropLast(3))
        let time2 = String(service["default_end_date"].stringValue.components(separatedBy: " ")[1].dropLast(3))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        
        let date1 = formatter.date(from: time1)!
        let date2 = formatter.date(from: time2)!
        
        let elapsedTime = date2.timeIntervalSince(date1)
        
        // convert from seconds to hours, rounding down to the nearest hour
        let hours = floor(elapsedTime / 60 / 60)
        
        // we have to subtract the number of seconds in hours from minutes to get
        // the remaining minutes, rounding down to the nearest minute (in case you
        // want to get seconds down the road)
        let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
        if minutes==0{
            return "\(Int(hours)) ساعت کار"

        }
        return "\(Int(hours)) ساعت و \(Int(minutes)) دقیقه کار"
    }
    }
    





