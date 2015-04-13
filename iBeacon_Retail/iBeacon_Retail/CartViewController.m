//
//  CartViewController.m
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/24/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "CartViewController.h"

@interface CartViewController ()

@property(nonatomic,strong)NetworkOperations *networks;
@property(nonatomic,assign) NSInteger *total;

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.tableData = [NSArray arrayWithObjects:@"1",@"2",nil];
//    [self.tableview registerClass:[CartTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CartTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self getCartListing];
    self.total=0;
    [self.tableview reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[SlideNavigationController sharedInstance].navigationBar.topItem setTitle:@"Cart"];
    [self getCartListing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartTableViewCell* cell = (CartTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];;
    
    CartItem* item = (CartItem*)[self.tableData objectAtIndex:indexPath.row];
    
    Products *prodObject= item.product;
    cell.product = prodObject;
    
    cell.productName.text = prodObject.prodName;
    cell.prodDescription.text = prodObject.prodDescription;
    cell.price.text = prodObject.price;
    cell.subTotal.text = prodObject.price;
    NSString *str=[prodObject.price  substringFromIndex:1];
    self.total+=[str intValue];
    self.totalValue.text=[NSString stringWithFormat:@"$%zd",self.total];
   // cell.prodImage.image=[UIImage imageNamed:prodObject.prodImage];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark This method will be replaced with api call to get cart items to be displayed in the tableview

-(void) getCartListing{
    self.tableData = [[GlobalVariables getCartItems] copy];
    [self.tableview reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark Slide view delegate method
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
@end
