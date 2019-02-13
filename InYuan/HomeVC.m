//
//  HomeVC.m
//  InYuan
//
//  Created by Lance on 2019/2/6.
//  Copyright © 2019 Lance. All rights reserved.
//

#import "HomeVC.h"
#import "SongCell.h"
#import "SDCursorView.h"
#import "Masonry.h"

@interface HomeVC ()
@property (nonatomic,strong) UITableView *table;

@property (nonatomic,assign) CGFloat tableViewOffset;
@property (nonatomic,assign) CGFloat topViewOriginTop;
@property (nonatomic,assign) CGFloat moveUpLimit;

@property (nonatomic, strong) ZHMenuPageScrollView *navSliderBar;
@property (nonatomic, strong) NSArray *pagesArray;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"width:%f,height:%f,topView top:%f,height:%f",self.view.frame.size.width,self.view.frame.size.height,_topView.frame.origin.y,_topView.frame.size.height);
    /*
    //_tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    _tableView.contentInset = UIEdgeInsetsMake(_topView.frame.size.height, 0,self.view.frame.size.height-_topView.frame.size.height-64, 0);
    _tableViewOffset = _tableView.contentOffset.y;
    _topViewOriginTop=_topView.frame.origin.y;
    _moveUpLimit=_topView.frame.size.height-40;
    NSLog(@"tableViewOffset:%f,topViewOriginTop:%f",_tableViewOffset,_topViewOriginTop);
    */
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(16, 64, self.view.frame.size.width-32, self.view.frame.size.height-64-49) style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.backgroundColor = [UIColor clearColor];
    self.table.contentInset = UIEdgeInsetsMake(_topView.frame.size.height - 64, 0, 0, 0);
    [self.view addSubview: self.table];
    _tableViewOffset = _table.contentOffset.y;

    [self setUpNavSliderBar];
    //_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setUpNavSliderBar {
    self.navSliderBar.pageMenu = self.pagesArray;
    [self.navSliderBar updateSelectedPage];
}

- (ZHMenuPageScrollView *)navSliderBar {
    if (!_navSliderBar) {
        NSMutableArray *contrors = [NSMutableArray array];
        for (NSString *title in self.pagesArray) {
            //ShowViewController *controller = [[ShowViewController alloc]init];
            UITableViewController *controller = [[UITableViewController alloc]init];

            controller.title = title;
            [contrors addObject:controller];
        }
        _navSliderBar = [[ZHMenuPageScrollView alloc]initWithParentController:self MenusPages:contrors];
        _navSliderBar.menuPageControllers = [contrors copy];
        [self.topView addSubview:_navSliderBar];
        [_navSliderBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userLabel).right.with.offset(10);
            make.right.equalTo(self.view).right.with.offset(10);
            make.top.and.bottom.equalTo(self.userLabel);
            //make.top.equalTo(self.userLabel);
        }];
        MASAttachKeys(_navSliderBar);
    }
    return _navSliderBar;
}

