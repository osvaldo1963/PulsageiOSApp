import UIKit
import Parse
import AVKit
import AVFoundation

class videoData: UIViewController {
    
    //Mark: public variable
    public var videoUrl : URL?
    
    //Mark: fileprivate variable
    fileprivate var challenges          = [PFObject]()
    fileprivate var challengeNameHolder = [""]
    fileprivate let challengePicker     = ChallengePicker()
    
    fileprivate var challengeObject: PFObject?
    
    
    private var player: AVPlayerViewController = {
        let con = AVPlayerViewController()
        con.view.translatesAutoresizingMaskIntoConstraints = false
        return con
    }()
    
    fileprivate lazy var videoDescription: UITextView = {
        let textview = UITextView()
        textview.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        textview.layer.borderWidth = 1
        textview.delegate = self
        textview.autocorrectionType = .no
        textview.font = UIFont.systemFont(ofSize: 16)
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
    
    fileprivate lazy var Picker: UIButton = {
        let picker = UIButton()
        picker.setTitle("Upload to a Challenge? (optional)", for: .normal)
        picker.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        picker.setTitleColor(.black, for: .normal)
        picker.addTarget(self, action: #selector(challengeController), for: .touchUpInside)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var uploadVideo: UIButton = {
        let button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.backgroundColor = UIColor(red:0.87, green:0.36, blue:0.35, alpha:1.0)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(self.uploadBtn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    //===============================
    
    //Mark: viewconroller default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.addsubviews()
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.session.startRunning()
        self.navigationController?.navigationBar.topItem?.title = "Upload Video!"
        self.navigationControllerProps()
        self.videosize(url: self.videoUrl!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     
    }
    
    //Mark: private functions
    private func addsubviews() {
        self.view.addSubview(self.player.view)
        self.addChildViewController(self.player)
        self.player.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive     = true
        self.player.view.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive   = true
        self.player.view.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.player.view.heightAnchor.constraint(equalToConstant: self.view.frame.size.height / 3).isActive  = true
        
        self.view.addSubview(self.videoDescription)
        self.videoDescription.topAnchor.constraint(equalTo: self.player.view.bottomAnchor, constant: 30).isActive   = true
        self.videoDescription.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive   = true
        self.videoDescription.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.videoDescription.heightAnchor.constraint(equalToConstant: self.view.frame.height / 5).isActive       = true
        
        self.view.addSubview(Picker)
        self.Picker.topAnchor.constraint(equalTo: self.videoDescription.bottomAnchor, constant: 10).isActive = true
        self.Picker.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive        = true
        self.Picker.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive      = true
        self.Picker.heightAnchor.constraint(equalToConstant: 40).isActive                                    = true
        
        self.view.addSubview(self.uploadVideo)
        self.uploadVideo.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        self.uploadVideo.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.uploadVideo.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.uploadVideo.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        self.setVideoPlayer()
        
        //Mark: Video and challenge picker delegates
        self.challengePicker.delegate = self
    }
    
    
    private func setVideoPlayer() {
        guard let urlback = self.videoUrl else {return}
        let video = AVPlayer(url: urlback)
        self.player.player = video
        video.play()
    }
    
    private func navigationControllerProps() {
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissControler))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = cancelBtn
       
    }
    
    //Mark: @objc functions
    @objc private func challengeController() {
        challengePicker.modalTransitionStyle = .coverVertical
        challengePicker.modalPresentationStyle = .overCurrentContext
        self.present(challengePicker, animated: true, completion: nil)
    }
    
    
    private func videosize(url: URL) {
        do {
            let resources = try url.resourceValues(forKeys: [.fileSizeKey])
            guard let filesize = resources.fileSize else {return}
            let file = Double(filesize / 1024)
            print(file / 1024)
        } catch {
            
        }
    }
    
    @objc private func dismissControler() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func uploadBtn() {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {return}
        guard let url = self.videoUrl else {return}
        let User = PFUser.current()
        let videoDescription = self.videoDescription.text!
        if User == nil  || videoDescription.isEmpty {
            self.simpleAlert(Message: "Video Description is required! ", title: "Error")
        } else {
        
            guard let currentUser = User else {return}
            if let challenge = self.challengeObject {
                app.submitVideos(videoUrl: url, user: currentUser, name: "", descript: videoDescription, challenge: challenge)
                self.dismissControler()
            } else {
                app.submitVideos(videoUrl: url, user: currentUser, name: "", descript: videoDescription, challenge: nil)
                self.dismissControler()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.videoDescription.endEditing(true)
    }
    
    private func checkHastags() {
        
    }
    
}

extension videoData: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.attributedText = convertHashtags(text: textView.text)
        
    }
    
    func convertHashtags(text: String) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: text)
        attrString.beginEditing()
        // match all hashtags
        do {
            // Find all the hashtags in our string
            let regex = try NSRegularExpression(pattern: "(?:\\s|^)(#(?:[a-zA-Z].*?|\\d+[a-zA-Z]+.*?))\\b", options: NSRegularExpression.Options.anchorsMatchLines)
            let results = regex.matches(in: text ,options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, text.characters.count))
            let array = results.map { (text as NSString).substring(with: $0.range) }
            for hashtag in array {
                // get range of the hashtag in the main string
                let range = (attrString.string as NSString).range(of: hashtag)
                // add a colour to the hashtag
                attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue , range: range)
            }
            attrString.endEditing()
        }
        catch {
            attrString.endEditing()
        }
        return attrString
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        moveTextField(textView, moveDistance: -210, up: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        moveTextField(textView, moveDistance: -210, up: false)
    }
    
    func moveTextField(_ textField: UITextView, moveDistance: Int, up: Bool) {
        let moveDuration = 0.2
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    
}

//Mark: challenge picked delegate
extension videoData: searchChallengeDelegate {
    func searchObeject(object: PFObject) {
        self.challengeObject = object
        guard let challengename = object["title"] as? String else {return}
        DispatchQueue.main.async {
            self.Picker.setTitle("Current Challenge: \(challengename) ", for: .normal)
        }
        
    }
}


