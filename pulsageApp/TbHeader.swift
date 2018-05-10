import UIKit

class TbHeader: UIView {
    
    public var profilePic: UIImageView = {
        let imageview = UIImageView()
        imageview.layer.cornerRadius = 25
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    public var username: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 10))
        label.textColor = .black
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var usernameBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.orange, for: .normal)
        btn.setTitle("@something", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.contentHorizontalAlignment = .left
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isHidden = true
        return btn
    }()
    
    public var instagramBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.gray, for: .normal)
        btn.setTitle("views", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    public var videoDescription: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
      
        return textview
    }()
    
    private lazy var Firstseparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var reportBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setFAIcon(icon: .FAExclamation, iconSize: 25, forState: .normal)
        btn.setTitleColor(.orange, for: .normal)
        return btn
    }()
    
    public var rocketIcon: CustomBtn = {
        let btn = CustomBtn()
        let icon = UIImage(named: "transport")
        btn.setImage(icon, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    public lazy var sharetBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setFAIcon(icon: .FAShare, iconSize: 25, forState: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.isEnabled = false
        return btn
    }()
    
    public lazy var votetBtn: CustomBtn = {
        let btn = CustomBtn()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let icon = UIImage(named: "heart")
        btn.setImage(icon, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    public lazy var voteText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Vote"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var Secondseparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var segmented: PulsageSegmented = {
        let framec = CGRect(x: 0, y: 0, width: frame.size.width, height:40)
        let segmented = PulsageSegmented(frame: framec)
        segmented.translatesAutoresizingMaskIntoConstraints = false
        return segmented
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.Subviews()
       
    }
    
    private func Subviews() {
        let withAndHeight: CGFloat = 30
        
        self.addSubview(self.profilePic)
        self.profilePic.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        self.profilePic.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.profilePic.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.profilePic.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        self.addSubview(self.username)
        self.username.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        self.username.leftAnchor.constraint(equalTo: self.profilePic.rightAnchor, constant: 20).isActive = true
        self.username.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.username.widthAnchor.constraint(equalToConstant: frame.size.width / 3).isActive = true
        
        self.addSubview(self.usernameBtn)
        self.usernameBtn.topAnchor.constraint(equalTo: self.username.bottomAnchor, constant: 5).isActive = true
        self.usernameBtn.leftAnchor.constraint(equalTo: self.profilePic.rightAnchor, constant: 20).isActive = true
        self.usernameBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.usernameBtn.widthAnchor.constraint(equalToConstant: frame.size.width / 3).isActive = true
        
        self.addSubview(self.instagramBtn)
        self.instagramBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        self.instagramBtn.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.instagramBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.instagramBtn.widthAnchor.constraint(equalToConstant: frame.size.width / 3).isActive = true
        
        self.addSubview(self.videoDescription)
        self.videoDescription.topAnchor.constraint(equalTo: self.profilePic.bottomAnchor, constant: 10).isActive = true
        self.videoDescription.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.videoDescription.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.videoDescription.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.addSubview(self.rocketIcon)
        self.rocketIcon.topAnchor.constraint(equalTo: self.videoDescription.bottomAnchor, constant: 20).isActive = true
        self.rocketIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.rocketIcon.heightAnchor.constraint(equalToConstant: withAndHeight).isActive = true
        self.rocketIcon.widthAnchor.constraint(equalToConstant: withAndHeight).isActive = true
        
        self.addSubview(self.votetBtn)
        self.votetBtn.topAnchor.constraint(equalTo: self.videoDescription.bottomAnchor, constant: 20).isActive = true
        self.votetBtn.leftAnchor.constraint(equalTo: self.rocketIcon.rightAnchor, constant: 20).isActive = true
        self.votetBtn.heightAnchor.constraint(equalToConstant: withAndHeight).isActive = true
        self.votetBtn.widthAnchor.constraint(equalToConstant: withAndHeight).isActive = true
        
        self.addSubview(self.voteText)
        self.voteText.topAnchor.constraint(equalTo: self.votetBtn.bottomAnchor, constant: -10).isActive = true
        self.voteText.leftAnchor.constraint(equalTo: self.rocketIcon.rightAnchor, constant: 20).isActive = true
        self.voteText.widthAnchor.constraint(equalToConstant: withAndHeight).isActive = true
        self.voteText.heightAnchor.constraint(equalToConstant: withAndHeight).isActive = true
        
        self.addSubview(self.sharetBtn)
        self.sharetBtn.topAnchor.constraint(equalTo: self.videoDescription.bottomAnchor, constant: 20).isActive = true
        self.sharetBtn.leftAnchor.constraint(equalTo: self.votetBtn.rightAnchor, constant: 20).isActive = true
        self.sharetBtn.heightAnchor.constraint(equalToConstant: withAndHeight).isActive = true
        self.sharetBtn.widthAnchor.constraint(equalToConstant: withAndHeight).isActive = true
        
        self.addSubview(self.reportBtn)
        self.reportBtn.topAnchor.constraint(equalTo: self.videoDescription.bottomAnchor, constant: 20).isActive = true
        self.reportBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.reportBtn.widthAnchor.constraint(equalToConstant: withAndHeight).isActive = true
        self.reportBtn.heightAnchor.constraint(equalToConstant: withAndHeight).isActive = true
    
        self.addSubview(self.Secondseparator)
        self.Secondseparator.topAnchor.constraint(equalTo: self.sharetBtn.bottomAnchor, constant: 15).isActive = true
        self.Secondseparator.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.Secondseparator.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.Secondseparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.addSubview(self.segmented)
        self.segmented.topAnchor.constraint(equalTo: self.Secondseparator.bottomAnchor, constant: 10).isActive = true
        self.segmented.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.segmented.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.segmented.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }

}

class VoteBtn: UIButton {
    var header: TbHeader?
}
