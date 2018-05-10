import UIKit

class  TermsConditions: UIViewController {
    
    let aboutText = AboutText()
    
    fileprivate lazy var text: UITextView = {
        let textview = UITextView()
        textview.isEditable = false
        textview.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        textview.text = self.aboutText.termsConditionsText
        textview.font = UIFont(name: "Arial", size: 18)
        return textview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let backArrow = UIImage.init(icon: .FAAngleLeft, size: CGSize(width: 40, height: 40))
        let backBtn = UIBarButtonItem(image: backArrow, style: .done, target: self, action: #selector(BackButtonAction))
        self.navigationController?.navigationBar.topItem?.title = "Termns & Conditions"
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = backBtn
        self.view.addSubview(self.text)
    }
    
    @objc fileprivate func BackButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
