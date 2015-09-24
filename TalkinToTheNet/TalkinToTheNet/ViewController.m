//
//  ViewController.m
//  TalkinToTheNet
//
//  Created by Michael Kavouras on 9/20/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "ViewController.h"
#import "APIManager.h"
#import <CoreLocation/CoreLocation.h>
#import "FoursquareResultTableViewCell.h"
#import "FoursquareSearchResult.h"

@interface ViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
CLLocationManagerDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic) NSMutableArray *searchResults;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSString *longitude;
@property (nonatomic) NSString *latitude;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestAlwaysAuthorization];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}




#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to get your location" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault handler:nil];
    
    [errorAlert addAction:okAction];
    
    [self presentViewController:errorAlert animated:true completion:nil];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location = locations.firstObject;
    
    self.longitude = [NSString stringWithFormat:@"%.1f", location.coordinate.longitude];
    self.latitude = [NSString stringWithFormat:@"%.1f",location.coordinate.latitude];
    
    
}

#pragma mark - API Manager
-(void)makeFoursquareAPIRequestWithSearchTerm:(NSString *)searchTerm
                                     callback:(void(^)())block{
    
    // Turn url into urlString
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=55NCEGSMRDWMKEKQWHOAZRLXBEAQAP41MVODXCCIIR1WTAKP&client_secret=POQGVUIVOI1QBXKQBTCE12ZGDM3WROBNIGVJNIFBHUNIAYE3&v=20130815&ll=%@,%@&query=%@", self.latitude, self.longitude, searchTerm];
    
    // Turn urlString into an encodedString
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    // Turn encodedString into a url
    NSURL *url = [NSURL URLWithString:encodedString];
    
    // Make request
    [APIManager getRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil){
            
            // Turn data into json
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            // Store the results in an NSDictionary
            NSDictionary *responses = [json objectForKey:@"response"];
            
            // Store the venues in an NSArray
            NSArray *venues = [responses objectForKey:@"venues"];
            
            
            //Alloc init searchResults NSMutableArray
            self.searchResults = [[NSMutableArray alloc] init];
            
            for (NSDictionary *venue in venues){
                FoursquareSearchResult *venueObject = [[FoursquareSearchResult alloc] init];
                
                NSDictionary *contact = [venue objectForKey:@"contact"];
                NSDictionary *location = [venue objectForKey:@"location"];
                
                NSArray *categories = [venue objectForKey:@"categories"];
                NSDictionary *category = [categories firstObject];
                
                NSString *name = [venue objectForKey:@"name"];
                NSString *categoryName = [category objectForKey:@"name"];
                NSString *formattedPhone = [contact objectForKey:@"formattedPhone"];
                NSMutableArray *formattedAddress = [location objectForKey:@"formattedAddress"];
                
                venueObject.venueName = name;
                venueObject.phoneNumber = formattedPhone;
                venueObject.address = formattedAddress;
                venueObject.category = categoryName;
                
                if ([venue objectForKey:@"url"] != nil) {
                    NSURL *venueUrl = [NSURL URLWithString:[venue objectForKey:@"url"]];
                    venueObject.siteURL = venueUrl;
                }
                
                if ([venue objectForKey:@"menu"] != nil) {
                    NSDictionary *menu = [venue objectForKey:@"menu"];
                    
                    if ([menu objectForKey:@"mobileUrl"] != nil) {
                        NSURL *mobileMenuURL = [NSURL URLWithString:[menu objectForKey:@"mobileUrl"]];
                        venueObject.menuURL = mobileMenuURL;
                    } else if ([menu objectForKey:@"url"] != nil){
                        NSURL *mobileMenuURL = [NSURL URLWithString:[menu objectForKey:@"url"]];
                        venueObject.menuURL = mobileMenuURL;
                    };
                }
                
                [self.searchResults addObject:venueObject];
            }
            block();
        }
    }];
    
}

#pragma mark - UI
- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
}


#pragma mark - Table View Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FoursquareResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    
    FoursquareSearchResult *currentResult = self.searchResults[indexPath.row];
    
    cell.venueName.text  = currentResult.venueName;
    cell.categoryName.text = currentResult.category;
    
    
    
    
    
    return cell;
}

#pragma mark - Text Field Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:true];
    
    [self makeFoursquareAPIRequestWithSearchTerm:textField.text callback:^{
        
        [self.tableView reloadData];
    }];
    
    //    [self.locationManager requestLocation];
    
    
    return true;
}

@end
