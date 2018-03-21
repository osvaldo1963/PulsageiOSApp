import UIKit

class PostTab: UIViewController {
    
    //Mark: fileprivate variable
    fileprivate var titleForRow = ["", ""]
    fileprivate var thumbnailForRow = [UIImage(), UIImage()]
    fileprivate var imagepickerController = UIImagePickerController()
    
    //Mark: fileprivate objects
    fileprivate lazy var tableview: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(PostTabCell.self, forCellReuseIdentifier: "id")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        DispatchQueue.global(qos: .userInteractive).async {
            self.loadImages()
        }
        
        self.addsubViews()
        self.view.backgroundColor = .white
        self.imagepickerController.delegate = self
        self.imagepickerController.allowsEditing = true
        self.imagepickerController.sourceType = .savedPhotosAlbum
        self.imagepickerController.mediaTypes = ["public.movie"]
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationProps()
       
        
        
    }
    
    private func navigationProps() {
        self.navigationController?.navigationBar.topItem?.title = "Create"
    }
    
    private func addsubViews() {
        self.view.addSubview(self.tableview)
        self.tableview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive       = true
        self.tableview.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive     = true
        self.tableview.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive   = true
        self.tableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func loadImages() {
        
        self.thumbnailForRow.removeAll()
        self.titleForRow.removeAll()
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
        self.thumbnailForRow = [UIImage(named: "postFirst")!, UIImage(named: "postSecond")!]
        self.titleForRow = ["Create a Challenge", "Record a Video"]
        
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
       
    }
}

extension PostTab: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleForRow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as? PostTabCell else {return UITableViewCell()}
        cell.title.text = self.titleForRow[indexPath.row]
        cell.thumbnail.image = self.thumbnailForRow[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableview.frame.size.height / 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let createChallenge = CreateChallenge()
            self.navigationController?.pushViewController(createChallenge, animated: true)
        case 1:
            
            let controller = UIAlertController(title: "Video Source", message: "Choose Video From Camera or Library", preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
                let cameraController = CameraRecorded()
                let rootNavigationController = UINavigationController(rootViewController: cameraController)
                rootNavigationController.gradientBackground()
                self.present(rootNavigationController, animated: true, completion: nil)
            })
            let library = UIAlertAction(title: "Library", style: .default, handler: { (alert) in
                
                self.present(self.imagepickerController, animated: true, completion: nil)
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(camera)
            controller.addAction(library)
            controller.addAction(cancel)
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
}

//Mark: library picked delegate
extension PostTab: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        guard let fileUrl = info[UIImagePickerControllerMediaURL] as? URL else {return}
        let video = videoData()
        video.videoUrl = fileUrl
        let rootNavigation = UINavigationController(rootViewController: video)
        rootNavigation.gradientBackground()
        self.present(rootNavigation, animated: true, completion: nil)
       
    }
    
}

