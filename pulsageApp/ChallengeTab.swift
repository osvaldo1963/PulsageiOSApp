import UIKit
import Parse

class ChallengeTab: UIViewController {
    
    public var PFObjectData: PFObject?
    
    private let cellId = "cellid"
    private var challengesForTable = [PFObject]()
    
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
        DispatchQueue.global(qos:.utility).async {
            self.setHeaderData()
        }
        DispatchQueue.global(qos: .utility).async {
            self.getVideosForChallenge()
        }
        ///
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationProps()
        
    }
    //UI Props
    private func navigationProps() {
        guard let challengeData = self.PFObjectData else {return}
        guard let navigationTitle = challengeData["title"] as? String else {return}
        self.navigationController?.navigationBar.topItem?.title = navigationTitle
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
        guard let challengeData = self.PFObjectData else {return}
        guard let user = challengeData["User"] as? PFObject else {return}
        user.fetchInBackground { (object, error) in
            guard let userData = object else {return}
            guard let objectFiel = userData["profilePicture"] as? PFFile else {return}
            guard let PictureUrl = objectFiel.url else {return}
            guard let urlLink  = URL(string: PictureUrl) else {return}
            guard let userName = userData["username"] as? String else {return}
            self.header.creatorProfileBtn.setTitle("@\(userName.getTextFromEmail())", for: .normal)
            self.header.challengeCreatorImage.sd_setImage(with: urlLink)
        }
        
    }
    
    private func getVideosForChallenge() {
        guard let challengeData = self.PFObjectData else {return}
        guard let challengeId = challengeData.objectId else {return}
        
        PFCloud.callFunction(inBackground: "getChallenges", withParameters: ["challenge": challengeId]) { (result, error) in
            if error == nil {
                guard let object = result as? [PFObject] else {return}
                self.header.objects = self.voteCount(videos: object) //<======= Call Vote count function
                self.challengesForTable = object
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    self.header.pageController.reloadData()
                    self.activityIndicator.stopAnimating()
                }
                
            } else {
                print("error Back: \(error.debugDescription)")
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
}

extension ChallengeTab: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let Header = self.header
        Header.followBtn.isHidden = true //challenge Follow bottom hidden until we make it work
        return Header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 310
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.challengesForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? VideoCell else {return UITableViewCell()}
        let videoForRow = self.challengesForTable[indexPath.row]
        guard let videoComment = videoForRow["description"] as? String else {return UITableViewCell()}
        
        cell.Header.challengeSponsor.isHidden = true
        cell.Footer.rewardBtn.isHidden = true
        cell.Footer.ChallengeText.isHidden = true
        cell.Footer.ArrowBtn.isHidden = true
        
        //Header Data
        guard let userData = videoForRow["User"] as? PFObject else {return UITableViewCell()}
        userData.fetchInBackground { (result, error) in
            if error == nil {
                guard let user = result else {return}
                guard let username = user["username"] as? String else {return}
                guard let file = user["profilePicture"] as? PFFile else {return}
                guard let fileurl = file.url else {return}
                guard let picUrl = URL(string: fileurl) else {return}
                
                cell.Header.profileBotton.button.setTitle(" \(username.getTextFromEmail())", for: .normal)
                cell.Header.profileImage.sd_setImage(with: picUrl)
            } else {
                print(error.debugDescription)
            }
        }
        //Header Data
        
        //Thumnail Data
        guard let file = videoForRow["thumbnail"] as? PFFile else {return UITableViewCell()}
        guard let url = file.url else {return UITableViewCell()}
        guard let picUrl = URL(string: url) else {return UITableViewCell()}
        cell.Thubnail.sd_setImage(with: picUrl)
        //Thumnail Data
        
        //Footer Data
        cell.Footer.VideoDescription.text = videoComment
        //Footer Data
        return cell
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


