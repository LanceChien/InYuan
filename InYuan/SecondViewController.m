//
//  SecondViewController.m
//  InYuan
//
//  Created by Lance on 2019/1/28.
//  Copyright © 2019 Lance. All rights reserved.
//

#import "SecondViewController.h"
//#import "SDCursorView.h"
#import "Menu1.h"
#import "Menu2.h"
#import "SongTableVC.h"
#import "Masonry.h"
#import "DatabaseHelper.h"
#import "GlobalData.h"

@interface SecondViewController ()
@property (nonatomic, strong) Menu1 *menu1;
@property (nonatomic, strong) Menu2 *menu2;
@property (nonatomic, strong) NSArray *pagesArray1;
@property (nonatomic, strong) NSArray *pagesArray2;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpMenu1];
    [self setUpMenu2];
    //[self getSongData];
}
/*
-(void)getSongData{
    if([GlobalData sharedManager].menu1Selected==0 && [GlobalData sharedManager].menu2Selected==0)
       [[GlobalData sharedManager].dbHelper searchByLang:@"C" andWord:@"1" andBegin:@"0" andCount:@"30"];
}*/
-(void)reloadTable{
    DatabaseHelper *dbHelper=[DatabaseHelper new];
    GlobalData *sharedManager=[GlobalData sharedManager];
    sharedManager.resultArray=[sharedManager.dbHelper searchByLang:@"T" andWord:@"1" andBegin:@"0" andCount:@"30"];
    SongTableVC *vc;//=[SongTableVC new];
    vc=[_menu2.menuPageControllers objectAtIndex:[GlobalData sharedManager].menu2Selected];
    [vc.tableView reloadData];
}
-(void)reloadMenu2{
    [_menu2 removeFromSuperview];
    _menu2=nil;
    _pagesArray2=nil;
    [self setUpMenu2];
}

- (void)setUpMenu2 {
    self.menu2.pageMenus = self.pagesArray2;
    [self.menu2 updateSelectedPage];
}

- (Menu2 *)menu2 {
    GlobalData *sharedManager=[GlobalData sharedManager];
    if (!_menu2) {
        NSMutableArray *contrors = [NSMutableArray array];
        for (int i=0;i<_pagesArray2.count;i++){
            SongTableVC *controller = [[SongTableVC alloc]initWithMenu:sharedManager.menu1Selected andMenu2:i];
            //[controller initWithMenu:sharedManager.menu1Selected andMenu2:i];
            //controller.content = title;
            [contrors addObject:controller];
        }
        _menu2 = [[Menu2 alloc]initWithParentController:self MenusPages:contrors];
        _menu2.menuPageControllers = [contrors copy];
        [self.view addSubview:_menu2];
        [_menu2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view);
            make.width.equalTo(self.view);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.view).offset(60);
        }];
        MASAttachKeys(_menu2);
    }
    return _menu2;
}

- (NSArray *)pagesArray2 {
    if (!_pagesArray2) {
        NSArray *tempArray=[GlobalData sharedManager].menu2Array;
        _pagesArray2=[tempArray objectAtIndex:[GlobalData sharedManager].menu1Selected];
    }
    return _pagesArray2;
}





- (void)setUpMenu1 {
    self.menu1.pageMenus = self.pagesArray1;
    [self.menu1 updateSelectedPage];
}

- (Menu1 *)menu1 {
    if (!_menu1) {
        NSMutableArray *contrors = [NSMutableArray array];
        for (NSString *title in self.pagesArray1) {
            UIViewController *controller = [[UIViewController alloc]init];
            //controller.content = title;
            [contrors addObject:controller];
        }
        _menu1 = [[Menu1 alloc]initWithParentController:self MenusPages:nil];
        _menu1.menuPageControllers = [contrors copy];
        
        [self.view addSubview:_menu1];
        [_menu1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view);
            make.width.equalTo(self.view);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.view).offset(20);
        }];
        MASAttachKeys(_menu1);
    }
    return _menu1;
}

- (NSArray *)pagesArray1 {
    if (!_pagesArray1) {
        _pagesArray1 = [GlobalData sharedManager].menu1Array;
    }
    return _pagesArray1;
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"Tab ViewWillDisappear");
    self.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;//关键语句，必须有
    
    
}

@end
