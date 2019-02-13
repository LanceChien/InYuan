//
//  SongTableVC.h
//  InYuan
//
//  Created by Lance on 2019/2/9.
//  Copyright © 2019 Lance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SongTableVC : UITableViewController
@property (nonatomic, assign) NSInteger menu1ID;
@property (nonatomic, assign) NSInteger menu2ID;
@property (nonatomic, strong) NSArray *resultArray;
-(instancetype)initWithMenu:(NSInteger)menu1 andMenu2:(NSInteger)menu2;
@end

NS_ASSUME_NONNULL_END
