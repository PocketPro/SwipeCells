//
//  SMAViewController.m
//  TableViewDemo
//
//  Created by Eytan Moudahi on 2013-08-05.
//  Copyright (c) 2013 PPG. All rights reserved.
//

#import "SMAViewController.h"
#import "UITableViewDisclosureCell.h"

@interface SMAViewController ()

@end

@implementation SMAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    activeCells = [[NSMutableSet alloc] init];
    disclosedCells = [[NSMutableSet alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"some identifier";
    
    UITableViewDisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewDisclosureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
        
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setTitle:@"Comment" forState:UIControlStateNormal];
        b.frame = CGRectMake(0, 0, CGRectGetWidth(cell.secondaryView.bounds)/2.0, CGRectGetHeight(cell.secondaryView.bounds));
        [cell.secondaryView addSubview:b];
        
        UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [b2 setTitle:@"Favourite" forState:UIControlStateNormal];
        b2.frame = CGRectMake(CGRectGetMaxX(b.frame), 0, CGRectGetWidth(b.frame), CGRectGetHeight(b.frame));
        [b2 addTarget:self action:@selector(favouriteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.secondaryView addSubview:b2];
        
    }
    
    return cell;
}

- (void)favouriteButtonPressed:(id)sender
{
    // TODO: Impelement me
    NSLog(@"favouriteButtonPressed");
}

#pragma mark - Disclosure Cell

- (BOOL)disclosureCell:(UITableViewDisclosureCell*)cell shouldRespondToGesture:(UIGestureRecognizer*)gesture
{
    return activeCells.count < 1;
}

- (void)disclosureCellWillDisclose:(UITableViewDisclosureCell*)cell
{
    [disclosedCells enumerateObjectsUsingBlock:^(UITableViewDisclosureCell* obj, BOOL *stop) {
        [obj concealSecondaryViewAnimated:YES];
    }];
    [disclosedCells removeAllObjects];

    [activeCells addObject:cell];
}

- (void)disclosureCellDidDisclose:(UITableViewDisclosureCell*)cell
{
    [activeCells removeObject:cell];
    [disclosedCells addObject:cell];
}

- (void)disclosureCellWillConceal:(UITableViewDisclosureCell*)cell
{
    [activeCells addObject:cell];
}

- (void)disclosureCellDidConceal:(UITableViewDisclosureCell*)cell
{
    [activeCells removeObject:cell];
    [disclosedCells removeObject:cell];
}

@end
