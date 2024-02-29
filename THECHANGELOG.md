1.20.1;

Fixed a bug where Linux users would have captures save in the engine's directory instead of in the gameRenders folder (Fixes issue #213)
Linux builds now get an icon
Lowered the volume of the note removal sound effect in the Chart Editor

Linux support is revived
Probably the best addition to this engine: Rendering Mode by HRK_EXEX. Now instead of waiting 1 hour playing a song at 0.1 playback rate you can render the video instead! (You'll need FFmpeg for this though)
Rendered Notes is now separate from the botplay text and is now a toggleable option
Changed the FPS counter color indicators:
Yellow when your FPS is half of the expected framerate
Orange when your FPS is 1/3 of the expected framerate
And red when your FPS is 1/4 of the expected framerate
Added missing Freeplay search bar credits
All editors now have music and sound effects. (The chart editor sound effects are toggleable so you don't go insane while charting)
Added a LOT of new botplay texts and some more tips
Characters can now have specific health drain amounts tied to them
Added an option to enable the garbage collector. It stops memory leaks for some reason (making the engine actually usable on higher framerates)