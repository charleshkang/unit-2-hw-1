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
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;

@end

@implementation FoursquareDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLabels];
    // Do any additional setup after loading the view.
}

- (void)updateLabels {
    
    FoursquareSearchResult *result = self.foursquareData;
    self.locationLabel.text = result.address.firstObject;
    self.categoryLabel.text = result.category;
    self.phoneNumberLabel.text = result.phoneNumber;
    //    self.menuLabel.text = result.menuURL;
    self.menuLabel = result.menuURL;

    
    
}




@end
