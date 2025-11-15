#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.jonathan.EFB";

/// The "prm" asset catalog color resource.
static NSString * const ACColorNamePrm AC_SWIFT_PRIVATE = @"prm";

/// The "MSFS" asset catalog image resource.
static NSString * const ACImageNameMSFS AC_SWIFT_PRIVATE = @"MSFS";

/// The "Simbrief" asset catalog image resource.
static NSString * const ACImageNameSimbrief AC_SWIFT_PRIVATE = @"Simbrief";

/// The "ifatc" asset catalog image resource.
static NSString * const ACImageNameIfatc AC_SWIFT_PRIVATE = @"ifatc";

#undef AC_SWIFT_PRIVATE
