import UIKit

class MenuViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var loadingView : UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var userCreditLabel: UILabel!
    @IBOutlet weak var userOrdersCountLabel: UILabel!
    
   
    var user : User?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMenu()
   

    }
    override func viewWillAppear(_ animated: Bool) {
        configureMenu()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (7/100)*UIScreen.main.bounds.height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "menuCell",for:indexPath) as! MenuTableViewCell
        cell.menuTextItem.text = MenuAttributes.menuTitles[indexPath.row]
        cell.menuImageItem.image = UIImage(named: MenuAttributes.menuImages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuAttributes.menuImages.count
        // your number of cell here
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToAppropriateView(indexPath.row)
    }
    
    
    
    
    
    func  configureMenu(){
        self.navigationItem.title = "منو"

    self.navigationController?.setToolbarHidden(true, animated: false)
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    self.userNameLabel.text = user!.name + " " + user!.lastName
    self.userCreditLabel.text = String(user!.money).convertToPersian()
    self.userOrdersCountLabel.text = String(user!.orders_count).convertToPersian()
     
        
        
    
    }
    
    func navigateToAppropriateView(_ index:Int){
        switch index {
        case 0:
            previousOrders()
//        case 1:
//            break
        case 1:
            editProfile()
//        case 3:
//            break
//        case 4:
//            break
        case 2:
            aboutUs()
        case 3:
            showSureNessDialogue().onDoneBlock = { result in //if true mean logout else dont
                
                if result{
            self.logout()
                }}
        default:
            break
        }
    }
    
    
    func aboutUs(){
        performSegue(withIdentifier: "aboutUsSegue", sender: self)
        
        
    }
    func logout(){
        loadingView = displaySpinner(onView: self.view)
        APIClient.requestForUserLogOut(rememberToken: self.getData(key: "rememberToken") as! String) { (response, error) in
            self.removeSpinner(spinner: self.loadingView)
            if response != nil{
                if self.tokenHasExpired(response!["respond"].intValue){
                    self.showTokenExpiredPopUp()
                }
                else{
                self.updataData(key: "isLoggedIn", value: false)
                self.updataData(key: "rememberToken", value: "none")
                self.updataData(key: "tempRememberToken", value: response!["data"]["remember_token"].string!)
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                self.navigateToLoginPage()

            }}else{
                let retry = self.showNetworkRetryPopUp()
                retry.onDoneBlock = { result in
                    self.logout()
                    
                }
            }
                }
                
            }
    
        

    func showSureNessDialogue()-> SureAboutLogOutViewController{
    
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let SureLogoutPopUpController = storyBoard.instantiateViewController(withIdentifier: "sureAboutLogout") as! SureAboutLogOutViewController
        SureLogoutPopUpController.modalTransitionStyle = .crossDissolve
        SureLogoutPopUpController.isModalInPopover = true
        SureLogoutPopUpController.modalPresentationStyle = .overCurrentContext
        self.present(SureLogoutPopUpController, animated: true)
        return SureLogoutPopUpController
        
        
        
    }
    
    func navigateToLoginPage(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginPageView = storyBoard.instantiateViewController(withIdentifier: "LoginPageViewController") as! LoginPageViewController
        
        loginPageView.modalTransitionStyle = .flipHorizontal
        self.present(loginPageView, animated: true, completion: nil)
    }
    
    func previousOrders(){
        performSegue(withIdentifier: "OrdersTableViewSegue", sender: self)
    }
    func editProfile(){
        performSegue(withIdentifier: "editProfileSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            if let editProfileView = segue.destination as? EditProfileViewController{
                editProfileView.user = self.user
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
  
    
    
    
    
    
    
  

}
