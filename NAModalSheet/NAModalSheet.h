//
//  NAModalSheet.h
//  Note All
//
//  Created by Ken Worley on 11/17/13.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NAModalSheetPresentationStyle) {
  NAModalSheetPresentationStyleSlideInFromBottom,
  NAModalSheetPresentationStyleSlideInFromTop,
  NAModalSheetPresentationStyleFadeInCentered
};

@class NAModalSheet;

@protocol NAModalSheetDelegate <NSObject>
@optional

// This delegate method will be called if the user touches outside the content view provided. You may want to use this
// to dismiss the sheet.
-(void)modalSheetTouchedOutsideContent:(NAModalSheet*)sheet;

// These two delegate methods are analogous to the UIViewController shouldAutorotate and supportedInterfaceOrientations
// methods. If the presenting view controller is overriding those methods, it should also implement these two methods
// and return the same values.
-(BOOL)modalSheetShouldAutorotate:(NAModalSheet*)sheet;
-(NSUInteger)modalSheetSupportedInterfaceOrientations:(NAModalSheet*)sheet;

@end

@interface NAModalSheet : UIViewController

@property (nonatomic, weak) id<NAModalSheetDelegate> delegate;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat slideInset;
@property (nonatomic, assign) CGFloat cornerRadiusWhenCentered;
@property (nonatomic, assign) BOOL disableBlurredBackground;

- (instancetype)initWithViewController:(UIViewController *)vc
                     presentationStyle:(NAModalSheetPresentationStyle)style;

-(void)presentWithCompletion:(void (^)(void))completion;
-(void)dismissWithCompletion:(void (^)(void))completion;

-(void)adjustContentSize:(CGSize)newSize animated:(BOOL)animated;

@end
