//
//  ImgUtils.h
//  Instagram
//
//  Created by samanthaburak on 7/9/21.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImgUtils : NSObject

+ (UIImagePickerController *)getImagePickerVC;

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
