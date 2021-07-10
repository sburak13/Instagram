//
//  PostCell.m
//  Instagram
//
//  Created by samanthaburak on 7/7/21.
//

#import "PostCell.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "DateTools/DateTools.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    
    self.postImageView.file = post.image;
    [self.postImageView loadInBackground];
    
    self.usernameLabel.text = post.author.username;
    self.captionLabel.text = post.caption;
    
    NSDate *createdAt = post.createdAt;
    self.timeLabel.text = createdAt.timeAgoSinceNow;
}



@end
