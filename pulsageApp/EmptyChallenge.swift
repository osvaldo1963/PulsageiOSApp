import UIKit
import Parse

class EmptyChallenge: UIViewController {
    
    public var objectData = ""
    
    private var iconAndButton: ButtonWithIcon = {
        let button = ButtonWithIcon()
        button.icon.backgroundColor = .gray
        button.icon.frame.size.height = 30
        button.icon.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.setFAIcon(icon: .FAClose, iconSize: 25, forState: .normal)
        button.setFATitleColor(color: .white)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var challengeCaption: UITextView = {
        let textview = UITextView()
        textview.isEditable = false
        textview.backgroundColor = .clear
        textview.textAlignment = .center
        textview.font = UIFont.systemFont(ofSize: 16)
        textview.textColor = .white
        textview.text = ""
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
    
    private var beTheFirst: UILabel = {
        let label = UILabel()
        label.text = "Be Te First!"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var attempt: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 30
        button.setTitle("Attempt!", for: .normal)
        button.addTarget(self, action: #selector(self.presentCamera), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewProps()
        self.addSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: .userInteractive).async {
            self.getData()
        }
    }
    
    private func addSubviews() {
        let saveAreaLayout = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(self.iconAndButton)
        self.iconAndButton.topAnchor.constraint(equalTo: saveAreaLayout.topAnchor, constant: 20).isActive = true
        self.iconAndButton.leftAnchor.constraint(equalTo: saveAreaLayout.leftAnchor, constant: 20).isActive = true
        self.iconAndButton.rightAnchor.constraint(equalTo: saveAreaLayout.rightAnchor, constant: -60).isActive = true
        self.iconAndButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.iconAndButton.icon.layer.cornerRadius = 20
        
        self.view.addSubview(self.closeBtn)
        self.closeBtn.topAnchor.constraint(equalTo: saveAreaLayout.topAnchor, constant: 20).isActive = true
        self.closeBtn.rightAnchor.constraint(equalTo: saveAreaLayout.rightAnchor, constant: -20).isActive = true
        self.closeBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.closeBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(self.challengeCaption)
        self.challengeCaption.topAnchor.constraint(equalTo: self.iconAndButton.bottomAnchor, constant: 20).isActive = true
        self.challengeCaption.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        self.challengeCaption.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        self.challengeCaption.heightAnchor.constraint(equalToConstant: self.view.frame.size.height / 4).isActive = true
        
        self.view.addSubview(self.beTheFirst)
        self.beTheFirst.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.beTheFirst.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.beTheFirst.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 40).isActive = true
        self.beTheFirst.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(self.attempt)
        self.attempt.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.attempt.topAnchor.constraint(equalTo: self.beTheFirst.bottomAnchor, constant: 15).isActive = true
        self.attempt.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 40).isActive = true
        self.attempt.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    private func viewProps() {
        let topColor = UIColor(red:0.08, green:0.14, blue:0.39, alpha:1.0)
        let buttomColor = UIColor(red:1.00, green:0.79, blue:0.70, alpha:1.0)
        let gradientLayer = CAGradientLayer()
        let backGround = gradientLayer.gradiendColorLayer(firstColor: topColor, secondColor: buttomColor, frame: self.view.bounds)
        self.view.layer.insertSublayer(backGround, at: 0)
    }
    
    @objc private func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func getData() {
        let object = PFObject(withoutDataWithClassName: "Challenges", objectId: self.objectData)
        object.fetchInBackground { (result, error) in
            if error == nil {
                guard let data = result else {return}
                
                guard let description = data["description"] as? String else {return}
                self.challengeCaption.text = description
                
                guard let user = data["User"] as? PFObject else {return}
                do {
                    let userData = try user.fetch()
                    guard let picture = userData["profilePicture"] as? PFFile else {return}
                    guard let username = userData["username"] as? String else {return }
                    self.iconAndButton.icon.sd_setAnimationImages(with: [picture.getImage()])
                    self.iconAndButton.button.setTitle(username.getTextFromEmail(), for: .normal)
                } catch {
                    print("could not get user data")
                }
                
            }
        }
    }
    
    @objc private func presentCamera() {
        let cameraController = CameraRecorded()
        cameraController.challenge = self.objectData
        let rootNavigationController = UINavigationController(rootViewController: cameraController)
        rootNavigationController.gradientBackground()
        self.present(rootNavigationController, animated: true, completion: nil)
    }
    
}
