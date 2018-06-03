import UIKit
import Parse
//Mark: Click Anymation for UIButton
class BonceButton: UIButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        super.touchesBegan(touches, with: event)
    }
}

//Mark: Extra parameter UIObjectes
class CustomBtn: UIButton {
    public var section: Int?
    public var row: Int?
    public var id: String?
    public var object: PFObject?
}

class Label: UILabel {
    public var id: String?
}

class iconButton: UIButton {
    var object: PFObject?
   
}

class ButtonWithIcon: UIView {
    
    public lazy var button: iconButton = {
        let btn = iconButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    public lazy var icon: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(self.icon)
        self.icon.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.icon.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.icon.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.icon.widthAnchor.constraint(equalToConstant: frame.size.height).isActive = true
        
        self.addSubview(self.button)
        self.button.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.button.leftAnchor.constraint(equalTo: self.icon.rightAnchor).isActive = true
        self.button.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.button.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}

class PulsageViewController: UIViewController {
    
    private let feedbackController = FeedbackController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNavigationProps()
    }
    
    private func setNavigationProps() {
        self.navigationController?.gradientBackground()
        let feedbackBtn = UIBarButtonItem(title: "Feedback", style: .done, target: self, action: #selector(presetFeebBackController))
        feedbackBtn.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Light", size: 16)!], for: .normal)
        self.navigationItem.setLeftBarButtonItems([feedbackBtn], animated: true)
    }
    
    @objc fileprivate func presetFeebBackController() {
        self.feedbackController.presetFeebBackController()
    }
    
}

class Inputform: UIView {
    public var LabelTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Arial", size: 18)
        return label
    }()
    
    public var InputField: UITextField = {
        let textfield = UITextField()
        textfield.textAlignment = .right
        return textfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.LabelTitle)
        self.LabelTitle.frame = CGRect(x: 10, y: 0, width: frame.size.width / 3 , height: frame.size.height)
        self.addSubview(self.InputField)
        self.InputField.frame = CGRect(x: frame.size.width / 3, y: 0, width: frame.size.width / 3 * 2 - 10, height: frame.size.height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

