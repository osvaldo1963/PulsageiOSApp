import UIKit
import Parse

class ChallengeTab: UIViewController {
    
    public var PFObjectData = ""
    
    private let cellId = "cellid"
    private var challengesForTable: [PFObject] = []
    private let parseData = ParseFunctions()
    
    private lazy var  header: ChallengeHeader = {
        let header = ChallengeHeader()
        header.delegate = self
        header.frame = CGRect(x: 0, y:0 , width: self.view.frame.width, height: 300)
        return header
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        activity.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activity.hidesWhenStopped = true
        activity.center = self.view.center
        return activity
    }()
    
    private lazy var tableview: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.register(VideoCell.self, forCellReuseIdentifier: self.cellId)
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Visual Props
        self.setViewControllerProps()
        self.setSubviewContrains()
        //
        
        //Data functions
        DispatchQueue.global(qos: .userInteractive).async {
            self.setHeaderData()
        }
        ///
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationProps()
        
    }
    //UI Props
    private func navigationProps() {
        //let challengeData = self.PFObjectData
        
        //guard let navigationTitle = challengeData["title"] as? String else {return}
        self.navigationController?.navigationBar.topItem?.title = "Challenge"
    }
    
    private func setViewControllerProps() {
        self.view.backgroundColor = .white
    }
   
    
    private func setSubviewContrains() {
        self.view.addSubview(self.tableview)
        self.tableview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive      = true
        self.tableview.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive    = true
        self.tableview.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive  = true
        self.tableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        
        self.tableview.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
    }
    ///
    
    //Mark: Data functions
    private func setHeaderData() {
        let challengeData = self.PFObjectData
        
        let query = PFQuery(className: "Challenges")
        query.whereKey("objectId", equalTo: challengeData)
        query.getFirstObjectInBackground { (data, error) in
            if error == nil {
                guard let challenge = data else {return}
                guard let challDescription = challenge["description"] as? String else  {return}
                self.getVideosForChallenge(challengeData: challenge)
                
                guard let user = challenge["User"] as? PFObject else {return}
                user.fetchInBackground { (object, error) in
                    if error == nil {
                        guard let userData = object else {return}
                        guard let objectFiel = userData["profilePicture"] as? PFFile else {return}
                        guard let PictureUrl = objectFiel.url else {return}
                        guard let urlLink  = URL(string: PictureUrl) else {return}
                        guard let userName = userData["username"] as? String else {return}
                        
                        self.header.creatorProfileBtn.setTitle("@\(userName.getTextFromEmail())", for: .normal)
                        let tapGesture = GestureRescognizer(target: self, action: #selector(self.presentprofile(sender:)))
                        tapGesture.data = userData
                        self.header.challengeCreatorImage.sd_setImage(with: urlLink)
                        self.header.challengeCreatorImage.isUserInteractionEnabled = true
                        self.header.challengeCreatorImage.addGestureRecognizer(tapGesture)
                        
                    }
                }
                self.header.challengeCaption.text = challDescription
            }
        }
        
    }
    
    private func getVideosForChallenge(challengeData: PFObject) {
        
        //guard let challengeId = challengeData.objectId else {return}
        let query = PFQuery(className: "Videos")
        query.whereKey("Challenges", equalTo: challengeData)
        query.findObjectsInBackground { (data, error) in
            if error == nil {
                guard let result = data else {return}
                if result.count == 0 {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.header.objects = self.voteCount(videos: result) //<======= Call Vote count function
                    self.challengesForTable = result
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                        self.header.pageController.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    
    private func voteCount(videos: [PFObject]) -> [PFObject] {
        var result = [Int]()
        for video in videos {
            let relation = video.relation(forKey: "Vote")
            let query = relation.query()
            do {
                let back = try query.findObjects()
                result.append(back.count)
            } catch {
                print(error)
            }
            
        }
        guard let maxFormArray = result.max() else {return [PFObject()]}
        guard let index = result.index(of: maxFormArray) else {return [PFObject()]}
        let bestVideo = videos[index]
        guard let firstVideo = videos.last else {return [PFObject()]}
        return [firstVideo, bestVideo]
    
    }
    ///
    
    //=============================================================
    //========================= Firs this one
    //=============================================================
    @objc private func presentprofile(sender: GestureRescognizer) {
        guard let data = sender.data else {return}
        let profileTab = ProfileTab()
        profileTab.userObject = data
        self.navigationController?.pushViewController(profileTab, animated: true)
    }
    
    @objc private func presentProfile(sender: iconButton) {
        guard let data = sender.object else {return}
        let profileTab = ProfileTab()
        profileTab.userObject = data
        self.navigationController?.pushViewController(profileTab, animated: true)
    }
    //=============================================================
    //=============================================================
    
    
    //================================================
    //Mark: Multi porpuse Functions
    //================================================
    @objc private func presentChallenge(sender: CustomBtn) {
        guard let obData = sender.object?.objectId else {return}
        let challegeview = ChallengeTab()
        challegeview.PFObjectData = obData
        self.navigationController?.pushViewController(challegeview, animated: true)
    }
    
  
    
    private func PresentVideoPlayer(video: PFObject, RealetedVideos: [PFObject]?) {
        let videoPlayer = VideoPlayer()
        videoPlayer.videdata = video
        self.navigationController?.pushViewController(videoPlayer, animated: true)
    }
    
    private func presentHashTag(hashtag: String) {
        let hastagPage = HashTag()
        hastagPage.hashTagString = hashtag
        self.navigationController?.pushViewController(hastagPage, animated: true)
    }
    
    @objc private func commentPage(sender: iconButton) {
        guard let videoData = sender.object else {return}
        let commentPage = VideoComment()
        commentPage.videoObject = videoData
        self.navigationController?.pushViewController(commentPage, animated: true)
    }
    //================================================
    //Mark: End Multi porpuse Functions
    //================================================
    @objc private func likeAction(sender: CustomBtn) {
        self.parseData.likeButtonAction(sender: sender)
    }
    
    @objc private func presentReward(sender: CustomBtn) {
        guard let id  = sender.id else {return}
        let rewardPage = RewardItem()
        rewardPage.challengeid = id
        self.navigationController?.pushViewController(rewardPage, animated: true)
    }
    
}

extension ChallengeTab: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let Header = self.header
        Header.followBtn.isHidden = true //challenge Follow bottom hidden until we make it work
        return Header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.challengesForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? VideoCell else {return UITableViewCell()}
        let videoForRow = self.challengesForTable[indexPath.row]
        
        return self.videoCell(cell: cell, row: videoForRow)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height / 2 + 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoPlayer = VideoPlayer()
        videoPlayer.videdata = self.challengesForTable[indexPath.row]
        self.navigationController?.pushViewController(videoPlayer, animated: true)
    }
    
}

extension ChallengeTab: ChallengeHeaderTaped {
    func videoSelected(item: PFObject) {
        let videoPlayer = VideoPlayer()
        videoPlayer.videdata = item
        self.navigationController?.pushViewController(videoPlayer, animated: true)
    }
}

extension ChallengeTab {
    func videoCell(cell: VideoCell, row: PFObject) -> VideoCell{
        
        cell.Header.challengeSponsor.isHidden = true //only for sponsor section
        row.fetchInBackground { (result, error) in
            if error == nil {
                guard let rowdata = result else {return} //<---- unwrap PFObject
                //============ InMark: Header ==============
                guard let user = rowdata["User"] as? PFUser else {return}
                user.fetchInBackground { (userData, error) in
                    if error == nil {
                        guard let data = userData else {return }
                        guard let userfile = data["profilePicture"] as? PFFile else {return}
                        guard let userPicture = userfile.url else {return}
                        let tapGesture = GestureRescognizer(target: self, action: #selector(self.presentprofile(sender:)))
                        tapGesture.data = data
                        cell.Header.profileImage.addGestureRecognizer(tapGesture)
                        cell.Header.profileImage.isUserInteractionEnabled = true
                        
                        DispatchQueue.main.async {
                            cell.Header.profileImage.sd_setImage(with: URL(string: userPicture), placeholderImage: UIImage(named: "User"), options: .transformAnimatedImage, completed: { (image, error, catched, url) in
                            })
                            cell.Header.profileBotton.button.setTitle("\(data.handle)", for: .normal)
                        }
                        cell.Header.profileBotton.button.object = data
                        cell.Header.profileBotton.button.addTarget(self, action: #selector(self.presentProfile(sender:)), for: .touchUpInside)
                    }
                }
                //=========== InMark: Header ==============
                
                //========== InMark: Body ==================
                guard let file = rowdata["thumbnail"] as? PFFile else {return }
                DispatchQueue.main.async {
                    cell.Thubnail.sd_setImage(with: file.getImage(), completed: nil)
                }
                //========== InMark: Body ==================
                
                //========== InMark: Footer ==================
                guard let challenge = rowdata["Challenges"] as? PFObject else {return}
                //rocket icon props
                if challenge.objectId == "nil" {
                    DispatchQueue.main.async {
                        cell.Footer.rocket.isEnabled = false
                    }
                } else {
                    challenge.fetchInBackground { (cha, error) in
                        if error == nil {
                            guard let chadata = cha else {return}
                            cell.Footer.rocket.isEnabled = true
                            cell.Footer.rocket.object = chadata
                            cell.Footer.rocket.addTarget(self, action: #selector(self.presentChallenge(sender:)), for: .touchUpInside)
                            
                            guard let rewardId = chadata["reward"] as? String else {return}
                            print(rewardId)
                            if rewardId.isEmpty {
                                cell.Footer.ruby.isEnabled = false
                            } else {
                                cell.Footer.ruby.isEnabled = true
                                cell.Footer.ruby.id = rewardId
                                cell.Footer.ruby.addTarget(self, action: #selector(self.presentReward(sender:)), for: .touchUpInside)
                            }
                        }
                    }
                }
                //comments icon props
                cell.Footer.comment.object = row
                cell.Footer.comment.addTarget(self, action: #selector(self.commentPage(sender:)), for: .touchUpInside)
                
                //like icon props
                guard let voteForVideo = rowdata["Votes"] as? [String] else {return}
                guard let currentUser = PFUser.current()?.objectId else  {return }
                if voteForVideo.contains(currentUser) {
                    DispatchQueue.main.async {
                        let icon = UIImage(named: "redHart")
                        cell.Footer.like.setImage(icon, for: .normal)
                        cell.Footer.like.object = rowdata
                        cell.Footer.like.addTarget(self, action: #selector(self.likeAction(sender:)), for: .touchUpInside)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        let icon = UIImage(named: "heart")
                        cell.Footer.like.setImage(icon, for: .normal)
                        cell.Footer.like.object = rowdata
                        cell.Footer.like.addTarget(self, action: #selector(self.likeAction(sender:)), for: .touchUpInside)
                    }
                }
                //video description props
                guard let videoDescription = rowdata["description"] as?  String else {return}
                cell.Footer.VideoDescription.text = "\(videoDescription)"
                cell.Footer.VideoDescription.handleHashtagTap({ (hash) in
                    self.presentHashTag(hashtag: hash)
                })
                //========== InMark: Footer ==================
            }
        }
        
        return cell
    }
}

