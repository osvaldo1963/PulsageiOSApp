import UIKit

class VideoProgress: UIView {
    
    public lazy var message: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = UIColor(red:0.87, green:0.36, blue:0.35, alpha:0.7)
        label.textAlignment = .center 
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        
        self.addSubview(self.message)
        self.message.topAnchor.constraint(equalTo: self.topAnchor, constant: 45).isActive = true
        self.message.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.message.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.message.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .gray
        self.addSubview(self.message)
        self.message.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.message.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.message.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.message.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    
}
