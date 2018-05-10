import UIKit
import Parse
import SDWebImage

class Home: PulsageViewController {
    
    //================================================
    //Mark: Private variables
    //================================================
    private var dataHolder: [[PFObject]] = [[]]
    private let collectioncellid = "collectionid"
    private let parseData = ParseFunctions()
    private let challengePage = HomePageHeaderPage()
    private let headerCollection = HomePageHeader()
    //================================================
    //Mark: End Private variables
    //================================================
    
    //================================================
    //Mark: Private visual objects
    //================================================
    private lazy var refreshController: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Updating Data")
        refresh.addTarget(self, action: #selector(homeFeedData), for: .valueChanged)
        return refresh
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        activity.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activity.hidesWhenStopped = true
        activity.center = self.view.center
        return activity
    }()
    
    private lazy var tableview: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.addSubview(self.refreshController)
        table.register(VideoCell.self, forCellReuseIdentifier: "video")
        table.register(VideoCell.self, forCellReuseIdentifier: "challenge")
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    //================================================
    //Mark: End Fileprivate visual objects
    //================================================
    
    //================================================
    //Mark: ViewController Functions
    //================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.addSunviews() //<--- add subview function
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.homeFeedData()
        }
        
        //=========== delegates  ====================
        self.headerCollection.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Trending"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.refreshController.endRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    //================================================
    //Mark: End ViewController Functions
    //================================================
    
    //================================================
    //Mark: Add Subviews
    //================================================
    private func addSunviews() {
        //self.getChallenges()
        self.view.addSubview(self.tableview)
        self.tableview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive       = true
        self.tableview.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive     = true
        self.tableview.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive   = true
        self.tableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.tableview.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    //================================================
    //Mark: End Add Subviews
    //================================================
    
    //==============================================
    ///Mark: Parse data
    //==============================================
    
    @objc private func homeFeedData() {
        PFCloud.callFunction(inBackground: "getVideos", withParameters: ["": ""], block: { (re, error) in
            
            DispatchQueue.main.async {
                if let data = re as? [[PFObject]]  {
                    self.dataHolder.removeAll(keepingCapacity: false)
                    self.headerCollection.challengesArray.removeAll(keepingCapacity: false)
                    //Reload table to clear the data holder data and prevent index range problems
                    self.tableview.reloadData()
                    self.headerCollection.headerColletion.reloadData()
                    self.dataHolder = data //<---- data for home table view
                    guard let headerArray = self.dataHolder.first else {return} // <---- data unwrap data for collection view
                    self.headerCollection.challengesArray = headerArray //<---- data for header collection view
                }
                self.activityIndicator.stopAnimating()
                self.headerCollection.headerColletion.reloadData()
                self.tableview.reloadData()
                self.refreshController.endRefreshing()
            }
        })
       
    }
    //================================================
    //Mark: End parse data
    //================================================
    
    //================================================
    //Mark: Multi porpuse Functions
    //================================================
    @objc private func presentChallenge(sender: CustomBtn) {
        guard let obData = sender.object?.objectId else {return}
        let challegeview = ChallengeTab()
        challegeview.PFObjectData = obData
        self.navigationController?.pushViewController(challegeview, animated: true)
    }
    
    @objc private func sendToProfile(sender: UIButton) {
        guard let userid = sender.titleLabel?.text else {return}
        let userprofile = UserProfile()
        userprofile.userid = userid
        self.navigationController?.pushViewController(userprofile, animated: true)
    }
    
    private func PresentVideoPlayer(video: PFObject, RealetedVideos: [PFObject]?) {
        let videoPlayer = VideoPlayer()
        videoPlayer.videdata = video
        self.navigationController?.pushViewController(videoPlayer, animated: true)
    }
    
    @objc private func presentProfile(sender: iconButton) {
        guard let data = sender.object else {return}
        let profileTab = ProfileTab()
        profileTab.userObject = data
        self.navigationController?.pushViewController(profileTab, animated: true)
    }
    
    @objc private func presentprofile(sender: GestureRescognizer) {

        guard let data = sender.data else {return}
        let profileTab = ProfileTab()
        profileTab.userObject = data
        self.navigationController?.pushViewController(profileTab, animated: true)
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



//================= tableview delegate and datasource ============================
extension Home: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //==========================================================
    // Mark: Header
    //==========================================================
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerCollection
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    //==========================================================
    // Mark: End Header
    //==========================================================

    
    //==========================================================
    // Mark: Cell
    //==========================================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let videosArray = self.dataHolder.last else {return 0}
        return  videosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let videosArray = self.dataHolder.last else {return UITableViewCell()}
        let row = videosArray[indexPath.row]
        if row.parseClassName == "Videos" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "video") as! VideoCell
            return self.videoCell(cell: cell, row: row)
        } else {
            let chaCell = tableView.dequeueReusableCell(withIdentifier: "challenge") as! VideoCell
            return self.challengeCell(cell: chaCell, row: row)
        }
        ///Mark: Video information
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height / 2 + 20
    }
    
    //==========================================================
    // Mark: End Cell
    //==========================================================
    
    //==========================================================
    // Mark: didSelectRowAt Cell Action
    //==========================================================
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let forCell = self.dataHolder.last else {return}
        let forRow = forCell[indexPath.row]
        if forRow.parseClassName == "Videos" {
            self.PresentVideoPlayer(video: forRow, RealetedVideos: nil)
        } else {
            guard let challengeId = forRow.objectId else {return}
            PFCloud.callFunction(inBackground: "bestvideosForChallenge", withParameters: ["challengeId": challengeId]) {
                (result, error) in
                if error == nil {
                    guard let array = result as? [PFObject] else {return}
                    if array.count == 0 {
                        let emptyChallenge = EmptyChallenge()
                        emptyChallenge.objectData = challengeId
                        self.present(emptyChallenge, animated: true, completion: nil)
                    } else {
                        let challegeview = ChallengeTab()
                        challegeview.PFObjectData = challengeId
                        self.navigationController?.pushViewController(challegeview, animated: true)
                    }
                }
            }
        }
        
    }
    
    //==========================================================
    // Mark: End didSelectRowAt Cell Action
    //==========================================================
    
    //==========================================================
    // Mark: Footer
    //==========================================================
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    //==========================================================
    // Mark: Footer
    //==========================================================
}

