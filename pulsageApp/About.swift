import UIKit

class About: UIViewController {
    public var section = ""
    public var titleText = ""
    
    let aboutText = AboutText()
    
    fileprivate lazy var text: UITextView = {
        let textview = UITextView()
        textview.isEditable = false
        textview.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        textview.font = UIFont(name: "Arial", size: 18)
        return textview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.text)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = self.titleText
        
        switch section {
        case "termsConditions":
            self.text.text = self.aboutText.termsConditionsText
        case "privacyPolicy":
            self.text.text = self.aboutText.privacyPolicy
        case "openSource":
            self.text.text = self.aboutText.OpenSourceLibraries
        default:
            return
        }
    }
    
}
