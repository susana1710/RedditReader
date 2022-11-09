//
//  PostListViewModel.swift
//  RedditReader
//
//  Created by Susana Charara on 7/11/22.
//

import Foundation

public class PostListViewModel {
  
  var fetchInProgress = Box(false)
  var postListResult = Box([PostViewModel]())
  private let fetchPostsListUseCase: FetchPostsListUseCase
  
  
  init(fetchPostsListUseCase: FetchPostsListUseCase) {
    self.fetchPostsListUseCase = fetchPostsListUseCase
  }
  
  func fetchPosts() {
    guard !fetchInProgress.value else { return }
    fetchInProgress.value = true
    
    fetchPostsListUseCase.execute { result in
      switch result {
      case .success(let posts):
        var postViewModels = [PostViewModel]()
        for post in posts {
          let postViewModel = self.createPostViewModel(post: post)
          postViewModels.append(postViewModel)
        }
        DispatchQueue.main.async {
          self.postListResult.value.append(contentsOf: postViewModels)
          self.fetchInProgress.value = false
        }
      case .failure(let error):
        print("Error fetching posts: \(error.localizedDescription)")
      }
      
    }
  }
  
  func createPostViewModel(post: Post) -> PostViewModel {
    return PostViewModel.init(from: post)
  }
  
}
