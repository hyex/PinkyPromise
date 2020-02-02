//
//  AddFriendsVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/29.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol SendSelectedFriendsDelegate {
    func sendSelectedFriends(data: [FriendData])
}

struct FriendData {
    var tag: Int!
    var id: String!
    var name: String!
    var image: String!
    var isChecked: Bool!
}

class AddFriendsVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    fileprivate var searchController = UISearchController(searchResultsController: nil)
    
    //    var checkBoxesState: [Int : Bool] = [:]
    //
    var delegate: SendSelectedFriendsDelegate!
    
    //    var myFriends: [Int : [String]]!
    //    var myFriendsImg: [UIImage]!
    
    var withFriendsList: [FriendData]!
    var filteredData = [FriendData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "이름 검색"
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        //        tableView.tableHeaderView?.frame.size.height = 80
        searchController.searchBar.tintColor = .appColor
        
        //        searchController.searchBar.setImage(UIImage(systemName: "multiple.circle.fill"), for: UISearchBar.Icon.clear, state: .normal)
        
        backBtn.tintColor = UIColor.appColor
        saveBtn.tintColor = UIColor.appColor
    }
    
    // MARK: - Navigation
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        let arr = withFriendsList.filter({ (friend) -> Bool in
            return friend.isChecked ? true : false
        })
        
        self.delegate.sendSelectedFriends(data: Array(arr))
        self.navigationController?.popViewController(animated: false)
    }
}


extension AddFriendsVC: UITableViewDelegate {}

extension AddFriendsVC: UITableViewDataSource {
    
    // MARK: - View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredData.count
        }
        return withFriendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCheckCell") as! CheckFriendsTVC
        
        let friend: FriendData
        let isSearched: Bool
        
        if searchController.isActive && searchController.searchBar.text != "" {
            friend = filteredData[indexPath.row]
            isSearched = true
        } else {
            friend = withFriendsList[indexPath.row]
            isSearched = false
        }
        
        cell.friendProfileImg.layer.cornerRadius = cell.friendProfileImg.frame.width/2
        cell.friendProfileImg.clipsToBounds = true
        
        FirebaseStorageService.shared.getPromiseImageWithName(name: (friend.image)!) { (result) in
            switch result {
            case .failure(let err):
                print(err)
                break
            case .success(let userImage):
                cell.friendProfileImg.image = userImage
                break
            }
        }
        
        
        cell.friendNameLabel.text = friend.name
        //        cell.promiseNameLabel.text = rowData.promisename
        cell.checkBox.delegate = self
        cell.checkBox.tag = indexPath.row
        
        if let isOn = friend.isChecked {
            cell.checkBox.on = isOn ? true: false
        } else {
            cell.checkBox.on = false
        }
        
        if isSearched {
            withFriendsList[filteredData[indexPath.row].tag].isChecked = cell.checkBox.on
        } else {
            withFriendsList[indexPath.row].isChecked = cell.checkBox.on
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    // MARK: - Logic
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CheckFriendsTVC
        let isSearched: Bool
        
        cell.switchCheckBox()
        
        if searchController.isActive && searchController.searchBar.text != "" {
            isSearched = true
        } else {
            isSearched = false
        }
        
        if isSearched {
            withFriendsList[filteredData[indexPath.row].tag].isChecked = cell.checkBox.on
        } else {
            withFriendsList[indexPath.row].isChecked = cell.checkBox.on
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension AddFriendsVC: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        withFriendsList[checkBox.tag].isChecked = checkBox.on
    }
}

extension AddFriendsVC: UISearchResultsUpdating {
    private func filterFriendsData(for searchText: String) {
        filteredData = withFriendsList.filter({ friend in
            return friend.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterFriendsData(for: searchController.searchBar.text ?? "")
    }
}
