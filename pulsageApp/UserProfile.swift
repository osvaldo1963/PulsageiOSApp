import UIKit
import Parse
import SDWebImage

class UserProfile: UIViewController {
    
    //========= Mark: fileprivate variables =================
    public var userid = ""
    fileprivate var userprops = ["following", "followers", "Videos", "Challenges"]
    fileprivate var aboutProps  = ["Termns & Conditions", "Private Policy", "Open Source Libraries"]
    
    fileprivate var data = [String : Any]()
    
    fileprivate var currentUserProfile = false
    fileprivate var profileimageurl = ""
    fileprivate var name = ""
    fileprivate var parseData = ParseData()
    fileprivate var isFollowed = false
    
    
    fileprivate var segmetedIndex = 0
    fileprivate var tempDataholder = [String]()
    
    //=======================================================
    
    //========== Mark: view objects =========================
    
    fileprivate lazy var table: UITableView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let tableview = UITableView.init(frame: frame, style: .grouped)
        tableview.register(VideosCell.self, forCellReuseIdentifier: "videos")
        tableview.register(challengeCell.self, forCellReuseIdentifier: "challenges")
        tableview.register(Followcell.self, forCellReuseIdentifier: "following")
        tableview.register(Followcell.self, forCellReuseIdentifier: "follower")
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.allowsSelection = true
        tableview.showsVerticalScrollIndicator = false
        tableview.backgroundColor = .white
        tableview.tag = 1
        return tableview
    }()
    

    
    //=======================================================
    
    //Mark: view controller props ============================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.Subviews()
        self.ButtonPresed(index: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Profile"
        let blockBtn = UIBarButtonItem(title: "Block", style: .done, target: self, action: #selector(self.blockUser))
        self.navigationItem.setRightBarButton(blockBtn, animated: true)
        self.getUserData()
        self.CheckFollow()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    //=======================================================
    
    //Mark: functions =======================================
    fileprivate func Subviews() {
        self.view.addSubview(self.table)
    }
    
    
    @objc fileprivate func presentLoginView() {
        
        let predent = UINavigationController(rootViewController: Presentation())
        self.present(predent, animated: true, completion: nil)
        
    }
    
    fileprivate func getUserData() {
        
        //=============== get user data =======================
        
        self.parseData.SingleUserData(usersId: self.userid) { (data) in

            guard let picture = data["profilePicture"] as? PFFile else {return}
            guard let name = data["username"] as? String else {return}
            self.profileimageurl = picture.url!
            self.name = name.getTextFromEmail()
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        
        //=============== get user data =======================
    }
    
    @objc fileprivate func changePicture() {
        print("change picture")
        
    }
    @objc fileprivate func blockUser() {
        if PFUser.current() == nil {
            self.simpleAlert(Message: "to block a user you need to log In", title: "Error")
        } else {
            
            self.parseData.SingleUserData(usersId: self.userid, Data: { (user) in
                let save = user
                save["block"] = true
                save.saveInBackground(block: { (success, error) in
                    if error == nil {
                        print("user is blcked")
                    }
                })
                
            })
            
            let videoBody =  ["user": self.userid]
            self.parseData.ParseQuery(body: videoBody, ClassName: "Videos", Type: .findObjects, Result: { (data) in
                guard let videos = data as? [PFObject] else {return}
                for video in videos {
                    video["block"] = true
                    video.saveInBackground(block: { (success, error) in
                        if error == nil {
                            print(success)
                        }
                    })
                }
            })
            
            let challenegeBody = ["user": self.userid]
            self.parseData.ParseQuery(body: challenegeBody, ClassName: "Challenges", Type: .findObjects, Result: { (result) in
                guard let challenges = result as? [PFObject] else {return}
                for challenge in challenges {
                    challenge["block"]  = true
                    challenge.saveInBackground(block: { (success, error) in
                        if error == nil {
                            print(success)
                        }
                    })
                }
            })
            
            self.navigationController?.popToRootViewController(animated: true)
            self.simpleAlert(Message: "users video and challneges are being blocked", title: "Report")
            
        }
    }
    
    @objc func CheckFollow() {
        guard let currentUser = PFUser.current()?.objectId else {return}
        let query = PFQuery(className: "Follow")
        query.whereKey("FollowerId", equalTo: currentUser)
        query.whereKey("FollowingId", equalTo: self.userid)
        query.findObjectsInBackground { (results, error) in
            guard let result = results else {return}
            if result.count == 0 {
                self.isFollowed = false
            } else {
                self.isFollowed = true
            }
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    
    @objc func Follow() {
        guard let currentUser = PFUser.current()?.objectId else {return}
        if self.isFollowed {
            let query = PFQuery(className: "Follow")
            query.whereKey("FollowerId", equalTo: currentUser)
            query.whereKey("FollowingId", equalTo: self.userid)
            query.getFirstObjectInBackground(block: { (object, error) in
                object?.deleteEventually()
                self.isFollowed = false
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            })
        } else {
            let object = PFObject(className: "Follow")
            object["FollowingId"] = self.userid
            object["FollowerId"] = currentUser
            object.saveInBackground(block: { (success, error) in
                if error == nil {
                    if success {
                        self.isFollowed = true
                        DispatchQueue.main.async {
                            self.table.reloadData()
                        }
                    } else {
                        self.simpleAlert(Message: "Check internet Connection ", title: "Error")
                    }
                    
                }
            })
        }
        
    }
    
    //=======================================================
}

extension UserProfile: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let celldata = self.data["data"] as? [PFObject] else {return 0}
        
        return celldata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let datasection = self.data["section"] as? Int else {return UITableViewCell()}
        guard let celldata = self.data["data"] as? [PFObject] else {return UITableViewCell()}
        let indexData = celldata[indexPath.row]
        
        switch datasection {
        case 0:
            let videoSection = tableView.dequeueReusableCell(withIdentifier: "videos", for: indexPath) as? VideosCell
            guard let imageFile = indexData["thumbnail"] as? PFFile else {return UITableViewCell()}
            videoSection?.titleText = indexData["name"] as! String
            videoSection?.viewText = indexData["description"] as! String
            videoSection?.videos.sd_setImage(with: URL(string: imageFile.url!))
            return videoSection!
        case 1:
            
            let challengeSection = tableView.dequeueReusableCell(withIdentifier: "challenges") as? challengeCell
            challengeSection?.title.text = indexData["title"] as? String
            challengeSection?.descrip.text = indexData["description"] as? String
            challengeSection?.accessoryType = .disclosureIndicator
            
            return challengeSection!
        case 2:
            
            let followingcell = tableView.dequeueReusableCell(withIdentifier: "following") as? Followcell
            guard let userid = indexData["FollowingId"] as? String else {return UITableViewCell()}
            let query = PFUser.query()
            query?.whereKey("objectId", equalTo: userid)
            query?.getFirstObjectInBackground(block: { (result, error) in
                if error == nil {
                    guard let user = result else {return}
                    guard let username = user["username"] as? String else {return}
                    guard let profileurl = user["profilePicture"] as? PFFile else {return}
                    followingcell?.userimage.sd_setImage(with: URL(string: profileurl.url!))
                    followingcell?.usernametext.text = username.getTextFromEmail()
                }
            })
            
            return followingcell!
        case 3:
            let followingcell = tableView.dequeueReusableCell(withIdentifier: "follower") as? Followcell
            guard let userid = indexData["FollowerId"] as? String else {return UITableViewCell()}
            let query = PFUser.query()
            query?.whereKey("objectId", equalTo: userid)
            query?.getFirstObjectInBackground(block: { (result, error) in
                if error == nil {
                    guard let user = result else {return}
                    guard let username = user["username"] as? String else {return}
                    guard let profileurl = user["profilePicture"] as? PFFile else {return}
                    followingcell?.userimage.sd_setImage(with: URL(string: profileurl.url!))
                    followingcell?.usernametext.text = username.getTextFromEmail()
                }
            })
            
            return followingcell!
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //let view = ProfileHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 250))
        let view = ProfileHeader(coder: NSCoder())
        view!.userimage.sd_setImage(with: URL(string: self.profileimageurl))
        view!.username.text = self.name
       
        view?.followBtn.addTarget(self, action: #selector(self.Follow), for: .touchUpInside)
        if self.isFollowed {
            view!.followBtn.setTitle("Unfollow", for: .normal)
        } else {
            view!.followBtn.setTitle("Follow", for: .normal)
        }
        if PFUser.current() == nil {
            view!.followBtn.isEnabled = false
        }
        
        //add segmented view to tableheader
        let segentedFrame = CGRect(x: 0, y: (view?.frame.size.height)! - 50, width: (view?.frame.size.width)!, height: 50)
        let segmented = Segmented(frame: segentedFrame)
        let cameraicon = UIImage.init(icon: .FAFileMovieO, size: CGSize(width: 30, height: 30))
        let listicon = UIImage.init(icon: .FAList, size: CGSize(width: 30, height: 30))
        let following = UIImage.init(icon: .FAUserPlus, size: CGSize(width: 30, height: 30))
        let follower = UIImage.init(icon: .FAUsers, size: CGSize(width: 30, height: 30))
        let segmentedIcons = [cameraicon, listicon, following, follower]
        segmented.ImagesArray = segmentedIcons
        segmented.delegate = self
        
        view?.addSubview(segmented)
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let datasection = self.data["section"] as? Int else {return}
        guard let celldata = self.data["data"] as? [PFObject] else {return}
        let indexData = celldata[indexPath.row]
        
        switch datasection {
        case 0:
            guard let created = indexData.createdAt else {return}
            guard let videoFile = indexData["video"] as? PFFile else {return}
            guard let videoId = indexData.objectId else {return}
            let player = VideoPlayer()
            player.videdata = indexData
            self.present(player, animated: true, completion: nil)
            
        case 1:
            guard let title = indexData["title"] as? String else {return}
            let challengepage = ChallengeTab()
            challengepage.PFObjectData = indexData
            
            self.navigationController?.pushViewController(challengepage, animated: true)
        case 2:
            guard let userid = indexData["FollowingId"] as? String else {return}
            let profile = UserProfile()
            profile.userid = userid
            self.navigationController?.pushViewController(profile, animated: true)
        case 3:
            guard let userid = indexData["FollowerId"] as? String else {return}
            let profile = UserProfile()
            profile.userid = userid
            self.navigationController?.pushViewController(profile, animated: true)
        default:
            return
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.segmetedIndex {
        case 0:
            return 100
        case 1:
            return 50
        case 2:
            return 50
        case 3:
            return 50
        default:
            return 0
        }
    }
    
}

extension UserProfile: SegmentDelegate {
    
    func ButtonPresed(index: Int) {
        self.segmetedIndex = index
        var query: PFQuery<PFObject>!
        
        switch index {
        case 0:
            query = PFQuery(className: "Videos")
            query.whereKey("user", equalTo: self.userid)
        case 1:
            query = PFQuery(className: "Challenges")
            query.whereKey("user", equalTo: self.userid)
        case 2:
            query = PFQuery(className: "Follow")
            query.whereKey("FollowerId", equalTo: self.userid)
        case 3:
            query = PFQuery(className: "Follow")
            query.whereKey("FollowingId", equalTo: self.userid)
            
        default:
            break
        }
        query.findObjectsInBackground(block: { (result, error) in
            guard let objects = result else {return}
           
            self.data["section"] = index
            self.data["data"] = objects
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        })
        
    }
}

