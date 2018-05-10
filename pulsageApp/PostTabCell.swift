import UIKit

class PostTabCell: UITableViewCell {
    
    //Mark: private visual objects
    public lazy var blackView: UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    
    //Mark: public visual objects
    public lazy var thumbnail: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    public lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionStyle = .none
        
        self.addSubview(self.thumbnail)
        self.thumbnail.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.thumbnail.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.thumbnail.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.thumbnail.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(self.blackView)
        self.blackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.blackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.blackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.blackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.blackView.addSubview(self.title)
        self.title.centerXAnchor.constraint(equalTo: self.blackView.centerXAnchor).isActive = true
        self.title.centerYAnchor.constraint(equalTo: self.blackView.centerYAnchor).isActive = true
        self.title.leftAnchor.constraint(equalTo: self.blackView.leftAnchor).isActive = true
        self.title.rightAnchor.constraint(equalTo: self.blackView.rightAnchor).isActive = true
    }
    
}
