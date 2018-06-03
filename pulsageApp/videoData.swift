import UIKit
import Parse
import AVKit
import AVFoundation
import NotificationBannerSwift

class videoData: UIViewController {
    
    //Mark: public variable
    public var videoUrl : URL?
    public var challengeObject: PFObject?
    
    //Mark: fileprivate variable
    private var challenges          = [PFObject]()
    private var challengeNameHolder = [""]
    private let challengePicker     = ChallengePicker()
    
    
    private let parsedata = ParseFunctions()
    private var pulsageServices = PulsageServices()
    private var video = AVPlayer()
    
    private var player: AVPlayerViewController = {
        let con = AVPlayerViewController()
        con.view.translatesAutoresizingMaskIntoConstraints = false
        return con
    }()
    
    private lazy var videoDescription: UITextView = {
        let textview = UITextView()
        textview.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        textview.layer.borderWidth = 1
        textview.delegate = self
        textview.autocorrectionType = .no
        textview.font = UIFont.systemFont(ofSize: 16)
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
    
    private lazy var Picker: UIButton = {
        let picker = UIButton()
        picker.backgroundColor = UIColor(red:0.87, green:0.36, blue:0.35, alpha:1.0)
        picker.layer.cornerRadius = 20
        picker.setTitle("Upload to a Challenge?", for: .normal)
        picker.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        picker.setTitleColor(.white, for: .normal)
        picker.addTarget(self, action: #selector(challengeController), for: .touchUpInside)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var optionalText: UILabel = {
        let label = UILabel()
        label.text  = "(optional)"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        self.ifChallengeExist()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.video.pause()
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
        self.Picker.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        self.Picker.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        self.Picker.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(self.optionalText)
        self.optionalText.topAnchor.constraint(equalTo: self.Picker.bottomAnchor, constant: 5).isActive = true
        self.optionalText.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.optionalText.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.optionalText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(self.uploadVideo)
        self.uploadVideo.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        self.uploadVideo.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.uploadVideo.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.uploadVideo.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        self.setVideoPlayer()
        
        //Mark: Video and challenge picker delegates
        self.challengePicker.delegate = self
    }
    
    private func ifChallengeExist() {
        guard let cha = self.challengeObject else {return}
        cha.fetchInBackground { (result, error) in
            if error == nil {
                guard let challenge = result else {return}
                guard let chaDescription = challenge["description"] as? String else {return}
                DispatchQueue.main.async {
                    self.Picker.setTitle(chaDescription, for: .normal)
                }
            }
        }
    }
    
    private func setVideoPlayer() {
        guard let urlback = self.videoUrl else {return}
        self.video = AVPlayer(url: urlback)
        self.player.player = video
        self.video.play()
        
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
        guard let url = self.videoUrl else {return}
        
        //self.parsedata.uploadVideo(videoUrl: url) { (result, error) in
           
        //}
        
        
        let User = PFUser.current()
        let videoDescription = self.videoDescription.text!
        if User == nil  || videoDescription.isEmpty {
            self.simpleAlert(Message: "Video Description is required! ", title: "Error")
        } else {
            guard let currentUser = User else {return}
            if let challenge = self.challengeObject {
                
                self.pulsageServices.videoUrl = url
                self.pulsageServices.user = currentUser
                self.pulsageServices.name = ""
                self.pulsageServices.descript = videoDescription
                self.pulsageServices.challenge = challenge
                self.pulsageServices.uploadVideo { (result, err) in
                    if err == nil {
                        
                        
                    } else {
                        
                    }
                }
                self.dismissControler()
                
            } else {
                self.pulsageServices.videoUrl = url
                self.pulsageServices.user = currentUser
                self.pulsageServices.name = ""
                self.pulsageServices.descript = videoDescription
                self.pulsageServices.challenge = nil
                self.pulsageServices.uploadVideo { (result, err) in
                    if err == nil {
                        
                        
                    } else {
                     
                    }
                }
                self.dismissControler()
            }
        }
 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.videoDescription.endEditing(true)
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
            let results = regex.matches(in: text ,options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, text.count))
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
        guard let challengename = object["description"] as? String else {return}
        DispatchQueue.main.async {
            self.Picker.setTitle("Current Challenge: \(challengename) ", for: .normal)
        }
        
    }
}


