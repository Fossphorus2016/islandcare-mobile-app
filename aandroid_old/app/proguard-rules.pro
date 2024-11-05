# Keep all annotations
-keepattributes *Annotation*

# Keep the errorprone and javax.annotation classes
-keep class com.google.errorprone.annotations.** { *; }
-keep class javax.annotation.** { *; }
