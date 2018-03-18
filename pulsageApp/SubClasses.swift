import UIKit
import Parse
//Mark: Click Anymation for UIButton
class BonceButton: UIButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
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
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.icon)
        self.icon.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.icon.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.icon.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(self.button)
        self.button.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.button.leftAnchor.constraint(equalTo: self.icon.rightAnchor).isActive = true
        self.button.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.button.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
