import UIKit

class CommentHeader: UIView {
    
    public lazy var profilePicture: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 20
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    public lazy var commentInput: UITextField = {
        let textinput = UITextField()
        textinput.backgroundColor = .white
        textinput.frame.size.height = 40
        textinput.layer.borderWidth = 0.5
        textinput.layer.borderColor = UIColor.gray.cgColor
        textinput.layer.cornerRadius = 17
        textinput.font = UIFont(name: "Arial", size: 14)
        textinput.setLeftPaddingPoints(10)
        textinput.translatesAutoresizingMaskIntoConstraints = false
        return textinput
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(self.profilePicture)
        self.profilePicture.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.profilePicture.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.profilePicture.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.profilePicture.widthAnchor.constraint(equalToConstant: frame.size.height - 20).isActive = true
        
        self.addSubview(self.commentInput)
        self.commentInput.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.commentInput.leftAnchor.constraint(equalTo: self.profilePicture.rightAnchor, constant: 10).isActive = true
        self.commentInput.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.commentInput.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
    }
    
}
