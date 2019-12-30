//
//  ViewController.swift
//  task
//
//  Created by Mina Gamil  on 12/24/19.
//  Copyright © 2019 Mina Gamil. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController ,UISearchBarDelegate{
    
    var repoArray = [WelcomeElement]()
    var isLoading:Bool = false
    var currentPage = 1
    var lastPage = 1
    var selectedIndex:Int!
    var filteredArray = [WelcomeElement]()
    var isChanging = false
    private lazy var searchBar:UISearchBar = {
         let searchBar = UISearchBar()
          searchBar.translatesAutoresizingMaskIntoConstraints = false
          searchBar.barTintColor = .red
          searchBar.isTranslucent = true
          searchBar.barStyle = .default
          searchBar.placeholder = "Type here"
          searchBar.delegate = self
          return searchBar
      }()
      
      private lazy var repo:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
      }()
    
    private lazy var dialog:UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .purple
        view.isHidden = true
        return view
    }()
    private lazy var closeButton:UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didClose), for: .touchUpInside)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    private lazy var dialogText:UILabel = {
       let label = UILabel()
        label.text = "Do you want to go to repository or owner url"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var repoOwnerButtton:UIButton = {
        let repoOwnerButton = UIButton()
        repoOwnerButton.translatesAutoresizingMaskIntoConstraints = false
        repoOwnerButton.setTitle("Repo Owner", for: .normal)
        repoOwnerButton.backgroundColor = .black
        repoOwnerButton.titleLabel?.textColor = .white
        repoOwnerButton.addTarget(self, action: #selector(repoOnwerPressed), for: .touchUpInside)
        return repoOwnerButton
    }()
    
    private lazy var repoButton:UIButton = {
          let repoButton = UIButton()
          repoButton.translatesAutoresizingMaskIntoConstraints = false
          repoButton.setTitle("Repo", for: .normal)
          repoButton.backgroundColor = .black
          repoButton.titleLabel?.textColor = .white
          repoButton.addTarget(self, action: #selector(repoPressed), for: .touchUpInside)
          return repoButton
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        networkRequest()
        tableViewSetup()
        constraintsSetup()
        refreshHadler()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dialog.layer.cornerRadius = dialog.frame.height*0.1
        dialog.clipsToBounds = true
        repoOwnerButtton.layer.cornerRadius = repoOwnerButtton.frame.height/2
        repoOwnerButtton.clipsToBounds = true
        repoButton.layer.cornerRadius = repoButton.frame.height/2
        repoButton.clipsToBounds = true
    }
    
    @objc func repoOnwerPressed(sender:UIButton){
        let buttonPosition = sender.convert(CGPoint.zero, to: self.repo)
        let indexPath = self.repo.indexPathForRow(at:buttonPosition)
        guard let index = indexPath?.item else {return}
        guard let htmlUrl = Api.ownerArray[index].htmlURL else{return}
        if let url = URL(string: htmlUrl ) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @objc func repoPressed(sender:UIButton){
        let buttonPosition = sender.convert(CGPoint.zero, to: self.repo)
        let indexPath = self.repo.indexPathForRow(at:buttonPosition)
        guard let index = indexPath?.item else {return}
        guard let htmlUrl = repoArray[index].htmlURL else{return}
        if let url = URL(string:htmlUrl) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @objc func didClose(sender:UIButton){
        dialog.isHidden = true
    }
    
    func layoutUI(){
        view.backgroundColor = .lightGray
        view.addSubview(searchBar)
        view.addSubview(repo)
        view.addSubview(dialog)
        dialog.addSubview(dialogText)
        dialog.addSubview(repoOwnerButtton)
        dialog.addSubview(repoButton)
        dialog.addSubview(closeButton)
    }
    
    func constraintsSetup(){
        NSLayoutConstraint.activate([
               searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
               searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               searchBar.widthAnchor.constraint(equalTo: view.widthAnchor),
               searchBar.heightAnchor.constraint(equalToConstant: 50)
           ])
           
           NSLayoutConstraint.activate([
               repo.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
               repo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               repo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               repo.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                  ])
        
        NSLayoutConstraint.activate([
            dialog.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dialog.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dialog.widthAnchor.constraint(equalToConstant: 350),
            dialog.heightAnchor.constraint(equalToConstant: 200)
                       ])
        
        NSLayoutConstraint.activate([
            dialogText.topAnchor.constraint(equalTo: dialog.topAnchor),
            dialogText.widthAnchor.constraint(equalTo: dialog.widthAnchor, multiplier: 0.95),
            dialogText.centerXAnchor.constraint(equalTo: dialog.centerXAnchor),
            dialogText.heightAnchor.constraint(equalTo: dialog.heightAnchor, multiplier: 0.6)
        ])
        
        NSLayoutConstraint.activate([
            repoOwnerButtton.bottomAnchor.constraint(equalTo: dialog.bottomAnchor, constant: -20),
            repoOwnerButtton.trailingAnchor.constraint(equalTo: dialog.trailingAnchor, constant: -25),
            repoOwnerButtton.widthAnchor.constraint(equalToConstant: 120),
            repoOwnerButtton.heightAnchor.constraint(equalToConstant: 40)
        
        ])
        
        NSLayoutConstraint.activate([
                   repoButton.bottomAnchor.constraint(equalTo: dialog.bottomAnchor, constant: -20),
                   repoButton.leadingAnchor.constraint(equalTo: dialog.leadingAnchor, constant: 25),
                   repoButton.widthAnchor.constraint(equalToConstant: 120),
                   repoButton.heightAnchor.constraint(equalToConstant: 40)
               
               ])
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: dialog.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: dialog.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            closeButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    func refreshHadler(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        repo.refreshControl = refresh
    }

    @objc func refreshPulled(){
        guard !isLoading else{return}
        isLoading = true
        repo.refreshControl?.endRefreshing()
        networkRequest()
        // clear cache
    }
    
    func tableViewSetup(){
        repo.delegate = self
        repo.dataSource = self
        repo.registerNib(cell: repoCell.self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view != dialog {
                dialog.isHidden = true
            }
        }
    }
    
    func filter(searchText:String){
        let nameFilter = repoArray.map({$0.name})
        filteredArray = repoArray.filter({$0.name.contains(searchText)})
        print(filteredArray)
        print(nameFilter)
        let array = [2,1,3,4,5,6]
        let sortedArray = array.sorted(by: {$0 < $1})
        print(sortedArray)
        print(filteredArray as Any)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else {
            return
        }
        filter(searchText: text)
        isChanging = true
        repo.reloadData()

    }
    
     func networkRequest(){
        Api.parsers(page: 1) { (error, repoArray) in
            self.isLoading = false
              if let task = repoArray{
              self.repoArray = task
              self.repo.reloadData()
                self.currentPage = 1
                //self.isChanging = false
              }
          }
      }
    
    func loadMore(){
        Api.parsers(page:currentPage+1) { (error, repoArray)  in
          self.isLoading = false
            if let task = repoArray{
                self.repoArray.append(contentsOf: task)
                self.repo.reloadData()
                self.currentPage += 1
            }
        }
       }
    
}

extension ViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isChanging == false{
            return repoArray.count

        }else{
            return filteredArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell") as! repoCell
        if repoArray[indexPath.row].fork == false{
            cell.containerView.backgroundColor = .green
            print("okey")
        }else{
             cell.containerView.backgroundColor = .white
            print("no")
        }
        if isChanging == false {
            cell.repoName.text = repoArray[indexPath.row].name
            cell.repoOwner.text = repoArray[indexPath.item].fullName
            cell.repoDescription.text = repoArray[indexPath.item].welcomeDescription
            let owner = Api.ownerArray[indexPath.item].avatarURL
            if let imageUrl = owner , let avatarImageUrl = URL(string: imageUrl){
                cell.avatarImage.kf.setImage(with: avatarImageUrl)
            }
            repoOwnerButtton.tag = indexPath.item
            repoButton.tag = indexPath.item
        }else{
            cell.repoName.text = filteredArray[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
}

extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell \(indexPath.item) selected")
        dialog.isHidden = false
        selectedIndex = indexPath.item
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let task = repoArray.count
        if indexPath.row == task - 1{
            print("func called")
            loadMore()
        }
    }
}



