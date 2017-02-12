//
//  FriendListViewController.swift
//  iOS-CleanArchitecture-Example
//
//  Created by Kohei Abe on 2016/12/13.
//  Copyright © 2016年 Kohei Abe. All rights reserved.
//

import UIKit

class FriendListViewController: UITableViewController, FriendListUseCaseDelegate {

    private let tableCellId = "friend cell id"
    
    private var useCase: FriendListUseCaseInput?
    
    private var friendList: [UserViewData] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        constructDependency()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        constructDependency()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellId)
        
        // データをロード
        useCase?.load()
    }
    
    /// 依存性の構築。DIコンテナを使うと外に出せる。
    private func constructDependency() {
        let repository = FriendListRepository()
        let useCase = FriendListUseCase(input: repository)
        useCase.delegate = self
        
        self.useCase = useCase
    }
    
    // MARK: - FriendListUseCaseDelegate
    
    func useCase(_ useCase: FriendListUseCase, didLoadFriendList friendList: [UserEntity]) {
        // ロードしたデータを受け取って表示
        self.friendList = friendList.map { UserViewData(entity: $0) }
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath)
        cell.textLabel?.text = friendList[indexPath.row].name
        return cell
    }
}
