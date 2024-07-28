package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.math.FlxMath;
import NoteShader.ColoredNoteShader;
import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxShader;
import flixel.FlxCamera;

typedef NoteSplashConfig = {
	anim:String,
	minFps:Int,
	maxFps:Int,
	redAnim:Int,
	offsets:Array<Array<Float>>
}

class NoteSplash extends FlxSprite
{
	public var colorSwap:ColorSwap = null;
	public var rgbShader:ColoredNoteShader = null;
	private var idleAnim:String;
	private var textureLoaded:String = null;

	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0) {
		super(x, y);

		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;
		if (ClientPrefs.splashType != 'Psych Engine') skin = 'noteSplashes-' + ClientPrefs.splashType.toLowerCase();
		
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;
			if (ClientPrefs.noteColorStyle == 'Normal' && ClientPrefs.enableColorShader)
			{
				colorSwap.hue = ClientPrefs.arrowHSV[note][0] / 360;
				colorSwap.saturation = ClientPrefs.arrowHSV[note][1] / 100;
				colorSwap.brightness = ClientPrefs.arrowHSV[note][2] / 100;
			}

		setupNoteSplash(x, y, note);
		antialiasing = ClientPrefs.globalAntialiasing;
        	if (ClientPrefs.noteColorStyle == 'Char-Based') 
		{
			rgbShader = new ColoredNoteShader(255, 255, 255, false);
			shader = rgbShader;
		}
	}

	var maxAnims:Int = 2;
	var config:NoteSplashConfig = null;
	public function setupNoteSplash(x:Float, y:Float, note:Int = 0, texture:String = null, hueColor:Float = 0, satColor:Float = 0, brtColor:Float = 0, color:FlxColor = null) {
		setPosition(x - Note.swagWidth * 0.95, y - Note.swagWidth);
		alpha = 0.6;

		if(texture == null && ClientPrefs.splashType == 'Psych Engine') {
			texture = 'noteSplashes';
			if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) texture = PlayState.SONG.splashSkin;
		}
		if (texture == null && ClientPrefs.splashType != 'Psych Engine') texture = 'noteSplashes-' + ClientPrefs.splashType.toLowerCase();

		if (!Paths.splashConfigs.exists(texture)) config = Paths.initSplashConfig(texture); 
		config = Paths.splashConfigs.get(texture);
		if(textureLoaded != texture) {
			loadAnims(texture);
		}
		if (ClientPrefs.enableColorShader)
		{
			if (ClientPrefs.noteColorStyle != 'Char-Based')
			{
				colorSwap.hue = hueColor;
				colorSwap.saturation = satColor;
				colorSwap.brightness = brtColor;
			} else if (color != null && ClientPrefs.noteColorStyle == 'Char-Based') { //null check
					rgbShader.enabled.value = [true];
					rgbShader.setColors(color.red, color.green, color.blue);
			}
		}
		offset.set(10, 10);

		var animNum:Int = FlxG.random.int(1, Paths.splashAnimCountMap.get(texture));
		var minFps:Int = 22;
		var maxFps:Int = 26;
		if(config != null)
		{
			var animID:Int = note + ((animNum - 1) * Note.colArray.length);
			var offs:Array<Float> = config.offsets[FlxMath.wrap(animID, 0, config.offsets.length-1)];
			offset.x += offs[0];
			offset.y += offs[1];
			minFps = config.minFps;
			maxFps = config.maxFps;
		}

		var splashToPlay:Int = note;
		if (ClientPrefs.noteColorStyle == 'Quant-Based' || ClientPrefs.noteColorStyle == 'Char-Based' || ClientPrefs.noteColorStyle == 'Rainbow')
		{
			splashToPlay = config.redAnim;
			if (Math.isNaN(config.redAnim)) splashToPlay = 3; //Incase the red anim wasn't specified
		}

		animation.play('note' + splashToPlay + '-' + (animNum), true);

		if(animation.curAnim != null)animation.curAnim.frameRate = FlxG.random.int(config.minFps, config.maxFps);
	}

	function loadAnims(skin:String) {
		maxAnims = 0;
		if (!Paths.splashSkinFramesMap.exists(skin)) Paths.initSplash(skin);
		frames = Paths.splashSkinFramesMap.get(skin);
		animation.copyFrom(Paths.splashSkinAnimsMap.get(skin));
	}

	override function update(elapsed:Float) {
		if(animation.curAnim != null)if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}