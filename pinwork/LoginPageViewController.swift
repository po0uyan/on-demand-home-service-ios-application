//
//  LoginPageViewController.swift
//  pinwork
//
//  Created by Pouyan on 5/27/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
import Lottie
import Alamofire
import Reachability
class LoginPageViewController: UIViewController, UIScrollViewDelegate{
    @IBOutlet weak var LoginScrollView: UIScrollView!
    @IBOutlet weak var featurePageControl: UIPageControl!
    @IBOutlet weak var firstOrderUIButton: UIButton!

    @IBOutlet weak var logInUIButton: UIButton!
    
    
    @IBAction func featurePageChanged(_ sender: UIPageControl) {
        LoginScrollView.setContentOffset(CGPoint(x:CGFloat(sender.currentPage) * self.view.bounds.width, y: 0), animated: true)
    }
    @IBAction func firstOrderAndRegisteredClicked(_ sender: UIButton) {
        showLoginRegisterPopUp(isRegisterring: true)
    }
    
    @IBAction func loginToAccountClicked(_ sender: UIButton) {
        showLoginRegisterPopUp(isRegisterring: false)
    }
    
    
    let feature1 = ["title":"حرفه‌ای‌های قابل اعتماد","description":"حرفه‌ای‌های فعال در سیستم پین ورک، تست‌های اخلاقی، امنیتی و حرفه‌ای را گذرانده‌‌اند تا صلاحیت همکاری با مجموعه را پیدا کنند.","image":"pro_trusted.png"]
    let feature2 = ["title":"حرفه‌ای‌های آموزش‌دیده","description":"حرفه‌ای های فعال در سیستم پین ورک، دوره‌های آموزشی بسیاری را گذرانده‌اند تا بهترین خدمات را به شما بدهند.","image":"pro_trained.png"]
    let feature3 = ["title":"سفارش آسان و شفافی‌ قیمت","description":"در کمتر از یک دقیقه می‌توانید سفارش خود را ثبت کنید تا کارشناسان پین ورک در سریع‌ترین زمان ممکن، بهترین حرفه‌ای را به شما اختصاص دهند.","image":"calculator.png"]
    let feature4 = ["title":"پشتیبانی و پیگیری","description":"کارشناسان پین ورک در تمامی مراحل در خدمت شما هستند تا شما با خیالی آسوده از نظافت منزل یا محل کار خود لذت ببرید.","image":"customer_service_icon.png"]
    
    var featureArray = [Dictionary<String,String>]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.popUpOnNetFail), name: Notification.Name.reachabilityChanged, object: nil)
        // Do any additional setup after loading the view.
        logInUIButton.layer.borderWidth = 1
        firstOrderUIButton.layer.cornerRadius = 5
        logInUIButton.layer.cornerRadius = 5
        logInUIButton.layer.borderColor = logInUIButton.currentTitleColor.cgColor
        LoginScrollView.delegate = self
        featureArray = [feature1,feature2,feature3,feature4]
        featurePageControl.numberOfPages=featureArray.count
        LoginScrollView.isPagingEnabled = true
        LoginScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(featureArray.count), height: 230)
        LoginScrollView.showsHorizontalScrollIndicator = false
        LoginScrollView.showsVerticalScrollIndicator = false
        loadFeatures()
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: nil)

    }
    @objc  func popUpOnNetFail(_ notification : Notification){
        let reachability = notification.object as! Reachability
        switch reachability.connection{
        case .none:
            showNetworkError()
            //debugPrint("Network became unreachable")
        case .wifi:
            break
            //debugPrint("Network became reachable wifi")
            
        case .cellular:
            break
            //debugPrint("Network became reachable cellular")
            
        }
        
    }
    func showNetworkError(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let noInternetPopUpController = storyBoard.instantiateViewController(withIdentifier: "NoInternetPopUpViewController") as! NoInternetPopUpViewController
        noInternetPopUpController.modalTransitionStyle = .crossDissolve
        noInternetPopUpController.isModalInPopover = true
        noInternetPopUpController.modalPresentationStyle = .overCurrentContext
        noInternetPopUpController.onDoneBlock = { result in
            // Do something
        }
        self.present(noInternetPopUpController, animated: true)
    }
    func loadFeatures(){
        for (index, feature) in featureArray.enumerated(){
            if  let featureView = Bundle.main.loadNibNamed("FirstScrollView", owner: self, options: nil)?.first as? FirstScrollView{
                featureView.featureImageView.image = UIImage(named: feature["image"]!)
                featureView.titleUILabel.text = feature["title"]
                featureView.descriptionUILabel.text = feature["description"]
                LoginScrollView.addSubview(featureView)
                featureView.frame.size.width = self.view.bounds.size.width
                featureView.frame.origin.x = CGFloat( index) * self.view.bounds.size.width
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.size.width
        featurePageControl.currentPage = Int(page)

    }
   
    func showLoginRegisterPopUp(isRegisterring: Bool){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let demandDialogController = storyBoard.instantiateViewController(withIdentifier: "demandDialog") as! ActivationCodeDemandViewController
        demandDialogController.isRegisterring = isRegisterring
        demandDialogController.modalTransitionStyle = .crossDissolve
        demandDialogController.isModalInPopover = true
        demandDialogController.modalPresentationStyle = .overCurrentContext
        demandDialogController.onDoneBlock = { result in
        // if true mean comming from registerring if false comming from login
            if result {
                self.navigateToMain(isCommingFromRegister: isRegisterring)
                self.dismiss(animated: true, completion: nil)
            }
            else{
                self.navigateToMain(isCommingFromRegister: isRegisterring)
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(demandDialogController, animated: true)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
