import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import CryptoSwift
import GoogleSignIn

class SignUp: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate  {
    
    fileprivate lazy var EmailInput: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter Email"
        textfield.setLeftPaddingPoints(6)
        textfield.keyboardType = .emailAddress
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.backgroundColor = .white
        textfield.textAlignment = .center
        textfield.layer.cornerRadius = 20
        textfield.layer.borderColor = UIColor.orange.cgColor
        textfield.layer.borderWidth = 1
        textfield.addTarget(self, action: #selector(self.validateEmail(textField:)), for: .editingChanged)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    fileprivate lazy var passwordInput: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter Password"
        textfield.layer.cornerRadius = 3
        textfield.setLeftPaddingPoints(6)
        textfield.isSecureTextEntry = true
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.backgroundColor = .white
        textfield.textAlignment = .center
        textfield.layer.cornerRadius = 20
        textfield.layer.borderColor = UIColor.orange.cgColor
        textfield.layer.borderWidth = 1
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    fileprivate lazy var rePassInput: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Confirm Password"
        textfield.layer.cornerRadius = 3
        textfield.setLeftPaddingPoints(6)
        textfield.isSecureTextEntry = true
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.backgroundColor = .white
        textfield.textAlignment = .center
        textfield.layer.cornerRadius = 20
        textfield.layer.borderColor = UIColor.orange.cgColor
        textfield.layer.borderWidth = 1
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    fileprivate lazy var handleInput: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Create Username"
        textfield.setLeftPaddingPoints(6)
        textfield.keyboardType = .default
        textfield.autocorrectionType = .yes
        textfield.autocapitalizationType = .none
        textfield.backgroundColor = .white
        textfield.textAlignment = .center
        textfield.layer.cornerRadius = 20
        textfield.layer.borderColor = UIColor.orange.cgColor
        textfield.layer.borderWidth = 1
        textfield.addTarget(self, action: #selector(self.textDidChange(textFiled:)), for: .editingChanged)
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
        let icon = UIImage(named: "facebookicon")
        button.setImage(icon, for: .normal)
        button.addTarget(self, action: #selector(loginManager), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var googleLogin: BonceButton = {
        let button = BonceButton()
        let icon = UIImage(named: "googleicon")
        button.setImage(icon, for: .normal)
        button.addTarget(self, action: #selector(self.googleSignUp(sender:)), for: .touchUpInside)
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
        self.view.addSubview(self.handleInput)
        self.handleInput.topAnchor.constraint(equalTo: self.rePassInput.bottomAnchor, constant: 10).isActive = true
        self.handleInput.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.handleInput.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        self.handleInput.heightAnchor.constraint(equalToConstant: 45).isActive = true
        ///
        
        ///
        self.view.addSubview(self.or)
        self.or.topAnchor.constraint(equalTo: self.handleInput.bottomAnchor, constant: 20).isActive = true
        self.or.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.or.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor , constant: -15).isActive = true
        self.or.heightAnchor.constraint(equalToConstant: 30).isActive = true
        ///
        
        ///
        self.view.addSubview(self.facebookLogin)
        self.facebookLogin.topAnchor.constraint(equalTo: self.or.bottomAnchor, constant: 20).isActive = true
        self.facebookLogin.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50).isActive = true
        self.facebookLogin.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.facebookLogin.heightAnchor.constraint(equalToConstant: 60).isActive = true
        ///
        
        ///
        self.view.addSubview(self.googleLogin)
        self.googleLogin.topAnchor.constraint(equalTo: self.or.bottomAnchor, constant: 20).isActive = true
        self.googleLogin.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 50).isActive = true
        self.googleLogin.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.googleLogin.heightAnchor.constraint(equalToConstant: 60).isActive = true
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
                
                self.signUpAction(email: userEmail, pass: userEmail.sha512(), fbAccount: true, googleAccount: false, imageFromApi: urlPic, name: nameSeparation[0], lastName: nameSeparation[1], handle: userName)
                
            })
        }
    }
    //===================================
    
    @objc private func googleSignUp(sender: BonceButton) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc fileprivate func signUp() {
        guard let email = self.EmailInput.text, let pass = self.passwordInput.text, let repass = self.rePassInput.text, let handleText = self.handleInput.text else {return}
        if email.isEmpty || pass.isEmpty || repass.isEmpty || handleText.isEmpty {
            self.simpleAlert(Message: "all fields are required", title: "Sign Up error")
        } else {
            if pass == repass {
                self.signUpAction(email: email, pass: pass, fbAccount: false, googleAccount: false, imageFromApi: "", name: "", lastName: "", handle: handleText)
            } else {
                self.simpleAlert(Message: "Password and ConfirmPassword doesn't match", title: "Sign Up error")
            }
        }
    }
    
    fileprivate func signUpAction(email: String, pass: String, fbAccount: Bool, googleAccount: Bool, imageFromApi: String, name: String, lastName: String, handle: String) {
        var imagefile: PFFile?
        if imageFromApi == "" {
            let localimage = UIImage(named: "User.png")
            let imagedata = UIImagePNGRepresentation(localimage!)
            imagefile = PFFile(name: "default.png", data: imagedata!)
        } else {
            let imagedata = try? Data(contentsOf: URL(string: imageFromApi)!)
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
                    user["googleAccount"] = googleAccount
                    user["profilePicture"] = imagefile
                    user["name"] = name
                    user["lastname"] = lastName
                    user["companyAccount"] = false
                    user["handle"] = handle
                    user.signUpInBackground(block: { (success, err) in
                        if success {
                            let tabBarViewcontroller = TabBar()
                            self.present(tabBarViewcontroller, animated: true, completion: nil)
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
    
    @objc private func textDidChange(textFiled: UITextField) {
        guard let text = textFiled.text else {return}
        let userQuery = PFUser.query()
        userQuery?.whereKey("handle", equalTo: text)
        userQuery?.findObjectsInBackground(block: { (results, error) in
            if error == nil {
                guard let resultHandle = results else {return}
                if resultHandle.count == 0 {
                    textFiled.layer.borderColor = UIColor.orange.cgColor
                    textFiled.layer.borderWidth = 1
                    self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
                } else {
                    textFiled.layer.borderColor = UIColor.red.cgColor
                    textFiled.layer.borderWidth = 2
                    self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = false
                }
            }
        })
    }
    
    @objc private func validateEmail(textField: UITextField) {
        guard let textResult = textField.text?.isEmail else {return}
        if textResult {
            textField.layer.borderColor = UIColor.orange.cgColor
            textField.layer.borderWidth = 1
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
        } else {
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 2
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = false
        }
    }
    
}

extension SignUp {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
        } else {
            guard let email = user.profile.email else {return}
            guard let firstName = user.profile.name else {return}
            guard let lastName = user.profile.familyName else {return}
            self.signUpAction(email: email, pass: email.sha512(), fbAccount: false, googleAccount: true, imageFromApi: "", name: firstName, lastName: lastName, handle: firstName)
        }
    }
}


