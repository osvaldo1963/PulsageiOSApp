import  UIKit

class ProfileScrollView: UIScrollView {
    
    public lazy var profilePicture: UIImageView = {
        let imageview = UIImageView()
        //imageview.frame = CGRect(x: self.view.frame.size.width / 2 - 70, y: 20, width: 140, height: 140)
        imageview.layer.cornerRadius = 70
        imageview.clipsToBounds = true
        imageview.backgroundColor = .gray
        return imageview
    }()
    
    public lazy var changePicture: UIButton = {
        let button = UIButton()
        //button.frame = CGRect(x: 10, y: 180, width: self.view.frame.size.width - 20, height: 40)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Change Profile Picture", for: .normal)
        return button
    }()
    
    public lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "First Name"
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.profilePicture)
        self.profilePicture.frame = CGRect(x: frame.size.width / 2 - 70, y: 20, width: 140, height: 140)
        self.addSubview(self.changePicture)
        self.changePicture.frame = CGRect(x: 10, y: 180, width: frame.size.width - 20, height: 40)
        self.addSubview(self.nameLabel)
        
        self.nameLabel.frame = CGRect(x: 10, y: 240, width: frame.size.width / 3 - 10, height: 50)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
