package options;

#if desktop
import DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import openfl.Lib;

using StringTools;

class GameRendererSettingsSubState extends BaseOptionsMenu
{
	var fpsOption:Option;
	public function new()
	{
		title = 'Game Renderer';
		rpcTitle = 'Game Renderer Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Video Rendering Mode', //Name
			'If checked, the game will render each frame as a screenshot into a folder. They can then be rendered into MP4s using FFmpeg.\nThey are located in a folder called gameRenders.\nDo NOT use this if you have a low-end PC!',
			'ffmpegMode',
			'bool',
			false);
		addOption(option);

        var option:Option = new Option('Show Debug Info',
			"If checked, it shows FrameTime and FrameCount\nby replacing botplay text.",
			'ffmpegInfo',
			'bool',
			false);
		addOption(option);

        var option:Option = new Option('Video Framerate',
			"How much FPS would you like for your videos?",
			'targetFPS',
			'float',
			60);
		addOption(option);

		final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
		option.minValue = 1;
		option.maxValue = 1000;
		option.scrollSpeed = 125;
		option.decimals = 0;
		option.defaultValue = Std.int(FlxMath.bound(refreshRate, option.minValue, option.maxValue));
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		fpsOption = option;

		var option:Option = new Option('Lossless Screenshots',
			"If checked, screenshots will save as PNGs.\nOtherwise, It uses JPEG.",
			'lossless',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('JPEG Quality',
			"Change the JPEG quality in here.\nRecommend is 80.",
			'quality',
			'int',
			80);
		addOption(option);

		option.minValue = 1;
		option.maxValue = 100;
		option.scrollSpeed = 30;
		option.decimals = 0;

        var option:Option = new Option('Unlock Framerate',
			"If checked, the fps limit will be 1000 in rendering.",
			'unlockFPS',
			'bool',
			false);
		addOption(option);

        var option:Option = new Option('No Screenshot',
			"If checked, Skip taking of screenshot.\nIt's a function for debug.",
			'noCapture',
			'bool',
			false);
		addOption(option);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length-1]];
		
		super();
	}
	function onChangeFramerate()
	{
		fpsOption.scrollSpeed = fpsOption.getValue() / 2;
	}

	function resetTimeScale()
	{
		FlxG.timeScale = 1;
	}
}