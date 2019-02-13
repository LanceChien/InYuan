//
//  SecondViewController.h
//  InYuan
//
//  Created by Lance on 2019/1/28.
//  Copyright © 2019 Lance. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SDCursorView.h"

@interface SecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIButton *firstMenuMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondMenuMoreBtn;

-(void)reloadMenu2;
-(void)reloadTable;

@end

