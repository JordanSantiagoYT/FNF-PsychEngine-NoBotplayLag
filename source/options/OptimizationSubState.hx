package options;

using StringTools;

class OptimizationSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Optimization';
		rpcTitle = 'Optimization Settings Menu'; //for Discord Rich Presence

		//I'd suggest using "Chars & BG" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Chars & BG', //Name
			'If unchecked, gameplay will only show the HUD.', //Description
			'charsAndBG', //Save data variable name
			'bool', //Variable type
			true); //Default value
		addOption(option);

		var option:Option = new Option('Enable GC',
			"If checked, then the game will be allowed to garbage collect, reducing RAM usage I suppose.\nIf you experience memory leaks, turn this on, and\nif you experience lag with it on then turn it off.",
			'enableGC',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Light Opponent Strums',
			"If this is unchecked, the Opponent strums won't light up when the Opponent hits a note.",
			'opponentLightStrum',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Light Botplay Strums',
			"If this is unchecked, the Player strums won't light when Botplay is active.",
			'botLightStrum',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Light Player Strums',
			"If this is unchecked, then uh.. the player strums won't light up.\nit's as simple as that.",
			'playerLightStrum',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Show Ratings & Combo',
			"If checked, shows the ratings & combo. Kinda defeats the purpose of this engine though...",
			'ratesAndCombo',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option('Load Songs',
			"If unchecked, PlayState songs won't be loaded.\n(Breaks a few of the Visuals & UI things, so be careful!)",
			'songLoading',
			'bool',
			true);
		addOption(option);
		
		var option:Option = new Option('Disable onSpawnNote Lua Calls',
			"If checked, the game will not call onSpawnNote when a note is spawned.\nIf you have a script that uses that, maybe leave it on.",
			'noSpawnFunc',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Disable Note Hit Lua Calls',
			"If checked, the game will not call note hit functions when a note is hit.",
			'noHitFuncs',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Even LESS Botplay Lag',
			"Reduce Botplay lag even further.",
			'lessBotLag',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Fast Note Spawning',
			"If checked, the game will use a faster type of note recycling.\n(HEAVILY WIP, SO USE AT YOUR OWN RISK!)",
			'fastNoteSpawn',
			'bool',
			false);
		addOption(option);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length-1]];
		
		super();
	}
}