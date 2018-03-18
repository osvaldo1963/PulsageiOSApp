import UIKit

class challengeCell: UITableViewCell {
    public lazy var title: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 5, width: frame.size.width, height: 20)
        label.font = UIFont(name: "Helvetica", size: 14)
        return label
    }()
    
    public lazy var descrip: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 25, width: frame.size.width, height: 20)
        label.font = UIFont(name: "Helvetica-Light", size: 12)
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
        self.addSubview(self.title)
        self.addSubview(self.descrip)
    }
}
