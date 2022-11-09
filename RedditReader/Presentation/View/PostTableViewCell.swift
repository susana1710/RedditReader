//
//  PostTableViewCell.swift
//  RedditReader
//
//  Created by Susana Charara on 8/11/22.
//

import Foundation
import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {
  static let id = "post_table_view_cell"
  
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var subreddit: UILabel!
  @IBOutlet weak var author: UILabel!
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var commentCount: UILabel!
  @IBOutlet weak var thumbnail: UIImageView!
  private var viewModel: PostViewModel!
  
  func setup(viewModel: PostViewModel) {
    self.viewModel = viewModel
    self.viewModel.title.bind { [weak self] title in
      self?.title.text = title
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
    self.viewModel.thumbnailURL.bind { [weak self] thumbnailURL in
      
      self?.thumbnail.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "placeholder.png"))
    }
  }
  
  
  override func prepareForReuse() {
    super.prepareForReuse()
    thumbnail.sd_cancelCurrentImageLoad()
    thumbnail.image = nil
    viewModel?.title.bind(listener: nil)
    viewModel?.subreddit.bind(listener: nil)
    viewModel?.author.bind(listener: nil)
    viewModel?.creationDate.bind(listener: nil)
    viewModel?.commentCount.bind(listener: nil)
    viewModel?.thumbnailURL.bind(listener: nil)
  }
}
