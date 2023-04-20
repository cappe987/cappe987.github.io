---
title: "Hexend"
description: "
Send hexdumps copied from Tcpdump/Wireshark. Easily repeat and manually modify useful or problematic frames instead of relying on pcap playback.
"

date: 2023-04-16
showReadingTime: false
showDate: false
showDescription: true
draft: true
---

Send hexdumps copied from Tcpdump/Wireshark. Save the hexdump in a file and
give it to `hexend` to send it on an interface. Useful for repeating a specific
captured frame, instead of making a pcap playback or trying to recreate it
using tools like [Nemesis](https://github.com/libnet/nemesis) or
[EasyFrames](https://github.com/microchip-ung/easyframes). It is also possible
to write the frame by hand if you so wish.


## GitHub repository
{{< github repo="cappe987/hexend" >}}


## Using Hexend
The input may only contain hexadecimal characters and whitespace.

Send a frame from file to eth0. Repeats until stopped.

```
hexend eth0 my_frames/frame.hex
```

Send a frame from file, repeat 10 times and suppress output

```
hexend eth0 my_frames/frame.hex -c 10 -q
```

Pipe file contents to input, repeat 5 times with 0.1 second interval

```
cat my_frames/frame.hex | hexend eth0 -c 5 -i 0.1
```

Pipe raw string to input, repeat 1000 times with no interval

```
echo ffffffffffffaaaaaaaaaaaa0000 | hexend eth0 -c 1000 -i 0
```


## Alternative
If you just want a simple alternative to this you can use a script like
```
#!/bin/sh
cat $2 | xxd -r -p | socat -u STDIN interface:$1
```
that will behave like Hexend regarding the input, but does not support any
flags. Looping this is also very inefficient for sending many frames quickly.
