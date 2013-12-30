//
//  NAModalSheet.m
//  Note All
//
//  Created by Ken Worley on 11/17/13.
//
//

#import "NAModalSheet.h"
#import "UIImage+BoxBlur.h"
#import "UIImage+screenshot.h"

#define kBlurParameter 0.6
#define kViewAnimationDuration 0.4

static NSMutableArray *modalSheets = nil;

@interface NAModalSheet () <UIGestureRecognizerDelegate>
{
  UIViewController *childContentVC;

  UIWindow* prevWindow;
  UIWindow* myWindow;
  
  UIView *backgroundTint;
  UIView *childContainer;
  UIView *blurredBackground;
  UIImageView *blurredImageView;
  
  CGRect childHiddenFrame;
  CGRect blurHiddenFrame;
}

@property (nonatomic, assign) NAModalSheetPresentationStyle presentationStyle;

@end

@implementation NAModalSheet

- (instancetype)initWithViewController:(UIViewController *)vc
                     presentationStyle:(NAModalSheetPresentationStyle)style
{
  self = [super initWithNibName:nil bundle:nil];
  if (self)
  {
    _presentationStyle = style;
    childContentVC = vc;
    prevWindow = [[UIApplication sharedApplication] keyWindow];
    
    // Make sure the view gets laid out fullscreen prior to iOS 7
    self.wantsFullScreenLayout = YES;

    if (modalSheets == nil)
    {
      modalSheets = [NSMutableArray array];
    }
  }
  return self;
}

- (void)loadView
{
  CGFloat cornerRadius = self.presentationStyle == NAModalSheetPresentationStyleFadeInCentered ? self.cornerRadiusWhenCentered : 0.0;
  
  myWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  myWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  myWindow.opaque = NO;

  UIView *mainView = [[UIView alloc] initWithFrame:myWindow.bounds];
  mainView.backgroundColor = [UIColor clearColor];

  UITapGestureRecognizer *mainViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTouched:)];
  [mainView addGestureRecognizer:mainViewTap];
  mainViewTap.delegate = self;

  // If the view is sliding on from somewhere other than the edge of the screen, then the darkening tint should exclude
  // that portion.
  CGRect tintRect = mainView.bounds;
  if (self.slideInset > 0.0)
  {
    if (self.presentationStyle == NAModalSheetPresentationStyleSlideInFromBottom)
    {
      tintRect.size.height -= self.slideInset;
    }
    else if (self.presentationStyle == NAModalSheetPresentationStyleSlideInFromTop)
    {
      tintRect.size.height -= self.slideInset;
      tintRect.origin.y += self.slideInset;
    }
  }
  backgroundTint = [[UIView alloc] initWithFrame:tintRect];
  backgroundTint.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  backgroundTint.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
  backgroundTint.alpha = 0.0;
  [mainView addSubview:backgroundTint];
  
  // This view contains the child view container. Any animated motion of the child container is clipped
  // to these bounds.
  UIView *childContainerContainer = [[UIView alloc] initWithFrame:tintRect];
  childContainerContainer.backgroundColor = [UIColor clearColor];
  childContainerContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  childContainerContainer.clipsToBounds = YES;
  childContainerContainer.layer.cornerRadius = cornerRadius;
  [mainView addSubview:childContainerContainer];
  
  // Add the child controller as a sub view controller of this one
  [self addChildViewController:childContentVC];
  UIView *childView =childContentVC.view;
  
  // The child container view animates in/out when using a sliding presentation while a blurred version
  // of the screen snapshot animates within it to appear motionless in relation to the screen.
  CGRect childContainerRect = childContainerContainer.bounds;
  childContainerRect.size = childView.frame.size;
  childContainerRect.origin.x = CGRectGetMidX(childContainerContainer.bounds) - roundf(0.5 * CGRectGetWidth(childView.frame));
  if (self.presentationStyle == NAModalSheetPresentationStyleFadeInCentered)
  {
    childContainerRect.origin.y = CGRectGetMidY(childContainerContainer.bounds) - roundf(0.5 * CGRectGetHeight(childView.frame));
  }
  else if (self.presentationStyle == NAModalSheetPresentationStyleSlideInFromBottom)
  {
    childContainerRect.origin.y = CGRectGetMaxY(childContainerContainer.bounds) - CGRectGetHeight(childView.frame);
  }
  else if (self.presentationStyle == NAModalSheetPresentationStyleSlideInFromTop)
  {
    childContainerRect.origin.y = 0.0;
  }
  else
  {
    NSAssert(0, @"Unknown presentation style");
  }
  
  childContainer = [[UIView alloc] initWithFrame:childContainerRect];
  childContainer.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
  childContainer.clipsToBounds = YES;
  childContainer.layer.cornerRadius = cornerRadius;
  childContainer.backgroundColor = [UIColor clearColor];
  [childContainerContainer addSubview:childContainer];
  
  // The blurred background container holds the blurred image of the screen snapshot. It's sized to fit the child view
  // and also sized to clip out a portion of the snapshot if the child view is sliding in from somewhere other than
  // the edge of the screen.
  CGRect blurredBackgroundRect = [childContainer convertRect:mainView.bounds fromView:mainView];
  blurredBackground = [[UIView alloc] initWithFrame:blurredBackgroundRect];
  blurredBackground.clipsToBounds = YES;
  blurredBackground.layer.cornerRadius = cornerRadius;
  UIViewAutoresizing blurredBackgroundAutoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
  if (self.presentationStyle == NAModalSheetPresentationStyleSlideInFromBottom)
  {
    blurredBackgroundAutoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    blurredBackgroundRect.size.height -= self.slideInset;
  }
  else if (self.presentationStyle == NAModalSheetPresentationStyleSlideInFromTop)
  {
    blurredBackgroundAutoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    blurredBackgroundRect.origin.y += self.slideInset;
    blurredBackgroundRect.size.height -= self.slideInset;
  }
  [childContainer addSubview:blurredBackground];
  
  blurredImageView = [[UIImageView alloc] initWithFrame:blurredBackground.bounds];
  blurredImageView.autoresizingMask = blurredBackgroundAutoresizingMask;
  blurredImageView.layer.cornerRadius = cornerRadius;
  [blurredBackground addSubview:blurredImageView];
  
  blurredBackground.frame = blurredBackgroundRect;
  
  // The child view itself gets added last so it sits on top.
  CGRect childViewRect = childView.frame;
  childViewRect.origin.x = childViewRect.origin.y = 0.0;
  childView.frame = childViewRect;
  childView.layer.cornerRadius = cornerRadius;
  [childContainer addSubview:childView]; // should already be sized to fit
  childView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  self.view = mainView;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  return !(CGRectContainsPoint(childContentVC.view.bounds, [touch locationInView:childContentVC.view]));
}

