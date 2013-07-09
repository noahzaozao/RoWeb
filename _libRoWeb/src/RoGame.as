package 
{
    import com.D5Power.D5Game;
    import com.D5Power.Controler.Actions;
    import com.D5Power.Controler.CharacterControler;
    import com.D5Power.Objects.CharacterObject;
    import com.D5Power.Stuff.HSpbar;
    import com.inoah.ro.scenes.MainScene;
    
    import flash.display.Stage;
    import flash.events.Event;
    
    public class RoGame extends D5Game
    {
        public function RoGame(config:String, stg:Stage, openGPU:uint=0)
        {
            super(config, stg, openGPU);
        }
        
        override protected function buildScene():void
        {
            _scene = new MainScene(_stg,this);
        }
        
        override protected function init(e:Event=null):void
        {
            super.init();
            
            var player:CharacterObject = new CharacterObject(null);
            player.changeController( new CharacterControler( _scene.perc , CharacterControler.MOUSE ));
            player.ID=1;
            player.setPos(500,500);
            player.speed = 6.5;
            player.setName("可爱的早早",-1,0,-130);
            player.action = Actions.Wait;
            
            player.hp = 150;
            player.hpMax = 150;
            player.sp = 100;
            player.spMax = 100;
            player.hpBar = new HSpbar( player,'hp','hpMax',10 , 0x009900 );
            player.spBar = new HSpbar( player,'sp','spMax',14 , 0x000099 );
            
            _scene.createPlayer(player);
            _camera.focus(player);
        }
    }
}