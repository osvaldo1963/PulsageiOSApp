import UIKit

class VideoCell: UITableViewCell {
    
    //========= Header Section ==============
    public lazy var Header: sectionHeader = {
        let view = sectionHeader(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height / 4))
        return view
    }()
    //========= Header Section ==============
    
    //========= Body Section ==============
    public lazy var Thubnail: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .gray
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
     //========= Body Section ==============
    
    //========= Footer Section ==============
    public lazy var Footer: sectionFooter = {
        let view = sectionFooter(frame: CGRect(x: 0, y: frame.size.height / 4 * 3 , width: frame.size.width, height: frame.size.height / 4))
        return view
    }()
     //========= Footer Section ==============
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        self.addSubview(Header)
        self.addSubview(self.Thubnail)
        self.Thubnail.frame = CGRect(x: 0, y: frame.size.height / 4, width: frame.size.width, height: frame.size.height / 4 * 2)
        self.addSubview(self.Footer)
        
    }
}
