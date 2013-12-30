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

-(void)modalSheetTouchedOutsideContent:(NAModalSheet*)sheet;

@end

@interface NAModalSheet : UIViewController

@property (nonatomic, weak) id<NAModalSheetDelegate> delegate;
@property (nonatomic, assign) CGFloat slideInset;
@property (nonatomic, assign) CGFloat cornerRadiusWhenCentered;

- (instancetype)initWithViewController:(UIViewController *)vc
                     presentationStyle:(NAModalSheetPresentationStyle)style;

-(void)presentWithCompletion:(void (^)(void))completion;
-(void)dismissWithCompletion:(void (^)(void))completion;

-(void)adjustContentSize:(CGSize)newSize animated:(BOOL)animated;

@end
