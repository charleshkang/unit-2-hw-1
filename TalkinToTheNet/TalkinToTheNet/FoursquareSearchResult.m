//
//  FoursquareSearchResult.m
//  TalkinToTheNet
//
//  Created by Charles Kang on 9/23/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "FoursquareSearchResult.h"
#import "FoursquareDetailViewController.h"
#import "FoursquareResultTableViewCell.h"


@implementation FoursquareSearchResult



#pragma mark - Life Cycle
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *fourSquareData = self.searchResults[indexPath.row];
    FoursquareDetailViewController *vc = segue.destinationViewController;
    vc.foursquareData = fourSquareData;
    
}
@end
