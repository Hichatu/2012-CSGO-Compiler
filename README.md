# 2012-CSGO-Compiler
This is a version of Valve's VRAD.exe and VBSP.exe from 2012.

Since the Wildfire update, the new versions of vrad.exe have forced mappers to use StaticPropLighting if they want their props to be properly lit.
This old version of vrad doesn't come with that issue, which means you can use the old prop lighting technique and cut filesize down drastically, since vertex lighting isn't used here.

This contains the whole bin folder from CSGO in 2012, but you only need the vrad.exe and vbsp.exe for the trick to work.

Guide:
-Download the zip, and extract it somewhere
-Go into Hammer World Editor -> Tools -> Options -> Build Programs
-Where it says "BSP executable", "Browse" to the vbsp.exe you just downloaded
-Same step as previous but for "RAD executable" and vrad.exe
-Hit OK / Apply
-Put this into your VRAD parameters during "Expert Compile": -textureshadows -hdr -StaticPropPolys -game $gamedir $path\$file
-Most of the above mentioned parameters are probably already there, but it's just to make sure
-Compile your map, and check the filesize against a regular compile

You should only use this when absolutely necessary, and if you know what you're doing. I'm not responsible for any of your mistakes!
Thanks to Niceshot for sharing this method with me!

(I don't take credit for finding this, I'm just sharing it)
