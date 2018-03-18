import UIKit

class VideosCell: UITableViewCell {
    //Mark: Visual Objects
    public lazy var videos: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = UIColor.lightGray
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        return imageview
    }()
    fileprivate lazy var videostitle: UILabel = {
        let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 10)

        return label
    }()
    fileprivate lazy var views: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    fileprivate lazy var postedby: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    //======================================
    
    //Mark: Set Text
    public var titleText: String {
        set(value) {
            return self.videostitle.text = value
        }
        get{
            return self.videostitle.text!
        }
    }
    public var viewText: String {
        set(value) {
            return self.views.text = value
        }
        get{
            return self.views.text!
        }
    }
    public var postedbyText: String {
        set(value) {
            return self.postedby.text = value
        }
        get{
            return self.postedby.text!
        }
    }
    //================================
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    fileprivate func setUI() {
        let width = Int(frame.size.width)
        self.addSubview(self.videos)
        
        self.videos.frame = CGRect(x: 10, y: 10, width: frame.size.width / 3, height: 80)
        self.videostitle.frame = CGRect(x: width / 3 + 20, y: 10, width: width / 3 * 2 - 10, height: 20)
        self.addSubview(self.videostitle)
        self.views.frame = CGRect(x: width / 3 + 20 , y: 25, width: width / 3 * 2 - 10, height: 20)
        self.addSubview(self.views)
        self.postedby.frame = CGRect(x: width / 3 + 20 , y: 50, width: width / 3 * 2 - 10, height: 20)
        self.addSubview(self.postedby)
    }

}
