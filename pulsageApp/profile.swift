import UIKit
//import Parse
import Parse

class profile: UIViewController {
    
    //========= Mark: fileprivate variables =================
    fileprivate var userprops = ["following", "followers", "Videos", "Challenges"]
    fileprivate var aboutProps  = ["Termns & Conditions", "Private Policy", "Open Source Libraries"]
    
    fileprivate var data = [String : Any]()
    
    fileprivate var currentUserProfile = false
    fileprivate var profileimageurl = ""
    fileprivate var name = ""
    fileprivate var parseData = ParseData()
    
    
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
    
    fileprivate lazy var loginBtn: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: self.view.frame.size.width / 2 - 100, y: 100, width: 200, height: 40)
        button.setTitle("Continue to Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red:0.95, green:0.44, blue:0.23, alpha:1.0)
        button.addTarget(self, action: #selector(presentLoginView), for: .touchUpInside)
        button.tag = 2
        button.layer.cornerRadius = 4
        return button
    }()
    
    //=======================================================
    
    //Mark: view controller props ============================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.Subviews()
        self.ButtonPresed(index: 0)
        print(self.data)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getUserData()
        self.removeFromSubview()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    //=======================================================
    
    //Mark: functions =======================================
    fileprivate func Subviews() {
        self.view.addSubview(self.table)
        self.view.addSubview(self.loginBtn)
    }
    
    fileprivate func removeFromSubview() {
        if PFUser.current() == nil{
            self.table.alpha = 0
            self.loginBtn.alpha = 1
        } else {
         
            self.loginBtn.alpha = 0
            self.table.alpha = 1
        }
    }
    
    @objc fileprivate func presentLoginView() {
        
        let predent = UINavigationController(rootViewController: Presentation())
        self.present(predent, animated: true, completion: nil)
        
    }
    
    fileprivate func getUserData() {
        guard let currentUser = PFUser.current() else {return}
        //=============== get user data =======================
        if currentUser.isAuthenticated == false {
            self.profileimageurl = ""
            self.name = ""
        } else {
            guard let picture = currentUser["profilePicture"] as? PFFile else {return}
            guard let name = currentUser.username else {return}
            self.profileimageurl = picture.url!
            self.navigationController?.navigationBar.topItem?.title =  name.getTextFromEmail()
            //self.name = name.getTextFromEmail()
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        //=============== get user data =======================
    }
    
    @objc fileprivate func changePicture() {
        print("change picture")
        
    }

    //=======================================================
}

extension profile: UITableViewDelegate, UITableViewDataSource {
    
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
        view?.userimage.sd_setImage(with: URL(string: self.profileimageurl))
        view?.username.text = self.name
            
        view?.followBtn.isHidden = true
            
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

extension profile: SegmentDelegate {
    
    func ButtonPresed(index: Int) {
       self.segmetedIndex = index
        var query: PFQuery<PFObject>!
        guard let currentuser = PFUser.current()?.objectId else {return}
        switch index {
        case 0:
            query = PFQuery(className: "Videos")
            query.whereKey("user", equalTo: currentuser)
        case 1:
            query = PFQuery(className: "Challenges")
            query.whereKey("user", equalTo: currentuser)
        case 2:
            query = PFQuery(className: "Follow")
            query.whereKey("FollowerId", equalTo: currentuser)
        case 3:
            query = PFQuery(className: "Follow")
            query.whereKey("FollowingId", equalTo: currentuser)

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


