import UIKit

class PostTab: UIViewController {
    
    //Mark: fileprivate variable
    fileprivate let titleForRow = ["Create a Challenge", "Reacord a Video"]
    fileprivate let thumbnailForRow = [#imageLiteral(resourceName: "postFirst"), #imageLiteral(resourceName: "postSecond")]
    
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
        self.view.backgroundColor = .white
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addsubViews()
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
            let recordVideo = CameraRecorded()
            self.navigationController?.pushViewController(recordVideo, animated: true)
        default:
            break
        }
    }
    
}
