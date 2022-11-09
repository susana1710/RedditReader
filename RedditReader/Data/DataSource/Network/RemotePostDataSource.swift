//
//  RemotePostDataSource.swift
//  RedditReader
//
//  Created by Susana Charara on 9/11/22.
//

import Foundation

class RemotePostDataSource: PostDataSourceProtocol {
  private var lastListingId: String = ""
  
  func getPosts() async -> Result<[Post], Error> {
    let fetchResult = await PostListService.shared.fetchPostList(afterListing: lastListingId)
    switch fetchResult {
    case .success((let posts, let lastListingId)):
      self.lastListingId = lastListingId
      return .success(posts)
    case .failure(let error):
      return .failure(error)
    }
//    PostListService.shared.fetchPostList(afterListing: lastListingId) { [weak self] (postData, error) in
//      guard let self = self else { return }
//      guard let posts = postData?.posts,
//            let lastListingId = postData?.lastListingId else {
//        return .failure(error)
//      }
//      self.lastListingId = lastListingId
//      return .success(posts)
//      
//    }
    //return fetchResult
  }
  
  
}
