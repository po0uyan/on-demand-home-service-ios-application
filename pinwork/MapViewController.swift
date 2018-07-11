import UIKit
import GoogleMaps
class MapViewController: UIViewController,GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var onDoneBlock : ((Bool) -> Void)?
    var isCommingFromNavigation = true
    @IBOutlet weak var submitButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressView: UIView!
    private let locationManager = CLLocationManager()
    @IBOutlet weak var addressLabel: UILabel!
    var OrderTillNow:Dictionary<String,Any> = [:]
    var addressDistrict = "آدرس انتخابی"
    var isRequestFailed = false
    var latestLocation = CLLocation(latitude: 35.723961, longitude: 51.410375)
    var requestArray = ["lat":"35.723961","long":"51.410375", "remember-token": "navidnavidnavidnavidnavidnavid"]
    @IBAction func submitClicked(_ sender: UIButton) {
        if isRequestFailed{
            requestLocation(requestArray)
        }
        else{
        showAddressPopUpView()
        }
        
    }
    @IBAction func pinButtonClicked(_ sender: UIButton) {
        showAddressPopUpView()
    }
    @IBOutlet weak var markerView: UIView!
    

    @IBAction func getMyLocation(_ sender: UIButton) {
            self.locationManager.startUpdatingLocation()
        
//         mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(true, animated: false)
        mapView.delegate = self
        locationManager.delegate = self
        configureMap()
        submitButton.layer.cornerRadius = 8
        submitButton.layer.shadowRadius = 5.0
            
        
    locationManager.requestWhenInUseAuthorization()
        addressView.clipsToBounds = true
        addressView.layer.cornerRadius = 10
  
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setToolbarHidden(false, animated: false)
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
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
       markerView.stopRotating()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.markerView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                    self.submitButtonConstraint.constant = (self.submitButton.frame.height+15)
                    self.view.layoutIfNeeded()
                
            }, completion: { (finished: Bool) in
                UIView.transition(with: self.submitButton, duration: 0.8, options: .curveEaseIn,
                                  animations: {
                                    // Animations
                                    self.submitButton.isHidden = true
                })
            })
        }
        
      

    }
    
     
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
         requestArray = ["lat":position.target.latitude.description,"long":position.target.longitude.description, "remember-token": "navidnavidnavidnavidnavidnavid"] //remove this token
        requestLocation(requestArray)
    }
    func requestLocation(_ requestArray:[String:String]){
        addressLabel.text = "در حال بارگیری آدرس شما ..."
        self.addressLabel.textColor = UIColor.black
        UIView.animate(withDuration: 0.3, animations: {
            self.markerView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.submitButtonConstraint.constant = (self.submitButton.frame.height+15)
            self.view.layoutIfNeeded()
            
        }, completion: { (finished: Bool) in
            
            
            
            
            APIClient.reverseAddressService(requestArray: requestArray) { (response, error) in
                self.markerView.stopRotating()
                UIView.animate(withDuration: 0.4, animations: {
                    self.markerView.transform = CGAffineTransform.identity
                }, completion: { (finished: Bool) in
                    
                })
                //self.markerView.transform = CGAffineTransform.identity
                if response != nil {
                    self.isRequestFailed = false
                    self.submitButton.setTitle("تایید آدرس", for: .normal)
                    self.addressLabel.textColor = UIColor.black

                    let res =  (response!["data"] as! NSDictionary )["localAddress"] as? String
                    self.addressLabel.text = res
                }
                else{
                    //debugPrint(error as Any)
                    self.addressLabel.text = "خطا در ارتباط "
                    self.addressLabel.textColor = UIColor.red
                    self.submitButton.setTitle("تلاش مجدد", for: .normal)
                    self.isRequestFailed = true
                    
                    
                }
                UIView.animate(withDuration: 0.3, animations: {
                    self.submitButton.isHidden = false
                    self.submitButtonConstraint.constant = -15
                    self.view.layoutIfNeeded()
                })
                
                
            }
            self.markerView.rotate()
            
        })
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
            if !self.isCommingFromNavigation{
                self.dismiss(animated: true)
            }
            
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
extension UIView {
    private static let kRotationAnimationKey = "rotationanimationkey"
    
    func rotate(duration: Double = 0.6) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.scale.x")
            
            rotationAnimation.fromValue = 0.7
            rotationAnimation.toValue = -0.7
            rotationAnimation.duration = duration
            rotationAnimation.autoreverses = true
            rotationAnimation.repeatCount = Float.infinity
            
            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }
    
    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
}

