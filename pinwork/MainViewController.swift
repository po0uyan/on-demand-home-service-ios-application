//
//  MainViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/7/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
import ENMBadgedBarButtonItem
class MainViewController: UIViewController, UIScrollViewDelegate {
    
    var leftBarButton : BadgedBarButtonItem!
    @IBOutlet weak var homecleanButton: UIButton!
    @IBOutlet weak var officeButton: UIButton!
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var garageButton: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var otherServicesButton: UIButton!
    var animationView: UIView!
    var slideMenu: UIView!
    var user : User?
    var reservedOrderButton : UIButton?
    static var isCommingFromRegister = false
    var goForRegisterNow = false
    var isMenuShowing = false
    var pageControl : UIPageControl?
    var currentPage = 0
    
    @IBAction func officeButtonCliecked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueToDateTimeOrder", sender: sender)

    }
    @IBAction func homeButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueToDateTimeOrder", sender: sender)
        
    }
    @IBAction func garageButtonCliecked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueToParkingOrder", sender: sender)
        
    }
    @IBAction func carButtonCliecked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "carWashSegue", sender: sender)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OtherServicesSegue" {
          //maybe something later for other Services
        
        }
        else if segue.identifier == "carWashSegue"{
          
        }
        else if segue.identifier == "segueToDateTimeOrder"{
            switch (sender as! UIButton).restorationIdentifier {
            case "home":
                if let destination = segue.destination as? OrderDateTimeViewController {
                    destination.orderType = .homeCleaning // you can pass value to destination view controller
                    
                    // destination.nomb = arrayNombers[(sender as! UIButton).tag] // Using button Tag
                }
            case "office":
                if let destination = segue.destination as? OrderDateTimeViewController {
                    destination.orderType = .officeCleaning // you can pass value to destination view controller
                    
                    // destination.nomb = arrayNombers[(sender as! UIButton).tag] // Using button Tag
                }
            default:
                break
            
        }
        }
        else if segue.identifier == "MenuSegue"{
         if let menuInstance = segue.destination as? MenuViewController {
            menuInstance.user = self.user
            }
        }
        else if segue.identifier == "reservedOrdersSegue"{
            if let reservedOrderInstance = segue.destination as? OrdersTableViewController{
                reservedOrderInstance.isReservedOrder = true
            }
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setUpMenuButton()
            self.setUpNotificationButton()
        }
        reservedOrderButton?.isEnabled = false
        reservedOrderButton = getUIBarButtonItemForNextLevel(title: " سفارش‌های رزرو شده ", image: "invoice")
        var items = [UIBarButtonItem]()
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append( UIBarButtonItem(customView: reservedOrderButton!))
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        reservedOrderButton!.addTarget(self, action: #selector(self.reservedOrderClicked), for: .touchUpInside)
        self.toolbarItems = items
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scrollMe),userInfo: nil , repeats: true)
   
        if !MainViewController.isCommingFromRegister{
            navigationController?.setToolbarHidden(false, animated: false)
            configureSliderMenu()
            
        }else{
            navigationController?.setToolbarHidden(true, animated: false)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
   
        if !MainViewController.isCommingFromRegister{
            navigationController?.setToolbarHidden(false, animated: false)
            
        }else{
            navigationController?.setToolbarHidden(true, animated: false)
            
            
        }
        DispatchQueue.main.async {
            self.configurePageController()
            self.configureMainScroll()
        }
     


    }
    func setUpMenuButton(){
        if MainViewController.isCommingFromRegister{
            leftBarButton = nil
        }
        else{
        
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 24, height: 24)
        menuBtn.setImage(UIImage(named:"menu-button"), for: .normal)
        menuBtn.addTarget(self, action: #selector(showMenu), for: UIControlEvents.touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItem
        
        
        }
        
    }
    func setUpNotificationButton(){
        if MainViewController.isCommingFromRegister{
            leftBarButton = nil
        }
        else{
        let image = UIImage(imageLiteralResourceName: "notification")
        
        let buttonFrame: CGRect = CGRect(x: 0.0, y: 0.0, width: 24, height: 24)
        let barButton = BadgedBarButtonItem(
            startingBadgeValue: 0,
            frame: buttonFrame,
            image: image
        )
        let currWidth = barButton.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = barButton.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        
        leftBarButton = barButton
        leftBarButton.addTarget(self, action: #selector(notifButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButton
        }
        
    }
    
    func setUpReservedButton(){
        let image = UIImage(imageLiteralResourceName: "notification")
        
        let buttonFrame: CGRect = CGRect(x: 0.0, y: 0.0, width: 24, height: 24)
        let barButton = BadgedBarButtonItem(
            startingBadgeValue: 0,
            frame: buttonFrame,
            image: image
        )
        let currWidth = barButton.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = barButton.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        
        leftBarButton = barButton
        leftBarButton.addTarget(self, action: #selector(notifButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func configureSliderMenu(){
       
        animationView =  displaySpinner(onView: self.view)
        APIClient.requestForUserProfile(rememberToken: getData(key: "rememberToken") as! String) { (response, error) in
            if response != nil {
                if self.tokenHasExpired(response!["respond"].intValue){
                    self.showTokenExpiredPopUp()
                }
                else{
                let data = response!["data"]["profile"]
                if data["name"].stringValue == "Pin" && data["lastname"].stringValue == "Work" {
                    
                    self.showCompeleteRegisterView()
                    self.removeSpinner(spinner: self.animationView)
                    return
                }
                self.user = User(name: data["name"].string!, lastName: data["lastname"].string!, picture: data["picture"].string!, birthDay: self.check(data["birthday"]), email: self.check(data["email"]), phone_place: data["phone_place"].string!,
                    cellPhone: data["phone"].string!,
                    orders_count:data["orders_count"].intValue,orders_duration: data["orders_duration"].intValue, gender: User.genderType(rawValue: data["gender"].string!)!, money: data["money"].intValue, invite_hash: self.check(data["invite_hash"]), notification_unseen_count: response!["data"]["notification_unseen_count"].intValue, messages_unseen_count: response!["data"]["messages_unseen_count"].intValue)
                self.leftBarButton.badgeValue = self.user!.notification_unseen_count
                //self.hambutton.isEnabled = true
                self.reservedOrderButton?.isEnabled = true

            }}else{
                let retry = self.showNetworkRetryPopUp()
                retry.onDoneBlock = { result in
                    self.configureSliderMenu()
                }
            }
            self.removeSpinner(spinner: self.animationView)
            
        }
        
    }
    func showCompeleteRegisterView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let completeRegisterView = storyBoard.instantiateViewController(withIdentifier: "compeleteRegister") as! CompeleteRegisterFormViewController
        completeRegisterView.modalTransitionStyle = .crossDissolve
        completeRegisterView.isModalInPopover = true
        completeRegisterView.modalPresentationStyle = .overCurrentContext
        self.present(completeRegisterView, animated: true)
        completeRegisterView.onDoneBlock = {result in 
            self.configureSliderMenu()
        }
        
    }
    func configureMainScroll(){
        mainScrollView.delegate = self
        mainScrollView.isPagingEnabled = true
        mainScrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(3), height: 0  )
        
        mainScrollView.sizeToFit()
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.alwaysBounceHorizontal = true
        mainScrollView.isDirectionalLockEnabled = true
        loadFeatures()

    }
    @objc func viewTapped(recognizer:UITapGestureRecognizer){
    //print("viewTapped")
        
    }
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        //check if is after registration
        if MainViewController.isCommingFromRegister{
                    //hambutton.isHidden = true
                    self.navigationController?.setToolbarHidden(true, animated: false)
        }

    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }

    func configurePageController(){
          pageControl = UIPageControl(frame: CGRect(x:self.view.frame.midX - 50 ,y: mainScrollView.frame.height - 30, width:100, height:40))
        self.pageControl!.numberOfPages = 3
        self.pageControl!.currentPage = 0
        self.pageControl!.pageIndicatorTintColor = getPinworkColors(color: 1)
        self.pageControl!.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl!)
        
    }
 
  
   @objc func showMenu(){
        
        performSegue(withIdentifier: "MenuSegue", sender: self)
    }
    func loadFeatures(){
        let featureArray = ["1.png","2.png","3.png"]
        
        for (index, image) in featureArray.enumerated(){
           let view = UIImageView(frame: CGRect(x: CGFloat(index)*self.view.frame.width, y: 0, width:  self.view.frame.width, height: mainScrollView.frame.height ))
            view.image = UIImage(named: image)
                
                mainScrollView.addSubview(view)
            
            
        }
    }
    @objc func scrollMe(){
        currentPage = currentPage % 3
        mainScrollView.setContentOffset(CGPoint(x:CGFloat(currentPage) * mainScrollView.bounds.width, y: 0), animated: true)
        currentPage += 1
        pageControl!.currentPage = currentPage - 1
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //pageController.currentPage = scrollView. - 1
    }
  @objc  func reservedOrderClicked(){
        performSegue(withIdentifier: "reservedOrdersSegue", sender: self)
    }
 
    @objc func notifButtonTapped(){
        performSegue(withIdentifier: "notificationTabelViewSegue", sender: self)
        
    }
}
