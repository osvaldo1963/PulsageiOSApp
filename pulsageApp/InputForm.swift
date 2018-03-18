import UIKit

class Inputform: UIView {
    public var LabelTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Arial", size: 18)
        return label
    }()
    
    public var InputField: UITextField = {
        let textfield = UITextField()
        textfield.textAlignment = .right
        return textfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.LabelTitle)
        self.LabelTitle.frame = CGRect(x: 10, y: 0, width: frame.size.width / 3 , height: frame.size.height)
        self.addSubview(self.InputField)
        self.InputField.frame = CGRect(x: frame.size.width / 3, y: 0, width: frame.size.width / 3 * 2 - 10, height: frame.size.height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
