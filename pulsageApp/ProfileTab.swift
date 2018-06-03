import UIKit
import Parse
import SDWebImage
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class ProfileTab: PulsageViewController {
    
    
    //Mark: Public variables
    public var userObject: PFObject?
    //=====================================
    
    //Mark: Private variables
    public var rootView = false
    private var ktableHeaderHeight = 220
    private let challengeCell = "challemgecell"
    private let videoCell = "videocell"
    private var currentData = [String: [PFObject]]()
    private var currentTab = ""
    private var follow = false
    private let functions = DataFunctions()
    private let parseData = ParseFunctions()
     //=====================================
    
    //==============================================================
    //  Mark: Visual Objects
    //==============================================================
    
    private lazy var tableHeader: ProfileHeader = {
        let hframe = CGRect(x: 0, y: 0, width: Int(self.view.frame.size.width), height: self.ktableHeaderHeight)
        let header = ProfileHeader(frame: hframe)
        header.segmented.delegate = self
        header.followBtn.addTarget(self, action: #selector(self.followBtn), for: .touchUpInside)
        header.followers.addTarget(self, action: #selector(self.Followers), for: .touchUpInside)
        header.following.addTarget(self, action: #selector(self.Following), for: .touchUpInside)
        return header
    }()
    
    private lazy var tableview: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.register(VideoCell.self, forCellReuseIdentifier: self.videoCell)
        table.register(UITableViewCell.self, forCellReuseIdentifier: self.challengeCell)
        table.estimatedRowHeight = UITableViewAutomaticDimension
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //==============================================================
    //  Mark: End Visual Objects
    //==============================================================
    
    
    //==============================================================
    //  Mark: UIViewController Defaults Functions
    //==============================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addviews()
        if userObject == nil {
            self.userObject  = PFUser.current()
            DispatchQueue.main.async {
                self.getProfileData(index: 0)
                
            }
        }
        self.checkUserType()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Set title for navigation Bar
        guard let user = self.userObject else {return}
        self.navigationController?.navigationBar.topItem?.title = user.handle
        
        if self.rootView == false {
            let navController = self.navigationController!
            let backArrow = UIImage.init(icon: .FAAngleLeft, size: CGSize(width: 40, height: 40))
            let backBtn = UIBarButtonItem(image: backArrow, style: .done, target: self, action: #selector(self.backButton))
            navController.navigationBar.topItem?.leftBarButtonItem = backBtn
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.getFollowers()
            self.getFolling()
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //==============================================================
    //  Mark: End UIViewController Defaults Functions
    //==============================================================
    
    //==============================================================
    //  Mark: Visual Object Constrains
    //==============================================================
    private func addviews() {
        self.view.addSubview(self.tableview)
        
        self.tableview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive       = true
        self.tableview.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive     = true
        self.tableview.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive   = true
        self.tableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.view.backgroundColor = .white
        
    }
    
    //==============================================================
    //  Mark: End Visual Objects Constrains
    //==============================================================
    
    private func checkUserType() {
        guard let user = self.userObject else {return}
        if user == PFUser.current() {
            self.tableHeader.followBtn.isHidden = true
        } else {
            self.tableHeader.Setting.isHidden = true
        }
    }
    
    
    @objc private func setting(sender: AnyObject) {
        let alertSheet = UIAlertController(title: "Settings", message: "options", preferredStyle: .actionSheet)
        let logout = UIAlertAction(title: "Log out", style: .default) { (alert) in
            self.unsubcribeToChannell()
            PFUser.logOutInBackground(block: { (error) in
                FBSDKLoginManager().logOut()
                GIDSignIn.sharedInstance().signOut()
                let presenatationView = UINavigationController(rootViewController: SplashAnimation()) 
                presenatationView.modalTransitionStyle = .coverVertical
                self.present(presenatationView, animated: true, completion: nil)
            })
        }
        let editProfile = UIAlertAction(title: "Settings", style: .default) { (alert) in
            self.navigationController?.pushViewController(Settings(), animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertSheet.addAction(logout)
        alertSheet.addAction(editProfile)
        alertSheet.addAction(cancel)
        if let popoverController = alertSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.barButtonItem = sender as? UIBarButtonItem
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
            
        }
        self.present(alertSheet, animated: true, completion: nil)
    }
    
    
    
    //==============================================================
    //  Mark: Profile Data
    //==============================================================
    private func getProfileData(index: Int) {
        guard let currentUser = self.userObject else {return}
        switch index {
        case 0:
           self.videos(user: currentUser)
        case 1:
            self.challenges(user: currentUser)
        default:
            break
        }
    }
    
    
    //==============================================================
    //  Mark: Videos and Challenges
    //==============================================================
    private func videos(user: PFObject) {
        self.currentData.removeAll(keepingCapacity: false)
        self.functions.videos(user: user) {
            (result) in
            guard let videos = result as? [PFObject] else {return}
            self.currentData["videos"] = videos
            self.currentTab = "videos"
            DispatchQueue.main.async {
                self.tableview.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
        }
    }
    
    private func challenges(user: PFObject) {
        self.functions.challenges(user: user) { (result) in
            guard let challenges = result as? [PFObject] else {return}
            self.currentData["challenges"] = challenges
            self.currentTab = "challenges"
            DispatchQueue.main.async {
                self.tableview.reloadSections(IndexSet(integer: 1), with: .fade)
            }
        }
    }
    
    //==============================================================
    //  Mark: Videos and Challenges
    //==============================================================
    
    private func getFollowers() {
        guard let user = self.userObject else {return}
        
        let query = PFQuery(className: "Follow")
        query.whereKey("Following", equalTo: user)
        query.findObjectsInBackground { (result, error) in
            if error == nil {
                guard let follers = result else {return}
                guard let currentUser = PFUser.current() else {return}
                let back = follers.map({ (object) -> String in
                    guard let data = object["Followers"] as? PFObject else {return String()}
                    guard let id = data.objectId else {return String()}
                    return id
                })

                DispatchQueue.main.async {
                    self.tableHeader.followers.setTitle("\(follers.count) \n Followers", for: .normal)
                    if back.contains(currentUser.objectId!) {
                        self.tableHeader.followBtn.isEnabled = true
                        self.tableHeader.followBtn.setTitle("Unfollow", for: .normal)
                        self.follow = true
                    } else {
                        self.tableHeader.followBtn.isEnabled = true
                        self.tableHeader.followBtn.setTitle("Follow", for: .normal)
                        self.follow = false
                    }
                }
            }
        }
    }
    private func getFolling() {
        guard let user = self.userObject else {return}
        
        let query = PFQuery(className: "Follow")
        query.whereKey("Followers", equalTo: user)
        query.findObjectsInBackground { (result, error) in
            if error == nil {
                guard let follers = result else {return}
                
                DispatchQueue.main.async {
                    self.tableHeader.following.isEnabled = true
                    self.tableHeader.following.setTitle("\(follers.count) \n Following", for: .normal)
                }
                
            }
        }
    }
    
    @objc private func followBtn() {
        guard let currentUser = PFUser.current() else {return}
        guard let user = self.userObject else {return}
        if currentUser != user {
            self.tableHeader.followBtn.isEnabled = false
            if follow {
                let query = PFQuery(className: "Follow")
                query.whereKey("Followers", equalTo: currentUser)
                query.whereKey("Following", equalTo: user)
                query.getFirstObjectInBackground(block: { (back, error) in
                    if error == nil {
                        guard let result = back else {return}
                        result.deleteInBackground(block: { (success, error) in
                            self.getFolling()
                            self.getFollowers()
                        })
                    }
                })
            } else {
                let object = PFObject(className: "Follow")
                object["Followers"] = currentUser
                object["Following"] = user
                object.saveInBackground(block: { (success, error) in
                    if error == nil {
                        if success {
                            self.getFolling()
                            self.getFollowers()
                        }
                    }
                })
            }
        }
    }
    
    @objc private func Followers() {
        guard let user = self.userObject else {return}
        let follow = Follow()
        follow.type = "followers"
        follow.userObject = user
        self.navigationController?.pushViewController(follow, animated: true)
    }
    
    @objc private func Following() {
        guard let user = self.userObject else {return}
        let follow = Follow()
        follow.type = "following"
        follow.userObject = user
        self.navigationController?.pushViewController(follow, animated: true)
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
                    let challengepage = ChallengeTab()
                    challengepage.PFObjectData = challengeId
                    self.navigationController?.pushViewController(challengepage, animated: true)
                }
            }
        }
    }
    
    @objc private func backButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func unsubcribeToChannell() {
        PFPush.unsubscribeFromChannel(inBackground: (PFUser.current()?.objectId!)!) { (success, error) in
            
        }

    }
    //==============================================================
    //  Mark: End UIViewController Defaults Functions
    //==============================================================
    
    
}

extension ProfileTab: SegmentDelegate {
    func ButtonPresed(index: Int) {
        self.getProfileData(index: index)
    }
}

extension ProfileTab: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let floatBack = section == 0 ? self.ktableHeaderHeight : 0
        return CGFloat(floatBack)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let rocketIcon = UIImage(named: "transport")
            let playIcon = UIImage(named: "play")
            let images     = [playIcon!, rocketIcon!]
            guard let user = userObject else {return UIView()}
           
            guard let file = user["profilePicture"] as? PFFile else {return UIView()}
            guard let picurl = file.url else {return UIView()}
            guard let url = URL(string: picurl) else {return UIView()}
            
            self.tableHeader.segmented.ImagesArray = images
            self.tableHeader.username.text = "" //keep empty username label
            self.tableHeader.userimage.sd_setImage(with: url)
            self.tableHeader.Setting.addTarget(self, action: #selector(self.setting(sender:)), for: .touchUpInside)
            
            return self.tableHeader
        } else {
            return nil
        }
 
    }
   
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            if self.currentData.first?.key == "videos" {
                guard let videos = self.currentData["videos"] else {return 0}
                return videos.count
            } else {
                guard let challenges = self.currentData["challenges"] else {return 0}
                return challenges.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.currentData
        
        if indexPath.section == 0 {
            return UITableViewCell() //not data will be load in section 0
        } else {
            let typeOfCell = data.first?.key
            if typeOfCell == "videos" {
                guard let datafromCell = data["videos"] else {return UITableViewCell()}
                let row = datafromCell[indexPath.row]
                guard  let videoCell = tableView.dequeueReusableCell(withIdentifier: self.videoCell , for: indexPath) as? VideoCell else {
                    return UITableViewCell()
                }
                
        
                videoCell.Header.challengeSponsor.isHidden = true
                
                //Header Data
                guard let file = row["User"] as? PFObject else {return UITableViewCell()}
                file.fetchInBackground(block: { (result, error) in
                    if error == nil {
                        guard let userData = result else {return}
                        //Profile picture
                        guard let pffile = userData["profilePicture"] as? PFFile else {return}
                        guard let picUrl = pffile.url else {return}
                        guard let url = URL(string: picUrl) else {return}
                        videoCell.Header.profileImage.sd_setImage(with: url, completed: nil)
                        //End profile picture
                        //username
                        videoCell.Header.profileBotton.button.setTitle(" \(userData.handle)", for: .normal)
                        //End username
                    }
                })
                
                
                //End Header Data
                
                //thumbnail Data
                guard let thumbnailFile = row["thumbnail"] as? PFFile else {return UITableViewCell()}
                guard let thumbUrl = thumbnailFile.url else {return UITableViewCell()}
                guard let url = URL(string: thumbUrl) else {return UITableViewCell()}
                videoCell.Thubnail.sd_setImage(with: url, completed: nil)
                //End thumbnaul Dara
                
                //footer Data
                guard let videoDescription = row["description"] as? String else {return UITableViewCell()}
                videoCell.Footer.VideoDescription.text = videoDescription
                //End footer
                
                return videoCell
            } else {
                guard let dataForChallenges = data["challenges"] else {return UITableViewCell()}
                let dataForRow = dataForChallenges[indexPath.row]
                guard let challengeTitle = dataForRow["description"] as? String else {return UITableViewCell()}
                let challengesCell = tableView.dequeueReusableCell(withIdentifier: self.challengeCell, for: indexPath)
                challengesCell.textLabel?.text = challengeTitle
                return challengesCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0
        } else {
            guard let sectionType = self.currentData.first?.key else {return 0}
            let back = sectionType == "videos" ? 310 : 65
            return CGFloat(back)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.currentTab)
        if self.currentTab == "videos" {
            guard let currentTabData = self.currentData["videos"] else  {return}
            let videoplayer = VideoPlayer()
            videoplayer.videdata = currentTabData[indexPath.row]
            print(currentTabData[indexPath.row])
            self.navigationController?.pushViewController(videoplayer, animated: true)
        } else if self.currentTab == "challenges" {
            guard let currentTabData = self.currentData["challenges"] else  {return}
            let row = currentTabData[indexPath.row]
            guard let id = row.objectId else {return}
            self.checkChallegeData(challengeId: id)
        }
    }
}


