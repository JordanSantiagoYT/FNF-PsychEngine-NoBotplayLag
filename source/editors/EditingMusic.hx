package editors;
//We gotta have music in the Editors!

import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.util.FlxTimer;

class EditingMusic
{
    var music:FlxSound = new FlxSound();
	var startTimer:FlxTimer = null;

    public function new() {
        playMusic(1);
    }

        public function shuffle() {
            music.loadEmbedded(Paths.music('editorMusic/' + Std.string(FlxG.random.int(0, 4))));
            music.fadeIn(1, 0, 0.5);
            music.onComplete = shuffle;
        }

        public function pauseMusic() {
            music.pause();
		if (startTimer != null) startTimer.cancel();
        }
        public function unpauseMusic(time:Float = 0) {
            if (time > 0)
		{
                startTimer = new FlxTimer().start(time, function(tmr:FlxTimer)
					{
                        music.fadeIn(1, 0, 0.5);
					});
		}
            else music.play();
        }
	    public function FocusLost()
	    {
		    pauseMusic();
	    }
        public function FocusGained():Void
	    {
		    unpauseMusic();
	    }
        public function destroy()
        {
		if (startTimer != null) startTimer.cancel();
            if (music != null) music.destroy();
            reset();
        }
        public function playMusic(time:Float = 0)
        {
            if (time > 0)
		{
		if (startTimer != null) startTimer.cancel();
                startTimer = new FlxTimer().start(time, function(tmr:FlxTimer)
					{
						shuffle();
					});
		}
            else shuffle();
        }

    public function reset() {
        music.onComplete = null;
    }
}