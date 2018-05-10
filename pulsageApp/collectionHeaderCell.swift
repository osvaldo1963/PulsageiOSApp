import UIKit

class collectionHeaderCell: UICollectionViewCell {

    public lazy var thumbnail: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
   private lazy var blackCover: UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    
    
    public lazy var videoDescription: UITextView = {        //<=========== this is not added to the cell subview if this is not need it remove it
        let tv = UITextView()
        tv.isEditable = false
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.text = ""
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let gradiendL = CAGradientLayer()
        gradiendL.colors =  [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradiendL.locations = [0.0, 1.0]
        gradiendL.startPoint = CGPoint(x: 0, y: 0)
        gradiendL.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradiendL.frame = self.blackCover.bounds
        self.blackCover.layer.insertSublayer(gradiendL, at: 0)
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(self.thumbnail)
        self.thumbnail.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.thumbnail.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.thumbnail.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.thumbnail.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(self.blackCover)
        self.blackCover.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.blackCover.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.blackCover.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.blackCover.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
