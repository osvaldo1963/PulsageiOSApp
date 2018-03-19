import UIKit
import Parse
import SDWebImage

class ProfileTab: UIViewController {
    
    public var userObject: PFObject?
    private var ktableHeaderHeight = 220
    private let challengeCell = "challemgecell"
    private let videoCell = "videocell"
    private var currentData = [String: [PFObject]]()
    private var currentTab = ""
    private var follow = false
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addviews()
        if userObject == nil {
            self.userObject  = PFUser.current()
            DispatchQueue.main.async {
                //self.tableview.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let user = self.userObject else {return}
        guard let username = user["username"] as? String else {return}
        self.navigationController?.navigationBar.topItem?.title = username.getTextFromEmail()
        
        guard let current = PFUser.current() else {return}
      
       
                let settins = UIBarButtonItem(title: "Settings", style: .done, target: self, action: #selector(self.settignBtn))
                self.navigationItem.setRightBarButton(settins, animated: true)
               
           
        
        
        
        
        self.checkUserType()
        self.getProfileData(index: 0)
        self.getFollowers()
        self.getFolling()
    }
    
    @objc private func settignBtn() {
        
    }
    
    private func addviews() {
        self.view.addSubview(self.tableview)
        
        self.tableview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive       = true
        self.tableview.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive     = true
        self.tableview.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive   = true
        self.tableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.view.backgroundColor = .white
        
    }
    
    private func checkUserType() {
        guard let user = self.userObject else {return}
        if user == PFUser.current() {
            self.tableHeader.followBtn.isHidden = true
        
        }
    }
    //Mark: Get Profile Data =======================================================================
    //==============================================================================================
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
    
    private func videos(user: PFObject) {
        self.currentData.removeAll(keepingCapacity: false)
        let videosQuery = PFQuery(className: "Videos")
        videosQuery.whereKey("User", equalTo: user)
        videosQuery.findObjectsInBackground(block: {
            (result, error) in
            if error == nil {
                guard let videos = result else {return}
                self.currentData["videos"] = videos
                self.currentTab = "videos"
                DispatchQueue.main.async {
                    self.tableview.reloadSections(IndexSet(integer: 1), with: .automatic)
                }
            } else {
                self.simpleAlert(Message: "Check your Interneter Connection", title: "Error")
            }
        })
    }
    
    private func challenges(user: PFObject) {
        self.currentData.removeAll(keepingCapacity: false)
        let challengeQuery = PFQuery(className: "Challenges")
        challengeQuery.whereKey("User", equalTo: user)
        challengeQuery.findObjectsInBackground { (result, error) in
            if error == nil {
                guard let challenges = result else {return}
                self.currentData["challenges"] = challenges
                self.currentTab = "challenges"
                DispatchQueue.main.async {
                    //self.tableview.reloadData()
                    self.tableview.reloadSections(IndexSet(integer: 1), with: .fade)
                }
            } else {
                self.simpleAlert(Message: "Check your Interneter Connection", title: "Error")
            }
        }
    }
    
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
                        self.tableHeader.followBtn.setTitle("Unfollow", for: .normal)
                        self.follow = true
                    } else {
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
                    self.tableHeader.following.setTitle("\(follers.count) \n Following", for: .normal)
                }
                
            }
        }
    }
    
    @objc private func followBtn() {
        guard let currentUser = PFUser.current() else {return}
        guard let user = self.userObject else {return}
        if currentUser != user {
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
    //==============================================================================================
    //==============================================================================================
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
            
            let videoImage = UIImage.init(icon: .FAYoutubePlay, size: CGSize(width: 40, height: 40))
            let listicon   = UIImage.init(icon: .FAPlusCircle, size: CGSize(width: 40, height: 40))
            let images     = [videoImage, listicon]
            guard let user = userObject else {return UIView()}
           
            guard let file = user["profilePicture"] as? PFFile else {return UIView()}
            guard let picurl = file.url else {return UIView()}
            guard let url = URL(string: picurl) else {return UIView()}
            
            self.tableHeader.segmented.ImagesArray = images
            self.tableHeader.username.text = "" //keep empty username label
            self.tableHeader.userimage.sd_setImage(with: url)
            
            
            
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
                
                videoCell.Footer.ArrowBtn.isHidden = true
                videoCell.Footer.ChallengeText.isHidden = true
                videoCell.Footer.rewardBtn.isHidden = true
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
                        guard let username = userData["username"] as? String else {return}
                        videoCell.Header.profileBotton.button.setTitle(" \(username.getTextFromEmail())", for: .normal)
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
                guard let challengeTitle = dataForRow["title"] as? String else {return UITableViewCell()}
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
        if self.currentTab == "videos" {
            guard let currentTabData = self.currentData["videos"] else  {return}
            let videoplayer = VideoPlayer()
            videoplayer.videdata = currentTabData[indexPath.row]
            self.navigationController?.pushViewController(videoplayer, animated: true)
        } else if self.currentTab == "challenges" {
            guard let currentTabData = self.currentData["challenges"] else  {return}
            let row = currentTabData[indexPath.row]
            guard let id = row.objectId else {return}
            let challengePage = ChallengeTab()
            challengePage.PFObjectData = id
            self.navigationController?.pushViewController(challengePage, animated: true)
        }
    }
}


