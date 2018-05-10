import UIKit
import Font_Awesome_Swift

class sectionHeader: UIView {
    //Mark: CustomBtn : custom/SubClasses.swift
    
    public lazy var profileImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .white
        imageview.layer.cornerRadius = 25
        imageview.contentMode = .scaleToFill
        imageview.layer.borderColor = UIColor.white.cgColor
        imageview.layer.borderWidth = 1
        imageview.clipsToBounds = true
        imageview.isUserInteractionEnabled = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    public lazy var profileBotton: ButtonWithIcon = {
        let btn = ButtonWithIcon()
        btn.icon.image = #imageLiteral(resourceName: "pulsageBlack")
        btn.button.setTitle(" osvaldo", for: .normal)
        btn.button.setTitleColor(.black, for: .normal)
        btn.button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    public lazy var challengeSponsor: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "Sponsored Challenge"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var instagramBotton: ButtonWithIcon = {
        let btn = ButtonWithIcon()
        btn.icon.image = UIImage.init(icon: .FAInstagram, size: CGSize(width: 25, height: 25))
        btn.icon.isHidden = true //when instagra link ius working
        btn.button.setTitle(" Pulsage", for: .normal)
        btn.button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.button.setTitleColor(.black, for: .normal)
        btn.button.isHidden = true // when instagram link is wokring
        btn.translatesAutoresizingMaskIntoConstraints = false
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
        self.profileImage.topAnchor.constraint(equalTo: self.topAnchor,constant: 10).isActive = true
        self.profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(self.profileBotton)
        self.profileBotton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.profileBotton.leftAnchor.constraint(equalTo: self.profileImage.rightAnchor, constant: 10).isActive = true
        self.profileBotton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.profileBotton.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.addSubview(self.instagramBotton)
        self.instagramBotton.topAnchor.constraint(equalTo: self.profileBotton.bottomAnchor, constant: 10).isActive = true
        self.instagramBotton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        self.instagramBotton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.instagramBotton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(self.challengeSponsor)
        self.challengeSponsor.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        self.challengeSponsor.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.challengeSponsor.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.challengeSponsor.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
    }
}
