import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

class Presentation: UIViewController {
    
    //Mark: UIView Objects =============================================
    //===================================================================

    fileprivate lazy var slogan: UILabel = {
        let label = UILabel()
        label.text = "PULSAGE"
        label.textColor = .white
        label.font = UIFont(name: "Segoe UI", size: 40)
        label.font = UIFont.systemFont(ofSize: 40)
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
    
    fileprivate lazy var signIn: BonceButton = {
        let button = BonceButton()
        button.setTitle("Log In with Email", for: .normal)
        button.backgroundColor = UIColor(red:0.87, green:0.36, blue:0.35, alpha:1.0)
        button.addTarget(self, action: #selector(presentSignInController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 26
        return button
    }()
    
    fileprivate lazy var signUp: BonceButton = {
        let button = BonceButton()
        button.setTitle("Sign up", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 26
        button.addTarget(self, action: #selector(presentSignUpController), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Arial-bold", size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var termOfServices: UIButton = {
        let button = UIButton()
        button.setTitle("By signing up you are agreeing to our terms & conditions", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.addTarget(self, action: #selector(self.presneTermsConditions), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var blackConver: UIView = {
        let view = UIView()
            view.frame = self.view.frame
            view.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.4)
        return view
    }()
    
    //===================================================================
    //===================================================================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.isHidden = true //hide navigation controller
        
        self.addSubviews()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        let when = DispatchTime.now() + 1.7
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.CheckSession()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    //Mark: Function will headle subviews constrains
    fileprivate func addSubviews() {

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "presentationBg.jpg")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        self.view.insertSubview(backgroundImage, at: 0)
        self.view.addSubview(self.blackConver)
        
        ///
        self.view.addSubview(self.slogan)
        slogan.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 150).isActive = true
        slogan.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        slogan.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        slogan.heightAnchor.constraint(equalToConstant: 50)
        ///
        
        ///
        self.view.addSubview(self.facebookLogin)
        self.facebookLogin.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        self.facebookLogin.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        self.facebookLogin.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        self.facebookLogin.heightAnchor.constraint(equalToConstant: 55).isActive = true
        ///
        
        ///
        self.view.addSubview(self.signIn)
        self.signIn.topAnchor.constraint(equalTo: self.facebookLogin.bottomAnchor, constant: 20).isActive = true
        self.signIn.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        self.signIn.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        self.signIn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        ///
        
        ///
        self.view.addSubview(self.signUp)
        self.signUp.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant:  -30).isActive = true
        self.signUp.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        self.signUp.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        self.signUp.heightAnchor.constraint(equalToConstant: 55).isActive = true
        ///
        
        ///
        self.view.addSubview(self.termOfServices)
        self.termOfServices.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.termOfServices.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.termOfServices.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.termOfServices.heightAnchor.constraint(equalToConstant: 20).isActive = true
        ///
    
        
    }
    //==========================================
    
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
                self.SigninAction(Email: userEmail, Pass: userEmail, fbAccount: true)
            })
        }
    }
    //===================================
    
    //Mark: Buttons navigation props
    @objc private func presentSignUpController() {
        self.navigationController?.pushViewController(SignUp(), animated: true)
    }
    
    @objc private func presentSignInController() {
        self.navigationController?.pushViewController(SignIn(), animated: true)
    }
    
    @objc private func presneTermsConditions() {
        self.navigationController?.pushViewController(TermsConditions(), animated: true)
    }
    
    //=====================================
    
    //Mark: Check User Session
    
    private func CheckSession() {
        if PFUser.current() != nil {
            let tabBarViewcontroller = TabBar()
            self.navigationController?.pushViewController(tabBarViewcontroller, animated: true)
        }
    }
    //====================================
    
    
    //Mark: Login action
    @objc fileprivate func SigninAction(Email: String, Pass: String, fbAccount: Bool) {
        var emailToLogin = ""
        var passToLogin = ""
        if fbAccount {
            emailToLogin = Email
            passToLogin = Pass.sha512()
        } else {
            emailToLogin = Email
            passToLogin = Pass
        }
        
        PFUser.logInWithUsername(inBackground: emailToLogin, password: passToLogin) { (user, error) in
            if error == nil {
                //do something after login success
                let tabBarViewcontroller = TabBar()
                self.present(tabBarViewcontroller, animated: true, completion: nil)
            } else {
                guard let err = error?.localizedDescription else {return}
                self.simpleAlert(Message: "\(err) \n if you sign up using facebook you need to login using facebook", title: "Login Error")
            }
        }
    }
    //======================================
}
