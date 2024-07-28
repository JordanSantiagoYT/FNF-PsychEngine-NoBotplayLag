package debug;

import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.util.FlxStringUtil;
import lime.system.System;

class FPSCounter extends TextField
{
	public var currentFPS(default, null):Float;

	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
    public var memory(get, never):Float;
	inline function get_memory():Float {
		return cast(openfl.system.System.totalMemory, UInt);
	}
    var mempeak:Float = 0;

	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x00000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("VCR OSD Mono", 12, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		times = [];
	}

    var timeColor:Float = 0.0;

	var fpsMultiplier:Float = 1.0;
    var deltaTimeout:Float = 0.0;
	// Event Handlers
	override function __enterFrame(deltaTime:Float):Void
	{
		if (deltaTimeout > 1000) {
			deltaTimeout = 0.0;
			return;
		}

		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();

		if (Std.isOfType(FlxG.state, PlayState) && !PlayState.instance.trollingMode) { 
			try { fpsMultiplier = PlayState.instance.playbackRate; }
			catch (e:Dynamic) { fpsMultiplier = 1.0; }
		}
		else fpsMultiplier = 1.0;

        if (memory > mempeak) mempeak = memory;

        currentFPS = Math.min(FlxG.drawFramerate, times.length) / fpsMultiplier;
        updateText();
        deltaTimeout += deltaTime;

		if (!ClientPrefs.ffmpegMode)
		{
    		if (ClientPrefs.rainbowFPS)
    		{
                timeColor = (timeColor % 360.0) + 1.0;
                textColor = FlxColor.fromHSB(timeColor, 1, 1);
    		}
			else
			{
				textColor = 0xFFFFFFFF;
				if (currentFPS <= ClientPrefs.framerate / 2 && currentFPS >= ClientPrefs.framerate / 3)
				{
					textColor = 0xFFFFFF00;
				}
				if (currentFPS <= ClientPrefs.framerate / 3 && currentFPS >= ClientPrefs.framerate / 4)
				{
					textColor = 0xFFFF8000;
				}
				if (currentFPS <= ClientPrefs.framerate / 4)
				{
					textColor = 0xFFFF0000;
				}
			}
		}
	}

	public dynamic function updateText():Void { // so people can override it in hscript
		text = (ClientPrefs.showFPS ? "FPS: " + (ClientPrefs.ffmpegMode ? ClientPrefs.targetFPS : Math.round(currentFPS)) : "");
		if (ClientPrefs.ffmpegMode) {
			text += " (Rendering Mode)";
		}
		
		if (ClientPrefs.showRamUsage) text += "\nRAM: " + FlxStringUtil.formatBytes(memory) + (ClientPrefs.showMaxRamUsage ? " / " + FlxStringUtil.formatBytes(mempeak) : "");
		if (ClientPrefs.debugInfo) {
			text += '\nState: ${Type.getClassName(Type.getClass(FlxG.state))}';
			if (FlxG.state.subState != null)
				text += '\nSubstate: ${Type.getClassName(Type.getClass(FlxG.state.subState))}';
			text += "\nSystem: " + '${System.platformLabel} ${System.platformVersion}';
		}
	}
}
