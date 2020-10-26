//
//  ViewController.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/5.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chartKinds:[ChartKind] = ChartKind.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        // 复用
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView) // 添加到视图中
        self.title = "图库列表"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chartKinds.count
    }
    // 创建各单元显示内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify: String = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath) as UITableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.chartKinds[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.chartKind = self.chartKinds[indexPath.row] // 传递值
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

