package;

import haxe.io.Bytes;
import lime.app.Application;
import lime.graphics.Image;
import flixel.FlxG;
import lime.ui.Window;
import sys.FileSystem;
import sys.io.FileOutput;

class Screenshot {
    var x:Int; 
    var y:Int; 
    var width:Int; 
    var height:Int;
    var window:Window = null;
    var image:Image;
    var target:String = #if !linux "assets\\gameRenders" #else "assets/gameRenders" #end;
    var isLossless = ClientPrefs.lossless;
    var quality = ClientPrefs.quality;
	public static var slash:String = #if !linux "\\" #else "/" #end;

    public function new(x:Int = -1, y:Int = -1, w:Int = -1, h:Int = -1) {
        if(x < 0) this.x = 0;
        if(y < 0) this.y = 0;
        if(w < 0) width = FlxG.width;
        if(h < 0) height = FlxG.height;

        image = new Image();
        isLossless = ClientPrefs.lossless;
        quality = ClientPrefs.quality;
    }

    public function setRegion(x:Int, y:Int, w:Int, h:Int) {
        this.x = x;
        this.y = y;
        width = w;
        height = h;

        if(x < 0) this.x = 0;
        if(y < 0) this.y = 0;
        if(w < 0) width = FlxG.width;
        if(h < 0) height = FlxG.height;
    }

    private function getScreen(){
        if(window == null)
            window = Application.current.window;

        image = window.readPixels();
    }

    private function fixFilename(name:String, isLossless:Bool = false):String
    {
        var type:String = isLossless ? ".png" : ".jpg";
        if (name.substr(-4) != type)
        {
            name = name + type;
        }
        return name;
    }

    var byteData:Bytes;

    public function save(path:String = "", name:String = '') {
        getScreen();

        if(FileSystem.exists(target)) {
            if(!FileSystem.isDirectory(target)) {
                FileSystem.deleteFile(target);
                FileSystem.createDirectory(target);
            } 
        } else FileSystem.createDirectory(target);

        if(FileSystem.exists(target + slash + path)) {
            if(!FileSystem.isDirectory(target + slash + path)) {
                FileSystem.deleteFile(target + slash + path);
                FileSystem.createDirectory(target + slash + path);
            } 
        } else FileSystem.createDirectory(target + slash + path);
        
        if(path + name == "" || path + name == null) {
            var millis = CoolUtil.zeroFill(Std.int(haxe.Timer.stamp() * 1000.0) % 1000, 3);
            path = "scr-" + DateTools.format(Date.now(), "%Y-%m-%d_%H-%M-%S-") + millis;
        }

        path = target + slash + fixFilename(path + name, isLossless);

        byteData = image.encode(isLossless ? PNG : JPEG, quality);
        var f:FileOutput = sys.io.File.write(path, true);
        if(byteData != null && f != null) {
            f.write(byteData);
            f.close();
            return true;
        } else {
            return false;
        }
    }
}