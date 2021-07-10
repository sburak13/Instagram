//
//  DetailsViewController.m
//  Instagram
//
//  Created by samanthaburak on 7/7/21.
//

#import "DetailsViewController.h"
#import "PostCell.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "DateTools/DateTools.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.postImageView.file = self.post.image;
    [self.postImageView loadInBackground];
    
    NSLog(@"%@", self.post.author.username);
    self.usernameLabel.text = self.post.author.username;
    self.captionLabel.text = self.post.caption;
    
    NSDate *createdAt = self.post.createdAt;
    self.timeLabel.text = createdAt.timeAgoSinceNow;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
