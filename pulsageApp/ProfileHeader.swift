import UIKit

class ProfileHeader: UIView {
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
        return imageview
    }()
    
    public lazy var addPictureBtn: UIButton = {
        let button = UIButton()
        return button
    }()
    
    public lazy var username: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Light", size: 16)
        label.text = "username"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    public lazy var followBtn: UIButton = {
        let button = UIButton()
        button.setTitle("following", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Light", size: 14)
        button.layer.cornerRadius = 3
        return button
    }()
    
    fileprivate lazy var location: UILabel = {
        let label = UILabel()
        label.text = "Portland, OR"
        label.font = UIFont(name: "Helvetica-Light", size: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
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
        self.backgrounfImage.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        self.addSubview(self.cover)
        self.cover.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        self.addSubview(self.userimage)
        self.userimage.frame = CGRect(x: frame.size.width / 2 - 50, y: frame.size.height / 2 - 100, width: 100, height: 100)
        
        self.addSubview(self.addPictureBtn)
        self.addPictureBtn.frame = CGRect(x: frame.size.width / 2 - 50, y: frame.size.height / 2 - 100, width: 100, height: 100)
        
        self.addSubview(self.username)
        self.username.frame = CGRect(x: 0, y: self.userimage.frame.origin.y + 110, width: frame.size.width, height: 20)
        /*
        self.addSubview(self.location)
        self.location.frame = CGRect(x: 0 , y: self.username.frame.origin.y + 25, width: frame.size.width, height: 20)
         */
        self.addSubview(self.followBtn)
        self.followBtn.frame = CGRect(x: frame.size.width / 2 - 60, y: self.username.frame.origin.y + 25, width: 120, height: 28)
    }
    
    //============================================================
}
