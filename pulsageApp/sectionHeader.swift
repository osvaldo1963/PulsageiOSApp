import UIKit
import Font_Awesome_Swift

class sectionHeader: UIView {
    //Mark: CustomBtn : custom/SubClasses.swift
    
    public lazy var profileImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .lightGray
        imageview.layer.cornerRadius = 25
        imageview.contentMode = .scaleToFill
        imageview.layer.borderColor = UIColor.white.cgColor
        imageview.layer.borderWidth = 1
        imageview.clipsToBounds = true
        return imageview
    }()
    
    public lazy var profileBotton: ButtonWithIcon = {
        let btn = ButtonWithIcon()
        btn.icon.image = #imageLiteral(resourceName: "pulsageBlack")
        btn.button.setTitle(" osvaldo", for: .normal)
        btn.button.setTitleColor(.black, for: .normal)
        btn.button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    
    public lazy var challengeSponsor: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "Sponsored Challenge"
        return label
    }()
    
    public lazy var instagramBotton: ButtonWithIcon = {
        let btn = ButtonWithIcon()
        btn.icon.image = UIImage.init(icon: .FAInstagram, size: CGSize(width: 25, height: 25))
        btn.button.setTitle(" Pulsage", for: .normal)
        btn.button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.button.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.subViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func subViews() {
        self.backgroundColor = .white
        
        self.addSubview(self.profileImage)
        self.profileImage.frame = CGRect(x: 20, y: frame.size.height / 2 - 25, width: 50, height: 50)
        
        self.addSubview(self.profileBotton)
        self.profileBotton.frame = CGRect(x: 80, y: frame.size.height / 2 - 25, width: frame.size.width / 2, height: 20)

        self.addSubview(self.instagramBotton)
        self.instagramBotton.frame = CGRect(x: 80, y: frame.size.height / 2 + 5, width: 100, height: 20)
       
        
        self.addSubview(self.challengeSponsor)
        self.challengeSponsor.frame = CGRect(x: 10, y: frame.size.height - 12, width: frame.size.width / 2, height: 10)
        
    }
}
