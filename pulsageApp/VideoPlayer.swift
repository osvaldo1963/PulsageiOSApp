import UIKit
import AVKit
import AVFoundation
import Parse

class VideoPlayer: UIViewController {
    
    //Mark: Required Variables=========
    public var videdata: PFObject!
    private var player = AVPlayer()
    fileprivate var realetevideos = [PFObject]() //holds realted video
    fileprivate var videoscomments = [PFObject]() //holds comments for each video
    fileprivate var buttonPressed  = "Comments"
    fileprivate let videoid        = "videoCell" //cell id
    fileprivate let commentid      = "commentCell" //cell id

    //======================================

    //================================================
    //Mark: objects variables
    //================================================
    
    fileprivate let mainView: UIView = {
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    
    fileprivate let textfield: UITextField = {
        let txt = UITextField()
        return txt
    }()
    
    private var controller: AVPlayerViewController = {
        let con = AVPlayerViewController()
        con.view.translatesAutoresizingMaskIntoConstraints = false
        return con
    }()
    
    private lazy var barController: UIView = {
        let views = UIView()
        let image = UIImage(named: "pulsageIcon")
        let imageview = UIImageView(image: image)
        views.addSubview(imageview)
        imageview.contentMode = .scaleAspectFit
        imageview.frame = views.bounds
        return views
    }()
    
    fileprivate lazy var vpTable: UITableView = {
        let height = self.view.frame.size.height / 3 - 10
        let conheight = self.view.frame.size.height / 4
        let tableframe = CGRect(x: 0, y: 0, width: 0, height:0)
        var table = UITableView.init(frame:  tableframe, style: .grouped)
   
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(VideoCell.self, forCellReuseIdentifier: self.videoid)
        table.register(CommentCell.self, forCellReuseIdentifier: self.commentid)
        table.showsVerticalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = true
        return table
    }()

    //================================================
    //End: objects variables
    //================================================
    
    //Mark: View Load =================================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        self.subviews()
       
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationBarProp()
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.setVideoData()
            self.getComments()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player.pause()
        self.player.seek(to: kCMTimeZero)
        self.controller.player = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player.seek(to: kCMTimeZero)
        self.player.pause()
        self.controller.player = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    //=======================================================
    
    //================================================
    //Mark: Add Number of views
    //================================================
    private func viewCount(header: TbHeader) {
        let query = self.videdata
        
        query?.fetchInBackground(block: { (data, error) in
            if error == nil {
                guard let result = data else {return}
                guard let currentViews = result["views"] as? Int else {return}
                result["views"] = currentViews + 1
                result.saveInBackground(block: { (success, error) in
                    guard let currentviews = result["views"] as? Int else {return}
                    print(currentviews)
                    DispatchQueue.main.async {
                        header.instagramBtn.setTitle("Views \(currentviews)", for: .normal)
                    }
                    
                    
                })
                
            }
        })
    
    }
    //================================================
    //Mark: End Adding number of views
    //================================================
    
    
    private func sendVideoToFullScreen(size: CGSize) {
        
    }
    
    private func resolutionForLocalVideo(url: URL) -> CGSize?{
        guard let track = AVURLAsset(url: url).tracks(withMediaType: .video).first else {
            return nil
        }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: fabs(size.width), height: fabs(size.height))
    }
    
