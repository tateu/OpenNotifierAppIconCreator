@interface UIImage (Private)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end


@interface LSResourceProxy : NSObject // _LSQueryResult -> NSObject
@property (nonatomic,readonly) NSString *primaryIconName;
@end

@interface LSBundleProxy : LSResourceProxy
@property (nonatomic,readonly) NSString *localizedShortName;
@property (nonatomic,readonly) NSString *bundleExecutable;
@property (nonatomic,readonly) NSString *bundleIdentifier;
@property (nonatomic,readonly) NSString *bundleType;
-(id)localizedName;
@end

@interface LSApplicationProxy : LSBundleProxy
@property (nonatomic,readonly) NSString *itemName;
@property (nonatomic,readonly) NSString *applicationType; // User, System
@property (nonatomic,readonly) NSUInteger installType;
@property (nonatomic,readonly) BOOL hasSettingsBundle;
@property (getter=isLaunchProhibited,nonatomic,readonly) BOOL launchProhibited;
@end

@interface LSApplicationWorkspace : NSObject
+ (id)defaultWorkspace;
- (id)allApplications;
@end

static int createIconsForBundle(NSString *bundleIdentifier, NSString *applicationName, CGFloat scale, BOOL create)
{
	int retVal = 0;
	NSError *error = nil;
	BOOL result = false;

	NSArray *filePaths = @[
		@"/System/Library/Frameworks/UIKit.framework/Silver_ON_%@ ONI.png",
		@"/System/Library/Frameworks/UIKit.framework/Black_ON_%@ ONI_Color.png",
		@"/System/Library/Frameworks/UIKit.framework/White_ON_%@ ONI_Color.png",

		@"/System/Library/Frameworks/UIKit.framework/Silver_ON_%@ ONI@2x.png",
		@"/System/Library/Frameworks/UIKit.framework/Black_ON_%@ ONI_Color@2x.png",
		@"/System/Library/Frameworks/UIKit.framework/White_ON_%@ ONI_Color@2x.png",

		@"/System/Library/Frameworks/UIKit.framework/Silver_ON_%@ ONI@3x.png",
		@"/System/Library/Frameworks/UIKit.framework/Black_ON_%@ ONI_Color@3x.png",
		@"/System/Library/Frameworks/UIKit.framework/White_ON_%@ ONI_Color@3x.png",

		@"/System/Library/Frameworks/UIKit.framework/LockScreen_ON_%@ ONI.png",
		@"/System/Library/Frameworks/UIKit.framework/LockScreen_ON_%@ ONI_Color.png",

		@"/System/Library/Frameworks/UIKit.framework/LockScreen_ON_%@ ONI@2x.png",
		@"/System/Library/Frameworks/UIKit.framework/LockScreen_ON_%@ ONI_Color@2x.png",

		@"/System/Library/Frameworks/UIKit.framework/LockScreen_ON_%@ ONI@3x.png",
		@"/System/Library/Frameworks/UIKit.framework/LockScreen_ON_%@ ONI_Color@3x.png"
	];

	if (create) {
		CGSize homeSize1 = CGSizeMake(20, 20);
		CGSize homeSize2 = CGSizeMake(40, 40);
		CGSize homeSize3 = CGSizeMake(60, 60);
		CGSize lockSize1 = CGSizeMake(24, 24);
		CGSize lockSize2 = CGSizeMake(48, 48);
		CGSize lockSize3 = CGSizeMake(72, 72);

		UIImage *icon = [UIImage _applicationIconImageForBundleIdentifier:bundleIdentifier format:2 scale:[UIScreen mainScreen].scale]; // 120x120 at 2x scale
		if (!icon) {
			fprintf(stderr, "ERROR - could not create image for bundleIdentifier\n");
			return 1;
		}

		CGFloat x, w;

		w = 20 * scale;
		x = (20 - w) / 2.0;
		UIImage *homeIcon1x = nil;
		UIGraphicsBeginImageContextWithOptions(homeSize1, NO, 1);
		[icon drawInRect:CGRectMake(x, x, w, w)];
		homeIcon1x = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();

		w = 40 * scale;
		x = (40 - w) / 2.0;
		UIImage *homeIcon2x = nil;
		UIGraphicsBeginImageContextWithOptions(homeSize2, NO, 1);
		[icon drawInRect:CGRectMake(x, x, w, w)];
		homeIcon2x = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();

		w = 60 * scale;
		x = (60 - w) / 2.0;
		UIImage *homeIcon3x = nil;
		UIGraphicsBeginImageContextWithOptions(homeSize3, NO, 1);
		[icon drawInRect:CGRectMake(x, x, w, w)];
		homeIcon3x = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();

		w = 24 * scale;
		x = (24 - w) / 2.0;
		UIImage *lockIcon1x = nil;
		UIGraphicsBeginImageContextWithOptions(lockSize1, NO, 1);
		[icon drawInRect:CGRectMake(x, x, w, w)];
		lockIcon1x = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();

		w = 48 * scale;
		x = (48 - w) / 2.0;
		UIImage *lockIcon2x = nil;
		UIGraphicsBeginImageContextWithOptions(lockSize2, NO, 1);
		[icon drawInRect:CGRectMake(x, x, w, w)];
		lockIcon2x = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();

		w = 72 * scale;
		x = (72 - w) / 2.0;
		UIImage *lockIcon3x = nil;
		UIGraphicsBeginImageContextWithOptions(lockSize3, NO, 1);
		[icon drawInRect:CGRectMake(x, x, w, w)];
		lockIcon3x = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();

		NSString *iconPath = nil;
		int idx = 0;
		for (NSString *path in filePaths) {
			UIImage *img = nil;
			switch (idx) {
				case 0:
				case 1:
				case 2:
					img = homeIcon1x;
					break;
				case 3:
				case 4:
				case 5:
					img = homeIcon2x;
					break;
				case 6:
				case 7:
				case 8:
					img = homeIcon3x;
					break;
				case 9:
				case 10:
					img = lockIcon1x;
					break;
				case 11:
				case 12:
					img = lockIcon2x;
					break;
				case 13:
				case 14:
					img = lockIcon3x;
					break;
			}
			iconPath = [NSString stringWithFormat:path, applicationName];

			result = [UIImagePNGRepresentation(img) writeToFile:iconPath options:NSDataWritingAtomic error:&error];
			if (!result) {
				fprintf(stderr, "ERROR - could not save image for\n    %s\n    (%ld) %s\n", [iconPath UTF8String], error.code, [error.localizedDescription UTF8String]);
				retVal = 1;
			}

			idx++;
		}
	} else {
		NSString *iconPath = nil;
		for (NSString *path in filePaths) {
			iconPath = [NSString stringWithFormat:path, applicationName];
			if ([NSFileManager.defaultManager fileExistsAtPath:iconPath]) {
				result = [NSFileManager.defaultManager removeItemAtPath:iconPath error:&error];
				if (!result) {
					fprintf(stderr, "ERROR - could not delete file\n    %s\n    (%ld) %s\n", [iconPath UTF8String], error.code, [error.localizedDescription UTF8String]);
					retVal = 1;
				}
			}
		}
	}

	return retVal;
}

