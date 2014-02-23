HLElasticView
============

HLElasticView is a UIView subclass that supports elastic snapping. It is inspired by UIScrollView's rubber band bouncing and [Facebook Paper](http://www.facebook.com/paper).

HLElasticView uses [CADisplayLink](https://developer.apple.com/library/ios/documentation/QuartzCore/Reference/CADisplayLink_ClassRef/Reference/Reference.html) to simulate spring damping and takes flick velocity into account. Spring and damping constants are defined in HLElasticView.m and can be modified to change the elasticity.