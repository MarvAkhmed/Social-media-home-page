//
//  HomeViewController.swift
//  Patres
//
//  Created by Marwa Awad on 17.03.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    private let viewModel = HomeViewModel.shared
    
    //MARK: - UI Compontns
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellView.self, forCellReuseIdentifier: CellView.identifier)
        return tableView
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigaionBarConfigs()
        self.setupUI()
    }

    //MARK: - Config the navigaionBar
    private func navigaionBarConfigs() {
        navigationItem.title = "Home"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(didTapUpdateButton))
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
        self.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        self.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        self.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

    }
    
    //MARK: - Selectors
    @objc private func didTapUpdateButton () {
        print("update button tapped")
    }
}

//MARK: - Table Delegate and DataSource extention
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard  let cell = tableView.dequeueReusableCell(withIdentifier: CellView.identifier, for: indexPath) as? CellView  else { fatalError("coudn't dequeue cell") }
        let post = self.viewModel.post
        cell.configureCell(with: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
