package com.inoah.ro.controllers
{
    import com.D5Power.Controler.Actions;
    import com.D5Power.Controler.NCharacterControler;
    import com.D5Power.Controler.Perception;
    import com.D5Power.GMath.GMath;
    import com.D5Power.Objects.GameObject;
    import com.D5Power.map.WorldMap;
    
    import flash.geom.Point;
    
    public class MonsterController extends NCharacterControler
    {
        private var _lastAutoMove:int;
        public function MonsterController(pec:Perception)
        {
            super(pec);
        }
        
        public function closeAutoMove():void
        {
            _lastAutoMove=-1;
        }
        
        public function fightTo(obj:GameObject):void
        {
            var a:Number = GMath.getPointAngle(_me.PosX-obj.PosX,_me.PosY-obj.PosY);
            a = GMath.R2A(a)-90;
            changeDirectionByAngle(a);
            closeAutoMove();
            _me.action=Actions.Attack;
        }
        
        override public function calcAction():void
        {
            if(_lastAutoMove!=-1 && Global.Timer-_lastAutoMove>2000)
            {
                // 自动移动
                _lastAutoMove = Global.Timer;
                var nextX:int = Math.random()>0.5 ? _me.PosX+int(Math.random()*100) : _me.PosX-int(Math.random()*100);
                var nextY:int = Math.random()>0.5 ? _me.PosY+int(Math.random()*100) : _me.PosY-int(Math.random()*100);
                // 不可移出屏幕
                if(nextX>Global.MAPSIZE.x || nextX<0) return;
                if(nextY>Global.MAPSIZE.y || nextY<0) return;
                
                // 不可移动到地图非0区域
                var p:Point = WorldMap.me.Postion2Tile(nextX,nextY);
                if(WorldMap.me.roadMap && WorldMap.me.roadMap[p.y] && WorldMap.me.roadMap[p.y][p.x]!=0) return;
                
                moveTo(nextX,nextY);
                
            }
            
            super.calcAction();
        }
    }
}