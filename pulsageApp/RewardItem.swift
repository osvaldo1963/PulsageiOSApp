import UIKit
import Font_Awesome_Swift
import SDWebImage
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

import MobileCoreServices



class RewardItem: UIViewController {
    
    public var challengeid = ""
    
    let menuController = MenuController()
    let feedbackController = FeedbackController()
    
    var viewWidth: CGFloat {
        let result = self.view.frame.size.width
        return result
    }
    
    var  viewHeight: CGFloat {
        let result = self.view.frame.size.height
        return result
    }
    
    fileprivate lazy var sposorLogo: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .gray
        imageview.frame = CGRect(x: 10, y: 70, width: 50, height: 50)
        imageview.layer.cornerRadius = 25
        imageview.clipsToBounds = true
        return imageview
    }()
    
    fileprivate lazy var itemPicture: UIImageView = {
        let imageview = UIImageView()
        let fourheigth = self.viewHeight / 4
        imageview.frame = CGRect(x: 60, y: fourheigth - 40, width: self.viewWidth - 120, height: self.viewHeight / 3 + 40)
        imageview.backgroundColor = .clear
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    fileprivate lazy var itemDescription: UITextView = {
        let label = UITextView()
        label.frame = CGRect(x: 60, y: self.viewHeight / 3 + 180, width: self.viewWidth - 120, height: self.viewHeight / 4 + 20)
        label.text = "Some Description"
        label.textColor = .black
        label.isEditable = false
        label.textAlignment = .center
        
        return label
    }()
    
    fileprivate lazy var backButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.frame = CGRect(x: 60, y: self.viewHeight - 180, width: self.viewWidth - 120, height: 40)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let safeview = self.view.safeAreaLayoutGuide
        self.menuController.delegate = self
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.sposorLogo)
        self.view.addSubview(self.itemPicture)
        self.view.addSubview(self.itemDescription)
        self.view.addSubview(self.backButton)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Challenge Reward"
        self.getData()

    }
    
  
    // Mark: present Camera view controller
    @objc private func cameraFunction() {
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
    
    @objc private func Menu() {
        self.menuController.PresentMenu()
    }
    
    @objc fileprivate func presentLoginController() {
        self.view.endEditing(true)
        let loginview = UINavigationController(rootViewController: Presentation())
        self.present(loginview, animated: true, completion: nil)
    }
    
    fileprivate func getData() {
        let challengeQuery = PFQuery(className: "Rewards")
        challengeQuery.whereKey("objectId", equalTo: self.challengeid)
        challengeQuery.getFirstObjectInBackground { (data, error) in
            guard let reward = data else {return}
            guard let fromSponsor = reward["from"] as? String else {return}
            guard let rewardPictureUrl = reward["itemPicture"] as? PFFile else {return}
            guard let rewardDescription = reward["itemDescription"] as? String else {return}
            self.itemPicture.sd_setImage(with: rewardPictureUrl.getImage())
            self.itemDescription.text = rewardDescription
            self.getSponsorData(id: fromSponsor)
        }
       
    }
    
    fileprivate func getSponsorData(id: String){
        let sponsorQuery = PFQuery(className: "SponsorAccounts")
        sponsorQuery.whereKey("objectId", equalTo: id)
        sponsorQuery.getFirstObjectInBackground { (data, error) in
            guard let sponsor = data else {return}
            guard let sponsorLogo = sponsor["logo"] as? PFFile else {return}
            guard let sponsorName = sponsor["companyName"] as? String else {return}
            self.sposorLogo.sd_setImage(with: URL(string:sponsorLogo.url!))
        }
    }
    
    @objc func backBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func alert(message: NSString, title: NSString) -> Void {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
  
    //===========================================================================
    
}

extension RewardItem: MenuDeledate {
    func buttonPressed(buttonPre: String) {
        let tbbar = TabBar()
        switch buttonPre {
        case "challenge":
            tbbar.selectedIndex = 2
        
        case "feedback":
            self.presetFeebBackController()
        case "settings":
            let settingsview = Settings()
            self.navigationController?.pushViewController(settingsview, animated: true)
        case "session":
            if PFUser.current() != nil {
                PFUser.logOut()
                FBSDKLoginManager().logOut()
                tbbar.selectedIndex = 0
             
            } else {
                self.presentLoginController()
            }
        default:
            break
        }
    }
}


