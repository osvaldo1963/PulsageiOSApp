import UIKit
import Parse
import Font_Awesome_Swift

class ChallengePicker: UIViewController {
    
    fileprivate let tablecell = "tablecellid"
    fileprivate var searchHolder = [PFObject]()
    public var delegate: searchChallengeDelegate?
    
    private lazy var mainView: UIView = {
        let sview = UIView(frame: CGRect.zero)
        sview.backgroundColor = .white
        sview.layer.cornerRadius = 8
        sview.translatesAutoresizingMaskIntoConstraints = false
        return sview
    }()
    
    private lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.setFAIcon(icon: .FAAngleDown , iconSize: 30, forState: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.gray, for: .normal)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchb = UISearchBar()
        searchb.delegate = self
        searchb.placeholder = "Search for challenge"
        searchb.translatesAutoresizingMaskIntoConstraints = false
        return searchb
    }()
    
    private lazy var tableview: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: self.tablecell)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.addSubview(self.mainView)
        self.mainView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        self.mainView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.mainView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.mainView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height - 40).isActive = true
        
        self.mainView.addSubview(self.closeBtn)
        self.closeBtn.topAnchor.constraint(equalTo: self.mainView.topAnchor).isActive = true
        self.closeBtn.leftAnchor.constraint(equalTo: self.mainView.leftAnchor).isActive = true
        self.closeBtn.rightAnchor.constraint(equalTo: self.mainView.rightAnchor).isActive = true
        self.closeBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.mainView.addSubview(self.searchBar)
        self.searchBar.topAnchor.constraint(equalTo: self.closeBtn.bottomAnchor).isActive = true
        self.searchBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.searchBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.mainView.addSubview(self.tableview)
        self.tableview.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 0).isActive = true
        self.tableview.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.tableview.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.tableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = .clear
        self.searchBar.endEditing(false)
    }
    
    @objc fileprivate func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension ChallengePicker: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let searchObject = searchBar.text else {return}
        let query = PFQuery(className: "Challenges")
        query.whereKey("description", contains: searchObject)
        query.findObjectsInBackground { (challenges, error) in
            guard let results = challenges as? [PFObject] else {return}
            self.searchHolder = results
            DispatchQueue.main.async {
                self.tableview.reloadData()
                
            }
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        self.searchBar.text = ""
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
      
    }
}

extension ChallengePicker: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchHolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tablecell, for: indexPath)
        let rowObject = self.searchHolder[indexPath.row]
        guard let rowDescript = rowObject["description"] as? String else {return UITableViewCell()}
        guard let rowTitle = rowObject["title"] as? String else {return UITableViewCell()}
        cell.textLabel?.text = rowTitle
        cell.detailTextLabel?.text = rowDescript
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let challengeSelected = self.searchHolder[indexPath.row]
        self.delegate?.searchObeject(object: challengeSelected)
        self.dismissView()
    }
    
}

protocol searchChallengeDelegate {
    func searchObeject(object: PFObject)
}
