import UIKit
import Parse
import SDWebImage

//In this view there is a Euraka library this library will be use temporlily
class EditProfile: UIViewController, UITextFieldDelegate {
    
    fileprivate var imageholder: UIImage = UIImage()
    private let imagePicker = UIImagePickerController()
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .gray
        indicator.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return indicator
    }()
    
    //Mark: Visual Objects =================================================
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollview.backgroundColor = .white
        scrollview.contentSize = CGSize(width: self.view.frame.size.width, height: 400)
        scrollview.isScrollEnabled = true
        return scrollview
    }()
    
    fileprivate var divider: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        return line
    }()
    
    fileprivate lazy var profilePicture: UIImageView = {
        let imageview = UIImageView()
        imageview.frame = CGRect(x: self.view.frame.size.width / 2 - 70, y: 20, width: 140, height: 140)
        imageview.layer.cornerRadius = 70
        imageview.clipsToBounds = true
        imageview.backgroundColor = .gray
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    fileprivate lazy var changePicture: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 10, y: 180, width: self.view.frame.size.width - 20, height: 40)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Change Profile Picture", for: .normal)
        button.addTarget(self, action: #selector(ActionSheet), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var InputFName: Inputform  = {
        let input = Inputform(frame: CGRect(x: 0, y: 240, width: self.view.frame.size.width, height: 50))
        input.LabelTitle.text = "First Name"
        input.InputField.placeholder = "Enter First Name"
        input.InputField.delegate = self
        return input
    }()
    
    fileprivate lazy var InputLName: Inputform  = {
        let input = Inputform(frame: CGRect(x: 0, y: 300, width: self.view.frame.size.width, height: 50))
        input.LabelTitle.text = "Last Name"
        input.InputField.placeholder = "Enter Last Name"
        input.InputField.delegate = self
        return input
    }()
    
    fileprivate lazy var InputEmail: Inputform = {
        let frame = CGRect(x: 0 , y: 360, width: self.view.frame.size.width, height: 50)
        let input = Inputform(frame: frame)
        input.LabelTitle.text = "Email"
        input.InputField.placeholder = "Enter Email"
        input.InputField.delegate = self
        return input
    }()
    // End Mark ====================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.activityIndicator)
        self.scrollView.addSubview(self.profilePicture)
        self.scrollView.addSubview(self.changePicture)
        
        self.scrollView.addSubview(self.InputFName)
        self.scrollView.addSubview(self.InputLName)
        self.scrollView.addSubview(self.InputEmail)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        DispatchQueue.main.async {
            self.LoadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(DoneBtnAction))
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Mark: Load Current User Data
    fileprivate func LoadData() {
        guard let curretnUserId = PFUser.current()?.objectId else {return}
        let userQuery = PFUser.query()
        userQuery?.getObjectInBackground(withId: curretnUserId, block: { (user, error) in
            if error == nil {
                guard let userData = user else {return}
                guard let userimagefile = userData["profilePicture"] as? PFFile else {return}
                guard let username = userData["name"] as? String else {return}
                guard let userlastname = userData["lastname"] as? String else {return}
                guard let useremail = userData["email"] as? String else {return}
                guard let userpictureurl = userimagefile.url else {return}
                self.activityIndicator.stopAnimating()
                
                DispatchQueue.main.async {
                    self.profilePicture.sd_setImage(with: URL(string: userpictureurl))
                    self.InputFName.InputField.text = username
                    self.InputLName.InputField.text = userlastname
                    self.InputEmail.InputField.text = useremail
                }
            }
        })
    }
    // end Mark
    
    //Mark: Notifications for scrollview to adjust to the keyboard
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        var userinfo = notification.userInfo
        var keyboardFrame: CGRect = (userinfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    // end of Mark
    
    //Mark: Done Action Functions ===============================
    @objc fileprivate func DoneBtnAction() {
        self.activityIndicator.startAnimating()
        guard let firstName = self.InputFName.InputField.text else {return}
        guard let lastName = self.InputLName.InputField.text else {return}
        guard let email = self.InputEmail.InputField.text else {return}
        guard let currentUserId = PFUser.current()?.objectId else {return}
        guard let imageData = UIImagePNGRepresentation(self.imageholder) else {return}
        print(self.imageholder)
        let Update = PFUser.query()
        Update?.whereKey("objectId", equalTo: currentUserId)
        Update?.getFirstObjectInBackground(block: { (user, error) in
            if error == nil {
                guard let userObject = user else {return }
                if self.imageholder.isEmpty {
                    userObject["name"] = firstName
                    userObject["lastname"] = lastName
                    userObject["email"] = email
                    userObject.saveInBackground(block: { (success, error) in
                        if error == nil {
                            if success {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    })
                    print("is is null")
                } else {
                    //let imageurl = URL(string: self.imageholder)
                    print(self.imageholder)
                    let uploadPicture = PFFile(name: "image.png", data: imageData)
                    uploadPicture?.saveInBackground({ (success, error) in
                        userObject["profilePicture"] = uploadPicture
                        userObject["name"] = firstName
                        userObject["lastname"] = lastName
                        userObject.saveInBackground(block: { (success, error) in
                            if error == nil {
                                if success {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        })
                    }, progressBlock: { (progress) in
                        print(progress)
                    })
                }
                
            }
        })
        self.activityIndicator.stopAnimating()
        self.navigationController?.popViewController(animated: true)
    }

    //end Mark ========================================================
    
    
    //Mark: Change Picture ============================================
    @objc fileprivate func ActionSheet() {
        let alertController = UIAlertController(title: "Choose Source", message: "Choose From Camera or Library", preferredStyle: .actionSheet)
        let cameraBtn = UIAlertAction(title: "Camera", style: .default) { (alert) in
            self.ChoosePictureFrom()
        }
        let libraryBtn = UIAlertAction(title: "Library", style: .default) { (alert) in
            self.ChooseFromLibrary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraBtn)
        alertController.addAction(libraryBtn)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc fileprivate func ChoosePictureFrom() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func ChooseFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    //End Mark ==============================================================
}

extension EditProfile: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        guard let imagePicked = UIImage.from(info: info) else {return}
        self.imageholder = imagePicked
        DispatchQueue.main.async {
            self.profilePicture.image = imagePicked
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

}

