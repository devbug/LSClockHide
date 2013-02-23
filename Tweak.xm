#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface SBAwayBulletinListController : UIViewController
@end


@interface SBAwayBulletinListView : UIView
@end


@interface SBAwayView : UIView
- (UIView *)topBar;
- (BOOL)isShowingMediaControls;
@end

@interface SBAwayView (NEW)
- (void)setVisibleHeaderViews:(BOOL)visible;
@end




%hook SBAwayView

%new
- (void)setVisibleHeaderViews:(BOOL)visible {
	if (visible) {
		self.topBar.alpha = 1.0f;
		self.topBar.hidden = NO;
	} else {
		self.topBar.alpha = 0.0f;
		self.topBar.hidden = YES;
	}
}

- (void)showMediaControls {
	%orig;
	
	[self setVisibleHeaderViews:YES];
}
- (void)hideMediaControls {
	%orig;
	
	[self setVisibleHeaderViews:NO];
}
- (void)updateInterface {
	%orig;
	
	[self setVisibleHeaderViews:self.isShowingMediaControls];
}

%end


%hook SBAwayController

- (BOOL)shouldShowLockStatusBarTime {
	return YES;
}

%end


%hook SBAwayBulletinListView

- (void)setFrame:(CGRect)frame {
	SBAwayView *awayView = (SBAwayView *)self.superview;
	CGRect newFrame = CGRectMake(frame.origin.x, awayView.topBar.frame.origin.y, frame.size.width, frame.size.height + frame.origin.y);
	%orig(newFrame);
}

%end


%hook SBAwayBulletinListController

- (void)setViewRect:(CGRect)frame {
	SBAwayView *awayView = (SBAwayView *)self.view.superview;
	CGRect newFrame = CGRectMake(frame.origin.x, awayView.topBar.frame.origin.y, frame.size.width, frame.size.height + frame.origin.y);
	%orig(newFrame);
}

%end


