import UIKit


class CameraRecorded: SwiftyCamViewController {
    //Mark: class Propeties
    //var videoDelegate : videoRecordedDelegate?
    
    //Mark: fileprivate variables
    fileprivate var timer = Timer()
    fileprivate var timeCount = 0
    //================================
    
    //Mark: filaprivate visual objects
    private lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.setFAIcon(icon: .FAAngleDown , iconSize: 30, forState: .normal)
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var starRecordingBtn: UIButton = {
        let btn = UIButton()
            btn.setFAIcon(icon: .FACircleO, iconSize: 80, forState: .normal)
            btn.frame = CGRect(x: self.view.frame.size.width / 2 - 40, y: self.view.frame.size.height - 80, width: 80, height: 80)
            btn.addTarget(self, action: #selector(record), for: .touchUpInside)
            btn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            btn.layer.cornerRadius = 40
        return btn
    }()
    
    public lazy var time: UILabel = {
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
    //==============================================
    
    //============ Mark: view controller props ==================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetViewsObjects()
        self.timeCount = 0
        self.time.text = "00:00"
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        /*
        guard let picked = self.pickedVideo else {return}
        
        if picked.absoluteString != "" {
            let videoview = VideoInfo()
            videoview.videoUrl = picked
            self.navigationController?.pushViewController(videoview, animated: true)
            self.pickedVideo = nil
        }
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.alpha = 1
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //============================================================
    
    //Mark: fileprivate functions
    fileprivate func SetViewsObjects() {
        
        self.videoQuality = .resolution1920x1080
        self.defaultCamera = .rear
        self.shouldUseDeviceOrientation = true
        self.maxZoomScale = 4.0
        self.tapToFocus = false
        self.doubleTapCameraSwitch = false
        self.maximumVideoDuration = 30
        self.cameraDelegate = self
    
        self.view.addSubview(self.closeBtn)
        self.closeBtn.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.closeBtn.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.closeBtn.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.closeBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(self.starRecordingBtn)
        self.view.addSubview(self.time)
        self.view.addSubview(self.changeCamera)
     
    }
    
    fileprivate func timerAction() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timebegan), userInfo: nil, repeats: true)
    }
    
    fileprivate func timeString(time:TimeInterval) -> String {
        let seconds = Int(time) % 60
        if seconds > 9 {
            return "00:\(seconds)"
        } else {
            return "00:0\(seconds)"
        }
    }
    
    //Mark: @objc functions
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
    
    @objc fileprivate func timebegan() {
        
        self.timeCount += 1
        self.time.text = self.timeString(time: TimeInterval(self.timeCount))
        if self.timeCount == 50 {
            self.timer.invalidate()
            self.record()
        }
        
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension CameraRecorded: SwiftyCamViewControllerDelegate {

    internal func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        self.time.text = "00:00"
        //push controller to videoData.swift
        let videodata = videoData()
        videodata.videoUrl = url
        self.navigationController?.pushViewController(videodata, animated: true)
    }
    
}



