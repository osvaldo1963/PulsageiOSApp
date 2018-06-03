import UIKit
import Parse
import AVKit

class Player: UIViewController {
    
    public var videoData: PFObject!
    public var videoUrl: URL!
    private var player = AVPlayer()
    private var buttonPressed  = "Comments"
    
    
    private var videoController: AVPlayerViewController = {
        let controller = AVPlayerViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    private lazy var table: UITableView = {
        let tb = UITableView.init(frame: CGRect.zero, style: .grouped)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.delegate = self
        tb.dataSource = self
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addsubview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func addsubview() {
        self.view.addSubview(self.videoController.view)
        self.addChildViewController(self.videoController)
        self.videoController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.videoController.view.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.videoController.view.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.videoController.view.heightAnchor.constraint(equalToConstant: self.view.frame.size.height / 3).isActive = true
        
        self.view.addSubview(self.table)
        self.table.topAnchor.constraint(equalTo: self.videoController.view.bottomAnchor).isActive = true
        self.table.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.table.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.table.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension Player {
    
}
//Header Functions
extension Player {
    private func tableHeader() -> TbHeader {
        let headerFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300)
        let header = TbHeader(frame: headerFrame)
        return header
    }
}

extension Player: UITableViewDelegate, UITableViewDataSource {
    
    //Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //
    
    //View Header Props
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let tableHeader = self.tableHeader()
        } else {
            if self.buttonPressed == "Comments" {
                
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 235 //header hight
        } else {
            //Mark: check current data state
            if self.buttonPressed == "Comments"{
                return 60
            } else {
                return 0
            }
        }
    }
    //
    
    //cell props
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    //
    
    //View Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    //
}
