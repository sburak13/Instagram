//
//  ProfileViewController.m
//  Instagram
//
//  Created by samanthaburak on 7/8/21.
//

#import "UserProfileViewController.h"
#import <Parse/Parse.h>
#import "ProfilePostCell.h"
#import "Post.h"

@interface UserProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *numPostsLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *profileScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *postsCollectionView;

@property (nonatomic) NSMutableArray *postsArray;



@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat contentWidth = self.profileScrollView.bounds.size.width;
        CGFloat contentHeight = self.profileScrollView.bounds.size.height * 3;
        self.profileScrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
    
    PFUser *currentUser = [PFUser currentUser];
    self.usernameLabel.text = currentUser.username;
    self.nameLabel.text = [currentUser objectForKey:@"name"];
    self.bioLabel.text = [currentUser objectForKey:@"bio"];
    
    self.postsCollectionView.dataSource = self;
    self.postsCollectionView.delegate = self;
    
    [self getUserPosts];
    
    self.profileImageView.layer.cornerRadius = 25;
    self.profileImageView.layer.masksToBounds = YES;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.postsCollectionView.collectionViewLayout;
            
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.postsCollectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1))/ postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.postsCollectionView.collectionViewLayout = layout;
        
    
    self.numPostsLabel = @(self.postsArray.count).stringValue;

    
}

- (void) getUserPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postsArray = posts;
            [self.postsCollectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)tapChangProfilePic:(id)sender {
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfilePostCell *cell = [self.postsCollectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePostCell" forIndexPath:indexPath];
    Post *post = self.postsArray[indexPath.item];
//    PFFileObject *img = post[@"image"];
//    NSURL *urlString = [NSURL URLWithString:img.url];
//    [cell.postImageView setImageWithURL:urlString];
    // cell.postImageView = img get;
    // [cell.postImageView setImageW];
    
    
//    PFFileObject * profileImage = user[@"profile_image"]; // set your column name from Parse here
//    NSURL * imageURL = [NSURL URLWithString:profileImage.url];
//    [self.profileImageView setImageWithURL:imageURL];
    
    cell.postImageView.file = post.image;
    [cell.postImageView loadInBackground];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postsArray.count;
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
