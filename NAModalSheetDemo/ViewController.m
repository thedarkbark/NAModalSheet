//
//  ViewController.m
//  NAModalSheet
//
//  Created by Ken Worley on 11/22/13.
//  Copyright (c) 2013 Ken Worley. All rights reserved.
//

#import "ViewController.h"
#import "SampleSheetViewController.h"
#import "SampleBottomSheetViewController.h"
#import "SampleTooltipViewController.h"
#import "NAModalSheet.h"
#import "UIImage+BoxBlur.h"

@interface ViewController () <NAModalSheetDelegate, UITableViewDataSource, UITableViewDelegate>
{
  __weak IBOutlet UINavigationBar* myNavBar;
  __weak IBOutlet UISwitch* landscapeSwitch;
  __weak IBOutlet UISwitch* dismissOnOutsideTouchSwitch;
  __weak IBOutlet UILabel* dismissOutsideLabel;
  __weak IBOutlet UISwitch* disableBlurSwitch;
  __weak IBOutlet UILabel* disableBlurLabel;
  __weak IBOutlet UITableView* demoTable;
  
  NAModalSheet *tooltip;
  
  NSMutableArray *_actions;
}
@end

// a container class for the demo actions presented in the main demo table
@interface DemoAction : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^action)();
+(DemoAction*)withTitle:(NSString*)title action:(void(^)())action;
@end

@implementation DemoAction
+(DemoAction*)withTitle:(NSString*)title action:(void(^)())action
{
  DemoAction *a = [[DemoAction alloc] init];
  a.title = title;
  a.action = action;
  return a;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  _actions = [NSMutableArray array];
  
  [_actions addObject:[DemoAction withTitle:@"Present from Top" action:^{
    [self presentFromTop:nil];
  }]];
  [_actions addObject:[DemoAction withTitle:@"Present from Top (Custom BG)" action:^{
    [self presentCustomFromTop:nil];
  }]];
  [_actions addObject:[DemoAction withTitle:@"Present from Nav Bar" action:^{
    [self presentFromTopExcludingNavBar:nil];
  }]];
  [_actions addObject:[DemoAction withTitle:@"Present from Bottom" action:^{
    [self presentFromBottom:nil];
  }]];
  [_actions addObject:[DemoAction withTitle:@"Present Centered" action:^{
    [self presentCentered:nil];
  }]];
  [_actions addObject:[DemoAction withTitle:@"Present from Fixed Position" action:^{
    [self presentFromFixed:nil];
  }]];
}

- (void)viewDidLayoutSubviews
{
  CGRect f = dismissOutsideLabel.frame;
  f.origin.x = CGRectGetMaxX(dismissOnOutsideTouchSwitch.frame) + 8.0;
  dismissOutsideLabel.frame = f;
  
  f = disableBlurLabel.frame;
  f.origin.x = CGRectGetMaxX(disableBlurSwitch.frame) + 8.0;
  disableBlurLabel.frame = f;
}

- (IBAction)presentFromTop:(id)sender
{
  SampleSheetViewController *svc = [[SampleSheetViewController alloc] init];
  svc.opaque = disableBlurSwitch.on;
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleSlideInFromTop];
  sheet.disableBlurredBackground = disableBlurSwitch.on;
  sheet.delegate = self;
  svc.modalSheet = sheet;
  [sheet presentWithCompletion:^{
    
  }];
}

- (IBAction)presentFromTopExcludingNavBar:(id)sender
{
  SampleSheetViewController *svc = [[SampleSheetViewController alloc] init];
  svc.opaque = disableBlurSwitch.on;
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleSlideInFromUnderNavBar];
  sheet.disableBlurredBackground = disableBlurSwitch.on;
  sheet.delegate = self;
  svc.modalSheet = sheet;
  [sheet presentWithCompletion:^{
    
  }];
}

- (IBAction)presentFromBottom:(id)sender
{
  SampleBottomSheetViewController *svc = [[SampleBottomSheetViewController alloc] init];
  svc.opaque = disableBlurSwitch.on;
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleSlideInFromBottom];
  sheet.disableBlurredBackground = disableBlurSwitch.on;
  sheet.delegate = self;
  svc.modalSheet = sheet;
  [sheet presentWithCompletion:^{
    
  }];
}

- (IBAction)presentCentered:(id)sender
{
  SampleSheetViewController *svc = [[SampleSheetViewController alloc] init];
  svc.opaque = disableBlurSwitch.on;
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleFadeInCentered];
  sheet.disableBlurredBackground = disableBlurSwitch.on;
  sheet.cornerRadiusWhenCentered = 24.0;
  sheet.delegate = self;
  svc.modalSheet = sheet;
  [sheet presentWithCompletion:^{
    
  }];
}

- (IBAction)presentCustomFromTop:(id)sender
{
  SampleSheetViewController *svc = [[SampleSheetViewController alloc] init];
  svc.opaque = disableBlurSwitch.on;
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleSlideInFromTop];
  sheet.disableBlurredBackground = disableBlurSwitch.on;
  sheet.delegate = self;
  sheet.backgroundProcessingBlock = ^(UIImage *image) {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
    return [[UIImage imageWithData:imageData] blurredImage:0.1];
  };
  svc.modalSheet = sheet;
  [sheet presentWithCompletion:^{
      
  }];
}

- (IBAction)presentFromFixed:(id)sender
{
  SampleTooltipViewController *stvc = [[SampleTooltipViewController alloc] init];
  tooltip = [[NAModalSheet alloc] initWithViewController:stvc presentationStyle:NAModalSheetPresentationStyleFixedPositionAndSize];
  CGRect f = stvc.view.frame;
  f.origin = CGPointMake(CGRectGetMinX(dismissOnOutsideTouchSwitch.frame), CGRectGetMaxY(dismissOnOutsideTouchSwitch.frame) - 4.0);
  tooltip.presentationRect = f;
  tooltip.disableBlurredBackground = YES;
  tooltip.backgroundTintColor = [UIColor clearColor];
  tooltip.delegate = self;
  stvc.sheet = tooltip;
  [tooltip presentWithCompletion:^{
    
  }];
}

#pragma mark NAModalSheetDelegate

- (void)modalSheetTouchedOutsideContent:(NAModalSheet *)sheet
{
  if (dismissOnOutsideTouchSwitch.on)
  {
    [sheet dismissWithCompletion:^{
      
    }];
  }
}

- (BOOL)modalSheetShouldAutorotate:(NAModalSheet *)sheet
{
  return [self shouldAutorotate];
}

- (NSUInteger)modalSheetSupportedInterfaceOrientations:(NAModalSheet *)sheet
{
  return [self supportedInterfaceOrientations];
}

-(BOOL)modalSheet:(NAModalSheet *)sheet willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  if (sheet == tooltip)
  {
    CGRect rect = sheet.presentationRect;
    rect.origin.x = CGRectGetMinX(dismissOnOutsideTouchSwitch.frame);
    rect.origin.y = CGRectGetMaxY(dismissOnOutsideTouchSwitch.frame) - 4.0;
    tooltip.presentationRect = rect;
    return YES;
  }
  return NO;
}

-(void)modalSheetDismissed:(NAModalSheet *)sheet
{
  tooltip = nil;
}

#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSD"];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MSD"];
  }
  DemoAction *action = _actions[indexPath.row];
  cell.textLabel.text = action.title;
  cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  DemoAction *action = _actions[indexPath.row];
  action.action();
}

@end
