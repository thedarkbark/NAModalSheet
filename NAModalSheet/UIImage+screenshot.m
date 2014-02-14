//
//  UIImage+screenshot.m
//  NAModalSheet
//
//  This code comes almost directly from public Apple sample code
//  https://developer.apple.com/library/ios/qa/qa1703/_index.html
//

#import "UIImage+screenshot.h"

@implementation UIImage (screenshot)

+ (UIImage*)screenshot
{
  return [self screenshotExcludingWindow:nil];
}

+ (UIImage*)screenshotExcludingWindow:(UIWindow*)excludeWindow
{
  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  
  // Create a graphics context with the target size
  // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
  // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
  CGSize imageSize = [[UIScreen mainScreen] bounds].size;
  
  // If the orientation is landscape, swap the height/width since the window
  // always has portrait dimensions.
  if (UIInterfaceOrientationIsLandscape(orientation))
  {
    CGFloat h = imageSize.height;
    imageSize.height = imageSize.width;
    imageSize.width = h;
  }

  if (NULL != UIGraphicsBeginImageContextWithOptions)
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
  else
    UIGraphicsBeginImageContext(imageSize);
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  // Iterate over every window from back to front
  for (UIWindow *window in [[UIApplication sharedApplication] windows])
  {
    if (window != excludeWindow && (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]))
    {
      // -renderInContext: renders in the coordinate space of the layer,
      // so we must first apply the layer's geometry to the graphics context
      CGContextSaveGState(context);
      // Center the context around the window's anchor point
      CGPoint windowCenter = CGPointMake(imageSize.width*0.5, imageSize.height*0.5);
      CGContextTranslateCTM(context, windowCenter.x, windowCenter.y);
      // Apply the window's transform about the anchor point
      CGContextConcatCTM(context, [window transform]);
      // If upside-down, apply an extra 180deg rotation
      if (UIInterfaceOrientationPortraitUpsideDown == orientation)
      {
        CGContextConcatCTM(context, CGAffineTransformMakeRotation(M_PI));
      }
      // Adjust for device orientation
      if (UIInterfaceOrientationIsLandscape(orientation))
      {
        CGContextConcatCTM(context, CGAffineTransformMakeRotation(M_PI_2 * (orientation == UIInterfaceOrientationLandscapeLeft ? 1.0 : -1.0)));
      }
      // Offset by the portion of the bounds left of and above the anchor point
      CGContextTranslateCTM(context,
                            -[window bounds].size.width * [[window layer] anchorPoint].x,
                            -[window bounds].size.height * [[window layer] anchorPoint].y);
      
      // Render the layer hierarchy to the current context
      [[window layer] renderInContext:context];
      
      // Restore the context
      CGContextRestoreGState(context);
    }
  }
  
  // Retrieve the screenshot image
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return image;
}

@end
