//
//  MapViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/24/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
import GoogleMaps
import Lottie
class MapViewController: UIViewController,GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var submitButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailLoadingView: UIView!
    @IBOutlet weak var addressView: UIView!
    private let locationManager = CLLocationManager()
    @IBOutlet weak var addressLabel: UILabel!
    var addressDistrict = "آدرس انتخابی"
    @IBAction func submitClicked(_ sender: UIButton) {
        
        showAddressPopUpView()
    }
    @IBOutlet weak var markerView: UIView!
    
    let animationView = LOTAnimationView(name: "trail_loading")

    @IBAction func getMyLocation(_ sender: UIButton) {
            self.locationManager.startUpdatingLocation()
        
//         mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        configureMap()
        submitButton.layer.cornerRadius = 8
        submitButton.layer.shadowRadius = 5.0
            
        
    locationManager.requestWhenInUseAuthorization()
        addressView.clipsToBounds = true
        addressView.layer.cornerRadius = 10
        configureAnimation()
        animationView.play()
    }
    func configureMap(){
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        let location = CLLocation(latitude: 35.723961, longitude: 51.410375)
         mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
        
     
        
        
    }
    func configureAnimation(){
        animationView.frame = trailLoadingView.bounds.applying(trailLoadingView.transform)
        animationView.contentMode = .scaleAspectFill
        self.trailLoadingView.addSubview(animationView)
        animationView.loopAnimation = true
        animationView.isHidden = true
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
       
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.markerView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                    self.submitButtonConstraint.constant = -(self.submitButton.frame.height+8)
                    self.view.layoutIfNeeded()
                
            })
        }
        
      

    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        UIView.animate(withDuration: 0.4, animations: {
            self.markerView.transform = CGAffineTransform.identity
        })
        
        let requestArray = ["lat":position.target.latitude.description,"long":position.target.longitude.description, "remember-token": "navidnavidnavidnavidnavidnavid"] //remove this token
        self.animationView.isHidden = false
        APIClient.reverseAddressService(requestArray: requestArray) { (response, error) in
            self.animationView.isHidden = true
            if response != nil {
                let res =  (response!["data"] as! NSDictionary )["localAddress"] as? String
                self.addressLabel.text = res
            }
            else{
                debugPrint(error as Any) 

            }
            UIView.animate(withDuration: 0.3, animations: {
                self.submitButtonConstraint.constant = 8
                self.view.layoutIfNeeded()
                })
  
            
        }
    }
 
    

    
    func showAddressPopUpView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let addressPopUpController = storyBoard.instantiateViewController(withIdentifier: "addressPopUpView") as! AddressPopUpViewController
//        addressPopUpController.isCritical = false
//        addressPopUpController.isLoggedIn = isLoggedIn()
        addressPopUpController.modalTransitionStyle = .coverVertical
        addressPopUpController.isModalInPopover = true
        addressPopUpController.modalPresentationStyle = .overCurrentContext
        self.present(addressPopUpController, animated: true)
        //addressDistrict = addressLabel.text?.split(separator: "،")[0]
        addressPopUpController.addressTextView.text = (addressLabel.text?.split(separator: "،")[1...].joined(separator: "،"))!
        
        addressPopUpController.onDoneBlock = { result in
            // Do something
//            if self.isLoggedIn(){
//                self.navigateToMain(isCommingFromRegister: false)
//            }
//            else{
//                self.navigateToLoginPage()
//            }
        
        
        
        }
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
extension MapViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            print("we have to add internet location") //pop up
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        //mapView.settings.myLocationButton = true
    }
    
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        mapView.animate(to: GMSCameraPosition(target: location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0))
        
        // 8
        locationManager.stopUpdatingLocation()
    }
    
    
   
}
