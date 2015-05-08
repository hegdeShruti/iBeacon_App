//
//  ProductDetailViewController.m
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/31/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface ProductDetailViewController()
@property (nonatomic,strong) NSString* randomDiscount;
@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    [self.recommendationCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"RecommendationCell"];
    
    UINib *cellNib1 = [UINib nibWithNibName:@"ProductImageCollectionViewCell" bundle:nil];
    UINib *cellNib2 = [UINib nibWithNibName:@"ProductRecommendationCollectionViewCell" bundle:nil];
    [self.productImageCollectionView registerNib:cellNib1 forCellWithReuseIdentifier:@"ProductImageCell"];
    [self.recommendationCollectionView registerNib:cellNib2 forCellWithReuseIdentifier:@"RecommendationCell"];
    
    self.productImagesArray = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
    self.recommendationDataArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
    [self.cartButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.cartButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
//    self.scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,  self.contentView.frame.size.height);
    
    [self setupPageControlForProductImagesCollectionView];
    [self startUserActivities];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [SlideNavigationController sharedInstance].navigationBar.tintColor = [UIColor whiteColor];
    
    
    /* Using custom button to add the WHITE back arrow to the leftbarbuttonitem */
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [button setImage:[UIImage imageNamed:@"icon_cart.png"] forState:UIControlStateNormal];
    [button addTarget:[GlobalVariables getInstance] action:@selector(loadCartScreen) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rtBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rtBarButtonItem;
    
    self.navigationItem.title = @"Product Details";
    
    [self loadProductDetails];
    [self setColorButtonsRoundedCorner];
    self.randomDiscount = [NSString stringWithFormat:@"%@",@(arc4random_uniform(90)+1)];
//    [self startUserActivities];
//    self.userActivity.needsSave = YES;
    [self updateUserActivityState:self.viewProductActivity];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.viewProductActivity invalidate];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)restoreUserActivityState:(NSUserActivity *)activity{
    if([activity.activityType isEqualToString:TavantIBeaconRetailContinutiyViewProduct]){
        NSDictionary* activityInfo = [activity.userInfo objectForKey:TavantIBeaconRetailContinutiyScreenData];
        self.product = [activityInfo objectForKey:@"product"];
        [self loadProductDetails];        
//        NSLog(@"TEST 2");
    }
    //    self.searchBar.text = @"TEST";
    [super restoreUserActivityState:activity];
}

-(void) startUserActivities{
    self.viewProductActivity =  [[NSUserActivity alloc] initWithActivityType:TavantIBeaconRetailContinutiyViewProduct];
    ProductViewController* temp;
    NSDictionary* activityData;
    self.viewProductActivity.title = @"Viewing Product Detail";
    switch(self.prevScreen){
        case BeaconRetailProductIndex:
            temp = (ProductViewController*)self.prevVCForUserActivityFlow;
            activityData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.prevScreen],@"prevScreen",[GlobalVariables getCartItems], @"cartItems",self.product, @"product", temp.products, @"products", temp.searchFilteredProducts, @"filteredProducts",temp.searchString, @"searchString", nil];
            break;
        case BeaconRetailOffersIndex:
            activityData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.prevScreen],@"prevScreen",[GlobalVariables getCartItems], @"cartItems",self.product, @"product", nil];
            break;
        default:
            break;
    }
    
//    ProductViewController* temp = (ProductViewController*)self.prevVCForUserActivityFlow;
//    NSDictionary* activityData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.prevScreen],@"prevScreen",[GlobalVariables getCartItems], @"cartItems",self.product, @"product", [GlobalVariables getCartItems],@"cartItems",temp.products, @"products", temp.searchFilteredProducts, @"filteredProducts",temp.searchString, @"searchString", nil];
    self.viewProductActivity.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:activityData,TavantIBeaconRetailContinutiyScreenData, nil];
    self.userActivity = self.viewProductActivity;
    
    [self.userActivity becomeCurrent];
}

-(void)updateUserActivityState:(NSUserActivity *)activity{    
    ProductViewController* temp;
    NSDictionary* activityData;
    switch(self.prevScreen){
        case BeaconRetailProductIndex:
            temp = (ProductViewController*)self.prevVCForUserActivityFlow;
            activityData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.prevScreen],@"prevScreen",[GlobalVariables getCartItems], @"cartItems",self.product, @"product", temp.products, @"products", temp.searchFilteredProducts, @"filteredProducts",temp.searchString, @"searchString", nil];
            break;
        case BeaconRetailOffersIndex:
            activityData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.prevScreen],@"prevScreen",[GlobalVariables getCartItems], @"cartItems",self.product, @"product", nil];
            break;
        default:
            break;
    }
    
//    ProductViewController* temp = (ProductViewController*)self.prevVCForUserActivityFlow;
//    NSDictionary* activityData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.prevScreen],@"prevScreen",[GlobalVariables getCartItems], @"cartItems", self.product, @"product", [GlobalVariables getCartItems], @"cartItems", temp.products, @"products", temp.searchFilteredProducts, @"filteredProducts",temp.searchString, @"searchString", nil];
    [activity addUserInfoEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:activityData,TavantIBeaconRetailContinutiyScreenData, nil]];
//    [self.viewProductActivity becomeCurrent];
    [super updateUserActivityState:activity];
    
}


