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


@interface ProductViewController ()
@property(nonatomic,strong) Products * product;
@property(nonatomic,strong)NetworkOperations *networks;
//@property(nonatomic,strong) NSMutableArray *productDataArray;
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
    /*
    for (UIView *subview in self.searchBar.subviews)
    {
        for (UIView *subSubview in subview.subviews)
        {
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                UITextField *textField = (UITextField *)subSubview;
//                [textField setKeyboardAppearance: UIKeyboardAppearanceAlert];
                textField.returnKeyType = UIReturnKeyDefault;
                break;
            }
        }
    }*/
  
}



-(void) getProductListing{
    self.networks=[[NetworkOperations alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"The product Api is %@",[dict objectForKey:@"Prod_Api"]);
 // send block as parameter to get callbacks
    [self.networks fetchDataFromServer:[dict objectForKey:@"Prod_Api"] withreturnMethod:^(NSMutableArray* data){
        globals.productDataArray=data;
        NSLog(@"The product Api is %lu",(unsigned long)[globals.productDataArray count]);
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self.prodCollectionView reloadData];
                           
                       });
    }];
   // [self.prodCollectionView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Collection view delegate methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [globals.productDataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    prodCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"prodCell" forIndexPath:indexPath];
    cell.frame = CGRectMake(0, cell.frame.origin.y, self.prodCollectionView.frame.size.width, cell.frame.size.height);
    //cell.backgroundColor = [UIColor whiteColor];
    
    Products *prodObject= [[Products alloc] initWithDictionary:[globals.productDataArray objectAtIndex:indexPath.row]];

    cell.product = prodObject;
    cell.productName.text=prodObject.prodName;
    cell.prodDescription.text = prodObject.prodDescription;
    cell.offerPrice.text = prodObject.price;
    cell.size.text = prodObject.size;
    
    cell.availableColor1.backgroundColor = [UIColor redColor];
    cell.availableColor1.layer.cornerRadius = (CGFloat)cell.availableColor1.frame.size.height/2;
    
    cell.availableColor2.backgroundColor = [UIColor blueColor];
    cell.availableColor2.layer.cornerRadius = (CGFloat)cell.availableColor2.frame.size.height/2;
    
    cell.availableColor3.backgroundColor = [UIColor blackColor];
    cell.availableColor3.layer.cornerRadius = (CGFloat)cell.availableColor3.frame.size.height/2;
    
    cell.availableColor4.backgroundColor = [UIColor yellowColor];
    cell.availableColor4.layer.cornerRadius = (CGFloat)cell.availableColor4.frame.size.height/2;
    
    return cell;
 
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Products *prodObject= [[Products alloc] initWithDictionary:[globals.productDataArray objectAtIndex:indexPath.row]];
    
    NSDictionary* tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:prodObject,@"product",[NSNumber numberWithInteger:1],@"quantity", nil];
    CartItem* cartItem = [[CartItem alloc] initWithDictionary:tempDic];
    
    [GlobalVariables addItemToCart:cartItem];
    
//    NSMutableArray* cartArray= [NSMutableArray arrayWithObjects:cartItem, nil];
//    
//    NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:cartArray];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:archivedObject forKey:@"CartItems"];
//    [defaults synchronize];
    
    [self testRetrieve];
    
    
//    UIAlertView* addedAlert = [[UIAlertView alloc] initWithTitle:@"Added" message:@"product added" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [addedAlert show];
}

-(void) testRetrieve
{
    // Read from NSUserDefaults
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *archivedObject = [defaults objectForKey:@"CartItems"];
//    NSArray *obj = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:archivedObject];
    NSArray *obj =  [GlobalVariables getCartItems];
    for(CartItem* itm in obj){
        NSLog(@"CARTITEM SAVED - productName: %@,%li", itm.product.prodName, (long)itm.quantity);
    }
}

#pragma searchBar delegates

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //[self applyFilters:[NSSet setWithObject:searchBar.text]];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
