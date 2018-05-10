import UIKit
import Font_Awesome_Swift
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import AVFoundation

class TabBar: UITabBarController, UITabBarControllerDelegate {
    
    //Mark: Menu and feedback Controllers
    private let feedbackController = FeedbackController()
    
    //Mark: initial view functions =================================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.setTabBar()
        self.feedbackController.delegate = self
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.translatesAutoresizingMaskIntoConstraints = false
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.subcribeUserForPushNofification()
        }
        
        /*
        guard let currentuser = PFUser.current()?.objectId else {return }
        
        PFCloud.callFunction(inBackground: "sendpush", withParameters: ["id": "global", "message": "\(Date().description)", "sender": currentuser]) { (result, error) in
            print("result \(result)")
            print("error \(error)")
            
        }
        */
        
        self.setupMiddleButton(hidden: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    //============================================================
    // Mark: Notification Register Functions
    //============================================================
    
    private func subcribeUserForPushNofification() {
        let token = UserDefaults.standard
        guard let deviceToken = token.object(forKey: "deviceToken") as? Data else {return}
        guard let userid = PFUser.current()?.objectId else {return}
        
        let install = PFInstallation.current()
        install?.setDeviceTokenFrom(deviceToken)
        install?["channels"] = ["\(userid)", "global"]
        install?.saveInBackground { (success, error) in
            if error != nil {
                self.simpleAlert(Message: "Nofication Device Problem", title: "Device Registration")
            } else {
                self.checkUserInChannel(user: PFUser.current()!)
            }
        }
        
        PFPush.subscribeToChannel(inBackground: userid) { (success, error) in
            if error != nil {
                print(error.debugDescription)
                self.simpleAlert(Message: "Notifications Channel Problem", title: "Error")
            }
        }
    }
    
    private func checkUserInChannel(user: PFUser) {
        let query = PFQuery(className: "ChannelsPerUser")
        query.whereKey("User", equalTo: user)
        query.getFirstObjectInBackground { (result, error) in
            if error != nil {
                self.registerUserForChannel(user: user)
            }
        }
    }
    
    private func registerUserForChannel(user: PFUser) {
        guard let id = user.objectId else {return}
        let inserData = PFObject(className: "ChannelsPerUser")
        inserData["User"] = user
        inserData["userId"] = "\(id)"
        inserData["channels"] = ["global", id]
        inserData.saveInBackground { (success, error) in
            if error == nil {
                if !success {
                    self.simpleAlert(Message: "Check Connectivity", title: "Registering Device Problems")
                }
            }
        }
    }
    
    //============================================================
    // Mark: End Notification Register Functions
    //============================================================
    
    override func viewWillLayoutSubviews() {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.tabBarController?.tabBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.tabBarController?.tabBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.tabBarController?.tabBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let newTabBarFrame = tabBar.frame
        tabBar.frame = newTabBarFrame
        tabBar.tintColor = UIColor(red:0.88, green:0.37, blue:0.37, alpha: 1.0)
        tabBar.barTintColor = .white
        tabBar.unselectedItemTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        tabBarItem.titleTextAttributes(for: .normal)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        guard let array = viewControllers else {return}
        //set style props to navbar
        for controller in array {
            controller.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        }
    }
    
    //=====================================================================================
    
    //Mark: tab bar navigation bar props
    fileprivate func setTabBar() {
        let home        = UINavigationController(rootViewController: Home())
        let HomeIcon    = UIImage(named: "HomeIcon.png")
        let hometabitem = UITabBarItem(title: nil, image: HomeIcon, tag: 1)
        
        let searchr       = UINavigationController(rootViewController: search())
        let SearchIcon    = UIImage(named: "SearchIcon.png")
        let searchtabitem = UITabBarItem(title: nil, image: SearchIcon, tag: 2)

        let posts       = UINavigationController(rootViewController: PostTab())
        let posticon    = UIImage.init(icon: .FAPlusSquareO, size: CGSize(width: 42, height: 42))
        let posttabitem = UITabBarItem(title: nil, image: posticon, tag: 3)
        
        let noti        = UINavigationController(rootViewController: notifications())
        let NotificationIcon = UIImage(named: "NotificationIcon.png")
        let notitabitem = UITabBarItem(title: nil, image: NotificationIcon, tag: 4)
        
        let profiletab = ProfileTab()
        profiletab.rootView = true
        let pro        =  UINavigationController(rootViewController: profiletab)
        let ProfileIcon = UIImage(named: "ProfileIcon.png")
        let protabitem = UITabBarItem(title: nil, image: ProfileIcon, tag: 5)
        
        home.tabBarItem    = hometabitem
        searchr.tabBarItem = searchtabitem
        posts.tabBarItem   = posttabitem
        noti.tabBarItem    = notitabitem
        pro.tabBarItem     = protabitem
        self.viewControllers = [home, searchr, posts, noti, pro]
    }
 
    
    //===========================================================================
}


//Mark: This delegate is the result of the text typed
extension TabBar: FeedBackDelegate {
    func submitFeedback(feedbackText: String) {
        let object = PFObject(className: "FeedBack")
        object["feedback"] = feedbackText
        
        if PFUser.current() == nil {
            object["user"] = "none"
        } else {
            object["user"] = PFUser.current()?.objectId
        }
        object.saveInBackground { (success, error) in
            if success {
                //self.feedbackDissmiss()
                //self.feedbackTextinput.text = ""
            } else {
                self.simpleAlert(Message: "check your internet connection and try again", title: "Feedback Error")
            }
        }
    }
}
//End Mark
