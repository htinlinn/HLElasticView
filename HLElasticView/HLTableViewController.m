//
//  HLTableViewController.m
//  HLElasticView
//
//  Created by Htin Linn on 2/23/14.
//  Copyright (c) 2014 Htin Linn. All rights reserved.
//

#import "HLTableViewController.h"
#import "HLSnapViewController.h"
#import "HLScaleViewController.h"

@implementation HLTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"HLElasticView";
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Snap";
    } else {
        cell.textLabel.text = @"Scale";
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        HLSnapViewController *snapViewController = [[HLSnapViewController alloc] init];
        [self.navigationController pushViewController:snapViewController animated:YES];
    } else {
        HLScaleViewController *scaleViewController = [[HLScaleViewController alloc] init];
        [self.navigationController pushViewController:scaleViewController animated:YES];
    }
}

@end
