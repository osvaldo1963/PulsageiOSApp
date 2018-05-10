import UIKit

class VideoCell: UITableViewCell {
    
    //========= Header Section ==============
    public lazy var Header: sectionHeader = {
        let view = sectionHeader(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //========= Header Section ==============
    
    //========= Body Section ==============
    public lazy var Thubnail: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .gray
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
     //========= Body Section ==============
    
    //========= Footer Section ==============
    public lazy var Footer: sectionFooter = {
        let view = sectionFooter(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     //========= Footer Section ==============
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.Thubnail.image = nil
        self.Header.profileImage.image = nil
        self.Header.profileBotton.button.setTitle(nil, for: .normal)
        self.Footer.VideoDescription.text = nil
        self.Footer.like.imageView?.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.Thubnail.image = nil
        self.Header.profileImage.image = nil
        self.Header.profileBotton.button.setTitle(nil, for: .normal)
        self.Footer.VideoDescription.text = nil
        self.Footer.like.imageView?.image = nil
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.selectionStyle = .none
        
        self.addSubview(Header)
        self.Header.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.Header.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.Header.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.Header.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.addSubview(self.Footer)
        self.Footer.heightAnchor.constraint(equalToConstant: 90).isActive = true
        self.Footer.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.Footer.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.Footer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(self.Thubnail)
        self.Thubnail.topAnchor.constraint(equalTo: self.Header.bottomAnchor).isActive = true
        self.Thubnail.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.Thubnail.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.Thubnail.bottomAnchor.constraint(equalTo: self.Footer.topAnchor).isActive = true
        
    }
}
