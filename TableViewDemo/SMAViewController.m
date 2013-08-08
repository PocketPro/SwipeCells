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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"some identifier";
    
    UITableViewDisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewDisclosureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
        
        
        // Primary View
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        nameLabel.text = @"Swing 182";
        [cell.primaryView addSubview:nameLabel];
        
        UILabel *speedLabel = [[UILabel alloc] init];
        speedLabel.translatesAutoresizingMaskIntoConstraints = NO;
        speedLabel.text = @"88 MPH";
        [cell.primaryView addSubview:speedLabel];
        
        UIView *favouriteView = [[UIView alloc] init];
        favouriteView.translatesAutoresizingMaskIntoConstraints = NO;
        favouriteView.backgroundColor = [UIColor greenColor];
        [cell.primaryView addSubview:favouriteView];
        
        UIView *notesView = [[UIView alloc] init];
        notesView.translatesAutoresizingMaskIntoConstraints = NO;
        notesView.backgroundColor = [UIColor orangeColor];
        
        [cell.primaryView addSubview:notesView];

        UIView *alertsView = [[UIView alloc] init];
        alertsView.translatesAutoresizingMaskIntoConstraints = NO;
        alertsView.backgroundColor = [UIColor orangeColor];
        alertsView.alpha = 0.8;
        [cell.primaryView addSubview:alertsView];
        
        
        [cell.primaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[nameLabel]-(10)-[speedLabel(==nameLabel)][alertsView(==44)][notesView(==alertsView)][favouriteView(==10)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(nameLabel, speedLabel, alertsView, notesView, favouriteView)]];
        [cell.primaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nameLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(nameLabel)]];
        [cell.primaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[speedLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(speedLabel)]];
        [cell.primaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[favouriteView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(favouriteView)]];
        [cell.primaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[notesView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(notesView)]];
        [cell.primaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[alertsView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(alertsView)]];                    
        
        
        
        
        // Secondary View
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.translatesAutoresizingMaskIntoConstraints = NO;
        [b setTitle:@"Comment" forState:UIControlStateNormal];
        [b addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.secondaryView addSubview:b];

        UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
        b2.translatesAutoresizingMaskIntoConstraints = NO;
        [b2 setTitle:@"Favourite" forState:UIControlStateNormal];
        [b2 addTarget:self action:@selector(favouriteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.secondaryView addSubview:b2];
        
        UIButton *b3 = [UIButton buttonWithType:UIButtonTypeCustom];
        b3.translatesAutoresizingMaskIntoConstraints = NO;
        [b3 setTitle:@"Delete" forState:UIControlStateNormal];
        [b3 addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.secondaryView addSubview:b3];

        [cell.secondaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(b)]];
        [cell.secondaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b2]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(b2)]];
        [cell.secondaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b3]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(b3)]];
        [cell.secondaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[b][b2(==b)][b3(==b)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(b,b2,b3)]];

        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0f;
}

- (void)favouriteButtonPressed:(id)sender
{
    // TODO: Impelement me
}

- (void)commentButtonPressed:(id)sender
{
    // TODO: Implement me
}

- (void)deleteButtonPressed:(id)sender
{
    // TODO: Implement me
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
