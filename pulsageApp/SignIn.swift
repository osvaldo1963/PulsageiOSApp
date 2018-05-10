import UIKit
import Parse
import Font_Awesome_Swift
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class SignIn: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
        } else {
            print(user.profile.email)
            guard let email = user.profile.email else {return}
            self.SigninAction(Email: email, Pass: email, fbAccount: false, googleAccount: true)
        }
    }
    
    //===================================================================
    //============       Mark: Visual Objects      ======================
    //===================================================================
    fileprivate lazy var EmailInput: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter Email"
        textfield.layer.cornerRadius = 3
        textfield.setLeftPaddingPoints(6)
        textfield.keyboardType = .emailAddress
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.becomeFirstResponder()
        textfield.backgroundColor = .white
        textfield.textAlignment = .center
        textfield.layer.cornerRadius = 20
        textfield.layer.borderColor = UIColor.orange.cgColor
        textfield.layer.borderWidth = 1
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
    
    fileprivate lazy var forgotPassBtn: UIButton = {
        let button = UIButton()
        button.setTitle(" Forgot? ", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(forgotPasswordAction), for: .touchUpInside)
        return button
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
        button.addTarget(self, action: #selector(self.googleSignIn(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    //===================================================================
    //===================================================================
    
    //Mark: UIIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        self.subViews()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let backArrow = UIImage.init(icon: .FAAngleLeft, size: CGSize(width: 40, height: 40))
        let backBtn = UIBarButtonItem(image: backArrow, style: .done, target: self, action: #selector(BackButtonAction))
        let login = UIBarButtonItem(title: "Log In", style: .plain, target: self, action: #selector(SigninBtn))
        
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = backBtn
        self.navigationController?.navigationBar.topItem?.title = "Sign In"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = login
    }
    
    //=================================================
    
    fileprivate func subViews() {
        ///
        self.view.addSubview(self.EmailInput)
        self.EmailInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        self.EmailInput.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.EmailInput.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        self.EmailInput.heightAnchor.constraint(equalToConstant: 45).isActive = true
        ///
        
        ///
        self.view.addSubview(self.passwordInput)
        self.passwordInput.topAnchor.constraint(equalTo: self.EmailInput.bottomAnchor, constant: 10).isActive = true
        self.passwordInput.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.passwordInput.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        self.passwordInput.heightAnchor.constraint(equalToConstant: 45).isActive = true
        ///
        
        self.passwordInput.rightView = self.forgotPassBtn
        self.passwordInput.rightViewMode = .whileEditing
        
        ///
        self.view.addSubview(self.or)
        self.or.topAnchor.constraint(equalTo: self.passwordInput.bottomAnchor, constant: 20).isActive = true
        self.or.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.or.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
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
    
    @objc private func googleSignIn(sender: BonceButton) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func SigninBtn() {
        self.SigninAction(Email: self.EmailInput.text!, Pass: self.passwordInput.text!, fbAccount: false, googleAccount: false)
    }
    
    @objc fileprivate func SigninAction(Email: String, Pass: String, fbAccount: Bool, googleAccount: Bool) {
        
        var emailToLogin = ""
        var passToLogin = ""
        
        if fbAccount {
            emailToLogin = Email
            passToLogin = Pass.sha512()
        } else if googleAccount {
            emailToLogin = Email
            passToLogin = Pass.sha512()
        } else {
            emailToLogin = Email
            passToLogin = Pass
        }
    
        PFUser.logInWithUsername(inBackground: emailToLogin, password: passToLogin) { (user, error) in
            if error == nil {
                let tabBarViewcontroller = TabBar()
                self.present(tabBarViewcontroller, animated: true, completion: nil)
            } else {
                guard let err = error?.localizedDescription else {return}
                self.simpleAlert(Message: "\(err) \n if you sign up using facebook you need to login using facebook", title: "Login Error")
            }
        }
 
        
        
    }
    
    @objc fileprivate func forgotPasswordAction() {
        self.resetPasswordAlert(Message: "Insert your email to reset your password", title: "Forgot your Password?")
    }
    
    //Mark: Reset password Functions
    func resetPassword(email: String) {
        let query = PFUser.query()
        query?.whereKey("email", equalTo: email)
        query?.getFirstObjectInBackground(block: { (user, error) in
            guard let userdata = user else {return}
            guard let isfbAccount = userdata["fbAccount"] as? Bool else {return}
            
            if isfbAccount {
                self.simpleAlert(Message: "if you sign up using facbook you need to reset password in facebook", title: "error")
            } else {
                PFUser.requestPasswordResetForEmail(inBackground: email) { (success, error) in
                    if error == nil {
                        if success {
                            self.simpleAlert(Message: "We send you the instructions to reset your password", title: "Check your Email! ")
                        }
                    }
                }
            }
        })
        
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
                guard let userEmail = userinfo["email"] as? String else {return}
                self.SigninAction(Email: userEmail, Pass: userEmail, fbAccount: true, googleAccount: false)
            })
        }
    }
    //===================================
    
}

extension SignIn {
    func resetPasswordAlert(Message: String, title: String) {
        let alertcontroller = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Send", style: .default) { (action) in
            guard let emailAddress = alertcontroller.textFields![0].text else {return}
            self.resetPassword(email: emailAddress)
        }
        alertcontroller.addTextField { (textfield) in
            textfield.keyboardType = .emailAddress
            textfield.placeholder = "Enter your email"
        }
        alertcontroller.addAction(cancel)
        alertcontroller.addAction(ok)
        self.present(alertcontroller, animated: true, completion: nil)
    }
    
}

