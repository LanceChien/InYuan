//
//  SongTableVC.m
//  InYuan
//
//  Created by Lance on 2019/2/9.
//  Copyright © 2019 Lance. All rights reserved.
//

#import "SongTableVC.h"
#import "SongCell.h"
#import "GlobalData.h"
#import "SongItem.h"

@interface SongTableVC ()

//@property (nonatomic, strong) NSArray *resultArray;

@end

@implementation SongTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
-(instancetype)initWithMenu:(NSInteger)menu1 andMenu2:(NSInteger)menu2{
    if(self=[super init]){
        GlobalData *sharedManager=[GlobalData sharedManager];
        _resultArray=[sharedManager.dbHelper searchByMenu:menu1 andMenu2ID:menu2 andWord:0 andBegin:0 andCount:30];
    }
    return self;
    /*SongItem *sItem=[SongItem new];
    if(_resultArray.count>0){
        sItem=[_resultArray objectAtIndex:0];
        NSLog(@"self:%@,name %@,array count %ld",self,sItem.name,_resultArray.count);
    }*/
        //[NSArray arrayWithArray:[GlobalData sharedManager].resultArray];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GlobalData *sharedManager=[GlobalData sharedManager];
    /*if(sharedManager.menu1Selected==3){
        static NSString *cellID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text=[_resultArray objectAtIndex:indexPath.row];
        return cell;
    }*/
    static NSString *cellID = @"songCell";
    SongCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"songCell" bundle:nil] forCellReuseIdentifier:@"songCell"];
        cell =[tableView dequeueReusableCellWithIdentifier:@"songCell"];
        //initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    SongItem *songItem=[_resultArray objectAtIndex:indexPath.row];
    cell.name.text=songItem.name;//@"name";
    //NSLog(@"name:%@",cell.name.text);
    cell.sID.text=songItem.sID;//[NSString stringWithFormat:@"%ld",indexPath.row];
    cell.singer.text=songItem.singer;// @"singer";
    cell.tmp1.text=@"E";
    cell.tmp2.text=@"MIDI";
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
