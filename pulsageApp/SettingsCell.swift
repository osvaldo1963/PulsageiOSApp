import UIKit

class SettingsCell: UICollectionViewCell {
    
    public lazy var setting: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubviews()
    }
    
    func addSubviews() {
        self.addSubview(self.setting)
        self.setting.frame = CGRect(x: 10, y: 0, width: frame.size.width, height: frame.size.height)
    }
    
}
