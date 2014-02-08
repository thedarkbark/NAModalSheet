//
//  SampleBottomSheetViewController.m
//  NAModalSheet
//
//  Created by Ken Worley on 11/22/13.
//  Copyright (c) 2013 Ken Worley. All rights reserved.
//

#import "SampleBottomSheetViewController.h"
#import "NAModalSheet.h"

@interface SampleBottomSheetViewController ()
{
  __weak IBOutlet UISwitch *sizeSwitch;
  __weak IBOutlet UILabel *sizeLabel;
}
@end

@implementation SampleBottomSheetViewController

- (instancetype)init
{
  self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
  if (self)
  {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  if (self.opaque)
  {
    self.view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
  }
}

- (void)viewDidLayoutSubviews
{
  CGRect f = sizeLabel.frame;
  f.origin.x = CGRectGetMaxX(sizeSwitch.frame) + 8.0;
  sizeLabel.frame = f;
}

- (IBAction)dismissButtonTouched:(id)sender
{
  [self.modalSheet dismissWithCompletion:^{
    
  }];
}

- (IBAction)sizeSwitchChanged:(id)sender
{
  UISwitch *size_switch = (UISwitch*)sender;
  if ([size_switch isKindOfClass:[UISwitch class]])
  {
    CGSize s = self.view.bounds.size;
    if (size_switch.on)
    {
      s.height += 40;
      s.width -= 40;
    }
    else
    {
      s.height -= 40;
      s.width += 40;
    }
    [self.modalSheet adjustContentSize:s animated:YES];
  }
}

@end
