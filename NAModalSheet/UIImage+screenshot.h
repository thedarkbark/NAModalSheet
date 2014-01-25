//
//  UIImage+screenshot.h
//  NAModalSheet
//

#import <UIKit/UIKit.h>

@interface UIImage (screenshot)

/* grab a screenshot */
+ (UIImage*)screenshot;
+ (UIImage*)screenshotExcludingWindow:(UIWindow*)excludeWindow;

@end
