class Sandbox extends starling.display.Sprite {
    public function new(){
        super();
        var textField = new starling.text.TextField(400, 300, "Hello World!");
        this.addChild(textField);
    }

    public static function main(){
        try {
            var flashStage = new starling.core.Starling(Sandbox, flash.Lib.current.stage);
            flashStage.start();
        } catch(e:Dynamic){
            trace(e);
        }
    }
}