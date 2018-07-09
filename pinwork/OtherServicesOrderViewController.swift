import UIKit

class OtherServicesOrderViewController: UIViewController {

    
    
    
    
    @IBOutlet weak var dateTimeButton: UIButton!
    
    @IBOutlet weak var addressButton: UIButton!
    
    @IBAction func timeDateButtunClicked(_ sender: UIButton) {
    }
    
    
    @IBAction func addressInfoButtonClicked(_ sender: UIButton) {
        
        showMap()
        
    }
    func showMap(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mapViewInstance = storyBoard.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
        mapViewInstance.isCommingFromNavigation = false
        mapViewInstance.modalTransitionStyle = .crossDissolve
        mapViewInstance.isModalInPopover = true
        mapViewInstance.modalPresentationStyle = .overCurrentContext
        self.present(mapViewInstance, animated: true)
//        mapViewInstance.onDoneBlock = { result in
//            // Do something
//
//
//        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateTimeButton.layer.borderWidth = 1
        addressButton.layer.borderWidth = 1
        dateTimeButton.layer.cornerRadius = 8
        addressButton.layer.cornerRadius = 8
        dateTimeButton.layer.borderColor = getPinworkColors(color: 1).cgColor
        addressButton.layer.borderColor = getPinworkColors(color: 1).cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
