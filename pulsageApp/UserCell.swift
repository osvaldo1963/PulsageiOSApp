import UIKit

class UserCell: UITableViewCell {
    
    public lazy var profilePicture: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .gray
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleToFill
        imageview.layer.cornerRadius = frame.size.height / 2 - 10
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    public lazy var usernameBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(.black, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    public lazy var textback: UITextView = {
        let textview = UITextView()
        textview.isEditable = false
        textview.textColor = .black
        textview.translatesAutoresizingMaskIntoConstraints = false
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
        
        self.addSubview(self.profilePicture)
        self.profilePicture.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.profilePicture.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.profilePicture.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.profilePicture.widthAnchor.constraint(equalToConstant: frame.size.height - 20).isActive = true
        
        self.addSubview(self.usernameBtn)
        self.usernameBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.usernameBtn.leftAnchor.constraint(equalTo: self.profilePicture.rightAnchor, constant: 10).isActive = true
        self.usernameBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.usernameBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(self.textback)
        self.textback.topAnchor.constraint(equalTo: self.usernameBtn.bottomAnchor).isActive = true
        self.textback.leftAnchor.constraint(equalTo: self.profilePicture.rightAnchor, constant: 10).isActive = true
        self.textback.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.textback.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profilePicture.backgroundColor = .gray
        self.usernameBtn.setTitle("", for: .normal)
        self.textback.text = ""
    }
    
}
