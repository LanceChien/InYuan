//
//  SDCursorView.h
//  SDPagesSelector
//
//  Created by gang on 18/7/15.
//  Copyright © 2018年 songdh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHMenuPageScrollView;
@class ZHMenuPageScrollViewPageItem;
@protocol ZHMenuPageScrollViewDelegate<NSObject>

@optional

- (void)pageScrollViewDidSelectedPageItem:(ZHMenuPageScrollViewPageItem *)selectedPageItem
                    WithSelectedItemIndex:(NSInteger)selectedItemIndex;

@end

@interface ZHMenuPageScrollView : UIView

@property (nonatomic, copy) NSArray *pageMenu;
//@property (nonatomic, copy) NSArray *pageMenu2;
@property (nonatomic, copy) NSArray *menuPageControllers;

- (instancetype)initWithParentController:(UIViewController *)parentController
                              MenusPages:(NSArray *)pages;

- (void)updateSelectedPage;

@end

@interface ZHMenuPageScrollViewPageItem :UICollectionViewCell

@property (nonatomic, strong) UILabel *itemNameLabel;

@property (nonatomic, copy) NSString *itemName;

@end;

