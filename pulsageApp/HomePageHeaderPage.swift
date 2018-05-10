import UIKit
import AVFoundation
import Parse
import SDWebImage

protocol HomePageHeaderPageDelegate {
    func attemptBtn()
}

class HomePageHeaderPage: UIViewController {
    
    public var delegate: HomePageHeaderPageDelegate?
    public var challengeId = ""
    //=============================================
    // Mark: Private Variables
    //=============================================
    private var isTimerRuning = false
    private var timer = Timer()
    private var second = 0
    private var player = AVPlayer()
    private var videoDurationTime = 0.0
    private var correntIndex = 0
    private var videosArray: [PFObject] = []
    //=============================================
    // Mark: End Private Variables
    //=============================================
    
    //=============================================
    // Mark: Private Variables Visual Objects
    //=============================================
    
    public lazy var profileIcon: ButtonWithIcon = {
        let button = ButtonWithIcon()
        button.button.setTitle("", for: .normal)
        button.button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.icon.image = UIImage(named: "")
        button.icon.clipsToBounds = true
        button.icon.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.setFAIcon(icon: .FAClose, iconSize: 25, forState: .normal)
        button.setFATitleColor(color: .white)
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var playerLayer: AVPlayerLayer = {
        let bp = AVPlayerLayer()
        return bp
    }()
    
    private lazy var blackView: UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    
    private lazy var challengeCamption: UITextView = {
        let textview = UITextView()
        textview.backgroundColor = UIColor.clear
        textview.textAlignment = .left
        textview.textColor = .white
        textview.font = UIFont.systemFont(ofSize: 14)
        textview.isEditable = false
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
    
    private lazy var attemptBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Attempt!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.presentCamera), for: .touchUpInside)
        return button
    }()
    //=============================================
    // Mark: End Private Visual Objects
    //=============================================
    
    //=============================================
    // Mark: UiViewController Default Functions
    //=============================================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewProps()
        self.addSubviews()
        
      
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.startedCounter()
        self.correntIndex = 0
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.challengeData()
            self.getVideos()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player.pause()
        UIApplication.shared.statusBarStyle = .default
        self.player.pause()
        self.player.seek(to: kCMTimeZero)
        self.playerLayer.player = nil
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //=============================================
    // Mark: End UiViewController Default Functions
    //=============================================
    
    //=============================================
    // Mark: ViewController Start Props
    //=============================================
    private func viewProps() {
        self.view.backgroundColor = .black
    }
    
    private func addSubviews() {
        let saveAreaLayout = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(self.profileIcon)
        self.profileIcon.topAnchor.constraint(equalTo: saveAreaLayout.topAnchor, constant: 20).isActive = true
        self.profileIcon.leftAnchor.constraint(equalTo: saveAreaLayout.leftAnchor, constant: 20).isActive = true
        self.profileIcon.rightAnchor.constraint(equalTo: saveAreaLayout.rightAnchor, constant: -70).isActive = true
        self.profileIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.profileIcon.icon.layer.cornerRadius = 20
        
        self.view.addSubview(self.closeBtn)
        self.closeBtn.topAnchor.constraint(equalTo: saveAreaLayout.topAnchor, constant: 20).isActive = true
        self.closeBtn.rightAnchor.constraint(equalTo: saveAreaLayout.rightAnchor, constant: -20).isActive = true
        self.closeBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.closeBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(self.blackView)
        self.blackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.blackView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.blackView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.blackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.blackView.addSubview(self.challengeCamption)
        self.challengeCamption.bottomAnchor.constraint(equalTo: saveAreaLayout.bottomAnchor).isActive = true
        self.challengeCamption.leftAnchor.constraint(equalTo: saveAreaLayout.leftAnchor).isActive = true
        self.challengeCamption.rightAnchor.constraint(equalTo: saveAreaLayout.rightAnchor).isActive = true
        self.challengeCamption.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.challengeCamption.text = ""
        
        self.blackView.addSubview(self.attemptBtn)
        self.attemptBtn.centerXAnchor.constraint(equalTo: self.blackView.centerXAnchor).isActive = true
        self.attemptBtn.centerYAnchor.constraint(equalTo: self.blackView.centerYAnchor).isActive = true
        self.attemptBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.attemptBtn.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2).isActive = true
        
    }
    //=============================================
    // Mark: End ViewController Start Props
    //=============================================
    
    //=============================================
    // Mark: GetVideos Data
    //=============================================
    private func getVideos() {
        
        PFCloud.callFunction(inBackground: "bestvideosForChallenge", withParameters: ["challengeId": self.challengeId]) {
            (result, error) in
            
            guard let videos = result as? [PFObject] else {return}
            let sorted = videos.sorted(by: {($0["Votes"] as AnyObject).count > ($1["Votes"] as AnyObject).count})
            self.videosArray = sorted
            self.setViedeoPlayer()
        }
    }
    //=============================================
    // Mark: End GetVideos Data
    //=============================================
    
    private func setViedeoPlayer() {
        guard let videoFile = self.videosArray[self.correntIndex]["video"] as? PFFile else {return}
        guard let videoUrl = videoFile.url else {return}
        guard let url = URL(string: videoUrl) else {return}
        self.player = AVPlayer(url: url)
        self.playerLayer  = AVPlayerLayer(player: self.player)
        self.playerLayer.frame = self.view.bounds
        self.playerLayer.videoGravity = .resizeAspect
        self.view.layer.insertSublayer(self.playerLayer, at: 0)
        self.player.play()
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
    }
    
    
    //=============================================
    // Mark: Observer Function
    //=============================================
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.correntIndex = self.correntIndex + 1
        if self.videosArray.count > self.correntIndex {
            guard let videoFile = self.videosArray[self.correntIndex]["video"] as? PFFile else {return}
            guard let videoUrl = videoFile.url else {return}
            guard let url = URL(string: videoUrl) else {return}
            self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
            self.player.play()
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        }
    }
    //=============================================
    // Mark: End Observer Function
    //=============================================
    
    //=============================================
    // Mark: Touch Actions
    //=============================================
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.isTimerRuning  {
            self.stopCounter()
        } else {
            self.startedCounter()
        }
    }
    //=============================================
    // Mark: End Touch Actions
    //=============================================
    
    //=============================================
    // Mark: Counter Functions
    //=============================================
    private func startedCounter() {
        self.isTimerRuning = true
        self.second = 0
        self.hideAndShow(hide: false)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (currentTime) in
            self.second = self.second + 1
            if self.second == 6 {
                self.stopCounter()
            }
        })
    }
    
    private func stopCounter() {
        self.timer.invalidate()
        self.isTimerRuning = false
        self.hideAndShow(hide: true)
        
    }
    
    //=============================================
    // Mark: End Counter Functions
    //=============================================
    
    private func hideAndShow(hide: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.blackView.isHidden = hide
            self.challengeCamption.isHidden = hide
            self.attemptBtn.isHidden = hide
        }
    }
    
    
    //=============================================
    // Mark: Button Actions
    //=============================================
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func attemptBtnAction() {
        self.dismissView()
        self.delegate?.attemptBtn()
    }
    //=============================================
    // Mark: End Button Actions
    //=============================================
    
    //=============================================
    // Mark: Get Challenge Data
    //=============================================
    @objc private func challengeData() {
        let challengeObject = PFObject(withoutDataWithClassName: "Challenges", objectId: self.challengeId)
        challengeObject.fetchInBackground { (object, error) in
            if error == nil {
                guard let challenge = object else {return}
                guard let challengeUser = challenge["User"] as? PFObject else {return}
                challengeUser.fetchInBackground(block: { (userData, error) in
                    if error == nil {
                        guard let user = userData else {return}
                        guard let userFile = user["profilePicture"] as? PFFile else {return}
                        guard let userPicUrl = userFile.url else {return}
                        guard let url = URL(string: userPicUrl) else {return}
                        self.profileIcon.icon.sd_setImage(with: url, completed: nil)
                        
                        guard let userName = user["username"] as? String else {return}
                        self.profileIcon.button.setTitle(" \(userName.getTextFromEmail())", for: .normal)

                    }
                })
                
                guard let challengeDescription = challenge["description"] as? String else {return}
                self.challengeCamption.text = " \(challengeDescription)"
                
            }
        }
    }
    //=============================================
    // Mark: Get Challenge Data
    //=============================================
    
    //=============================================
    // Mark: Present Camera
    //=============================================
    @objc private func presentCamera() {
        let cameraController = CameraRecorded()
        let rootNavigationController = UINavigationController(rootViewController: cameraController)
        rootNavigationController.gradientBackground()
        self.present(rootNavigationController, animated: true, completion: nil)
    }
    //=============================================
    // Mark: End Present Camera
    //=============================================
    
}

extension PFObject {
    func relationDataBack(className: String) -> [PFObject] {
        let classRelation = self.relation(forKey: className)
        let query = classRelation.query()
        do {
            let tryQuery = try query.findObjects()
            return tryQuery
        } catch {
            return [PFObject()]
        }
    }
    
    
}
