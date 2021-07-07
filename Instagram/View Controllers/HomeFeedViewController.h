//
//  HomeFeedViewController.h
//  Instagram
//
//  Created by samanthaburak on 7/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *feedTableView;


@end

NS_ASSUME_NONNULL_END
