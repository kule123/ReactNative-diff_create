

#import <JSONModel/JSONModel.h>

@interface DYHotUpdateDataModel : JSONModel

@property (nonatomic,copy) NSString *app_version;
@property (nonatomic,copy) NSString *b_version;
@property (nonatomic,copy) NSString *ios_zip;
@property (nonatomic,copy) NSString *md5;
@property (nonatomic,copy) NSString *ios_zip_patch_md5;
@property (nonatomic,copy) NSString *ios_zip_name;
@end
