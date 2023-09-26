//
//  TableViewController.swift
//  SwiftPullToRefreshDemo
//
//  Created by ys zhou on 2023/9/26.
//  Copyright © 2023 Wiredcraft. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    private var tableView: UITableView!
    private lazy var dataList: [String] = {
        (1...15).map { String($0) }
    }()

    var refresh: Refresh = .indicatorHeader

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = refresh.rawValue

        tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        switch refresh {
        case .indicatorHeader:
            tableView.spr_setIndicatorHeader { [weak self] in
                self?.action(insertFromTop: true)
            }
        case .textHeader:
            tableView.spr_setTextHeader { [weak self] in
                self?.action(insertFromTop: true)
            }
        case .smallGIFHeader:
            guard
                let url = Bundle.main.url(forResource: "demo-small", withExtension: "gif"),
                let data = try? Data(contentsOf: url) else { return }
            tableView.spr_setGIFHeader(data: data) { [weak self] in
                self?.action(insertFromTop: true)
            }
        case .bigGIFHeader:
            guard
                let url = Bundle.main.url(forResource: "demo-big", withExtension: "gif"),
                let data = try? Data(contentsOf: url) else { return }
            tableView.spr_setGIFHeader(data: data, isBig: true, height: 120) { [weak self] in
                self?.action(insertFromTop: true)
            }
        case .gifTextHeader:
            guard
                let url = Bundle.main.url(forResource: "demo-small", withExtension: "gif"),
                let data = try? Data(contentsOf: url) else { return }
            tableView.spr_setGIFTextHeader(data: data) { [weak self] in
                self?.action(insertFromTop: true)
            }
        case .superCatHeader:
            let header = SuperCatHeader(style: .header, height: 120) { [weak self] in
                self?.action()
            }
            tableView.spr_setCustomHeader(header)
        case .indicatorAutoHeader:
            tableView.spr_setIndicatorAutoHeader { [weak self] in
                self?.action(insertFromTop: true)
            }
        case .textAutoHeader:
            tableView.spr_setTextAutoHeader { [weak self] in
                self?.action(insertFromTop: true)
            }
        case .indicatorFooter:
            tableView.spr_setIndicatorFooter { [weak self] in
                self?.action()
            }
        case .textFooter:
            tableView.spr_setTextFooter { [weak self] in
                self?.action()
            }
        case .indicatorAutoFooter:
            tableView.spr_setIndicatorAutoFooter { [weak self] in
                self?.action()
            }
        case .textAutoFooter:
            tableView.spr_setTextAutoFooter { [weak self] in
                self?.action()
            }
        }
    }

    private func action(insertFromTop: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if insertFromTop {
                self.dataList.insert(String(self.dataList.count + 1), at: 0)
            } else {
                self.dataList.append(String(self.dataList.count + 1))
            }
            self.tableView.reloadData()
            self.tableView.spr_endRefreshing()
        }
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableReuseId = "identifier"
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: tableReuseId) else {
                return UITableViewCell(style: .default, reuseIdentifier: tableReuseId)
            }
            return cell
        }()
        cell.textLabel?.text = dataList[indexPath.row]
        return cell
    }
}

