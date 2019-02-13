//
//  SDCursorView.h
//  SDPagesSelector
//
//  Created by gang on 18/7/15.
//  Copyright © 2018年 songdh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Menu2;
@class MenuItem;
@protocol ZHMenuPageScrollViewDelegate<NSObject>

@optional

- (void)pageScrollViewDidSelectedPageItem:(MenuItem *)selectedPageItem
                    WithSelectedItemIndex:(NSInteger)selectedItemIndex;

@end

@interface Menu2 : UIView

@property (nonatomic, copy) NSArray *pageMenus;

@property (nonatomic, copy) NSArray *menuPageControllers;
@property (nonatomic, strong) UIViewController *parentViewController;
//@property (nonatomic, assign) NSInteger didSelectedIndex;

-(void)selecedPageWithItemIndexPath:(NSIndexPath*)indexPath;

- (instancetype)initWithParentController:(UIViewController *)parentController
                              MenusPages:(NSArray *)pages;
//- (instancetype)initWithParentController:(UIViewController *)parentController;

- (void)updateSelectedPage;

@end

@interface MenuItem :UICollectionViewCell

@property (nonatomic, strong) UILabel *itemNameLabel;

@property (nonatomic, copy) NSString *itemName;

@end;

