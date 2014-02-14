//
//  SampleSheetViewController.m
//  NAModalSheet
//
//  Created by Ken Worley on 11/22/13.
//  Copyright (c) 2013 Ken Worley. All rights reserved.
//

#import "SampleSheetViewController.h"
#import "NAModalSheet.h"

@interface SampleSheetViewController ()
{
  __weak IBOutlet UISwitch *sizeSwitch;
  __weak IBOutlet UILabel *sizeLabel;
}
@end

@implementation SampleSheetViewController

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
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
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

- (IBAction)largerSizeSwitchChanged:(id)sender
{
  UISwitch *largerSizeSwitch = (UISwitch*)sender;
  if ([largerSizeSwitch isKindOfClass:[UISwitch class]])
  {
    CGSize s = self.view.bounds.size;
    if (largerSizeSwitch.on)
    {
      s.height += 40;
      s.width += 40;
    }
    else
    {
      s.height -= 40;
      s.width -= 40;
    }
    [self.modalSheet adjustContentSize:s animated:YES];
  }
}

@end