extension Home {
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
                            cell.Footer.ruby.addTarget(self, action: #selector(self.presentReward(sender:)), for: .touchUpInside)
                            if rewardId.isEmpty {
                                cell.Footer.ruby.isEnabled = false
                            } else {
                                cell.Footer.ruby.isEnabled = true
                                cell.Footer.ruby.id = rewardId
                                
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
    
    func challengeCell(cell: VideoCell, row: PFObject) -> VideoCell{
        row.fetchInBackground { (data, error) in
            if error == nil {
                guard let challenge = data else {return}
                //====== Mark: Header =============
                guard let user = challenge["User"] as? PFObject else {return}
                user.fetchInBackground(block: { (userResult, error) in
                    if error == nil {
                        guard let userData = userResult else {return}
                        guard let proPicture = userData["profilePicture"] as? PFFile else {return}
                        cell.Header.profileImage.sd_setImage(with: proPicture.getImage(), completed: nil)
                        
                        guard let username = userData["username"] as? String else {return}
                        cell.Header.profileBotton.button.setTitle(" \(username.getTextFromEmail())", for: .normal)
                    }
                })
                //====== Mark: End Header ==========
                
                //====== Mark: Thumbnail ===========
                cell.Thubnail.image = UIImage(named: "sponsor")
                //====== Mark: End Thumbnail =======
                
                //====== Mark: Footer ==============
                guard let challengeDescription = challenge["description"] as? String else {return}
                cell.Footer.VideoDescription.text = challengeDescription
                cell.Footer.rocket.isHidden = true
                cell.Footer.comment.isHidden = true
                cell.Footer.like.isHidden = true
                cell.Footer.ruby.isHidden = false
                
                guard let rewardId = challenge["reward"] as? String else {return}
                cell.Footer.ruby.addTarget(self, action: #selector(self.presentReward(sender:)), for: .touchUpInside)
                if rewardId.isEmpty {
                    cell.Footer.ruby.isEnabled = false
                } else {
                    cell.Footer.ruby.isEnabled = true
                    cell.Footer.ruby.id = rewardId
                    
                }
                
                //====== Mark: End Footer ==========
                
            }
        }
        
        return cell
    }
    
    func checkChallegeData(challengeId: String) {
        PFCloud.callFunction(inBackground: "bestvideosForChallenge", withParameters: ["challengeId": challengeId]) {
            (result, error) in
            if error == nil {
                guard let array = result as? [PFObject] else {return}
                if array.count == 0 {
                    let emptyChallenge = EmptyChallenge()
                    emptyChallenge.objectData = challengeId
                    self.present(emptyChallenge, animated: true, completion: nil)
                } else {
                    self.challengePage.challengeId = challengeId
                    self.present(self.challengePage, animated: true, completion: nil)
                }
            }
        }
    }
}


extension Home: UITextViewDelegate {
    //==========================================================
    // Mark: On select hash tag action
    //==========================================================
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        guard let type = URL.scheme else {return true}
        let array = Array(textView.text)
        let range = array[characterRange.lowerBound + 1 ... characterRange.upperBound - 1 ]
        switch type {
        case "mention":
            print("mention \(String(range))")
        case "hash":
            let hastagPage = HashTag()
            hastagPage.hashTagString = String(range)
            self.navigationController?.pushViewController(hastagPage, animated: true)
            
        default:
            break
        }
        return true
    }
    //==========================================================
    // Mark: On select hash tag action
    //==========================================================
}

extension Home: HomePageHeaderPageDelegate {
    func attemptBtn() {
        //send users to video recorder  <==================
    }
}

extension Home: HomepagehaderDelegate {
    func challengeSelected(index: Int) {
        //present challenge page
        guard let headerArray = self.dataHolder.first else {return}
        guard let challengeSelectedId = headerArray[index].objectId else {return}
        self.checkChallegeData(challengeId: challengeSelectedId)
        
    }
}

class GestureRescognizer: UITapGestureRecognizer {
    var data: PFObject?
}
