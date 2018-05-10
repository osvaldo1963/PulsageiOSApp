import UIKit

class HomeHeaderCell: UICollectionViewCell {
    
    public lazy var thumbnail: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .gray
        imageview.layer.cornerRadius = 25
        imageview.clipsToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    public lazy var challengeTittle: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.thumbnail.image = nil
        self.challengeTittle.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(self.thumbnail)
        self.thumbnail.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.thumbnail.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.thumbnail.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.thumbnail.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(self.challengeTittle)
        self.challengeTittle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.challengeTittle.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.challengeTittle.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.challengeTittle.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