-(IBAction)backgroundTouched:(id)sender
{
  // Let the delegate know the user touched outside the child content area.
  if ([self.delegate respondsToSelector:@selector(modalSheetTouchedOutsideContent:)])
  {
    [self.delegate modalSheetTouchedOutsideContent:self];
  }
}

-(void)adjustContentSize:(CGSize)newSize animated:(BOOL)animated
{
  CGRect containerFrame = childContainer.frame;
  CGRect blurredBackgroundFrame = blurredBackground.frame;
  
  CGFloat vDelta = newSize.height - containerFrame.size.height;
  CGFloat hDelta = newSize.width - containerFrame.size.width;
  CGFloat vHalfDelta = roundf(vDelta * 0.5);
  CGFloat hHalfDelta = roundf(hDelta * 0.5);
  
  if (self.presentationStyle == NAModalSheetPresentationStyleFadeInCentered)
  {
    containerFrame.origin.y -= vHalfDelta;
    blurredBackgroundFrame.origin.y += vHalfDelta;
    childHiddenFrame.origin.y -= vHalfDelta;
    blurHiddenFrame.origin.y += vHalfDelta;
  }
  else if (self.presentationStyle == NAModalSheetPresentationStyleSlideInFromBottom)
  {
    containerFrame.origin.y -= vDelta;
    blurredBackgroundFrame.origin.y += vDelta;
  }
  else if (self.presentationStyle == NAModalSheetPresentationStyleSlideInFromTop)
  {
    childHiddenFrame.origin.y -= vDelta;
    blurHiddenFrame.origin.y += vDelta;
  }

  childHiddenFrame.origin.x -= hHalfDelta;
  blurHiddenFrame.origin.x += hHalfDelta;
  containerFrame.origin.x -= hHalfDelta;
  blurredBackgroundFrame.origin.x += hHalfDelta;
  
  containerFrame.size = newSize;
  childHiddenFrame.size = newSize;
  if (animated)
  {
    [UIView animateWithDuration:0.5 animations:^{
      childContainer.frame = containerFrame;
      blurredBackground.frame = blurredBackgroundFrame;
    }];
  }
  else
  {
    childContainer.frame = containerFrame;
    childContentVC.view.frame = childContainer.bounds;
    blurredBackground.frame = blurredBackgroundFrame;
  }
}

