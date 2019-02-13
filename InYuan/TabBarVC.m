//
//  TabBarVC.m
//  InYuan
//
//  Created by Lance on 2019/2/3.
//  Copyright © 2019 Lance. All rights reserved.
//

#import "TabBarVC.h"

@interface TabBarVC ()

@end

@implementation TabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex=0;
    
    //self.tabBarController.tabBarItem 
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"Tab ViewWillDisappear");
    //self.definesPresentationContext = YES;
    //self.modalPresentationStyle = UIModalPresentationCurrentContext;//关键语句，必须有
    

}
- (IBAction)tabBArLongPress:(id)sender {
    if(![[GlobalData sharedManager]remoteMode]){
        NSLog(@"tabBar long press");
        [[GlobalData sharedManager]setRemoteMode:YES];
        [self performSegueWithIdentifier:@"remoteSegue" sender:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
