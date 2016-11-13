//
//  ProfileViewController.m
//  Boost
//
//  Created by Stiven Deleur on 11/13/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import "ProfileViewController.h"
#import "ServerProtocol.h"
#import "Utils.h"
#import "FireActivityIndicator.h"

@interface ProfileViewController ()
@property FireActivityIndicator *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *donationsTableView;
@end

@implementation ProfileViewController

NSMutableArray *donations;

-(void)refreshData{
	_activityIndicator = [[FireActivityIndicator alloc] initWithSuperview:self.view];
	[ServerProtocol getPastDonations:self];
	[_activityIndicator animate];
}
- (void)refresh:(UIRefreshControl *)refreshControl {
	[self refreshData];
	[refreshControl endRefreshing];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	donations = [[NSMutableArray alloc] init];
	
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
	[_donationsTableView addSubview:refreshControl];
	[self refreshData];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (donations) {
		return [donations count];
	}else{
		return 0;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"donationCell"];
	Donation *donation = [donations objectAtIndex:indexPath.section];
	[cell setTag:indexPath.section];
	UILabel *name = [cell viewWithTag:101];
	UILabel *amountDonated = [cell viewWithTag:102];
	UIImageView *image = [cell viewWithTag:103];
	UILabel *date = [cell viewWithTag:104];

	
	name.text = [donation charityName];
	amountDonated.text = [NSString stringWithFormat:@"   $%@", [Utils moneyNumberFrom: [donation amount]]];
	date.text = [donation transactionDate];
	//image.image = [donation icon];
	
	return cell;
}

-(void)urlRequestCompletion: (NSData*) data response: (NSURLResponse *) response error: (NSError *) error{
	[_activityIndicator stopAnimate];
	if (error){
		return;
	}
	NSError * decodingError=nil;
	NSArray * parsedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&decodingError];
	if (!decodingError){
		[donations removeAllObjects];
		for (NSDictionary *dict in parsedData){
			Donation *donation = [[Donation alloc] init];
			donation.pid = [dict objectForKey:@"pid"];
			donation.transactionDate = [dict objectForKey:@"date"];
			donation.charityName = [dict objectForKey:@"merchant"];
			donation.amount = [dict objectForKey:@"amount"];
			[donations addObject:donation];
		}
		[_donationsTableView reloadData];
	}else{
		NSLog(@"JSON Decoding Error: %@", decodingError);
	}
}
@end
