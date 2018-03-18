import UIKit
import Parse

class ChallengePage: UIViewController {
    
    //Mark: data variables ========================
    public var challengeid = "" //this variable must be use in order to reuse this class
    public var challengeTitle = "" //this variable must be use in order to reuse this class
    fileprivate var videos = [PFObject]()
    fileprivate var headerdata = [PFObject]()
    //=============================================

    //Mark: view objects ==========================
    fileprivate lazy var table: UITableView = {
        var table = UITableView()
        let tableframe = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        table = UITableView.init(frame: tableframe, style: .grouped)
        table.register(VideosCell.self, forCellReuseIdentifier: "id")
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    fileprivate lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height / 3)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 80, height: 80), collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(challengeHeader.self, forCellWithReuseIdentifier: "cid")
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false
    
        return collection
    }()
    
    //=============================================
    
    //Mark: view controller props ==================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        self.subViews()
        self.getChallengeData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationProps()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.challengeid = ""
        self.challengeTitle = ""
    }
    //===============================================
    
    //Mark: methods =================================
    fileprivate func subViews() {
        self.view.addSubview(self.table)
    }
    
    fileprivate func navigationProps() {
        self.navigationController?.navigationBar.topItem?.title = self.challengeTitle
    }
    
    fileprivate func getChallengeData() {
        self.headerdata.removeAll(keepingCapacity: false)
        let query = PFQuery(className: "Videos")
        query.whereKey("challengeid", equalTo: self.challengeid)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (data, error) in
            guard let chaVideos = data else {return}
            self.videos = chaVideos
            self.headerdata.append(chaVideos[chaVideos.endIndex - 1])
            for video in chaVideos {
                print(video.objectId)
            }
            DispatchQueue.main.async {
                self.table.reloadData()
                self.collection.reloadData()
            }
            self.getvoteBest()
        }
        
    }
    
    fileprivate func getvoteBest() {
        let query = PFQuery(className: "Videos")
        query.whereKey("challengeid", equalTo: self.challengeid)
        query.order(byDescending: "VoteBest")
        query.findObjectsInBackground { (data, error) in
            guard let votebestVideo = data else {return}
            guard let last = votebestVideo.last else {return}
            self.headerdata.append(last)
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
    }
    
    //===============================================
    
}

extension ChallengePage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as? VideosCell
        let indexdata = self.videos[indexPath.row]
        if let videoThumb = indexdata["thumbnail"] as? PFFile {
            cell?.videos.sd_setImage(with: URL(string: videoThumb.url!))
        }
        cell?.titleText = indexdata["name"] as! String
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return self.collection
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.size.height / 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoplayer = VideoPlayer()
        let row = self.videos[indexPath.row]
        
        
    
        videoplayer.videdata = row
        
        self.present(videoplayer, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ChallengePage: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.headerdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cid", for: indexPath) as? challengeHeader
        let url = self.headerdata[indexPath.item]["thumbnail"] as? PFFile
        
        
        if let imageurl = url?.url {
            cell?.videoThum.sd_setImage(with: URL(string: imageurl))
        }
        
        if indexPath.row == 0 {
            cell?.topText.text = "First Video"
        } else {
            cell?.topText.text = "Best Vote Video"
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let videoplayer = VideoPlayer()
        let item = self.headerdata[indexPath.item]
        
        guard let url = item["video"] as? PFFile else {return}
        guard let id = item.objectId else {return}
        guard let createdAt = item.createdAt else {return}
        
       
        videoplayer.videdata = item
        
        self.present(videoplayer, animated: true, completion: nil)
        
    }

}

class challengeHeader: UICollectionViewCell {
    
    fileprivate lazy var videoThum: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .white
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        return imageview
    }()
    
    fileprivate lazy var cover: UIView = {
        let cover = UIView()
        cover.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return cover
    }()
    
    fileprivate lazy var topText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica-Bold", size: 18)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subViews(frame: frame)
        
    }
    
    fileprivate func subViews(frame: CGRect) {
        self.addSubview(self.videoThum)
        self.videoThum.frame = CGRect(x: 0, y:0, width: frame.size.width, height: frame.size.height)
        
        self.addSubview(self.cover)
        self.cover.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        self.addSubview(self.topText)
        self.topText.frame = CGRect(x: 10, y: 15, width: frame.size.width - 10, height: 40)
        
    }
}
