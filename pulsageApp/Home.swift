import UIKit
import Parse
import AVFoundation
import SystemConfiguration
import SDWebImage

class Home: UIViewController {
    //Mark: fileprivate prop =====================
    fileprivate var dataHolder = [[String: Any]]()
    fileprivate let collectioncellid = "collectionid"
    fileprivate let parseData = ParseData()
    //======================================
    
    //Mark: fileprivate visual objects ==========================
    fileprivate lazy var refreshController: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Updating Data")
        refresh.addTarget(self, action: #selector(homeFeedData), for: .valueChanged)
        return refresh
    }()
    
    fileprivate lazy var tableview: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.addSubview(self.refreshController)
        table.register(VideoCell.self, forCellReuseIdentifier: "video")
        table.register(VideoCell.self, forCellReuseIdentifier: "sponsor")
        table.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    //========================================================
    
    //Mark: UIViewController properties ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.homeFeedData()
        //self.getChallenges()
        self.view.addSubview(self.tableview)
        self.tableview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive       = true
        self.tableview.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive     = true
        self.tableview.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive   = true
        self.tableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        let back = defaults.object(forKey: "firstTime") as? String
        
        if back == nil {
            let presenationViewcontroller = UINavigationController(rootViewController: Presentation())
            self.present(presenationViewcontroller, animated: true, completion: nil)
            defaults.set("no", forKey: "firstTime")
        }
        self.navigationController?.navigationBar.topItem?.title = "Trending"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //=================================================
    
    //==============================================
    ///Mark: Parse data
    //==============================================
    
    @objc func homeFeedData() {
        PFCloud.callFunction(inBackground: "getVideos", withParameters: ["": ""], block: { (re, error) in
            guard let data = re as? [[String: Any]] else {return}
            self.dataHolder = data
            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.refreshController.endRefreshing()
            }
        })
    }
    //================================================
    //Mark: End parse data
    //================================================
    
    
    @objc func presentChallenge(sender: CustomBtn) {
        guard let id = sender.id else {return}
        let challegeview = ChallengePage()
        challegeview.challengeid = id
    
        self.navigationController?.pushViewController(challegeview, animated: true)
    }
    
    @objc func sendToProfile(sender: UIButton) {
        guard let userid = sender.titleLabel?.text else {return}
        let userprofile = UserProfile()
        userprofile.userid = userid
        self.navigationController?.pushViewController(userprofile, animated: true)
    }
   
   
    
    fileprivate func PresentVideoPlayer(video: PFObject, RealetedVideos: [PFObject]?) {
        let videoPlayer = VideoPlayer()
    
        videoPlayer.videdata = video
       
        self.navigationController?.pushViewController(videoPlayer, animated: true)
        //self.present(videoPlayer, animated: true, completion: nil)
    }

    
}


//================= tableview delegate and datasource ============================
extension Home: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dataHolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forCell = self.dataHolder[indexPath.row]
        guard let key = forCell["key"] as? String else {return UITableViewCell()}
        
        if key == "sponsor"  {
            ///Mark: Sponsor Section ================================
            let cell = tableView.dequeueReusableCell(withIdentifier: "sponsor", for: indexPath) as? VideoCell
            guard let row = forCell["value"] as? PFObject else {return UITableViewCell()}
            guard let profile = row["logo"] as? PFFile else {return UITableViewCell()}
            guard let logoUrl = profile.url else {return UITableViewCell()}
            guard let companyname = row["companyName"] as? String else {return UITableViewCell()}
            cell?.Header.profileImage.sd_setImage(with: URL(string: logoUrl))
            let relation = row.relation(forKey: "Challenges")
            let query = relation.query()
            query.findObjectsInBackground(block: { (result, error) in
                guard let first = result else {return}
                guard let id = first[0].objectId else {return}
                guard let challengeDes = first[0]["description"] as? String else {return}
                    cell?.Footer.ArrowBtn.id = id
                    cell?.Footer.ArrowBtn.addTarget(self, action: #selector(self.presentChallenge(sender:)), for: .touchUpInside)
                    cell?.Footer.VideoDescription.text = challengeDes
            })
    
            return cell!
            ///=====================================================
        } else {
            
            ///Mark: Video inforation
            let cell = tableView.dequeueReusableCell(withIdentifier: "video", for: indexPath) as? VideoCell
            
            guard let row = forCell["value"] as? PFObject else {return UITableViewCell()}
            ///video Data
            guard let file = row["thumbnail"] as? PFFile else {return UITableViewCell()}
            guard let videoDescription = row["description"] as?  String else {return UITableViewCell()}
            guard let videoChallenge = row["Challenges"] as? PFObject else {return UITableViewCell()}
            guard let thumUrl = file.url else {return UITableViewCell()}
            //
            
            cell?.Footer.rewardBtn.isHidden = true //only for sponsor section
            cell?.Header.challengeSponsor.isHidden = true //only for sponsor section
            
            ///
            
            ///Mark: User Information Header
            guard let user = row["User"] as? PFUser else {return UITableViewCell()}
            user.fetchInBackground { (userData, error) in
                if error == nil {
                    guard let data = userData else {return }
                    guard let username = data["username"] as? String else {return}
                    guard let userfile = data["profilePicture"] as? PFFile else {return}
                    guard let userPicture = userfile.url else {return}
                    cell?.Header.profileImage.sd_setImage(with: URL(string: userPicture))
                    cell?.Header.profileBotton.button.setTitle(" \(username.getTextFromEmail())", for: .normal)
                }
            }
            ///
            
            cell?.Thubnail.sd_setImage(with: URL(string: thumUrl))
            
            ///Mark: Video Information Footer
            guard let challenge = row["Challenges"] as? PFObject else {
                cell?.Footer.ChallengeText.text = "none"
                return cell!
            }
            challenge.fetchInBackground { (cha, error) in
                if error == nil {
                    guard let chadata = cha else {return}
                    guard let challengeid = chadata.objectId else {return}
                    cell?.Footer.ChallengeText.text = "Challenge"
                    cell?.Footer.ArrowBtn.id = chadata.objectId
                    cell?.Footer.ArrowBtn.addTarget(self, action: #selector(self.presentChallenge(sender:)), for: .touchUpInside)
                }
            }
            cell?.Footer.VideoDescription.text = videoDescription
            cell?.Footer.VideoDescription.resolveHashTags()
            cell?.Footer.VideoDescription.delegate = self
            ///
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height / 2 + 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let forCell = self.dataHolder[indexPath.row]
        guard let row = forCell["value"] as? PFObject else {return }
        self.PresentVideoPlayer(video: row, RealetedVideos: nil)
    }
    //================ Row end section ===========================
    
}

extension Home: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        guard let type = URL.scheme else {return true}
        let array = Array(textView.text)
        let range = array[characterRange.lowerBound + 1 ... characterRange.upperBound - 1 ]
        switch type {
        case "mention":
            print("mention \(String(range))")
        case "hash":
            print("hash \(String(range))")
        default:
            break
        }
        return true
    }
}



