import UIKit

class CommentCell: UITableViewCell {
    
    public lazy var profilePicture: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        return imageview
    }()
    
    public lazy var linkToProfile: iconButton = {
        let btn = iconButton()
        
        btn.contentHorizontalAlignment = .left
        btn.setTitle("", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    public lazy var commentText: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.isEditable = false
        return textview
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        
        self.addSubview(self.profilePicture)
        self.profilePicture.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.profilePicture.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.profilePicture.widthAnchor.constraint(equalToConstant: frame.size.height - 20).isActive = true
        self.profilePicture.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        let half = frame.size.height - 20
        self.profilePicture.layer.cornerRadius = half / 2
        
        
        self.addSubview(self.linkToProfile)
        self.linkToProfile.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.linkToProfile.leftAnchor.constraint(equalTo: self.profilePicture.rightAnchor, constant: 10).isActive = true
        self.linkToProfile.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.linkToProfile.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        self.addSubview(self.commentText)
        self.commentText.topAnchor.constraint(equalTo: self.linkToProfile.bottomAnchor, constant: 5).isActive = true
        self.commentText.leftAnchor.constraint(equalTo: self.profilePicture.rightAnchor, constant: 10).isActive = true
        self.commentText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.commentText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
}
