//
//  MainViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/7/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var hamButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var hambutton: UIButton!
    @IBOutlet weak var homecleanButton: UIButton!
    @IBOutlet weak var officeButton: UIButton!
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var garageButton: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var otherServicesButton: UIButton!
    var slideMenu: UIView!
    var reservedOrderButton : UIButton?
    var isCommingFromRegister = false
    var goForRegisterNow = false
    var isMenuShowing = false
    var pageControl : UIPageControl?
    var currentPage = 0
    
    @IBAction func officeButtonCliecked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueToDateTimeOrder", sender: sender)

    }
    @IBAction func homeButtonCliecked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueToDateTimeOrder", sender: sender)
        
    }
    @IBAction func garageButtonCliecked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueToParkingOrder", sender: sender)
        
    }
    @IBAction func carButtonCliecked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "carWashSegue", sender: sender)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToOrder" {
            switch (sender as! UIButton).restorationIdentifier {
             
         
                
            case "garage":
               // if let destination = segue.destination as? OrderViewController {
                   // destination.orderType = .garageCleaning // you can pass value to destination view controller
                    
                    // destination.nomb = arrayNombers[(sender as! UIButton).tag] // Using button Tag
               // }
                break
            default:
                print("somethin went wrong in prepare main")
            
            }
        
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
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //self.navigationController?.navigationBar.isUserInteractionEnabled = false

        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(recognizer:)))
        self.view.isUserInteractionEnabled = true
        //self.view.addGestureRecognizer(tapGestureRecognizer)
        configureMainScroll()
       
        reservedOrderButton = getUIBarButtonItem(title: " سفارش‌های رزرو شده ", image: "invoice")
        var items = [UIBarButtonItem]()
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append( UIBarButtonItem(customView: reservedOrderButton!))
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        reservedOrderButton!.addTarget(self, action: #selector(self.reservedOrderClicked), for: .touchUpInside)
        self.toolbarItems = items

        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scrollMe),userInfo: nil , repeats: true)
        configurePageController()


    }
    override func viewDidAppear(_ animated: Bool) {
        configureSliderMenu()

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
        if isCommingFromRegister{
                    hambutton.isHidden = true
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
    func configureSliderMenu(){
        slideMenu = UIView(frame: CGRect(x: self.view.frame.width - CGFloat(200), y: CGFloat(0), width: CGFloat(200), height: self.view.frame.height))
        slideMenu.backgroundColor = UIColor.white
        slideMenu.translatesAutoresizingMaskIntoConstraints = false
        slideMenu.layer.shadowOpacity = 1
        slideMenu.layer.shadowRadius = 10
        //slideMenu.layer.shadowColor = getPinworkColors(color: 0).cgColor
        self.view.addSubview(slideMenu)
        let heightConstraint = NSLayoutConstraint(item: slideMenu, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: slideMenu, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200)
        let leadingConstraint = NSLayoutConstraint(item: slideMenu, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        self.view.addConstraints([ heightConstraint,widthConstraint,leadingConstraint])
        loadSliderMenuFeatures()
        slideMenu.isHidden = true
    
    }
    func loadSliderMenuFeatures(){
        if  let menuFeatures = Bundle.main.loadNibNamed("SliderMenuFeaturesView", owner: self, options: nil)?.first as? SliderMenuFeaturesView{
            menuFeatures.frame.size.height = slideMenu.frame.height
            slideMenu.addSubview(menuFeatures)
            menuFeatures.previouseOrdersButton.semanticContentAttribute = .forceRightToLeft
            menuFeatures.eminentWorkersButton.semanticContentAttribute = .forceRightToLeft
            menuFeatures.supportButton.semanticContentAttribute = .forceRightToLeft
            menuFeatures.shareButton.semanticContentAttribute = .forceRightToLeft
            menuFeatures.aboutButton.semanticContentAttribute = .forceRightToLeft
            menuFeatures.logoutButton.semanticContentAttribute = .forceRightToLeft
             menuFeatures.editProfileButton.semanticContentAttribute = .forceRightToLeft

//            featureView.featureImageView.image = UIImage(named: feature["image"]!)
//            featureView.titleUILabel.text = feature["title"]
//            featureView.descriptionUILabel.text = feature["description"]
//            LoginScrollView.addSubview(featureView)
//            featureView.frame.size.width = self.view.bounds.size.width
//            featureView.frame.origin.x = CGFloat( index) * self.view.bounds.size.width
        }
        else{
            print("err")
        }
    }
  
    func loadFeatures(){
        let featureArray = ["1.jpg","2.jpg","3.jpg"]
        
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
        print("reserved clicked")
    }
    @IBAction func hamButtonClicked(_ sender: UIButton) {
        let sliderConstraint = view.constraints.filter({ $0.firstAttribute == .leading && $0.firstItem as? UIView == slideMenu }).first!
        if isMenuShowing{

            sliderConstraint.constant = 0
            UIView.animate(withDuration: 0.3,animations: {
                self.view.layoutIfNeeded()

            }, completion: { (finished: Bool) in
                self.slideMenu.isHidden = !self.slideMenu.isHidden
            })
        }else{
            sliderConstraint.constant = -200
            UIView.animate(withDuration: 0.6, animations: {self.view.layoutIfNeeded()
                self.slideMenu.isHidden = !self.slideMenu.isHidden

            })
        }
        isMenuShowing = !isMenuShowing
    }
}
