//
//  PostsRepository.swift
//  RedditReader
//
//  Created by Susana Charara on 9/11/22.
//

import Foundation

class PostsRepository: PostsRepositoryProtocol {
  
  private var lastListingId = ""
  
  func fetchPostsList(completion: @escaping (Result<[Post], Error>) -> Void) {
    PostListService.shared.fetchPostList(afterListing: lastListingId) { [weak self] (postData, error) in
      guard let self = self else { return }
      guard let posts = postData?.posts,
            let lastListingId = postData?.lastListingId else {
        completion(.failure(error!))
        return
      }
      self.lastListingId = lastListingId
      completion(.success(posts))
      
    }
  }
}
