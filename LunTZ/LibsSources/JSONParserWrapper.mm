#import "JSONParserWrapper.h"
#include <tao/json.hpp>

using namespace tao::json;

@implementation JSONParserWrapper

- (id)convertJsonValue:(const value &)val {
    switch (val.type()) {
        case type::STRING:
            return [NSString stringWithUTF8String:val.get_string().c_str()];
        case type::SIGNED:
            return @(val.get_signed());
        case type::UNSIGNED:
            return @(val.get_unsigned());
        case type::DOUBLE:
            return @(val.get_double());
        case type::BOOLEAN:
            return @(val.get_boolean());
        case type::NULL_:
            return [NSNull null];
        case type::OBJECT: {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (const auto &kv : val.get_object()) {
                dict[@(kv.first.c_str())] = [self convertJsonValue:kv.second];
            }
            return dict;
        }
        case type::ARRAY: {
            NSMutableArray *array = [NSMutableArray array];
            for (const auto &elem : val.get_array()) {
                [array addObject:[self convertJsonValue:elem]];
            }
            return array;
        }
        default:
            return [NSNull null];
    }
}

- (NSDictionary<NSString *, id> *)parseJSON:(NSString *)jsonString {
    @try {
        try { 
            std::string input([jsonString UTF8String]);
            tao::json::value v = tao::json::from_string(input);

            if (v.type() != tao::json::type::OBJECT) {
                @throw [NSError errorWithDomain:@"JSONParser"
                                           code:1
                                       userInfo:@{NSLocalizedDescriptionKey:@"Root is not an object"}];
            }

            return [self convertJsonValue:v];

        } catch (const std::exception &e) {
            @throw [NSError errorWithDomain:@"JSONParser"
                                       code:2
                                   userInfo:@{NSLocalizedDescriptionKey: @(e.what())}];
        }
    } @catch (NSException *exception) {
        @throw [NSError errorWithDomain:@"JSONParser"
                                   code:3
                               userInfo:@{NSLocalizedDescriptionKey: exception.reason ?: @"Unknown error"}];
    }
}

@end
