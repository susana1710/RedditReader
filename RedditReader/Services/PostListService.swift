//
//  PostListService.swift
//  RedditReader
//
//  Created by Susana Charara on 8/11/22.
//

import Foundation
import Alamofire
import SwiftyJSON

enum JSONPostListParseError: Error {
  case invalidData
}

enum PostListFetchError: Error {
  case failedRequest
  case noData
  case invalidData(Error)
}

class PostListService {
  typealias PostListDataCompletion = (PostData?, PostListFetchError?) -> ()
  typealias PostListParseCompletion = (data: PostData, error: JSONPostListParseError?)
  typealias PostData = (posts: [Post]?, lastListingId: String?)
  
  
  static let shared = PostListService()
  
  private static let host = "https://www.reddit.com"
  private static let path = "/top.json"
  
  public func fetchPostList(afterListing: String, completion: @escaping PostListDataCompletion) {
    let parameters: Parameters = [
      "after": afterListing
    ]
    AF.request("\(PostListService.host)\(PostListService.path)", parameters: parameters)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseData { [weak self] response in
          
          guard let self = self else { return }
          
            switch response.result {
            case .success:
              guard let data = response.data else {
                print("Error fetching Post List: No Data")
                completion(nil, PostListFetchError.noData)
                return
              }
              do {
                let json = try JSON(data: data)
                let parsedJSON = self.getPostListFromJSON(json)
                var parseError: PostListFetchError?
                if let error = parsedJSON.error {
                  parseError = PostListFetchError.invalidData(error)
                }
                completion(parsedJSON.data, parseError)
              } catch let error {
                completion(nil, PostListFetchError.invalidData(error))
              }
            case let .failure(error):
              print("Error fetching Post List: \(error)")
              completion(nil, PostListFetchError.failedRequest)
            }
        }
  }
  
  //FIXME: Refactor
  
  private func getPostListFromJSON(_ json: JSON) -> PostListParseCompletion {
    guard let postListJSON = json["data"]["children"].array else {
      return ((nil,nil), JSONPostListParseError.invalidData)
    }
    var posts = [Post]()
    for (index,singlePostJSON) in postListJSON.enumerated() {
      let postData = singlePostJSON["data"]
      let post = Post()
      post.order = index
      post.id = postData["id"].stringValue
      post.title = postData["title"].stringValue
      post.author = postData["author"].stringValue
      if let createdMillliseconds = postData["created"].double {
        post.creationDate = NSDate.init(timeIntervalSince1970: createdMillliseconds)
      }
      post.thumbnailURL = postData["thumbnail"].stringValue
      post.mediaURL = postData["url"].stringValue
      post.commentCount = postData["num_comments"].intValue
      post.subreddit = postData["subreddit"].stringValue
      posts.append(post)
    }
    let lastListingId = getAfterListingIdFrom(json)
    let postsData = PostData(posts: posts, lastListingId: lastListingId)
    return (postsData,nil)
  }
  
  private func getAfterListingIdFrom(_ json: JSON) -> String {
    return json["data"]["after"].stringValue
  }
  
}
