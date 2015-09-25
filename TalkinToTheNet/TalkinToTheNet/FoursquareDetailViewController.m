//
//  FoursquareDetailViewController.m
//  TalkinToTheNet
//
//  Created by Charles Kang on 9/24/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "FoursquareDetailViewController.h"
#import "FoursquareResultTableViewCell.h"
#import "FoursquareSearchResult.h"

@interface FoursquareDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel2;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation FoursquareDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLabels];
    // Do any additional setup after loading the view.
}

- (void)updateLabels {
    
    // update location labels from api
   // NSDictionary *location = [self.foursquareData objectForKey:@"location"];
   // NSArray *formattedAddress= [location objectForKey:@"formattedAddress"];
    
    FoursquareSearchResult *result = self.foursquareData;
    self.categoryLabel.text = result.category;
    self.locationLabel.text = result.address.firstObject;
    
   // NSString *address1 = [formattedAddress firstObject];
   // self.locationLabel.text = address1;
    
//    if (formattedAddress.count > 1) {
//        NSString *address2 = formattedAddress[1];
//        self.locationLabel2.text = address2;
//        
//    } else {
//        self.locationLabel2.text = @" ";
//    }



//    NSArray *categoryArray = [self.foursquareData objectForKey:@"categories"];
//    NSDictionary *categoryObject = [categoryArray firstObject];
//    NSString *category = [categoryObject objectForKey:@"name"];
//    
//    self.categoryLabel.text = category;
}




@end
