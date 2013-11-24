//
//  SampleBottomSheetViewController.h
//  NAModalSheet
//
//  Created by Ken Worley on 11/22/13.
//  Copyright (c) 2013 Ken Worley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAModalSheet.h"

@interface SampleBottomSheetViewController : UIViewController

+ (void)presentWithStyle:(NAModalSheetPresentationStyle)style slideInset:(CGFloat)slideInset;

@end
