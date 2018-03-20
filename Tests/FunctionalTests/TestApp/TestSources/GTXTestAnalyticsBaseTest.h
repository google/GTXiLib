#import "GTXTestBaseTest.h"


/**
 Base test case class for analytics related tests.
 */
@interface GTXTestAnalyticsBaseTest : GTXTestBaseTest

/**
 Analytics events detected so far.
 */
@property (nonatomic, assign) NSInteger analyticsEventCount;

@end
