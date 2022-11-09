//
//  PostListViewController.swift
//  RedditReader
//
//  Created by Susana Charara on 7/11/22.
//

import Foundation
import UIKit

class PostListViewController: UIViewController {
  
  @IBOutlet weak var postsTableView: UITableView!
  
  static let postDetailSegueIddntifier = "post_detail_segue"
  var postListTableViewModel: PostListViewModel!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    assert(postListTableViewModel != nil,  "PostListViewModel not set")
    postsTableView.dataSource = self
    postsTableView.delegate = self
    postsTableView.prefetchDataSource = self
    bindTableViewModel()
    postListTableViewModel.fetchPosts()
    //postsTableView.delegate = self
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case PostListViewController.postDetailSegueIddntifier:
      if let selectedIndex = sender as? NSNumber,
         let postDetailController = segue.destination as? PostDetailViewController {
        postDetailController.viewModel = postListTableViewModel.postListResult.value[selectedIndex.intValue]
      }
      
    default: break
    }
  }
  
  private func bindTableViewModel() {
    postListTableViewModel?.fetchInProgress.bind { [weak self] fetchInProgress in
      guard let self = self else { return }
      if !fetchInProgress {
        self.postListTableViewModel?.postListResult.bind { _ in
          self.postsTableView.reloadData()
        }
      }
    }
  }
  
  private func setUpView() {
    postsTableView.estimatedRowHeight = 100
    postsTableView.rowHeight = UITableView.automaticDimension
  }
  
  
}

extension PostListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return postListTableViewModel.postListResult.value.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let
            cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.id,
                                                 for: indexPath) as? PostTableViewCell else {
      return UITableViewCell()
    }
    let viewModel = postListTableViewModel.postListResult.value[indexPath.row]
    cell.setup(viewModel: viewModel)
    return cell
  }
}

extension PostListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: PostListViewController.postDetailSegueIddntifier, sender: indexPath.row)
  }
}


extension PostListViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    postListTableViewModel.fetchPosts()
  }
}
