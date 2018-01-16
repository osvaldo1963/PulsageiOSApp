import UIKit
import Font_Awesome_Swift
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

class TabBar: UITabBarController, UITabBarControllerDelegate {
    
    //Mark: Menu and feedback Controllers
    fileprivate let menuController = MenuController()
    fileprivate let feedbackController = FeedbackController()
   
    
    //Mark: initial view functions =================================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.setTabBar()
        self.menuController.delegate = self
        self.feedbackController.delegate = self
        self.navigationItem.hidesBackButton = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
        self.setNavbarProp()
        //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.green], for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.translatesAutoresizingMaskIntoConstraints = false
        self.tabBarController?.tabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.tabBarController?.tabBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.tabBarController?.tabBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.tabBarController?.tabBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let newTabBarFrame = tabBar.frame
        tabBar.frame = newTabBarFrame
        tabBar.tintColor = UIColor.black
        tabBar.barTintColor = .white
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.green], for: .normal)
        tabBar.unselectedItemTintColor = UIColor.lightGray
        
        
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
        let home        = Home()
        let homeicon    = UIImage.init(icon: .FAHome, size: CGSize(width: 42, height: 42))
        let hometabitem = UITabBarItem(title: nil, image: homeicon, tag: 1)
        
        let searchr       = search()
        let searchicon    = UIImage.init(icon: .FASearch, size: CGSize(width: 40, height: 40))
        let searchtabitem = UITabBarItem(title: nil, image: searchicon, tag: 2)

        let posts       = PostTab()
        let posticon    = UIImage.init(icon: .FAPlusSquareO, size: CGSize(width: 42, height: 42))
        let posttabitem = UITabBarItem(title: nil, image: posticon, tag: 3)
        
        let noti        = notifications()
        let noticon     = UIImage.init(icon: .FABell, size: CGSize(width: 40, height: 40))
        let notitabitem = UITabBarItem(title: nil, image: noticon, tag: 4)
        
        let pro        = profile()
        let proicon    = UIImage.init(icon: .FAUser, size: CGSize(width: 40, height: 40))
        let protabitem = UITabBarItem(title: nil, image: proicon, tag: 5)
        
        home.tabBarItem    = hometabitem
        searchr.tabBarItem = searchtabitem
        posts.tabBarItem   = posttabitem
        noti.tabBarItem    = notitabitem
        pro.tabBarItem     = protabitem
        self.viewControllers = [home, searchr, posts, noti, pro]
    }
    //===========================================================================
    
    //Mark: Navigation bar props and functions ==================================
    fileprivate func setNavbarProp() {
        let videoIcon      = UIImage.init(icon: .FAVideoCamera, size: CGSize(width: 25, height: 30))
        let videoCameraBtn = UIBarButtonItem(image: videoIcon, style: .plain, target: self, action: #selector(cameraFunction))
        let menuIcon       = UIImage.init(icon: .FAEllipsisH, size: CGSize(width: 25, height: 30))
        let menuBtn        = UIBarButtonItem(image: menuIcon, style: .plain, target: self, action: #selector(Menu))
        
        self.navigationItem.setRightBarButtonItems([menuBtn ], animated: true)
        
        let feedbackBtn = UIBarButtonItem(title: "Feedback", style: .done, target: self, action: nil)
        feedbackBtn.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Light", size: 16)!], for: .normal)
        self.navigationItem.setLeftBarButtonItems([feedbackBtn], animated: true)
        
        
        let attributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
    }
    // Mark: present Camera view controller
    @objc fileprivate func cameraFunction() {
        if PFUser.current() != nil {
            self.navigationController?.pushViewController(CameraRecorded(), animated: true)
        } else {
            let presenationViewcontroller = UINavigationController(rootViewController: Presentation())
            self.present(presenationViewcontroller, animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func presetFeebBackController() {
        self.feedbackController.presetFeebBackController()
    }
    
    @objc fileprivate func Menu() {
        self.menuController.PresentMenu()
    }
    
    @objc fileprivate func presentLoginController() {
        self.view.endEditing(true)
        let loginview = UINavigationController(rootViewController: Presentation())
        self.present(loginview, animated: true, completion: nil)
    }
    
    //===========================================================================
}

//Mark: This delegate data is the result of the button pressed
extension TabBar: MenuDeledate {
    func buttonPressed(buttonPre: String) {
        switch buttonPre {
        case "challenge":
            self.selectedIndex = 2
        case "feedback":
            self.presetFeebBackController()
        case "settings":
            let settingsview = Settings()
            self.navigationController?.pushViewController(settingsview, animated: true)
        case "session":
            if PFUser.current() != nil {
                PFUser.logOut()
                FBSDKLoginManager().logOut()
                self.selectedIndex = 0
            } else {
               self.presentLoginController()
            }
        default:
            break
        }
    }
}
//End Mark

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
