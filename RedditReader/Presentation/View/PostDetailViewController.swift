//
//  PostViewController.swift
//  RedditReader
//
//  Created by Susana Charara on 7/11/22.
//

import Foundation
import UIKit

class PostDetailViewController: UIViewController {
  
  @IBOutlet weak var subreddit: UILabel!
  @IBOutlet weak var author: UILabel!
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var postTitle: UILabel!
  @IBOutlet weak var commentCount: UILabel!
  @IBOutlet weak var image: UIImageView!
  
  static let identifier = "post_detail_view_controller"
  var viewModel: PostViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    assert(viewModel != nil, "ViewModel not set for Post Detail")
    setUpView()
  }
  
  private func setUpView() {
    self.viewModel.title.bind { [weak self] title in
      self?.postTitle.text = title
    }
    self.viewModel.subreddit.bind { [weak self] subreddit in
      self?.subreddit.text = subreddit
    }
    self.viewModel.author.bind { [weak self] author in
      self?.author.text = author
    }
    //FIXME
    self.viewModel.creationDate.bind { [weak self] date in
      self?.date.text = date
    }
    self.viewModel.commentCount.bind { [weak self] commentCount in
      if commentCount != nil {
        self?.commentCount.text = "\(commentCount!) comments"
      }
    }
    // FIXME: Load image
    self.viewModel.mediaURL.bind { [weak self] mediaURL in
      self?.image.sd_setImage(with: mediaURL,
                              placeholderImage: UIImage(named: "placeholder.png"))
    }
  }
}
