import UIKit
import Font_Awesome_Swift
import ActiveLabel

class sectionFooter: UIView {
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        return view
    }()
    
    public lazy var rocket: CustomBtn = {
        let button = CustomBtn()
        let icon = UIImage(named: "transport")
        button.setImage(icon, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var ruby: CustomBtn = {
        let button = CustomBtn()
        let icon = UIImage(named: "ruby")
        button.setImage(icon, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var comment: iconButton = {
        let button = iconButton()
        let icon = UIImage(named: "comment")
        button.setImage(icon, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var like: CustomBtn = {
        let button = CustomBtn()
        let icon = UIImage(named: "heart")
        button.setImage(icon, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var VideoDescription: ActiveLabel = {
        let label = ActiveLabel()
        label.text = ""
        label.textColor = .black
        label.numberOfLines = 3
        label.enabledTypes = [.hashtag]
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subViews()
    }
    
    private func subViews() {
        
        self.addSubview(self.rocket)
        self.rocket.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.rocket.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        self.rocket.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.rocket.widthAnchor.constraint(equalToConstant: 33).isActive = true
        
        self.addSubview(self.ruby)
        self.ruby.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.ruby.leftAnchor.constraint(equalTo: self.rocket.rightAnchor, constant: 5).isActive = true
        self.ruby.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.ruby.widthAnchor.constraint(equalToConstant: 33).isActive = true
        
        self.addSubview(self.comment)
        self.comment.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.comment.leftAnchor.constraint(equalTo: self.ruby.rightAnchor, constant: 5).isActive = true
        self.comment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.comment.widthAnchor.constraint(equalToConstant: 33).isActive = true
        
        self.addSubview(self.like)
        self.like.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.like.leftAnchor.constraint(equalTo: self.comment.rightAnchor, constant: 5).isActive = true
        self.like.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.like.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        self.addSubview(self.VideoDescription)
        self.VideoDescription.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        self.VideoDescription.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.VideoDescription.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.VideoDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        
        self.addSubview(self.separator)
        self.separator.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.size.width, height: 1)
    }
    
}