#pragma mark - For Status Bar
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(collectionView.tag == 1){ // this is the product images collection view
        return 1;
    }else{
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView.tag == 1){ // this is the product images collection view
        return self.productImagesArray.count;
    }else{
        return self.recommendationDataArray.count;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"Collection tag: %d",collectionView.tag );
    if(collectionView.tag == 1){ // this is the product images collection view
        ProductImageCollectionViewCell* cell = (ProductImageCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProductImageCell" forIndexPath:indexPath];
       // cell.prodImage.image = [UIImage imageNamed:self.product.prodImage ];
        [cell.prodImage sd_setImageWithURL:[NSURL URLWithString:[self.product.prodImage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] placeholderImage:[UIImage imageNamed:@"Default_imageHolder.png"] options:SDWebImageRetryFailed];
//        cell.discountAmountLabel.text = [NSString stringWithFormat:@"%@",@(arc4random_uniform(90)+1)];
        cell.discountAmountLabel.text = self.randomDiscount;
        return cell;
        
    }else{
        ProductRecommendationCollectionViewCell* cell = (ProductRecommendationCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendationCell" forIndexPath:indexPath];
        cell.layer.cornerRadius=2.5f;
       // cell.productImage.image=[UIImage imageNamed:self.product.prodImage];
         [cell.productImage sd_setImageWithURL:[NSURL URLWithString:[self.product.prodImage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ] placeholderImage:[UIImage imageNamed:@"Default_imageHolder.png"]];

        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
    NSLog(@"Cell : %@", NSStringFromCGRect(cell.frame));
//           cell.frame = CGRectMake(self.productImageCollectionView.frame.size.width * indexPath.row, cell.frame.origin.y, self.productImageCollectionView.frame.size.width, self.productImageCollectionView.frame.size.height);

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1){
        return self.productImageCollectionView.frame.size;
    }else{
        CGSize defaultSize = [(UICollectionViewFlowLayout*)collectionViewLayout itemSize];
        return defaultSize;
    }
}


- (IBAction)pageControlChanged:(UIPageControl *)sender {
    UIPageControl *pageControl = sender;
    CGFloat pageWidth = self.productImageCollectionView.frame.size.width;
    CGPoint scrollTo = CGPointMake(pageWidth * pageControl.currentPage, 0);
    [self.productImageCollectionView setContentOffset:scrollTo animated:YES];
}

- (IBAction)sizeButtonSelected:(id)sender {
    UIButton* selectedButton = (UIButton*) sender;
    for (UIButton* button in self.sizeButtonCollectionView){
        [button setBackgroundImage:[UIImage imageNamed:@"sizebox_normal"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [selectedButton setBackgroundImage:[UIImage imageNamed:@"sizebox_selected"] forState:UIControlStateNormal];
    [selectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)locateProduct:(UIButton *)sender {
//    StoreLocationMapViewController* storeMap = [GlobalVariables getStoreMap];
//    [[SlideNavigationController sharedInstance] pushViewController:storeMap animated:YES];
    [GlobalVariables loadStoreMapScreen:_product fromMenu:NO];
}

- (IBAction)addProductToCart:(id)sender {
   
        NSDictionary* tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:self.product,@"product",[NSNumber numberWithInteger:1],@"quantity", nil];
//    self.cartButton.titleLabel.textColor=[UIColor whiteColor];
        CartItem* cartItem = [[CartItem alloc] initWithDictionary:tempDic];
        [GlobalVariables addItemToCart:cartItem];
    [self updateUserActivityState:self.viewProductActivity];
    [self.cartButton setTitle:@"  ADDED TO CART" forState:UIControlStateNormal];
    self.cartButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBoldItalic" size:14];
    [self.cartButton setBackgroundColor:[UIColor colorWithRed:74/255.00 green:170/255.00 blue:192/255.00 alpha:1.0]];
}

- (IBAction)highlightAddToCartButton:(id)sender {
    [self.cartButton setBackgroundColor:[UIColor colorWithRed:60/255.00 green:145/255.00 blue:165/255.00 alpha:1.0]];
}

- (IBAction)colorButtonSelected:(id)sender {
    UIButton* selectedButton = (UIButton*) sender;
    for (UIButton* button in self.colorButtonCollectionView){
        [button setBackgroundImage:[UIImage imageNamed:@"Color_box_normal"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [selectedButton setBackgroundImage:[UIImage imageNamed:@"Color_box_selected"] forState:UIControlStateNormal];
    [selectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.productImageCollectionView.frame.size.width;
    self.pageControl.currentPage = self.productImageCollectionView.contentOffset.x / pageWidth;
}

-(void) setupPageControlForProductImagesCollectionView
{
    if(self.productImagesArray.count > 0)
    {
        self.pageControl.currentPage = 0; // set the current page for pagecontrol
        self.pageControl.numberOfPages = self.productImagesArray.count;
    }else{
        self.pageControl.hidden = YES;
    }
}
-(void)backToPreviousScreen{
    [self.navigationController popViewControllerAnimated:YES];
   // [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
}

-(void)loadProductDetails
{
    self.productName.text = self.product.prodName;
    self.productDescription.text = self.product.prodDescription;
    self.productPrice.text = self.product.price;
    self.productCostBaseLabel.text = self.product.price;
}

-(void)setColorButtonsRoundedCorner{
    for (UIButton* button in self.colorButtonCollectionView){
        button.layer.cornerRadius = 6;
    }
}


@end
