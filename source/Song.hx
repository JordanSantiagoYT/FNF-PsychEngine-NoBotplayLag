package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var events:Array<Dynamic>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var gfVersion:String;
	var stage:String;

	var songCredit:String;
	var songCreditBarPath:String;
	var songCreditIcon:String;
	var event7:String;
	var event7Value:String;

	var windowName:String;
	var specialAudioName:String;
	var specialEventsName:String;

	var arrowSkin:String;
	var splashSkin:String;
	var validScore:Bool;
}

class Song
{
	private static function onLoadJson(songJson:Dynamic) // Convert old charts to newest format
	{
		if(songJson.gfVersion == null)
		{
			songJson.gfVersion = songJson.player3;
			if(Reflect.hasField(songJson, 'player3')) Reflect.deleteField(songJson, 'player3');
		}

		if(songJson.events == null)
		{
			songJson.events = [];
			for (secNum in 0...songJson.notes.length)
			{
				var sec:SwagSection = songJson.notes[secNum];

				var i:Int = 0;
				var notes:Array<Dynamic> = sec.sectionNotes;
				var len:Int = notes.length;
				while(i < len)
				{
					var note:Array<Dynamic> = notes[i];
					if(note[1] < 0)
					{
						songJson.events.push([note[0], [[note[2], note[3], note[4]]]]);
						notes.remove(note);
						len = notes.length;
					}
					else i++;
				}
			}
		}

		var sectionsData:Array<SwagSection> = songJson.notes;
		if(sectionsData == null) return;

		for (section in sectionsData)
		{
			var beats:Null<Float> = cast section.sectionBeats;
			if (beats == null || Math.isNaN(beats))
			{
				section.sectionBeats = 4;
				if(Reflect.hasField(section, 'lengthInSteps')) Reflect.deleteField(section, 'lengthInSteps');
			}

			for (note in section.sectionNotes)
			{
				var gottaHitNote:Bool = (note[1] < 4) ? section.mustHitSection : !section.mustHitSection;
				note[1] = (note[1] % 4) + (gottaHitNote ? 0 : 4);

				if(note[3] != null && !Std.isOfType(note[3], String))
					note[3] = editors.ChartingState.noteTypeList[note[3]]; //Backward compatibility + compatibility with Week 7 charts
			}
		}
	}

	public static function hasDifficulty(songName:String, difficulty:String):Bool
	{
		var formattedSong:String = Paths.formatToSongPath(songName);
		var formDiff:String = Paths.formatToSongPath(difficulty);
		var jsonToFind:String = Paths.json(formattedSong + '/' + formattedSong + '-' + formDiff);
		#if MODS_ALLOWED
			if (!CoolUtil.defaultSongs.contains(formattedSong) && !CoolUtil.defaultSongsFormatted.contains(formattedSong))
				jsonToFind = Paths.modsJson(formattedSong + '/' + formattedSong + '-' + formDiff); #end
		if(FileSystem.exists(jsonToFind)) return true;

		return false;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson = null;
		
		var formattedFolder:String = Paths.formatToSongPath(folder);
		var formattedSong:String = Paths.formatToSongPath(jsonInput);
		#if MODS_ALLOWED
		var moddyFile:String = Paths.modsJson(formattedFolder + '/' + formattedSong);
		if(FileSystem.exists(moddyFile)) {
			rawJson = File.getContent(moddyFile).trim();
		}
		#end

		if(rawJson == null) {
			var path:String = Paths.json('$formattedFolder/$formattedSong');
			#if sys
			if(FileSystem.exists(path))
				rawJson = File.getContent(path);
			else
			#end
				rawJson = Assets.getText(path);
		}

		var songJson:Dynamic = parseJSONshit(rawJson);
		if(jsonInput != 'events') StageData.loadDirectory(songJson);
		onLoadJson(songJson);
		return songJson;
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		return cast Json.parse(rawJson).song;
	}
}
