//
//  CharitiesViewController.m
//  Boost
//
//  Created by Stiven Deleur on 11/12/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import "CharitiesViewController.h"
#import "ServerProtocol.h"
#import "CharityViewController.h"
#import "Utils.h"
#import "FireActivityIndicator.h"


@interface CharitiesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *charitiesTableView;
@property FireActivityIndicator *activityIndicator;


@end


@implementation CharitiesViewController

NSMutableArray *charities;
NSArray *searchResults;

- (void)viewDidLoad {
	[super viewDidLoad];
	charities = [[NSMutableArray alloc] init];
	_activityIndicator = [[FireActivityIndicator alloc] initWithSuperview:self.view];
	[ServerProtocol getListOfCharities: self];
	[_activityIndicator animate];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)filterContentForSearchText:(NSString*)searchText
{
	if ([searchText isEqualToString:@""]){
		searchResults = [NSArray arrayWithArray:charities];
	}else{
		NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
		searchResults = [charities filteredArrayUsingPredicate:resultPredicate];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (searchResults) {
		return [searchResults count];
	}else{
		return 0;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	CharityViewController *charityVC = segue.destinationViewController;
	[charityVC setCharity:sender];
}

- (IBAction)openCharity:(UITapGestureRecognizer *)sender {
	
	[self performSegueWithIdentifier:@"openCharity" sender:[searchResults objectAtIndex:[[sender view] tag]]];
}

- (IBAction)unwindFromCharityViewController:(UIStoryboardSegue *)sender {
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"charityCell"];
	Charity *charity = [searchResults objectAtIndex:indexPath.section];
	[cell setTag:indexPath.section];
	UILabel *name = [cell viewWithTag:101];
	UILabel *shortDescription = [cell viewWithTag:102];
	UIImageView *image = [cell viewWithTag:103];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCharity:)];
	[cell addGestureRecognizer:tapGesture];
	
	name.text = [charity name];
	shortDescription.text = [charity shortDescription];
	image.image = [charity icon];

	return cell;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
	searchBar.text = @"";
	[self filterContentForSearchText:searchBar.text];
	[_charitiesTableView reloadData];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	[self filterContentForSearchText:searchText];
	[_charitiesTableView reloadData];
}


-(void)urlRequestCompletion: (NSData*) data response: (NSURLResponse *) response error: (NSError *) error{
	[_activityIndicator stopAnimate];
	if (error){
		return;
	}
	NSError * decodingError=nil;
	NSArray * parsedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&decodingError];
	if (!decodingError){
		[charities removeAllObjects];
		for (NSDictionary *dict in parsedData){
			Charity *charity = [[Charity alloc] init];
			charity.charityid = [dict objectForKey:@"id"];
			charity.name = [dict objectForKey:@"org_name"];
			charity.shortDescription = [dict objectForKey:@"short_description"];
			charity.fullDescription = [dict objectForKey:@"long_description"];
			charity.icon = [UIImage imageNamed:@"boostfire.png"];
			NSURL *imageURL = [NSURL URLWithString:[dict objectForKey:@"icon_url"]];
			[Utils downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
				if (succeeded) {
					// change the image in the cell
					charity.icon = image;
					[_charitiesTableView reloadData];
				}
			}];
			[charities addObject:charity];
		}
		[self filterContentForSearchText:@""];
		[_charitiesTableView reloadData];
	}
	
}


@end