static void showHelp()
{
	fprintf(stderr, "Usage:\n");
	fprintf(stderr, "    -n <AppName>            - Application Name or ExecutableName\n");
	fprintf(stderr, "                                'Messages'\n");
	fprintf(stderr, "    -b <AppBundleID>        - Bundle Identifier of the Application\n");
	fprintf(stderr, "                                'com.apple.MobileSMS'\n");
	fprintf(stderr, "    -c <1 | 0>              - Create or delete icons\n");
	fprintf(stderr, "                                default is '1' create icons\n");
	fprintf(stderr, "    -s <scale>              - Icon scale value (0.25 to 1.0)\n");
	fprintf(stderr, "                                default is '0.7'\n");
	fprintf(stderr, "    -h                      - This help file\n");
}

int main(int argc, char **argv, char **envp)
{
	BOOL create = YES;
	BOOL systemIcons = NO;
	BOOL userIcons = NO;
	NSString *applicationName = nil;
	NSString *bundleIdentifier = nil;
	CGFloat scale = 0.7;

	for (int i = 0; i < argc; i++) {
		if (strcmp(argv[i], "--bundle") == 0 || strcmp(argv[i], "-b") == 0) {
			bundleIdentifier = [NSString stringWithUTF8String:argv[++i]];
		} else if (strcmp(argv[i], "--name") == 0 || strcmp(argv[i], "-n") == 0) {
			applicationName = [NSString stringWithUTF8String:argv[++i]];
		} else if (strcmp(argv[i], "--scale") == 0 || strcmp(argv[i], "-s") == 0) {
			scale = [[NSString stringWithUTF8String:argv[++i]] floatValue];
		} else if (strcmp(argv[i], "--create") == 0 || strcmp(argv[i], "-c") == 0) {
			int r = [[NSString stringWithUTF8String:argv[++i]] intValue];
			if (r == 0) {
				create = NO;
			}
		// } else if (strcmp(argv[i], "--system") == 0 || strcmp(argv[i], "-s") == 0) {
		// 	systemIcons = YES;
		// } else if (strcmp(argv[i], "--user") == 0 || strcmp(argv[i], "-u") == 0) {
		// 	userIcons = YES;
		} else if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0) {
			showHelp();
			return 1;
		}
	}

	if ((!systemIcons && !userIcons && !applicationName && !bundleIdentifier)) {
		showHelp();
		return 1;
	}

	if (scale < 0.25 || scale > 1.0) {
		fprintf(stderr, "ERROR - scale must be between 0.25 and 1.0. You set %0.2f\n", scale);
		showHelp();
		return 1;
	}


	LSApplicationWorkspace *applicationWorkspace = [LSApplicationWorkspace defaultWorkspace];
	NSArray *proxies = [applicationWorkspace allApplications];
	BOOL found = NO;
	for (LSApplicationProxy *proxy in proxies) {
		if (userIcons || systemIcons) {
			// skip items that don't have a primaryIconName, they are probably hidden apps
			if ((userIcons && [proxy.applicationType isEqualToString:@"User"]) || (systemIcons && [proxy.applicationType isEqualToString:@"System"])) {
				if (proxy.localizedName && proxy.bundleIdentifier && proxy.primaryIconName) {
					int retVal = createIconsForBundle(proxy.bundleIdentifier, proxy.localizedName, scale, create);
					if (retVal == 0) {
						fprintf(stderr, "Success - images %s for %s (%s)\n", create ? "created" : "deleted", [applicationName UTF8String], [bundleIdentifier UTF8String]);
					} else {
						fprintf(stderr, "ERROR - could not %s images for %s (%s)\n", create ? "create" : "delete", [applicationName UTF8String], [bundleIdentifier UTF8String]);
					}
				}

				found = YES;
			}
		} else {
			if (bundleIdentifier && [bundleIdentifier isEqualToString:proxy.bundleIdentifier]) {
				applicationName = proxy.localizedName;
				found = YES;
			} else if (applicationName) {
				if ([applicationName isEqualToString:proxy.bundleExecutable]) {
					bundleIdentifier = proxy.bundleIdentifier;
					applicationName = proxy.localizedName;
					found = YES;
				} else if ([applicationName isEqualToString:proxy.localizedName]) {
					bundleIdentifier = proxy.bundleIdentifier;
					applicationName = proxy.localizedName;
					found = YES;
				}
			}

			if (found) {
				if (!proxy.primaryIconName) {
					fprintf(stderr, "ERROR - could not find primaryIconName for bundleIdentifier %s\n", [bundleIdentifier UTF8String]);
					return 1;
				}

				if (bundleIdentifier && applicationName) {
					int retVal = createIconsForBundle(bundleIdentifier, applicationName, scale, create);
					if (retVal != 0) {
						fprintf(stderr, "ERROR - could not %s images for %s (%s)\n", create ? "create" : "delete", [applicationName UTF8String], [bundleIdentifier UTF8String]);
						return retVal;
					}

					fprintf(stderr, "Success - images %s for %s (%s)\n", create ? "created" : "deleted", [applicationName UTF8String], [bundleIdentifier UTF8String]);
					fprintf(stderr, "    You need to respring for changes to take effect\n    killall -9 SpringBoard\n");
				}

				break;
			}
		}
	}

	if (!found) {
		if (systemIcons || userIcons) {
			fprintf(stderr, "ERROR - could not find any user and/or system icons\n");
		} else if (applicationName || bundleIdentifier) {
			fprintf(stderr, "ERROR - could not find Application for %s (%s)\n", applicationName ? [applicationName UTF8String] : "", bundleIdentifier ? [bundleIdentifier UTF8String] : "");
		}
	}

	return 0;
}
