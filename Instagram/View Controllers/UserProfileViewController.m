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
#import "ImgUtils.h"

@interface UserProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
    
    self.numPostsLabel.text = [@(self.postsArray.count) stringValue];
    
    self.profileImageView.layer.cornerRadius = 60;
    self.profileImageView.layer.masksToBounds = YES;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.postsCollectionView.collectionViewLayout;
            
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.postsCollectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1))/ postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.postsCollectionView.collectionViewLayout = layout;
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
            self.numPostsLabel.text = [@(self.postsArray.count) stringValue];
            [self.postsCollectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)tapChangeProfilePic:(id)sender {
    UIImagePickerController *imagePickerVC = [ImgUtils getImagePickerVC];
    imagePickerVC.delegate = self;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    UIImage *resizedImg = [ImgUtils resizeImage:editedImage withSize:CGSizeMake(300, 300)];
    self.profileImageView.image = resizedImg;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfilePostCell *cell = [self.postsCollectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePostCell" forIndexPath:indexPath];
    Post *post = self.postsArray[indexPath.item];

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
