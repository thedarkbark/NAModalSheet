//
//  UIImage+BoxBlur.m
//
//  Created by Ken Worley on 11/22/13.
//
//  Most of this image blur code came from a public post on the IndieAmbitions blog: http://indieambitions.com/idevblogaday/perform-blur-vimage-accelerate-framework-tutorial/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+IndieAmbitions+%28Indie+Ambitions%29
//  The triple-processing of the blur is inspired by code in ios-realtimeblur available on github.
//


#import "UIImage+BoxBlur.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (BoxBlur)

// Return a blurred copy of this image
// blurAmount - 0.0 min to 1.0 max
- (UIImage*)blurredImage:(CGFloat)blurAmount
{
  //If blurAmount is outside the bounds we expect, use an average value
  if (blurAmount < 0.0 || blurAmount > 1.0)
  {
    blurAmount = 0.5;
  }
  int boxSize = (int)(blurAmount * 40);
  boxSize = boxSize - (boxSize % 2) + 1;

  //Get CGImage from UIImage
  CGImageRef img = self.CGImage;
  
  //setup variables
  vImage_Buffer inBuffer, outBuffer;
  
  vImage_Error error;
  
  void *pixelBuffer;
  
  //create vImage_Buffer with data from CGImageRef
  
  //These two lines get get the data from the CGImage
  CGDataProviderRef inProvider = CGImageGetDataProvider(img);
  CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
  
  //The next three lines set up the inBuffer object based on the attributes of the CGImage
  inBuffer.width = CGImageGetWidth(img);
  inBuffer.height = CGImageGetHeight(img);
  inBuffer.rowBytes = CGImageGetBytesPerRow(img);
  
  //This sets the pointer to the data for the inBuffer object
  inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
  
  //create vImage_Buffer for output
  
  //allocate a buffer for the output image and check if it exists in the next three lines
  pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
  
  if(pixelBuffer == NULL)
    NSLog(@"No pixelbuffer");
  
  //set up the output buffer object based on the same dimensions as the input image
  outBuffer.data = pixelBuffer;
  outBuffer.width = CGImageGetWidth(img);
  outBuffer.height = CGImageGetHeight(img);
  outBuffer.rowBytes = CGImageGetBytesPerRow(img);
  
  //perform convolution - this is the call for our type of data
  error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
  if (!error)
  {
    //reprocess for a smoother blur
    error = vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (!error)
    {
      //and one more time
      error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    }
  }
  
  //check for an error in the call to perform the convolution
  if (error) {
    NSLog(@"error from convolution %ld", error);
    }
  
  //create CGImageRef from vImage_Buffer output
  //1 - CGBitmapContextCreateImage -
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                               outBuffer.width,
                                               outBuffer.height,
                                               8,
                                               outBuffer.rowBytes,
                                               colorSpace,
                                               (CGBitmapInfo)kCGImageAlphaNoneSkipLast);

  CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
  
  UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
  
  //clean up
  CGContextRelease(ctx);
  CGColorSpaceRelease(colorSpace);
  
  free(pixelBuffer);
  CFRelease(inBitmapData);
  
  CGColorSpaceRelease(colorSpace);
  CGImageRelease(imageRef);
  
  return returnImage;
}

@end
