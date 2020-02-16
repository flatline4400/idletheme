# idletheme
Script to give Corsair's CUE/iCUE software an idle ability.

All this AutoIt script does is add an icon to your system tray for management of a set of three timers.  As each timer is hit, the script will execute another seperate program (also written in AutoIt) which pops up an invisible window to the foreground.  This window will go away by pressing escape, and is also killed by the main tray script if there is any keyboard or mouse activity.

The idea is, using Corsair's iCUE software, you associate each different popup program (IdleButton1.exe, IdleButton2.exe, IdleButton3.exe in the path where you've placed them) with a different lighting profile.  The effect is, simply, a "screensaver" idle type of ability that iCUE sorely lacks.

Compiling:

These are AutoIt scripts, thus you need to get the software from https://www.autoitscript.com .  Remember that even though there is only one IdleButton1.au3 script, you need all three different .exe files.  So compile it once, then make copies so that you have IdleButton1.exe, IdleButton2.exe, IdleButton3.exe in the same spot as IdleTheme.au3 (or .exe).  The Button files *must* be compiled to exe's to work, as the Corsair software will only read them as seperate programs (and thus, profile them seperately) that way (else they all just show up as Autoit3.exe.)

Installation:

Unzip the .exe's somewhere, Program Files works fine, but anywhere will do.  Run IdleTheme.exe.  Suggested that you add it to windows startup, you can do so by typing "shell:startup" into the start menu (without the quotes) and drag a shortcut to IdleTheme.exe there.

Now go into the iCUE software, and select a profile (or create a new one).  In the Edit Profile section you will see "Link profile to program".  Click on the dots and select IdleButton1.exe wherever you put it.  Repeat for 2 and 3.  Now when the main script fires up the button's, the profile will activate.

Usage:

Run Idletheme.exe (or .au3.)  An icon is created in the system tray and will sit there.  Click on it for various functions, including setting the timer values.  All numbers are in milliseconds, although the script itself is only sensitive to the closest 1/10th of a second.  This could be changed but results in more CPU usage for little benefit (mostly because I cant figure out a way to exit a loop on any input and there's no help on the forums because this is somehow indicative of a desire to create a keylogger, so whatever.)  So it's a little kludgy.  Well, let's face it, the whole thing is a kludge, but it does work.

The three timers default to 15 minutes, 60 minutes and 120 minutes (900000, 3600000, 7200000 ms).  There are some sanity checks built in to keep the script from freaking out (eg Timer1 must be at least 1 second).  You can also have them loop by clicking that option.  The settings are saved in IdleTheme.ini which is placed in your appdata folder, and is created automatically if it doesn't exist.  The exact location can be seen by going to the About section.

So as stated, the purpose of all this is to have an invisible window pop up at various intervals of idle time.  The reason for an actual window being created is that the Corsair software can have a hard time recognizing and activating a profile if it doesn't have a window.  So I made it invisible in case you are watching a movie or something, it wont get in the way.

Issues:

The only major one is that the idle timer only detects mouse and keyboard input.  Thus if you are say, playing a game with a gamepad, it wont think there is activity going on.  This could cause the button popup window to interfere just as you are about to score, or something!  So be aware and either bonk the mouse every once in a while or exit the script while playing such a game.


