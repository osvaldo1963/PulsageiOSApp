import UIKit
import Font_Awesome_Swift

class sectionFooter: UIView {
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        return view
    }()
    
    public lazy var VideoDescription: UITextView = {
        let label = UITextView()
        label.text = ""
        label.textColor = .black
        label.isEditable = false
        label.isSelectable = true
        label.dataDetectorTypes = .link
        
        return label
    }()
    
    public lazy var ChallengeText: UILabel = {
        let label = UILabel()
        label.textColor = .orange
        label.text = "Challenge "
        label.textAlignment = .center
        return label
    }()
    
    public lazy var ArrowBtn: CustomBtn = {
        let button = CustomBtn()
        button.setTitleColor(.orange, for: .normal)
        button.contentHorizontalAlignment = .center
        button.setFAIcon(icon: .FAAngleRight, iconSize: 40, forState: .normal)
        return button
    }()
    
    public lazy var rewardBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Challenge Reward", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.subViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func subViews() {
        self.addSubview(self.VideoDescription)
        self.VideoDescription.frame = CGRect(x: 10, y: 5, width: frame.size.width / 4 * 3, height: frame.size.height - 20)
        self.VideoDescription.resolveHashTags()
        
        self.addSubview(self.ChallengeText)
        self.ChallengeText.frame = CGRect(x: frame.size.width / 4 * 3 , y: 5, width: frame.size.width / 4 , height: 20)
        
        self.addSubview(self.ArrowBtn)
        self.ArrowBtn.frame = CGRect(x: frame.size.width - 70 , y: 25, width: 50, height: 50)
        
        self.addSubview(self.rewardBtn)
        self.rewardBtn.frame = CGRect(x: 0, y: frame.size.height - 18, width: frame.size.width, height: 16)
        
        self.addSubview(self.separator)
        self.separator.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.size.width, height: 1)
    }
    
}
