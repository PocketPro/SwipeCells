//
//  UITableViewDisclosureCell.h
//  TableViewDemo
//
//  Created by Eytan Moudahi on 2013-08-05.
//  Copyright (c) 2013 PPG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UITableViewDisclosureCell;

@protocol UITableViewDisclosureCellDelegate <NSObject>

- (void)disclosureCellWillDisclose:(UITableViewDisclosureCell*)cell;
- (void)disclosureCellDidDisclose:(UITableViewDisclosureCell*)cell;
- (void)disclosureCellWillConceal:(UITableViewDisclosureCell*)cell;
- (void)disclosureCellDidConceal:(UITableViewDisclosureCell*)cell;
- (BOOL)disclosureCell:(UITableViewDisclosureCell*)cell shouldRespondToGesture:(UIGestureRecognizer*)gesture;

@end

@interface UITableViewDisclosureCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *primaryView;
@property (nonatomic, strong) UIView *secondaryView;
@property (nonatomic, weak) id <UITableViewDisclosureCellDelegate> delegate;

- (void)concealSecondaryViewAnimated:(BOOL)animated;

@end