-(void)presentWithCompletion:(void (^)(void))completion
{
  // Force my view to load now.
  if (self.view == nil)
    return;
  
  [modalSheets addObject:self];
  
  [myWindow setRootViewController:self];
  
  // Take an immediate snapshot of the existing screen
  UIImage *snapshot = [UIImage screenshot];
  NSData *imageData = UIImageJPEGRepresentation(snapshot, 0.01);
  UIImage *blurredSnapshot = [[UIImage imageWithData:imageData] blurredImage:kBlurParameter];
  
  blurredImageView.image = blurredSnapshot;
  
  CGRect mainBounds = self.view.bounds;
  
  // Position the child controller's view below the screen bottom (or above the top) if it's going to slide in.
  // This is its before-animation state.
  CGRect childContainerOrig = childContainer.frame;
  childHiddenFrame = childContainerOrig;
  if (self.presentationStyle == NAModalSheetPresentationStyleSlideInFromBottom)
  {
    childHiddenFrame.origin.y = CGRectGetMaxY(mainBounds);
  }
  else if (self.presentationStyle == NAModalSheetPresentationStyleSlideInFromTop)
  {
    childHiddenFrame.origin.y = CGRectGetMinY(mainBounds) - CGRectGetHeight(childContainer.frame);
  }
  childContainer.frame = childHiddenFrame;
  
  // Position the blurred background view above the top or below the bottom edge of the
  // child container. At the same time the child view animates upward/downward, the blurred
  // background will animate downward/upward so the child view will appear to blur
  // the view behind it (for sliding presentations).
  CGRect blurredBackgroundOrig = blurredBackground.frame;
  blurHiddenFrame = blurredBackgroundOrig;
  if (self.presentationStyle == NAModalSheetPresentationStyleSlideInFromBottom)
  {
    blurHiddenFrame.origin.y = CGRectGetMinY(childContainer.bounds) - CGRectGetHeight(blurredBackground.frame);
  }
  else if (self.presentationStyle == NAModalSheetPresentationStyleSlideInFromTop)
  {
    blurHiddenFrame.origin.y = CGRectGetMaxY(childContainer.bounds);
  }
  blurredBackground.frame = blurHiddenFrame;
  
  if (self.presentationStyle == NAModalSheetPresentationStyleFadeInCentered)
  {
    self.view.alpha = 0.0;
    backgroundTint.alpha = 1.0;
  }
  else
  {
    self.view.alpha = 1.0;
    backgroundTint.alpha = 0.0;
  }
  
  // Make my window visible. Everything on it should be either clear or clipped out at this point.
  [myWindow makeKeyAndVisible];
  
  // Present.
  [UIView animateWithDuration:kViewAnimationDuration
                   animations:^{
                     childContainer.frame = childContainerOrig;
                     blurredBackground.frame = blurredBackgroundOrig;
                     backgroundTint.alpha = 1.0;
                     self.view.alpha = 1.0;
                   }
                   completion:^(BOOL finished) {
                     if (completion)
                     {
                       completion();
                     }
                   }];
}

- (void)dismissWithCompletion:(void (^)(void))completion
{
  NSUInteger sheetIndex = [modalSheets indexOfObject:self];
  NSAssert(sheetIndex != NSNotFound, @"Dismissing sheet not found in modalSheets");
  NSAssert(self == [modalSheets lastObject], @"Dismissing sheet not presented last");
  
  [modalSheets removeObject:self];
  
  // Animate the view away
  [UIView animateWithDuration:kViewAnimationDuration
                   animations:^{
                     childContainer.frame = childHiddenFrame;
                     blurredBackground.frame = blurHiddenFrame;
                     backgroundTint.alpha = 0.0;
                     if (self.presentationStyle == NAModalSheetPresentationStyleFadeInCentered)
                     {
                       self.view.alpha = 0.0;
                     }
                   }
                   completion:^(BOOL finished) {
                     myWindow.hidden = YES;
                     
                     // remove child view controller
                     [childContentVC.view removeFromSuperview];
                     [childContentVC removeFromParentViewController];
                     
                     // restore prev window key status
                     [prevWindow makeKeyAndVisible];
                     
                     if (completion)
                     {
                       completion();
                     }
                   }];
}

@end
