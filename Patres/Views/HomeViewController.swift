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
    private(set) var posts: [Post] = []
    var isPaginating: Bool = false
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellView.self, forCellReuseIdentifier: CellView.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        configureNavigationBar()
        setupUI()
        
    }
    
    // MARK: - Navigation Bar Configuration
    private func configureNavigationBar() {
        navigationItem.title = "Home"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(didTapUpdateButton))
    }
    
    // MARK: - UI Setup
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
    
    // MARK: - API Requests
    private func bindData() {
        Task {
            do {
                let newPosts = try await viewModel.fetchPosts(pagination: true)
                self.posts.append(contentsOf: newPosts)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.isPaginating = false
                    self.tableView.tableFooterView = nil
                    self.tableView.isUserInteractionEnabled = true
                }
            } catch {
                print("Pagination fetch error: \(error)")
                self.isPaginating = false
            }
        }
    }
    
    
    //MARK: - Selectors
    @objc private func didTapUpdateButton() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

// MARK: - UITableView Delegate & DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: CellView.identifier, for: indexPath) as? CellView  else { fatalError("Couldn't dequeue cell") }
        
        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        400
    }
}
 // MARK: - UITableView Pagination
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            guard !isPaginating else { return }
            isPaginating = true
            tableView.isUserInteractionEnabled = false
            self.tableView.tableFooterView = createSpinnerFooter()
            self.bindData()
        }
    }
}

// MARK: - Spinner Footer
extension HomeViewController {
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        
        spinner.startAnimating()
        return footerView
    }

}
