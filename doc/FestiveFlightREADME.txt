Festive Flight
==============
A festive, flying (and familiar!) mount in the spirit of the holidays!

Getting Started
===============
The courier should track you down near any major city. He'll deliver a note and the Golden Bell. The note will tell you what to do, but basically go somewhere and ring the bell. You will gain a new Power called Happy Thoughts, and automatically use it. After that, just use Happy Thoughts to summon Rudolph wherever you are.

Some people are having trouble getting the Courier to show up. It's the same courier that the vanilla game uses and works the same way: if you're in a town when you first load the mod, you may need to travel to another town before he'll appear.

Although SKSE and SkyUI are not required to use this mod with its default settings, they are required to edit the controls and options. To be clear: You can install this mod and fly around on Rudolph WITHOUT SKSE. 

SKSE: http://skse.silverlock.org/ 
SkyUI: http://steamcommunity.com/sharedfiles/filedetails/?id=8122 

Flying on Rudolph
=================
Flight controls are similar to the swimming controls. Point the camera where you want to go, and your new mount will do his best to take you there, whether it's on the ground or in the air. 

If you have SKSE (and you really, really should!) you can hold down the Jump button (spacebar by default) to gain altitude no matter where the camera is pointed. This is the easiest way to get airborne.

If you want to get down quickly, you can stop in mid-air and aim the camera STRAIGHT down. After a couple of seconds (this interval can be adjusted in MCM) you will land VERY quickly immediately where you are standing. 

As of version 1.05, Rudolph now will vanish back to whence he came after standing around, unridden, for an hour of game time. This interval can be changed or disabled entirely in the MCM.

Update Notes
============
Version 1.05 may cause the script engine to lag a bit. This is fixed in 1.06, but if you are noticing script lag (Rudolph is falling a lot, other scripts are being delayed) you may need to give the engine time to "catch up". You can either do a clean save (remove the mod, load your game, save, and reinstall the mod), or go somewhere quiet in game and leave it running for an hour or so of REAL (not game) time. You can hit ESC so the game is on the menu if you don't want time to pass in-game. 

This is only needed if you have entered an interior cell while running 1.05 AND you are noticing script lag. Otherwise, you almost certainly won't have this problem.

A Note on Orphaned Objects
==========================
You'll get a note about this as soon as you upgrade from 1.03 or lower. Here are some more details.

Earlier versions of the mod had a bug in the summoning spell that could leave extra objects in memory. This could unnecessarily increase the size of your saved game by a few bytes. They were NOT objects with running scripts and thus do not cause save game corruption. Version 1.05 fixes the original bug and can clean up the offending objects when you reenter the cell they are in.

In other words, yes, you might have a few bytes of the dread "save game bloat" if you summoned Rudolph repeatedly in version 1.03 or lower. Here's a few reasons not to panic and uninstall:
1) It's fixed (yes, I'm sure).
2) It only happened if you used the summoning spell repeatedly. It didn't happen as a result of simply riding/flying around on him or anything else, only actually summoning him.
3) It's not the sort of object that corrupts your save game.
4) It'll get cleaned up as you keep playing.

So no worries, and sorry about the oversight!

Other Festive Mods 
=============== 
Father Christmas Follower: 
http://steamcommunity.com/sharedfiles/filedetails/?id=203337068 

Special Events of Tamriel: 
http://www.nexusmods.com/skyrim/mods/48498 

Saturalia - Christmas in Skyrim: 
http://www.nexusmods.com/skyrim/mods/28093 

Christmas Lanterns 
http://www.nexusmods.com/skyrim/mods/27845 

Updates
=======
v1.07 - The "Hey, look, no game-breaking bugs" release! Fixed a typo that was messing up one of the MCM options, and hopefully made Rudolph a bit easier to steer.
v1.06 - Fixed an issue which caused an extra load on the script engine. See update notes.
v1.05 - Fixed a bad cleanup on the summoning script that could leave empty objects in the savegame. Rudolph now optionally vanishes after being dismounted.
v1.04 - Resolved an issue with the update script that meant some previous fixes weren't getting applied.
v1.03 - Hopefully resolved the problem with Rudolph going berserk and attacking everybody.
v1.02 - Optimized the hoofprint effects script. It should now place considerably less load on the script VM.
v1.01 - Fixed a bug where changes made in MCM weren't always taking effect.
v1.00 - Initial release.

Compatibility
=============
This mod is compatible with everything, as far as I know. It has been specifically tested with Convenient Horses (in fact, I encourage you to use it!) though you may want to hold off on flying until after the faction registration is complete.

It does place a fair load on the scripting engine, but all the scripts are self-limiting and will not bloat your save game. I'm a careful scripter, and whatever other faults my mods have, my scripts are safe.

Troubleshooting
===============
Problem: Rudolph keeps falling to the ground while flying.
Fix: This is probably due to some other mod placing a heavy load on your script engine or your system is having trouble keeping up with the load speed as you rapidly change cells. Try reducing the speed multiplier in the MCM menu: 80% is a good starting point. This both reduces the memory load and allows the script engine more time to catch up. If that doesn't do it, try disabling the sparkling hoofprint effect in MCM.

Problem: I keep bouncing high into the air while I'm trying to fly straight.
Fix: This is a collision problem and happens most often while flying downward at a very shallow angle. Increasing the “Flight Smoothing” in the MCM may help. Or decreasing it. Either might help, it depends heavily on your system and setup. It's pretty rare; if you find it happening to you a lot, let me know.

Problem: The “emergency landing” engages randomly or throws me at weird angles.
Fix: I haven't tracked this one down yet, but you can avoid it 100% by not looking straight down (angles are ok). You can also just disable the Emergency Landing altogether or increase the delay to 5 seconds.

Problem: The mod is crashing my game! 
Fix: It's probably not my mod, but the load caused by rapidly changing cells. If you used the console to speed up the player and ran around you'd probably encounter the same problem. Skyrim just does not handle heavy memory usage very well. Reduce the speed multiplier, or fly higher: if you're high enough most objects don't get loaded and you may have an easier time. 

Other problems? Let me know about them!

Notes
=====
The visual effects, including the glowing nose, can be disabled in the MCM panel. So if you want a flying reindeer mount but aren't digging the red nose, I've got you covered.

History
=======
12/24/2013 - 1.07 - Fixed a typo that was messing up one of the MCM options, and hopefully made Rudolph a bit easier to steer.
12/22/2013 - 1.06 - Fixed an issue which caused an extra load on the script engine. 
12/19/2013 - 1.05 - released, fixed bug in update script and possible orphaned objects.
12/15/2013 - Fixed Rudolph going berserk sometimes
12/12/2013 - Optimized the hoofprint effects script
12/09/2013 - Fixed bug where changes made in MCM might not take effect.
12/07/2013 - Initial release.
