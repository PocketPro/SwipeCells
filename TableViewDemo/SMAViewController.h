//
//  SMAViewController.h
//  TableViewDemo
//
//  Created by Eytan Moudahi on 2013-08-05.
//  Copyright (c) 2013 PPG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewDisclosureCell.h"

@interface SMAViewController : UITableViewController <UITableViewDisclosureCellDelegate>
{
    NSMutableSet *activeCells;
    NSMutableSet *disclosedCells;
}

@end
