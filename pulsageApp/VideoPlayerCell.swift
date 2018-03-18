import UIKit

class VideoPlayerCell: UITableViewCell {
    
    public lazy var videoThumbnail: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    public lazy var videoDescript: UITextView = {
        let textview = UITextView()
        textview.textColor = .black
        textview.isEditable = false
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
        self.selectionStyle = .none
        super.layoutSubviews()
        
        self.addSubview(self.videoThumbnail)
        self.videoThumbnail.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.videoThumbnail.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.videoThumbnail.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.videoThumbnail.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.addSubview(self.videoDescript)
        self.videoDescript.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.videoDescript.leftAnchor.constraint(equalTo: self.videoThumbnail.rightAnchor, constant: 10).isActive = true
        self.videoDescript.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.videoDescript.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
    }
}
