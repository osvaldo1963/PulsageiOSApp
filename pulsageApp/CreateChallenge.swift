import UIKit
import Parse

class CreateChallenge: UIViewController {
    
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

extension post: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
}

