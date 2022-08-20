# 2012-CSGO-Compiler
CSGO's bin/ folder from 2012.

Since the Wildfire update, the new versions of vrad.exe have forced mappers to use StaticPropLighting if they want their props to be properly lit.
This old version of vrad doesn't come with that issue, which means you can use the old prop lighting technique and cut filesize down drastically, since vertex static prop lighting isn't used here.
 
#### Guide:
Make a backup of your Counter-Strike Global Offensive/bin folder, you can also rename it to binX or something similar
Download this bin folder, and throw it into Counter-Strike Global Offensive/
You will need to create a .bat file in order to compile your map, see below for an example you can edit and run
Run the .bat file when you want to compile your map, you will need to switch between bin folders!
Switch back when you need to open Hammer or CSGO

##### Example .bat file to compile your map
```
cd FULL_PATH_TO_BIN_FOLDER
vbsp.exe -game "PATH_TO_csgo/" "PATH_TO_vmf (do not include .vmf)"
vvis.exe -game "PATH_TO_csgo/" "PATH_TO_vmf (do not include .vmf)"
vrad.exe -hdr -staticproppolys -game "PATH_TO_csgo/" "PATH_TO_vmf (do not include .vmf)"
```



##### OLD Guide (OBSOLETE WITH A RECENT CSGO UPDATE):  
Download the zip, and extract it somewhere  
Go into Hammer World Editor -> Tools -> Options -> Build Programs  
Where it says "BSP executable", "Browse" to the vbsp.exe you just downloaded  
Same step as previous but for "RAD executable" and vrad.exe  
Hit OK/Apply  
Put this into your VRAD parameters during "Expert Compile": -textureshadows -hdr -StaticPropPolys -game $gamedir $path\$file  
Most of the above mentioned parameters are probably already there, but it's just to make sure  
Compile your map  


You should only use this when absolutely necessary, and if you know what you're doing. I'm not responsible for any of your mistakes!  
Thanks to Niceshot for sharing the bin folder.
