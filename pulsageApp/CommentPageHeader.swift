import UIKit
import ActiveLabel

class CommentPageHeader: UIView {
    
    public lazy var profilePicture: UIImageView = {
        let imageview = UIImageView()
        imageview.clipsToBounds = true
        imageview.isUserInteractionEnabled = true
        imageview.layer.cornerRadius = 35
        imageview.backgroundColor = .gray
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    public lazy var comment: ActiveLabel = {
        let textview = ActiveLabel()
        textview.enabledTypes = [.hashtag]
        textview.font = UIFont.systemFont(ofSize: 13)
        textview.numberOfLines = 2
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        
        self.addSubview(self.profilePicture)
        self.profilePicture.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.profilePicture.widthAnchor.constraint(equalToConstant: 70).isActive = true
        self.profilePicture.heightAnchor.constraint(equalToConstant: 70).isActive = true
        self.profilePicture.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
        self.addSubview(self.comment)
        self.comment.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.comment.leftAnchor.constraint(equalTo: self.profilePicture.rightAnchor, constant: 10).isActive = true
        self.comment.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.comment.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
    
}
