import UIKit

class notifications: UIViewController {
    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: self.view.frame.size.height / 2 - 20, width: self.view.frame.size.width, height: 30)
        label.textColor = .gray
        label.text = "Notifications"
        label.textAlignment = .center
        
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.label)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
