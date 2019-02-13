#import "FMDB.h"
#import "SongItem.h"
#import "UserItem.h"
#import "KRoomItem.h"
#import "SongQueueListItem.h"

@interface DatabaseHelper : NSObject

//create Database, SongTable and KRoomTable
-(void)createDB;
//delete Database or table, for debug purpose
-(void)deleteDB;
-(void)deleteTable;

//SongBook VC middle ware
-(NSArray *)searchByMenu:(NSInteger)menu1ID andMenu2ID:(NSInteger)menu2ID andWord:(NSInteger)word andBegin:(NSInteger)begin andCount:(NSInteger)count;

//讀取JSON曲庫並且寫入到資料庫
-(void)parseJSONToDBFromFile;
-(void)parseJSONToDBFromData:(NSData *)data;

//我的K房
//新增User
-(void)addUserToKRoom:(NSString *)userName;
//列出所有User
-(NSArray *)searchAllUser;
//新增最愛歌曲到User的K房
-(void)addToKRoom:(KRoomItem *)kItem;
//列出User的最愛歌曲,錄音,錄影
-(NSArray *)searchByKRoom:(NSString *)userName andType:(NSString *)type;



/* Search Function */
//根據 SongID 搜尋歌曲
-(SongItem *)searchByID:(NSString *)songID;
//語言選歌 SPEC p14 API p59 @"":列出九種語言 C:國語 T:台語 K:客語 GD:粵語 E:英文 J:日文 KR:韓文 TH:泰文 VN:越文, word是字部，1~8,9:9以上,其他:不分字部
//begin:搜尋結果從begin開始取，count是取出的筆數
-(NSArray *)searchByLang:(NSString *)lang andWord:(NSInteger)word andBegin:(NSInteger)begin andCount:(NSInteger)count;
//列出音圓之星
-(NSArray *)searchIYStar;
//列出音圓歌曲
-(NSArray *)searchIYSong;
//列出歌手 p.14 (lang:[C:華語 F:外語])(gender:[0:其他 1:男 2:女 3:對唱 4:團體])
-(NSArray *)searchBySinger:(NSString *)lang andGender:(NSInteger)gender andBegin:(NSInteger)begin andCount:(NSInteger)count;
//最新歌曲
//還未決定
//常唱歌曲 API p.38
//等待實作
//對唱 SPEC p.14 API duet:p.56 lang:p58 @"":列出以下五個選項 C:國語 T:台語 GD:粵語 E:英文 J:日文 ok
-(NSArray *)searchByDuet:(NSString *)lang;
//經典懷舊 SPEC p.14 API p.59 0:列出以下六個選項 1:國語經典 2:台語經典 3:民歌年代 4:台灣歌謠 5:西洋經典 6:東洋經典 ok
-(NSArray *)searchByNost:(NSString *)nost;
//音域 SPEC p.14 API lang:p58 @"":列出以下3個選項 C:國語 T:台語 GD:粵語 range:p.63
-(NSArray *)searchByRange:(NSString *)lang andRange:(NSString *)range;
//舞曲 SPEC p.14 API dance:p.57 lang:p58 @"":列出以下5個選項 C:國語 T:台語 GD:粵語 E:英文 J:日文
-(NSArray *)searchByDance:(NSString *)lang;
//情境 SPEC p.14 API scen:p60 @"":列出以下6個選項 1:友情不渝 2:愛情萬歲 3:失戀悲歌 4:勵志向上 5:感嘆人生 6:酒場文化
-(NSArray *)searchByScen:(NSString *)scen;
//節奏 SPEC p.14 API scen:p60 @"":列出以下27個選項 
-(NSArray *)searchByTempo:(NSString *)tempo;
//大陸歌曲等 SPEC p.14 API class:p61 other:其他 music:音樂欣賞 CN:大陸 W:會場
-(NSArray *)searchByClass:(NSString *)classCode;
//影音收藏
//等待實作
//關鍵字搜尋歌曲或歌手
-(NSArray *)searchByKeyword:(NSString *)type andKeyword:(NSString *)keyword;


/* Utility */

@end