    private func navigationBarProp() {
        let navController = self.navigationController!
        let backArrow = UIImage.init(icon: .FAAngleLeft, size: CGSize(width: 40, height: 40))
        let backBtn = UIBarButtonItem(image: backArrow, style: .done, target: self, action: #selector(BackButtonAction))
        navController.navigationBar.topItem?.leftBarButtonItem = backBtn

        let holder = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let image = #imageLiteral(resourceName: "pulsageIcon")
        let imageview = UIImageView(image: image)
        holder.addSubview(imageview)
        imageview.frame = holder.bounds
        imageview.contentMode = .scaleAspectFit
        self.navigationItem.titleView = holder
        
    }
    
    private func subviews() {
        
        self.view.addSubview(self.controller.view)
        self.addChildViewController(self.controller)
        self.controller.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.controller.view.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.controller.view.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.controller.view.heightAnchor.constraint(equalToConstant: self.view.frame.size.height / 3).isActive = true
 
        self.view.addSubview(self.vpTable)
        self.vpTable.topAnchor.constraint(equalTo: self.controller.view.bottomAnchor).isActive = true
        self.vpTable.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.vpTable.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.vpTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    //========================================================
   
    //Mark: Video Player Functions ==================
    
    @objc private func BackButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    private func setVideoData() {
        /// set video player
        guard let videoFile = self.videdata["video"] as? PFFile else {return}
        guard let videoUrl = videoFile.url else {return}
        guard let url = URL(string: videoUrl) else {return}
        
        
        self.player = AVPlayer(url: url)
        self.controller.player = self.player
        
        self.player.play()
        
        guard let videoResolution = self.resolutionForLocalVideo(url: url) else {
            return
        }
        //self.player.play()
        if videoResolution.width < videoResolution.height {
            DispatchQueue.main.async {
                //self.controller.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
            }
        }
        
        ///
    }
    
    private func changeForVideoSelected(videoObject: PFObject) {
        self.videdata = videoObject
        /// set video player
        guard let videoFile = self.videdata["video"] as? PFFile else {return}
        guard let videoUrl = videoFile.url else {return}
        guard let url = URL(string: videoUrl) else {return}
        self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
        self.player.play()
        self.getComments()
    }
    
    fileprivate func getComments() {
        guard let videoId = self.videdata.objectId else {return}
        
        let query = PFQuery(className: "VideoComments")
        query.whereKey("videoId", equalTo: videoId)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (data, error) in
            guard let comments = data else {return}
            
            self.videoscomments = comments
            self.buttonPressed = "Comments"
            DispatchQueue.main.async {
                self.vpTable.reloadSections(IndexSet(integer: 1), with: .automatic)
                
            }
        }
    }
    
    fileprivate func realetedVideos() {
        guard let challenge = self.videdata["Challenges"] as? PFObject else {return}
        let query = PFQuery(className: "Videos")
        query.whereKey("Challenges", equalTo: challenge)
        query.findObjectsInBackground { (videosResult, error) in
            guard let videosData = videosResult else {return}
            self.realetevideos = videosData
            self.buttonPressed = "Similar Videos"
            DispatchQueue.main.async {
                self.vpTable.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
        }
    }
    //===============================================
    
    private func voteCount(head: TbHeader) {
        let videoVotes = self.videdata
        let relation = videoVotes?.relation(forKey: "Vote")
        let relationQuery = relation?.query()
        relationQuery?.findObjectsInBackground(block: { (objects, error) in
            if error == nil {
                guard let votes = objects else {return}
                head.voteText.text = "Votes \(votes.count)"
                //head.votetBtn.setFATitleColor(color: .red, forState: .normal)
            } else {
                self.simpleAlert(Message: "Check your internet Connection", title: "Error Voting")
            }
        })
    }
    
    //================================================================================
    
    //Mark: Report Share and Vote Button Functions
    @objc fileprivate func ReportBtn() {
        self.simpleAlert(Message: "thank you for reposting this video our team will review the content of this video and take action", title: "Report Video")
        
    }
    
    @objc fileprivate func ShareBtn() {
        guard let videoFile = self.videdata["thumbnail"] as? PFFile else {return}
        guard let videoUrl = videoFile.url else {return}
        guard let url = URL(string: videoUrl) else {return}
        guard let data = try? Data(contentsOf: url) else {return}
        guard let image = UIImage(data: data) else {return}

        guard let appLink = URL(string: "PulsageApp://host/video") else {return}
        
        let vc = UIActivityViewController(activityItems: [image, appLink], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    @objc fileprivate func VoteBtn(header: VoteBtn) {
        guard let hd = header.header else {return}
        guard let currentVideo = self.videdata else {return}
        guard let user = PFUser.current() else {return}
        let vote = currentVideo.relation(forKey: "Vote")
        vote.add(user)
        currentVideo.saveInBackground { (success, error) in
            if error == nil {
                self.voteCount(head: hd)
            } else {
                print(error.debugDescription)
            }
        }
        
    }
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
    
    @objc fileprivate func presentChallenge(sender: CustomBtn) {
        guard let data = sender.object?.objectId else {return}
        let challenge = ChallengeTab()
        challenge.PFObjectData = data
        self.navigationController?.pushViewController(challenge, animated: true)
        
    }
    
    //============================================
}

//Mark: tableview setttings
extension VideoPlayer: UITableViewDelegate, UITableViewDataSource {
    //================================================================
    //Mark: Load header in section 0 and load data in section one
     //================================================================
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 280 //header hight
        } else {
            //Mark: check current data state
            if self.buttonPressed == "Comments"{
                return 40
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            //Dafault header ============================
            let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300)
            let tableHeader = TbHeader(frame: frame)
            //video data
            guard let videoDescription = self.videdata["description"] as? String else {return UIView()}
            guard let videoChallenge = self.videdata["Challenges"] as? PFObject else {
                tableHeader.ArrowBtn.isHidden = true
                tableHeader.ChallengeText.isHidden = true
                return tableHeader
            }
            self.voteCount(head: tableHeader)
            tableHeader.videoDescription.text = videoDescription
            tableHeader.sharetBtn.addTarget(self, action: #selector(ShareBtn), for: .touchUpInside)
            tableHeader.segmented.currentButton = self.buttonPressed
            tableHeader.segmented.ButtonTitles = ["Comments", "Similar Videos"]
            tableHeader.segmented.delegate = self
            tableHeader.votetBtn.header = tableHeader
            tableHeader.votetBtn.addTarget(self, action: #selector(self.VoteBtn(header:)), for: .touchUpInside)
            tableHeader.reportBtn.addTarget(self, action: #selector(self.ReportBtn), for: .touchUpInside)
            tableHeader.ArrowBtn.object = videoChallenge
            tableHeader.ArrowBtn.addTarget(self, action: #selector(self.presentChallenge(sender:)), for: .touchUpInside)
            //user data
            guard let user = self.videdata["User"] as? PFUser else {return UIView()}
            user.fetchInBackground { (userdata, error) in
                guard let userresult = userdata else {return}
                guard let username = userresult["username"]  as? String else {return}
                guard let picfile = user["profilePicture"] as? PFFile else {return}
                guard let picUrl = picfile.url else {return}
                tableHeader.username.text = username.getTextFromEmail()
                tableHeader.profilePic.sd_setImage(with: URL(string: picUrl))
            }
            self.viewCount(header: tableHeader)
            return tableHeader
        } else {
            //Mark: comments input
            if self.buttonPressed == "Comments"{
                textfield.backgroundColor = .white
                textfield.frame.size.height = 40
                textfield.font = UIFont(name: "Arial", size: 14)
                textfield.setLeftPaddingPoints(10)
                if PFUser.current() == nil {
                    self.textfield.isEnabled = false
                    self.textfield.placeholder = "You need to Log In"

                } else {
                    self.textfield.isEnabled = true
                    self.textfield.placeholder = "What you think about this video?"
                    self.textfield.delegate = self
                }
                return textfield
            } else {
                return nil
            }
        }
       
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            if self.buttonPressed == "Comments"{
                return self.videoscomments.count
            } else {
                return self.realetevideos.count
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            return UITableViewCell() //not data will be load in section 0
        } else {
            if self.buttonPressed == "Comments" {
                guard let commentsCell = tableView.dequeueReusableCell(withIdentifier: self.commentid, for: indexPath) as? CommentCell else {
                    return UITableViewCell()
                }
                let indexComments = self.videoscomments[indexPath.row]
                guard let comment = indexComments["comment"] as? String else {return UITableViewCell()}
                commentsCell.commentText.text = comment
                
                /// user data
                guard let user = indexComments["User"] as? PFUser else {return UITableViewCell()}
                user.fetchInBackground(block: { (userData, error) in
                    if error == nil {
                        guard let data = userData as? PFUser else {return}
                        guard let username = data.username else {return}
                        guard let userpicFile = data["profilePicture"] as? PFFile else {return}
                        guard let picUrl = userpicFile.url else {return}
                        guard let url = URL(string: picUrl) else {return}
                        let tapGesture = GestureRescognizer(target: self, action: #selector(self.presentprofile(sender:)))
                        tapGesture.data = data
                        commentsCell.profilePicture.isUserInteractionEnabled = true
                        commentsCell.profilePicture.addGestureRecognizer(tapGesture)
                        commentsCell.profilePicture.sd_setImage(with: url)
                        commentsCell.linkToProfile.setTitle("@\(username.getTextFromEmail())", for: .normal)
                        commentsCell.linkToProfile.object = data
                        commentsCell.linkToProfile.addTarget(self, action: #selector(self.presentProfile(sender:)), for: .touchUpInside)
                        

                    }
                })
                
                ///
                return commentsCell
            } else {
                //Mark: hometab/SectionContent/VideoCell.swift
                guard let videocell = self.vpTable.dequeueReusableCell(withIdentifier: self.videoid, for: indexPath) as? VideoCell else {return UITableViewCell()}
                let indexvideos = self.realetevideos[indexPath.row]
                //Data for row
                guard let picFile = indexvideos["thumbnail"] as? PFFile else {return UITableViewCell()} //transform to PFFile
                guard let picurl = picFile.url else {return UITableViewCell()}
                guard let url = URL(string: picurl) else {return UITableViewCell()}
                
                guard let videoDescription = indexvideos["description"] as? String else {return UITableViewCell()}
                guard let userForVideo = indexvideos["User"] as? PFUser else {return UITableViewCell()}
                ///
                
                videocell.Header.challengeSponsor.isHidden = true // only for sponsor section
                videocell.Footer.rewardBtn.isHidden = true // only for sponsor section
                
                ///Load data for user
                userForVideo.fetchInBackground(block: { (result, error) in
                    if error == nil {
                        guard let userdata = result else {return}
                        guard let username = userdata["username"] as? String else {return}
                        guard let profileFile = userdata["profilePicture"] as? PFFile else {return}
                        guard let profileurl = profileFile.url else {return}
                        guard let profileToUrl = URL(string: profileurl) else {return}
                        
                        let tapGesture = GestureRescognizer(target: self, action: #selector(self.presentprofile(sender:)))
                        tapGesture.data = userdata
                        videocell.Header.profileImage.addGestureRecognizer(tapGesture)
                        videocell.Header.profileImage.isUserInteractionEnabled = true
                        videocell.Header.profileImage.sd_setImage(with: profileToUrl)
                        videocell.Header.profileBotton.button.setTitle(" \(username.getTextFromEmail())", for: .normal)
                        videocell.Header.profileBotton.button.object = userdata
                        videocell.Header.profileBotton.button.addTarget(self, action: #selector(self.presentProfile(sender:)), for: .touchUpInside)
                    }
                })
                ///
                
                videocell.Thubnail.sd_setImage(with: url)
                
                ///Load Video data
                videocell.Footer.VideoDescription.text = videoDescription
                videocell.Footer.ChallengeText.isHidden = true
                videocell.Footer.ArrowBtn.isHidden = true
                ///
                return videocell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0
        } else {
            if self.buttonPressed == "Comments" {
                return 100
            } else {
                return 280
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.buttonPressed == "Similar Videos" {
            let indexobject = self.realetevideos[indexPath.row]
            print(indexobject)
            self.changeForVideoSelected(videoObject: indexobject)
        }
    }
    

}


extension VideoPlayer: PulsageSegmentedDelegate {
    func buttonPressed(id: String) {
        switch id {
        case "Comments":
            DispatchQueue.global(qos: .userInitiated).async {
                self.getComments()
            }
        case "Similar Videos":
            DispatchQueue.global(qos: .userInitiated).async {
                self.realetedVideos()
            }
            
            
        default:
            break
        }
    }
}

extension VideoPlayer: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let user = PFUser.current() else {return false}
        
        if user != nil {
            if textField.text != ""{
                let query = PFObject(className: "VideoComments")
                query["comment"] = self.textfield.text
                query["User"] = user
                query["Video"] = self.videdata
                query.saveInBackground { (success, error) in
                    if success {
                        self.getComments()
                        self.textfield.text = ""
                        self.textfield.resignFirstResponder()
                    }
                }
            } else {
                self.textfield.endEditing(true)
            }
        }
 
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textfield, moveDistance: -220, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -220, up: false)
    }
    
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.2
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}


