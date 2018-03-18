import UIKit
import Font_Awesome_Swift

class ProfileHeader: UIView{
    //========= Mark: view objects ============================
    lazy var cover: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()
    
    lazy var backgrounfImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .gray
        imageview.image = UIImage(named: "wallpaper")
        return imageview
    }()
    
    public lazy var userimage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .white
        imageview.layer.cornerRadius = 50
        imageview.contentMode = .scaleToFill
        imageview.layer.borderColor = UIColor.white.cgColor
        imageview.layer.borderWidth = 1
        imageview.clipsToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
 
    
    public lazy var username: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Light", size: 16)
        label.text = "username"
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var followers: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("\n Followers", for: .normal)
        button.titleLabel?.textAlignment = .center
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var following: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitle("\n Following", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var followBtn: UIButton = {
        let button = UIButton()
        button.setTitle("follow", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Light", size: 14)
        button.layer.cornerRadius = 14
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var segmented: Segmented = {
        let seg = Segmented(frame: CGRect.zero)
        seg.backgroundColor = .gray
        seg.translatesAutoresizingMaskIntoConstraints = false
        return seg
    }()
    
    //==========================================================
    
    //============== Mark: view props ==========================
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.subViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //==========================================================
    
    //============= Mark: functions =============================
    func subViews() {
        
        self.addSubview(self.backgrounfImage)
        self.backgrounfImage.frame = bounds
        
        self.addSubview(self.cover)
        self.cover.frame = bounds
        
        self.addSubview(self.userimage)
        self.userimage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.userimage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.userimage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.userimage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.addSubview(self.followers)
        self.followers.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.followers.leftAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.followers.widthAnchor.constraint(equalToConstant: frame.size.width / 4).isActive = true
        self.followers.heightAnchor.constraint(equalToConstant: frame.size.height / 2).isActive = true
        
        self.addSubview(self.following)
        self.following.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.following.leftAnchor.constraint(equalTo: self.followers.rightAnchor).isActive = true
        self.following.widthAnchor.constraint(equalToConstant: frame.size.width / 4).isActive = true
        self.following.heightAnchor.constraint(equalToConstant: frame.size.height / 2).isActive = true
        
        self.addSubview(self.username)
        self.username.topAnchor.constraint(equalTo: self.userimage.bottomAnchor, constant: 10).isActive = true
        self.username.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.username.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.username.widthAnchor.constraint(equalToConstant: frame.size.width / 2 - 20).isActive = true
        
        self.addSubview(self.followBtn)
        self.followBtn.topAnchor.constraint(equalTo: self.userimage.bottomAnchor).isActive = true
        self.followBtn.leftAnchor.constraint(equalTo: self.username.rightAnchor).isActive = true
        self.followBtn.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.followBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(self.segmented)
        self.segmented.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.segmented.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.segmented.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.segmented.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
     }
    
    //============================================================
}
