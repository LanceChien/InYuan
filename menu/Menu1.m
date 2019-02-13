//
//  Menu1.m
//  SDPagesSelector
//
//  Created by Lance on 2019/2/10.
//  Copyright © 2019 songdh. All rights reserved.
//

#import "Menu1.h"
#import "SecondViewController.h"
#import "GlobalData.h"

@interface Menu1 ()

@property (nonatomic, assign) NSInteger didSelectedIndex;

@end

@implementation Menu1

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_didSelectedIndex == indexPath.item) { return; }
    _didSelectedIndex = indexPath.item;
    [self selecedPageWithItemIndexPath:indexPath];
    NSLog(@"Menu1: %ld selected",indexPath.row);
    [GlobalData sharedManager].menu1Selected=indexPath.row;
    [GlobalData sharedManager].menu2Selected=0;

    SecondViewController *vc=(SecondViewController *)self.parentViewController;
    [vc reloadMenu2];
    //[self reloadMenu2];
}

-(void)reloadMenu2{
    SecondViewController *vc=(SecondViewController *)self.parentViewController;
    [vc reloadMenu2];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
