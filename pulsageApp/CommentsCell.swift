import UIKit

class CommentCell: UITableViewCell {
    
    public lazy var profilePicture: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.cornerRadius = 40
        return imageview
    }()
    
    public lazy var linkToProfile: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.blue, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
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
        self.selectionStyle = .none
        
        super.layoutSubviews()
        
        self.addSubview(self.profilePicture)
        self.profilePicture.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.profilePicture.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.profilePicture.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.profilePicture.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.addSubview(self.linkToProfile)
        self.linkToProfile.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.linkToProfile.leftAnchor.constraint(equalTo: self.profilePicture.rightAnchor, constant: 10).isActive = true
        self.linkToProfile.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.linkToProfile.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        self.addSubview(self.commentText)
        self.commentText.topAnchor.constraint(equalTo: self.linkToProfile.bottomAnchor, constant: 5).isActive = true
        self.commentText.leftAnchor.constraint(equalTo: self.profilePicture.rightAnchor, constant: 10).isActive = true
        self.commentText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.commentText.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
