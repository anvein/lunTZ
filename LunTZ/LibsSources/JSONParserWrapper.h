#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSONParserWrapper : NSObject

- (NSDictionary<NSString *, id> *)parseJSON:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
