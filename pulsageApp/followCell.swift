import UIKit

class Followcell: UITableViewCell {
    
    public lazy var userimage: UIImageView = {
        let imagaview = UIImageView()
        imagaview.frame = CGRect(x: 15, y: 5, width: 40, height: 40)
        imagaview.backgroundColor = .gray
        imagaview.layer.cornerRadius = 20
        imagaview.clipsToBounds = true
        
        return imagaview
    }()
    
    public lazy var usernametext: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 70, y: 5, width: frame.size.width, height: 20)
        label.font = UIFont(name: "Helvetica-Light", size: 14)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(self.userimage)
        self.addSubview(self.usernametext)
    }
}
