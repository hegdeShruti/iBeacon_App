//
//  ProductViewController.m
//  iBeacon_Retail
//
//  Created by shruthi on 02/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "ProductViewController.h"
#import "prodCell.h"
#import "Products.h"
#import "CartItem.h"
#import "NetworkOperations.h"
#import "GlobalVariables.h"

#import "UIImageView+WebCache.h"




@interface ProductViewController ()
@property(nonatomic,strong) Products * product;
@property(nonatomic,strong)NetworkOperations *networks;
//@property(nonatomic,strong) NSMutableArray *productImagesArray;
@property(nonatomic,strong) GlobalVariables *globals;

@end

@implementation ProductViewController
@synthesize globals;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    globals=[GlobalVariables getInstance];
    UINib *cellNib = [UINib nibWithNibName:@"prodCell" bundle:nil];
    [self.prodCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"prodCell"];
   
    if(![globals.productDataArray count]>0){
          [self getProductListing];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIButton *rtButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [rtButton setImage:[UIImage imageNamed:@"icon_cart.png"] forState:UIControlStateNormal];
    [rtButton addTarget:[GlobalVariables getInstance] action:@selector(loadCartScreen) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rtButton];
    [SlideNavigationController sharedInstance].rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.title = @"Products";
    if([globals.productDataArray count]>0){
        self.products = self.searchFilteredProducts = globals.productDataArray;
    }
    [self.prodCollectionView reloadData];
   
}

-(void) getProductListing{
    self.networks=[[NetworkOperations alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"The product Api is %@",[dict objectForKey:@"Prod_Api"]);
 // send block as parameter to get callbacks
    [self shouldHideLoadingIndicator:NO];
    [self.networks fetchDataFromServer:[dict objectForKey:@"Prod_Api"] withreturnMethod:^(NSMutableArray* data){
        self.products = self.searchFilteredProducts = globals.productDataArray=data;
        NSLog(@"The product Api is %lu",(unsigned long)[globals.productDataArray count]);
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self.prodCollectionView reloadData];
                           [self shouldHideLoadingIndicator:YES];
                           
                       });
        
    }];
   // [self.prodCollectionView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - For Status Bar
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma Collection view delegate methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.searchFilteredProducts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    prodCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"prodCell" forIndexPath:indexPath];
    cell.frame = CGRectMake(0, cell.frame.origin.y, self.prodCollectionView.frame.size.width, cell.frame.size.height);
    //cell.backgroundColor = [UIColor whiteColor];
    
    Products *prodObject= [[Products alloc] initWithDictionary:[self.searchFilteredProducts objectAtIndex:indexPath.row]];
   // prodObject.prodImage=[NSString stringWithFormat:@"%@.png",prodObject.prodName];
    
    cell.product = prodObject;
    cell.productName.text=prodObject.prodName;
    cell.prodDescription.text = prodObject.prodDescription;
    cell.offerPrice.text = prodObject.price;
    cell.size.text = prodObject.size;
    
    //  using SDWEbimage for lazy loading of images
    NSString* result = [prodObject.prodImage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [cell.productImage sd_setImageWithURL:[NSURL URLWithString:result] placeholderImage:[UIImage imageNamed:@"Default_imageHolder.png"]];

    
  //  cell.availableColor1.backgroundColor = [UIColor redColor];
    cell.availableColor1.layer.cornerRadius = (CGFloat)cell.availableColor1.frame.size.height/2;
    
  //  cell.availableColor2.backgroundColor = [UIColor blueColor];
    cell.availableColor2.layer.cornerRadius = (CGFloat)cell.availableColor2.frame.size.height/2;
    
  //  cell.availableColor3.backgroundColor = [UIColor blackColor];
    cell.availableColor3.layer.cornerRadius = (CGFloat)cell.availableColor3.frame.size.height/2;
    
   // cell.availableColor4.backgroundColor = [UIColor yellowColor];
    cell.availableColor4.layer.cornerRadius = (CGFloat)cell.availableColor4.frame.size.height/2;
    
    return cell;
 
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Products *prodObject= [[Products alloc] initWithDictionary:[self.searchFilteredProducts objectAtIndex:indexPath.row]];
    ProductDetailViewController* prodDetailVC = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    prodDetailVC.product = prodObject;
   // prodDetailVC.selectedImage=;
    [[SlideNavigationController sharedInstance] pushViewController:prodDetailVC animated:YES];
}

#pragma searchBar delegates

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //[self applyFilters:[NSSet setWithObject:searchBar.text]];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.text=@"";
    [self filterRetailerList];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText.length == 0){
        [self filterRetailerList];
        
    }else{
        searchBar.showsCancelButton = YES;
    }
    if([[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) return;
    [self filterRetailerList];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"YES!!!!!!!");
    if(searchBar.text.length > 0){
        searchBar.showsCancelButton = YES;
    }else{
        searchBar.showsCancelButton = NO;
    }
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.searchBar isFirstResponder] && [touch view] != self.searchBar) {
        [self.searchBar resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)filterRetailerList
{
    NSPredicate *searchKeyWordPredicate;    
    //Setting predicate if there is a keyword entered in the searchbar
    NSString* trimmedString = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
    if(trimmedString.length > 0){
                searchKeyWordPredicate = [NSPredicate predicateWithFormat:@"productName CONTAINS[cd] %@",trimmedString];
    }else{
        searchKeyWordPredicate = [NSPredicate predicateWithValue:YES]; // returns all products
    }
//    NSArray*  temp =  [[NSArray alloc] initWithArray:[self.products filteredArrayUsingPredicate:searchKeyWordPredicate]];
    self.searchFilteredProducts = [self.products filteredArrayUsingPredicate:searchKeyWordPredicate];
    [self.prodCollectionView reloadData];
}

#pragma mark Slide view delegate method
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

-(void) shouldHideLoadingIndicator:(BOOL) state{
        self.loadingIndicatorView.hidden=state;
}


@end
