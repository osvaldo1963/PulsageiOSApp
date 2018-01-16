import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import CryptoSwift

class SignUp: UIViewController {
    
    fileprivate lazy var EmailInput: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter Email"
        textfield.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
        textfield.layer.cornerRadius = 3
        textfield.setLeftPaddingPoints(6)
        textfield.keyboardType = .emailAddress
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    fileprivate lazy var passwordInput: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter Password"
        textfield.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
        textfield.layer.cornerRadius = 3
        textfield.setLeftPaddingPoints(6)
        textfield.isSecureTextEntry = true
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    fileprivate lazy var rePassInput: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Confirm Password"
        textfield.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
        textfield.layer.cornerRadius = 3
        textfield.setLeftPaddingPoints(6)
        textfield.isSecureTextEntry = true
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    fileprivate lazy var or: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var facebookLogin: BonceButton = {
        let button = BonceButton()
        button.setTitle("Log In with Facebook", for: .normal)
        button.backgroundColor = UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0)
        button.addTarget(self, action: #selector(loginManager), for: .touchUpInside)
        button.layer.cornerRadius = 26
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        
        self.Subviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let backArrow = UIImage.init(icon: .FAAngleLeft, size: CGSize(width: 40, height: 40))
        let backBtn = UIBarButtonItem(image: backArrow, style: .done, target: self, action: #selector(BackButtonAction))
        let login = UIBarButtonItem(title: "Sign Up", style: .plain, target: self, action: #selector(signUp))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = login
        self.navigationController?.navigationBar.topItem?.title = "Sign Up"
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = backBtn
    }
    
    fileprivate func Subviews() {
        self.EmailInput.becomeFirstResponder()
        ///
        self.view.addSubview(self.EmailInput)
        self.EmailInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        self.EmailInput.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.EmailInput.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor , constant: -15).isActive = true
        self.EmailInput.heightAnchor.constraint(equalToConstant: 45).isActive = true
        ///
        
        ///
        self.view.addSubview(self.passwordInput)
        self.passwordInput.topAnchor.constraint(equalTo: self.EmailInput.bottomAnchor, constant: 10).isActive = true
        self.passwordInput.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.passwordInput.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor , constant: -15).isActive = true
        self.passwordInput.heightAnchor.constraint(equalToConstant: 45).isActive = true
        ///
        
        ///
        self.view.addSubview(self.rePassInput)
        self.rePassInput.topAnchor.constraint(equalTo: self.passwordInput.bottomAnchor, constant: 10).isActive = true
        self.rePassInput.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.rePassInput.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor , constant: -15).isActive = true
        self.rePassInput.heightAnchor.constraint(equalToConstant: 45).isActive = true
        ///
        
        ///
        self.view.addSubview(self.or)
        self.or.topAnchor.constraint(equalTo: self.rePassInput.bottomAnchor, constant: 20).isActive = true
        self.or.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.or.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor , constant: -15).isActive = true
        self.or.heightAnchor.constraint(equalToConstant: 30).isActive = true
        ///
        
        ///
        self.view.addSubview(self.facebookLogin)
        self.facebookLogin.topAnchor.constraint(equalTo: self.or.bottomAnchor, constant: 20).isActive = true
        self.facebookLogin.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.facebookLogin.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor , constant: -15).isActive = true
        self.facebookLogin.heightAnchor.constraint(equalToConstant: 55).isActive = true
        ///
        
    }
    
    @objc fileprivate func BackButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Mark: Facebook login Manager
    @objc fileprivate func loginManager() {
        let loginmanager = FBSDKLoginManager()
        loginmanager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            self.getFBUserData()
        }
    }
    //===============================
    
    //Mark: Facebook user inforation
    fileprivate func getFBUserData() {
        if FBSDKAccessToken.current() != nil {
            let graphic = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,picture.width(480).height(480), gender"])
            graphic?.start(completionHandler: { (connection, user, error) in
                guard let userinfo = user as? [String: Any] else {return}
                guard let userPic = userinfo["picture"] as? [String: Any] else {return}
                guard let data = userPic["data"] as? [String: Any] else {return}
                guard let urlPic = data["url"] as? String else {return}
                guard let userEmail = userinfo["email"] as? String else {return}
                guard let userName = userinfo["name"] as? String else {return}
                let nameSeparation = userName.components(separatedBy: " ")
                
                self.signUpAction(email: userEmail, pass: userEmail.sha512(), fbAccount: true, imageFromFB: urlPic, name: nameSeparation[0], lastName: nameSeparation[1])
            })
        }
    }
    //===================================
    
    @objc fileprivate func signUp() {
        guard let email = self.EmailInput.text, let pass = self.passwordInput.text, let repass = self.rePassInput.text else {return}
        if email.isEmpty || pass.isEmpty || repass.isEmpty {
            self.simpleAlert(Message: "all fields are required", title: "Sign Up error")
        } else {
            if pass == repass {
                self.signUpAction(email: email, pass: pass, fbAccount: false, imageFromFB: "", name: "", lastName: "")
            } else {
                self.simpleAlert(Message: "Password and ConfirmPassword doesn't match", title: "Sign Up error")
            }
        }
    }
    
    fileprivate func signUpAction(email: String, pass: String, fbAccount: Bool, imageFromFB: String, name: String, lastName: String) {
        var imagefile: PFFile?
        if imageFromFB == "" {
            let localimage = UIImage(named: "User.png")
            let imagedata = UIImagePNGRepresentation(localimage!)
            imagefile = PFFile(name: "default.png", data: imagedata!)
        } else {
            let imagedata = try? Data(contentsOf: URL(string: imageFromFB)!)
            imagefile = PFFile(name: "default.png", data: imagedata!)
        }
        imagefile?.saveInBackground({ (succes, error) in
            if error == nil {
                if succes {
                    let user = PFUser()
                    user.username = email
                    user.email = email
                    user.password = pass
                    user["fbAccount"] = fbAccount
                    user["profilePicture"] = imagefile
                    user["name"] = name
                    user["lastname"] = lastName
                    user.signUpInBackground(block: { (success, err) in
                        if success {
                            let tabBarViewcontroller = TabBar()
                            self.navigationController?.pushViewController(tabBarViewcontroller, animated: true)
                        } else {
                            FBSDKLoginManager().logOut()
                            self.simpleAlert(Message: (err?.localizedDescription)!, title: "Sign up Error")
                        }
                    })
                }
            }
        }, progressBlock: { (percentenge ) in
            print(percentenge)
        })
        
    
    }
}
