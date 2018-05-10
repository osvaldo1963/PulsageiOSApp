import UIKit

class SearchSQCell: UICollectionViewCell {
    
    //Mark: Public Visual Objects
    
    private var BackgroundCover: UIView = {
        let backview  = UIView()
        backview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        backview.translatesAutoresizingMaskIntoConstraints = false
        return backview
    }()
    
    public var Thumbnail: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    public var CameraIcon: UIButton = {
        let button = UIButton()
        button.setFAIcon(icon: .FAVideoCamera, iconSize: 20, forState: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //====================================
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(self.Thumbnail)
        self.Thumbnail.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.Thumbnail.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.Thumbnail.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.Thumbnail.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(BackgroundCover)
        self.BackgroundCover.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.BackgroundCover.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.BackgroundCover.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.BackgroundCover.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.BackgroundCover.addSubview(self.CameraIcon)
        self.CameraIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.CameraIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.CameraIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.CameraIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
}
