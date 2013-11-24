//
//  UIImage+BoxBlur.h
//
//  Created by Ken Worley on 11/22/13.
//


#import <UIKit/UIKit.h>

@interface UIImage (BoxBlur)

// Return a blurred copy of this image
// blurAmount - 0.0 min to 1.0 max
- (UIImage*)blurredImage:(CGFloat)blurAmount;

@end
