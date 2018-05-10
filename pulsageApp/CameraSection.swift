import UIKit
import Font_Awesome_Swift

class CameraSection: UIView {
    
    public lazy var recordBtn: UIButton = {
        let button = UIButton()
        button.setFAIcon(icon: .FAVideoCamera, iconSize: 60, forState: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    public lazy var cameraBtn: UIButton = {
        let button = UIButton()
        button.setFAIcon(icon: .FAPictureO, iconSize: 60, forState: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(self.recordBtn)
        self.recordBtn.frame = CGRect(x: 0, y: 0, width: frame.size.width / 2, height: frame.height)
        self.addSubview(self.cameraBtn)
        self.cameraBtn.frame = CGRect(x: frame.size.width / 2, y: 0, width: frame.size.width / 2, height: frame.height)
        
    }
}
