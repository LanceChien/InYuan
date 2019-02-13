//
//  SongCell.h
//  InYuan
//
//  Created by Lance on 2019/2/7.
//  Copyright © 2019 Lance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SongCell : UITableViewCell

//歌名
@property (weak, nonatomic) IBOutlet UILabel *name;
//曲號
@property (weak, nonatomic) IBOutlet UILabel *sID;
//歌手
@property (weak, nonatomic) IBOutlet UILabel *singer;
//
@property (weak, nonatomic) IBOutlet UILabel *tmp1;
//
@property (weak, nonatomic) IBOutlet UILabel *tmp2;

@end

NS_ASSUME_NONNULL_END
