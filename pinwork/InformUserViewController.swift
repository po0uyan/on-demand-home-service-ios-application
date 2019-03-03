import UIKit
import Lottie

class InformUserViewController: UIViewController {
  
        let animationView = LOTAnimationView(name: "newmessage")
        var serviceCode = ""
        @IBOutlet weak var containerView: UIView!
        @IBOutlet weak var dissmissButton: UIButton!
        @IBOutlet weak var doneAnimationView: UIView!
        var message : String = ""
    @IBOutlet weak var messageLabel: UILabel!
    
    
        var onDoneBlock : ((Bool) -> Void)?
        
        override func viewDidLoad() {
            super.viewDidLoad()
        
            
            containerView.clipsToBounds = true
            containerView.layer.cornerRadius = 8
            dissmissButton.clipsToBounds = true
            dissmissButton.layer.cornerRadius = 8
            messageLabel.text = self.message
            dissmissButton.layer.shadowColor = UIColor(red:0.02, green:0.29, blue:0.36, alpha:1.0).cgColor
            dissmissButton.layer.shadowOffset = CGSize(width: 4, height: 4)
            dissmissButton.layer.shadowRadius = 2
            dissmissButton.layer.shadowOpacity = 0.5
            // Do any additional setup after loading the view.
        }
        
        
        @IBAction func dissmissClicked(_ sender: UIButton) {
            self.dismiss(animated: true)
            onDoneBlock!(true)
            
        }
        
        
        override func viewDidAppear(_ animated: Bool) {
            animationView.frame = CGRect(x: self.doneAnimationView.frame.origin.x, y: self.doneAnimationView.frame.origin.y, width: self.doneAnimationView.frame.width, height: self.doneAnimationView.frame.height)
            animationView.center = self.doneAnimationView.center
            animationView.contentMode = .scaleAspectFit
            
            self.doneAnimationView.addSubview(animationView)
            
            animationView.play()
            animationView.loopAnimation = true
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
