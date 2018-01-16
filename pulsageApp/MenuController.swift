import UIKit
import Parse

//Mark: This is the menu delegate
protocol MenuDeledate {
    func buttonPressed(buttonPre: String)
}

class MenuController: NSObject {
    
    //menu delegate
    var delegate: MenuDeledate?
    
    //Mark: Menu objects ==============================================
    public lazy var createChallenge: UIButton = {
        let button                = UIButton()
        button.backgroundColor    = .orange
        button.frame              = CGRect(x: 20, y: 20, width: self.ButtonContainer.frame.size.width - 40, height: 60)
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(redirectToCreateCha), for: .touchUpInside)
        button.setTitle("Create Challenge", for: .normal)
        return button
    }()
    
    public lazy var feedBack: UIButton = {
        let button             = UIButton()
        button.backgroundColor = .clear
        button.frame           = CGRect(x: 20, y: 90, width: self.ButtonContainer.frame.size.width - 40, height: 60)
        button.addTarget(self, action: #selector(self.feedback), for: .touchUpInside)
        button.setTitle("Feed Back", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    public lazy var challengeAccepted: UIButton = {
        let button             = UIButton()
        button.frame           = CGRect(x: 20, y: 170, width: self.ButtonContainer.frame.size.width - 40, height: 60)
        button.backgroundColor = .clear
        button.setTitle("Challenges Accepted", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    public lazy var login: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 20, y: 330, width: self.ButtonContainer.frame.size.width - 40, height: 60)
        button.addTarget(self, action: #selector(self.logoutAndlogin), for: .touchUpInside)
        return button
    }()
    public lazy var Profile: UIButton = {
        let button = UIButton()
        button.setTitle("Settings", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 20, y: 250, width: self.ButtonContainer.frame.size.width - 40, height: 60)
        button.addTarget(self, action: #selector(redirectToProfile), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var ButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var menu: UIView = {
        let viewmenu = UIView()
        viewmenu.backgroundColor = UIColor(red:0.13, green:0.11, blue:0.18, alpha:0.6)
        viewmenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDissmiss)))
        return viewmenu
    }()
    override init() {
        super.init()
    }
    
    public func PresentMenu() {
        if let window = UIApplication.shared.keyWindow {
            let width = window.bounds.size.width
            let height = window.bounds.size.height
        
            self.menu.addSubview(self.ButtonContainer)
            self.ButtonContainer.frame = CGRect(x: width / 2 - 135, y: height / 2 - 200, width: 270, height: 400)
            self.ButtonContainer.addSubview(self.feedBack)
            self.ButtonContainer.addSubview(self.challengeAccepted)
            self.ButtonContainer.addSubview(self.login)
        
            //if user login =====================
            if PFUser.current() == nil {
                self.login.setTitle("Login", for: .normal)
            } else {
                self.login.setTitle("Log Out", for: .normal)
            }
        
            self.ButtonContainer.addSubview(self.Profile)
            self.ButtonContainer.addSubview(self.createChallenge)
            self.menu.frame = window.bounds
        
            window.addSubview(self.menu)
    
            self.menu.alpha = 0
        
            UIView.animate(withDuration: 0.6, animations: {
                self.menu.alpha = 1
            })
        }
    }
    
    @objc fileprivate func handleDissmiss() {
        UIView.animate(withDuration: 0.5) {
            self.menu.alpha = 0
        }
    }
    
    //Mark: button functions
    @objc fileprivate func redirectToCreateCha() {
        self.delegate?.buttonPressed(buttonPre: "challenge")
        self.handleDissmiss()
    }
    
    @objc fileprivate func feedback() {
        self.delegate?.buttonPressed(buttonPre: "feedback")
        self.handleDissmiss()
    }
    
    @objc fileprivate func redirectToProfile() {
        self.delegate?.buttonPressed(buttonPre: "settings")
        self.handleDissmiss()
        
    }
    
    @objc fileprivate func logoutAndlogin() {
        self.delegate?.buttonPressed(buttonPre: "session")
        self.handleDissmiss()
    }
    //======================= end of menu objects ============================
}

