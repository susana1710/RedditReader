//
//  FetchPostsListUseCase.swift
//  RedditReader
//
//  Created by Susana Charara on 8/11/22.
//

import Foundation

class FetchPostsListUseCase {
  private let postsRepository: PostsRepository
  
  init(postsRepository: PostsRepository) {
    self.postsRepository = postsRepository
  }
  
  func execute(completion: @escaping (Result<[Post], Error>) -> Void) {
    return postsRepository.fetchPostsList(completion: completion)
  }
}
