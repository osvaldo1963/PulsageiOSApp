import UIKit


class CameraRecorded: SwiftyCamViewController {
    fileprivate var imagepickerController = UIImagePickerController()
    fileprivate var pickedVideo: URL?
    fileprivate let swiftCam = SwiftyCamViewController()
    fileprivate var timer = Timer()
    fileprivate var timeCount = 0
    
    fileprivate lazy var starRecordingBtn: UIButton = {
        let btn = UIButton()
            btn.setFAIcon(icon: .FACircleO, iconSize: 80, forState: .normal)
            btn.frame = CGRect(x: self.view.frame.size.width / 2 - 40, y: self.view.frame.size.height - 80, width: 80, height: 80)
            btn.addTarget(self, action: #selector(record), for: .touchUpInside)
            btn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            btn.layer.cornerRadius = 50
        return btn
    }()
    
    fileprivate lazy var flashBtn: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 20, y: self.view.frame.size.height - 120, width: 40, height: 40)
        btn.setFAIcon(icon: .FAFlash , iconSize: 40, forState: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(self.flashOnandOff), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var time: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 10, y: self.view.frame.size.height - 60, width: self.view.frame.size.width - 20, height: 40)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var changeCamera: UIButton = {
        let btn = UIButton()
            btn.frame = CGRect(x: self.view.frame.size.width - 60, y: self.view.frame.size.height - 60, width: 40, height: 40)
            btn.setFAIcon(icon: .FARefresh, iconSize: 40, forState: .normal)
            btn.addTarget(self, action: #selector(ChangeCamera), for: .touchUpInside)
        return btn
    }()
    
    
    //============ Mark: view controller props ==================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetViewsObjects()
        self.timeCount = 0
        self.time.text = "00:00"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.NavigationBarProps()
        
        guard let picked = self.pickedVideo else {return}
        
        if picked.absoluteString != "" {
            let videoview = VideoInfo()
            videoview.videoUrl = picked
            self.navigationController?.pushViewController(videoview, animated: true)
            self.pickedVideo = nil
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.alpha = 1
    }
    
    //============================================================
    fileprivate func SetViewsObjects() {
   
        self.cameraDelegate = self
        self.view.backgroundColor = UIColor.orange
        //self.videoQuality = .resolution640x480
        self.videoQuality = .iframe960x540
        self.defaultCamera = .rear
        self.shouldUseDeviceOrientation = true
        self.maxZoomScale = 4.0
        self.tapToFocus = false
        self.doubleTapCameraSwitch = false
        self.maximumVideoDuration = 45.0
    
    
        self.view.addSubview(self.starRecordingBtn)
        //self.view.addSubview(self.flashBtn)
        self.view.addSubview(self.time)
        self.view.addSubview(self.changeCamera)
     
    }
    
    fileprivate func NavigationBarProps() {
        self.navigationController?.navigationBar.topItem?.title = "Camera"
        let libraryBtn = UIBarButtonItem(title: "Library", style: .plain, target: self, action: #selector(videoLibrary))
        self.navigationController?.navigationBar.topItem?.setRightBarButton(libraryBtn, animated: true)
        self.navigationController?.navigationBar.alpha = 0.6
    }
    
    fileprivate func timerAction() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timebegan), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func timebegan() {
        
        self.timeCount += 1
        self.time.text = self.timeString(time: TimeInterval(self.timeCount))
        if self.timeCount == 50 {
            self.timer.invalidate()
            self.record()
        }
    
    }
    
    func timeString(time:TimeInterval) -> String {
        let seconds = Int(time) % 60
        return "00:\(seconds)"
    }
    
    @objc fileprivate func record() {
        if self.isVideoRecording {
            self.stopVideoRecording()
            self.navigationController?.navigationBar.topItem?.title = "Camera"
            self.starRecordingBtn.setTitleColor(.white, for: .normal)
            self.timer.invalidate()
            
        } else {
            self.startVideoRecording()
            self.navigationController?.navigationBar.topItem?.title = "Recording"
            self.starRecordingBtn.setTitleColor(.red, for: .normal)
            self.timerAction()
            self.timeCount = 0
        }
    }
    
    @objc fileprivate func ChangeCamera() {
        self.switchCamera()
    }
    
    @objc fileprivate func flashOnandOff() {
    
    }
    
    @objc fileprivate func videoLibrary() {
        self.imagepickerController.delegate = self
        self.imagepickerController.allowsEditing = true
        self.imagepickerController.sourceType = .savedPhotosAlbum
        self.imagepickerController.mediaTypes = ["public.movie"]
        self.present(self.imagepickerController, animated: true, completion: nil)
    }
    
}

extension CameraRecorded: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let fileUrl = info[UIImagePickerControllerMediaURL] as? URL else {return}
        self.pickedVideo = fileUrl
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CameraRecorded: SwiftyCamViewControllerDelegate {

    internal func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        self.time.text = "00:00"
        let videoinfo = VideoInfo()
        videoinfo.videoUrl = url
        self.navigationController?.pushViewController(videoinfo, animated: true)
    }
    

}
