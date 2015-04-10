//
//  ProductDetailViewController.m
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/31/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ViewController.h"

@interface ProductDetailViewController ()
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
    
    //self.scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,  self.contentView.frame.size.height);
    
    [self setupPageControlForProductImagesCollectionView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [SlideNavigationController sharedInstance].navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Product Details";
    
    [self loadProductDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell.prodImage.image = [UIImage imageNamed: @"jacket.jpg"];
        return cell;
        
    }else{
        ProductRecommendationCollectionViewCell* cell = (ProductRecommendationCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendationCell" forIndexPath:indexPath];
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
    ViewController* temp = [ViewController getInstance];
    [temp.productNavigationViewController popViewControllerAnimated:YES];
}

- (IBAction)addProductToCart:(id)sender {
        NSDictionary* tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:self.product,@"product",[NSNumber numberWithInteger:1],@"quantity", nil];
        CartItem* cartItem = [[CartItem alloc] initWithDictionary:tempDic];
        [GlobalVariables addItemToCart:cartItem];
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
}
@end
