import UIKit
import Parse

class CreateChallenge: UIViewController {
    //Mark: private visual objects
    
    
    private lazy var challengeTitle: UITextView = {
        let textview = UITextView()
        textview.sizeToFit()
        textview.font = UIFont.systemFont(ofSize: 14)
        textview.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.layer.borderColor = UIColor.gray.cgColor
        textview.layer.borderWidth = 0.5
        //textview.delegate = self
        return textview
    }()
    
    private lazy var sendToFriendsBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Send to Squad!", for: .normal)
        button.backgroundColor = UIColor(red:0.87, green:0.36, blue:0.35, alpha:1.0)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createChallenge), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var optionalText: UILabel = {
        let label = UILabel()
        label.text = "(optional)"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true 
        return label
    }()
    
    private lazy var createChallengeBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Create Challenge!", for: .normal)
        button.backgroundColor = UIColor(red:0.87, green:0.36, blue:0.35, alpha:1.0)
        button.layer.cornerRadius = 26
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createChallenge), for: .touchUpInside)
        return button
    }()
    
    //====================================================
    
    //Mark: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationProps()
    }
    //===================================
    
    //Mark: Functions
    private func addviews() {
        self.view.backgroundColor = .white
        ///
       
        
        ///
        self.view.addSubview(self.challengeTitle)
        self.challengeTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        self.challengeTitle.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        self.challengeTitle.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        self.challengeTitle.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.challengeTitle.becomeFirstResponder()
        
        ///
        self.view.addSubview(self.sendToFriendsBtn)
        self.sendToFriendsBtn.topAnchor.constraint(equalTo: self.challengeTitle.bottomAnchor, constant: 10).isActive = true
        self.sendToFriendsBtn.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 60).isActive = true
        self.sendToFriendsBtn.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -60).isActive = true
        self.sendToFriendsBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        ///
        self.view.addSubview(self.optionalText)
        self.optionalText.topAnchor.constraint(equalTo: self.sendToFriendsBtn.bottomAnchor, constant: 10).isActive = true
        self.optionalText.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 60).isActive = true
        self.optionalText.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -60).isActive = true
        self.optionalText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        ///
        self.view.addSubview(self.createChallengeBtn)
        self.createChallengeBtn.topAnchor.constraint(equalTo: self.optionalText.bottomAnchor, constant: 10).isActive = true
        self.createChallengeBtn.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        self.createChallengeBtn.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        self.createChallengeBtn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
    }
    
    private func navigationProps() {
        self.navigationController?.navigationBar.topItem?.title = "Create Challenge"
        
    }
    
    @objc private func createChallenge() {
        guard let titleText = self.challengeTitle.text else {return}
        
        if titleText == "" {
            self.simpleAlert(Message: "Challenge Title Field Can't be empty", title: "Create Challenge Error!")
        } else {
            guard let currentUser = PFUser.current() else {return}
            let query = PFObject(className: "Challenges")
            query["description"] = titleText
            query["User"] = currentUser
            query["reward"] = ""
            query["sponsor"] = false
            query.saveInBackground(block: { (success, error) in
                if error == nil {
                    if success {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
 
        }
    }
    
}

extension CreateChallenge: UITextViewDelegate {
    
    
}

