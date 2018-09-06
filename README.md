# OpenNotifier App Icon Creator
Create full color Application icon images for use with OpenNotifier.

By default, images are created at a scale of 0.7 (70%). You can change the scale with the '-s' option to any value between 0.25 and 1.0.

Create icon images for the Messages App at the default scale (70%)

	ONICreator -c 1 -n Messages

Create icon images for the Messages App at 100% scale

	ONICreator -c 1 -n Messages -s 1.0

Delete icon images for the Messages App

	ONICreator -c 0 -n Messages

The '-n' option takes an AppName or ExecutableName.

You must respring for changes to take effect.

Images are saved to

	/System/Library/Frameworks/UIKit.framework/Silver_ON_AppName ONI.png
	/System/Library/Frameworks/UIKit.framework/Black_ON_AppName ONI_Color.png
	/System/Library/Frameworks/UIKit.framework/White_ON_AppName ONI_Color.png

	/System/Library/Frameworks/UIKit.framework/Silver_ON_AppName ONI@2x.png
	/System/Library/Frameworks/UIKit.framework/Black_ON_AppName ONI_Color@2x.png
	/System/Library/Frameworks/UIKit.framework/White_ON_AppName ONI_Color@2x.png

	/System/Library/Frameworks/UIKit.framework/Silver_ON_AppName ONI@3x.png
	/System/Library/Frameworks/UIKit.framework/Black_ON_AppName ONI_Color@3x.png
	/System/Library/Frameworks/UIKit.framework/White_ON_AppName ONI_Color@3x.png

	/System/Library/Frameworks/UIKit.framework/LockScreen_ON_AppName ONI.png
	/System/Library/Frameworks/UIKit.framework/LockScreen_ON_AppName ONI_Color.png

	/System/Library/Frameworks/UIKit.framework/LockScreen_ON_AppName ONI@2x.png
	/System/Library/Frameworks/UIKit.framework/LockScreen_ON_AppName ONI_Color@2x.png

	/System/Library/Frameworks/UIKit.framework/LockScreen_ON_AppName ONI@3x.png
	/System/Library/Frameworks/UIKit.framework/LockScreen_ON_AppName ONI_Color@3x.png"
