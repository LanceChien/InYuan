//
//  HomeVC.h
//  InYuan
//
//  Created by Lance on 2019/2/6.
//  Copyright © 2019 Lance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@end

NS_ASSUME_NONNULL_END
