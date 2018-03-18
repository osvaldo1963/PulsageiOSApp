import UIKit

//Mark: Menu delegate
protocol FeedBackDelegate {
    
    //mark: This function will retrun feedback text in order
    func submitFeedback(feedbackText: String)
}
//End Mark

class FeedbackController: NSObject {
    
    //Mark: public delegate variable
    public var delegate: FeedBackDelegate?
    //End Mark
    
    //Mark: Visual Objects declarations
    fileprivate lazy var feedbackTextinput: UITextView = {
        let textfield = UITextView()
        textfield.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
        textfield.font = UIFont.systemFont(ofSize: 16)
        return textfield
    }()
    
    fileprivate lazy var feeblabel: UILabel = {
        let label = UILabel()
        label.text = "Feed Back"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    fileprivate lazy var whiteBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        return view
    }()
    
    fileprivate lazy var submit: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(self.submitBtn), for: .touchUpInside)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor(red:0.87, green:0.36, blue:0.35, alpha:1.0)
        button.layer.cornerRadius = 5
        return button
    }()
    
    fileprivate lazy var feedback: UIView = {
        let viewmenu = UIView()
        viewmenu.backgroundColor = UIColor(red:0.13, green:0.11, blue:0.18, alpha:0.7)
        viewmenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(feedbackDissmiss)))
        return viewmenu
    }()
    //End Mark
    
    override init() {
        super.init()
    }
    
    //Mark: Present all visual object for the feed back alert
    @objc public func presetFeebBackController() {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.feedback)
            self.feedback.frame = window.bounds
            
            self.feedback.addSubview(self.whiteBackground)
            self.whiteBackground.frame = CGRect(x: 35, y: 100, width: window.frame.size.width - 70, height: window.frame.size.height / 2)
            
            self.whiteBackground.addSubview(self.feedbackTextinput)
            self.feedbackTextinput.frame = CGRect(x: 10, y: 50, width: window.frame.size.width - 90, height: window.frame.size.height / 2 - 110)
            
            self.whiteBackground.addSubview(self.feeblabel)
            self.feeblabel.frame =  CGRect(x: 10, y: 15 , width: window.frame.size.width - 90, height: 20)
            
            self.whiteBackground.addSubview(self.submit)
            self.submit.frame = CGRect(x: 10, y: self.feedbackTextinput.frame.origin.y + window.frame.size.height / 2 - 100, width: window.frame.size.width - 90, height: 40)
            
            self.feedback.frame = window.frame
            self.feedback.alpha = 0
            
            UIView.animate(withDuration: 0.5, animations: {
                self.feedback.alpha = 1
            })
        }
    }
    //End Mark
    
    //Mark: feedback element turn hides
    @objc fileprivate func feedbackDissmiss() {
        self.feedbackTextinput.endEditing(true)
        UIView.animate(withDuration: 0.5) {
            self.feedback.alpha = 0
        }
    }
    //End Mark
    
    //Makr: when submit element is press it will send the data to throght the delegate
    @objc fileprivate func submitBtn() {
        self.feedbackDissmiss()
        self.delegate?.submitFeedback(feedbackText: self.feedbackTextinput.text)
        self.feedbackTextinput.text = ""
    }
    //End Mark
}