- (NSArray *)pagesArray {
    if (!_pagesArray) {
        _pagesArray = [NSArray arrayWithObjects:@"头条",@"大数据股票财经",@"精选",@"娱乐视",@"热点点附近会计分录的",@"体育",@"科技",@"汽车", nil];
    }
    return _pagesArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *cellID = @"songCell";
    SongCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"songCell" bundle:nil] forCellReuseIdentifier:@"songCell"];
        cell =[tableView dequeueReusableCellWithIdentifier:@"songCell"];
               //initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.name.text=@"name";
    //NSLog(@"name:%@",cell.name.text);
    cell.sID.text=[NSString stringWithFormat:@"%ld",indexPath.row];
    cell.singer.text=@"singer";
    cell.tmp1.text=@"E";
    cell.tmp2.text=@"MIDI";
    
    return cell;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"Will begin dragging");
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"ScrollEnd y %f",y);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"y %f,tableViewOffset %f",y,_tableViewOffset);
    if (_tableViewOffset == 0)
        return;
    
    
    CGRect frame = _topView.frame;
    if (y > _tableViewOffset) {
        NSLog(@"向上");
        self.title = @"";
        frame.origin.y = _tableViewOffset-y;
        if (y>=0) {
            frame.origin.y = _tableViewOffset;
            self.title = @"标题";
        }
        _topView.frame = frame;
    }
    
    else {
        NSLog(@"向下");
        //CGFloat x = self.offset - y;
        //frame = CGRectMake(-x/2, -x/2, self.view.frame.size.width + x, self.view.frame.size.height/3+x);
        //self.image.frame = frame;
    }
    
    
    
    /*
    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"y %f,offset %f",y,_tableViewOffset);
    
    // tableView设置偏移时不能立马获取他的偏移量，所以一开始获取的offset值为0
    if (_tableViewOffset == 0)
        return;
    CGRect frame = _topView.frame;
    UIEdgeInsets contentInset = _tableView.contentInset;
    CGFloat move=y-_tableViewOffset;
    //_moveUpLimit-=40;
    
    CGFloat tableInsetBottom=_tableView.contentInset.bottom;
    NSLog(@"tableContentInsetBottom:%f",tableInsetBottom);
    
    if(move>_moveUpLimit){
        NSLog(@"超過 %f",move);

    }
    else if(move>0 && move<_moveUpLimit){
        NSLog(@"向上%f",move);
        frame.origin.y = _topViewOriginTop-move;
        //if (y>=0)
          //  frame.origin.y = _offset;
        
        _topView.frame = frame;
        //_tableView.contentInset = UIEdgeInsetsMake(_topView.frame.size.height, 0,self.view.frame.size.height-_topView.frame.size.height, 0);

    }else if(move<0){
        CGFloat tableInsetBottom=_tableView.contentInset.bottom;
        NSLog(@"向下%f,tableContentInsetBottom:%f",-move,_tableView.contentInset.bottom);
        //_tableView.contentInset = UIEdgeInsetsMake(_topView.frame.size.height, 0,self.view.frame.size.height-_topView.frame.size.height, 0);

    }
    _tableView.contentInset = UIEdgeInsetsMake(_topView.frame.size.height+64, 0,self.view.frame.size.height-_topView.frame.size.height-64, 0);
*/
    /*
    if (y > _offset) {
        NSLog(@"向上");
        self.title = @"";
        frame.origin.y = _offset-y;
        if (y>=0) {
            frame.origin.y = _offset;
            
        }
        _topViewAll.frame = frame;
    }*/
    /*
    NSLog(@"width:%f,height:%f,topView height:%f",self.view.frame.size.width,self.view.frame.size.height,_topViewAll.frame.size.height);
    _tableView.contentInset = UIEdgeInsetsMake(_topViewAll.frame.size.height-40, 0, _tableView.frame.size.height-_topViewAll.frame.size.height, 0);
    _offset = _tableView.contentOffset.y;
    NSLog(@"offset:%f",_offset);
    */
    // tableView设置偏移时不能立马获取他的偏移量，所以一开始获取的offset值为0
    /*
    else if (_offset == 0) return;

    else {
        NSLog(@"向下");
        CGFloat x = _offset - y;
        //frame = CGRectMake(-x/2, -x/2, self.view.frame.size.width + x, self.view.frame.size.height/3+x);
        _topViewAll.frame = frame;
    }*/
    //NSLog(@"Did Scroll ContentOffset:%f",scrollView.contentOffset.y);
    //NSLog(@"Did Scroll ContentSize:%f",scrollView.contentSize.height);
    //NSLog(@"Did Scroll ContentInset:%f",scrollView.contentInset.top);

    //_tableView.contentSize.height=433-scrollView.contentOffset.y;
    //CGRect frame = _tableView.frame;
    //frame.origin.y=185-scrollView.contentOffset.y;
    //frame.size.height = 433+scrollView.contentOffset.y;
    //scrollView.frame=frame;
    //_tableView.frame = frame;
    //NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    //NSLog(@"table origin %f",_tableView.frame.origin.y);

    //NSLog(@"table origin %f",_tableView.frame.origin.y);
    //CGRect frame2 = _topViewAll.frame;
    //frame2.origin.y=20-scrollView.contentOffset.y;
    //frame2.size.height = 433+scrollView.contentOffset.y;
    //_topViewAll.frame = frame2;
    
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
