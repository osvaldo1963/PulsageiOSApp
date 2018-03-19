import UIKit
import Parse

class CreateChallenge: UIViewController {
    //Mark: private visual objects
    private var blackCover: UIView = {
        let cover = UIView()
        cover.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        cover.translatesAutoresizingMaskIntoConstraints = false
        return cover
    }()
    
    private lazy var bgImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleToFill
        imageview.clipsToBounds = true
        imageview.frame = self.view.bounds
        imageview.image = UIImage(named: "createChallengeBack")
        return imageview
    }()
    
    private lazy var challengeTitle: UITextView = {
        let textview = UITextView()
        textview.sizeToFit()
        textview.font = UIFont.systemFont(ofSize: 14)
        textview.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        textview.translatesAutoresizingMaskIntoConstraints = false
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
        self.view.insertSubview(self.bgImage, at: 0)
        ///
        self.view.addSubview(self.blackCover)
        self.blackCover.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.blackCover.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.blackCover.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.blackCover.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        ///
        self.blackCover.addSubview(self.challengeTitle)
        self.challengeTitle.topAnchor.constraint(equalTo: self.blackCover.topAnchor, constant: 40).isActive = true
        self.challengeTitle.leftAnchor.constraint(equalTo: self.blackCover.leftAnchor, constant: 20).isActive = true
        self.challengeTitle.rightAnchor.constraint(equalTo: self.blackCover.rightAnchor, constant: -20).isActive = true
        self.challengeTitle.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.challengeTitle.becomeFirstResponder()
        
        ///
        self.blackCover.addSubview(self.sendToFriendsBtn)
        self.sendToFriendsBtn.topAnchor.constraint(equalTo: self.challengeTitle.bottomAnchor, constant: 10).isActive = true
        self.sendToFriendsBtn.leftAnchor.constraint(equalTo: self.blackCover.leftAnchor, constant: 60).isActive = true
        self.sendToFriendsBtn.rightAnchor.constraint(equalTo: self.blackCover.rightAnchor, constant: -60).isActive = true
        self.sendToFriendsBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        ///
        self.blackCover.addSubview(self.optionalText)
        self.optionalText.topAnchor.constraint(equalTo: self.sendToFriendsBtn.bottomAnchor, constant: 10).isActive = true
        self.optionalText.leftAnchor.constraint(equalTo: self.blackCover.leftAnchor, constant: 60).isActive = true
        self.optionalText.rightAnchor.constraint(equalTo: self.blackCover.rightAnchor, constant: -60).isActive = true
        self.optionalText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        ///
        self.blackCover.addSubview(self.createChallengeBtn)
        self.createChallengeBtn.topAnchor.constraint(equalTo: self.optionalText.bottomAnchor, constant: 10).isActive = true
        self.createChallengeBtn.leftAnchor.constraint(equalTo: self.blackCover.leftAnchor, constant: 20).isActive = true
        self.createChallengeBtn.rightAnchor.constraint(equalTo: self.blackCover.rightAnchor, constant: -20).isActive = true
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
            query.saveInBackground(block: { (success, error) in
                if error == nil {
                    if success {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
 
        }
    }
    /*
    private func gethashtag(text: String) -> [String]? {
        var result = [String]()
        let arrayOfText = text.components(separatedBy: " ")
        for arr in arrayOfText {
            let character = Array(arr)
            if character.contains("#") {
                let back = String(character)
                result.append(back)
            }
        }
        return result
    }
    
    
    
    @objc fileprivate func finishAction() {
        guard let titleIn = self.titleInput.text else {return}
        guard let descriptionIn = self.descriptionInput.text else {return}
        
        if titleIn.isEmpty || descriptionIn.isEmpty || self.categoryHolderid.isEmpty {
            self.simpleAlert(Message: "All fields are required!", title: "Error")
        } else {
            if PFUser.current() == nil {
                let presentationViewController = UINavigationController(rootViewController: Presentation())
                self.present(presentationViewController, animated: true, completion: nil)
            } else {
                let object = PFObject(className: "Challenges")
                guard let user = PFUser.current()?.objectId else {return}
                object["title"] = self.titleInput.text
                object["description"] = self.descriptionInput.text
                object["user"] = user
                object["category"] = self.categoryHolderid
                object.saveInBackground { (result, error) in
                    if error == nil {
                        if result {
                            self.titleInput.text = ""
                            self.descriptionInput.text = ""
                            self.tabBarController?.selectedIndex = 0
                            self.simpleAlert(Message: "", title: "Challenge Created!")
                        }
                    }
                }
            }
        }
    }
    */
    //===================================
    
    /*
    fileprivate var categorie = ["Select a category"]
    fileprivate var categorieId = ["0"]
    fileprivate var categoryHolderid = ""
    
    //========= Mark: objects ========================
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 70, width: self.view.frame.size.width - 40, height: 20)
        label.font = UIFont(name: "Helvetica-Light", size: 13)
        label.text = "Challenge Title"
        label.textColor = .gray
        return label
    }()
    
    fileprivate lazy var titleInput: UITextField = {
        let textInput = UITextField()
        textInput.frame = CGRect(x: 20, y: self.titleLabel.frame.origin.y + 25, width: self.view.frame.size.width - 40, height: 40)
        textInput.placeholder = "Challenge title"
        textInput.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
        textInput.layer.cornerRadius = 3
        return textInput
    }()
    
    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: self.titleInput.frame.origin.y + 50 , width: self.view.frame.size.width - 40, height: 20)
        label.font      = UIFont(name: "Helvetica-Light", size: 13)
        label.text      = "Challenge Description"
        label.textColor = .gray
        
        return label
    }()
    
    fileprivate lazy var descriptionInput: UITextField = {
        let textInput = UITextField()
        textInput.frame = CGRect(x: 20, y: self.descriptionLabel.frame.origin.y + 25, width: self.view.frame.size.width - 40, height: 40)
        textInput.placeholder = "Challenge description"
        textInput.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
        textInput.layer.cornerRadius = 3
        return textInput
    }()
    
    fileprivate lazy var Picker: UIPickerView = {
        let picker = UIPickerView()
        picker.frame = CGRect(x: 20, y: self.descriptionInput.frame.origin.y + 70, width: self.view.frame.size.width - 40, height: 90)
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        return picker
    }()
    
    fileprivate lazy var uploadBtn: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 20, y: self.view.frame.size.height - 100, width: self.view.frame.size.width - 40, height: 50)
        btn.setTitle("Finish", for: .normal)
        btn.addTarget(self, action: #selector(finishAction), for: .touchUpInside)
        btn.tintColor = .white
        btn.layer.cornerRadius = 3
        btn.backgroundColor = .orange
        return btn
    }()
    //=================================================

    //============ Mark: View controeller props =======
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.Subviews()
        self.getCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //=================================================
    
    //========= Mark: Methods ============================
    fileprivate func Subviews() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.titleInput)
        self.view.addSubview(self.descriptionLabel)
        self.view.addSubview(self.descriptionInput)
        self.view.addSubview(self.uploadBtn)
        self.view.addSubview(self.Picker)
    }
    
    @objc fileprivate func finishAction() {
        guard let titleIn = self.titleInput.text else {return}
        guard let descriptionIn = self.descriptionInput.text else {return}
        
        if titleIn.isEmpty || descriptionIn.isEmpty || self.categoryHolderid.isEmpty {
            self.simpleAlert(Message: "All fields are required!", title: "Error")
        } else {
            if PFUser.current() == nil {
                let presentationViewController = UINavigationController(rootViewController: Presentation())
                self.present(presentationViewController, animated: true, completion: nil)
            } else {
                let object = PFObject(className: "Challenges")
                guard let user = PFUser.current()?.objectId else {return}
                object["title"] = self.titleInput.text
                object["description"] = self.descriptionInput.text
                object["user"] = user
                object["category"] = self.categoryHolderid
                object.saveInBackground { (result, error) in
                    if error == nil {
                        if result {
                            self.titleInput.text = ""
                            self.descriptionInput.text = ""
                            self.tabBarController?.selectedIndex = 0
                            self.simpleAlert(Message: "", title: "Challenge Created!")
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func checkUserSession() {
        if PFUser.current() == nil {
            let presentationViewController = UINavigationController(rootViewController: Presentation())
            self.present(presentationViewController, animated: true, completion: nil)
        }
    }
    
    fileprivate func getCategories() {
        let query = PFQuery(className: "Categories")
        query.findObjectsInBackground { (catData, error) in
            guard let category = catData else { return }
            for names in category {
                guard let name = names["category"] as? String else {return}
                guard let id = names.objectId else {return}
                self.categorie.append(name)
                self.categorieId.append(id)
                self.Picker.reloadAllComponents()
            }
        }
    }
    
    //=================================================
}

extension CreateChallenge: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categorie.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categorie[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryHolderid = self.categorieId[row]
    }
    
*/
}

extension CreateChallenge: UITextViewDelegate {
    
    
}

