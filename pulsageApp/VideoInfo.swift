import UIKit
import AVKit
import AVFoundation
import Photos
import Parse

class VideoInfo: UIViewController {
    
    fileprivate var urlAsset: URL?
    fileprivate var challengesNames = ["pick a challenge"]
    fileprivate var challengesid = ["0"]
    public var videoUrl: URL?
    fileprivate var currentChallengeId = ""
    fileprivate var activituIndicator = UIActivityIndicatorView()
    fileprivate var currentUser = PFUser.current()
    
    fileprivate lazy var Picker: UIPickerView = {
        let picker = UIPickerView()
            picker.frame = CGRect(x: 20, y: 60, width: self.view.frame.size.width - 40, height: 90)
            picker.delegate = self
            picker.dataSource = self
            picker.showsSelectionIndicator = true
        return picker
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
            label.frame = CGRect(x: 20, y: self.Picker.frame.origin.y + 85, width: self.view.frame.size.width - 40, height: 20)
            label.font = UIFont(name: "Helvetica-Light", size: 13)
            label.text = "Video Title"
            label.textColor = .gray
        
        return label
    }()
    
    fileprivate lazy var titleInput: UITextField = {
        let textInput = UITextField()
            textInput.frame = CGRect(x: 20, y: self.titleLabel.frame.origin.y + 25, width: self.view.frame.size.width - 40, height: 40)
            textInput.placeholder = "video title"
            textInput.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
            textInput.layer.cornerRadius = 3
        return textInput
    }()
    
    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
            label.frame = CGRect(x: 20, y: self.titleInput.frame.origin.y + 50 , width: self.view.frame.size.width - 40, height: 20)
            label.font      = UIFont(name: "Helvetica-Light", size: 13)
            label.text      = "Video Description"
            label.textColor = .gray
        
        return label
    }()
    
    fileprivate lazy var descrotionInput: UITextField = {
        let textInput = UITextField()
        textInput.frame = CGRect(x: 20, y: self.descriptionLabel.frame.origin.y + 25, width: self.view.frame.size.width - 40, height: 40)
        textInput.placeholder = "video description"
        textInput.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
        textInput.layer.cornerRadius = 3
        return textInput
    }()
    
    fileprivate lazy var uploadBtn: UIButton = {
        let btn = UIButton()
            btn.frame = CGRect(x: 20, y: self.view.frame.size.height - 70, width: self.view.frame.size.width - 40, height: 50)
            btn.setTitle("Upload", for: .normal)
            btn.addTarget(self, action: #selector(UploadVideo), for: .touchUpInside)
            btn.tintColor = .white
            btn.layer.cornerRadius = 3
            btn.backgroundColor = .orange
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ViewProps()
        do {
            let resources = try self.videoUrl!.resourceValues(forKeys: [.fileSizeKey])
            guard let filesize = resources.fileSize else {return}
            let file = Double(filesize / 1024)
            print(file / 1024)
        } catch {
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getVideoFromUrl(url: self.videoUrl!)
        self.currentChallengeId = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.getChallenges()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func ViewProps() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.Picker)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.titleInput)
        self.view.addSubview(self.descriptionLabel)
        self.view.addSubview(self.descrotionInput)
        self.view.addSubview(self.uploadBtn)
    }
    
    fileprivate func setNatigationprops() {
        
    }
    
    
    
    fileprivate func getVideoFromUrl(url: URL) {
        let viewwidth = self.view.frame.size.width
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = CGRect(x: 20, y: self.descrotionInput.frame.origin.y + 60, width: viewwidth - 40 , height: self.view.frame.size.height / 3)
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    //Mark: video upoad =====================================================
    @objc fileprivate func UploadVideo() {
        //let app = UIApplication.shared.delegate as! AppDelegate
        //guard let url = self.videoUrl  else {return }
        guard let id = PFUser.current()?.objectId else {return}
        guard let name = self.titleInput.text else {return}
        guard let descript = self.descrotionInput.text else {return}
        
        if id.isEmpty || name.isEmpty || descript.isEmpty || self.currentChallengeId.isEmpty {
            self.simpleAlert(Message: "All field are required", title: "Error Uploading")
        } else {
            //app.submitVideos(videoUrl: url, userId: id, name: name, descript: descript, challenId: self.currentChallengeId)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    fileprivate func getChallenges() {
        let query = PFQuery(className: "Challenges")
        query.findObjectsInBackground { (results, error) in
            guard let challenges = results else {return}
            for challenge in challenges {
                guard let id = challenge.objectId else {return}
                guard let names = challenge["title"] as? String else {return}
                self.challengesid.append(id)
                self.challengesNames.append(names)
                DispatchQueue.main.async {
                    self.Picker.reloadAllComponents()
                }
            }
        }
    }
    
    func createThumbnailOfVideoFromFileURL(videoURL: URL) -> UIImage? {
        
        let asset = AVAsset(url: videoURL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(1), 100)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            // Set a default image if Image is not acquired
        }
        
        return nil
    }
}

extension VideoInfo: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.challengesNames.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.challengesNames[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentChallengeId = self.challengesid[row]
    }
}
