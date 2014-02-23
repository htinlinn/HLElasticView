HLElasticView
============

HLElasticView is a UIView subclass that supports elastic snapping. It is inspired by UIScrollView's rubber band bouncing and [Facebook Paper](http://www.facebook.com/paper).

HLElasticView takes flick velocity into account and uses [CADisplayLink](https://developer.apple.com/library/ios/documentation/QuartzCore/Reference/CADisplayLink_ClassRef/Reference/Reference.html) to update view positions. Spring and damping constants are defined in HLUtility.h and can be modified to change the elasticity.