package
{
    import com.D5Power.Stuff.BackgroundMusicPlayer;
    import com.D5Power.basic.ResourcePool;
    import com.D5Power.utils.CharacterData;
    import com.D5Power.utils.XYArray;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.net.LocalConnection;
    import flash.system.ApplicationDomain;
    import flash.system.System;
    
    import utils.Cast;
    
    /**
     * 公用数据交换接口
     */
    public class Global
    {
        public static var httpServer:String = '';
        public static var localServer:String = '';
        /**
         * 角色贴图库
         */ 
        
        public static var characterLib:ApplicationDomain;
        /**
         * 地图贴图库
         */ 
        public static var mapLib:ApplicationDomain;
        
        public static var resPool:ResourcePool=new ResourcePool();
        
        /**
         * 单位死亡后在地图上保存的时间
         * 0为不限制
         */ 
        public static var DieSaveTime:uint = 10000;
        
        /**
         * 舞台宽度
         */ 
        public static var W:uint=1000;
        /**
         * 舞台高度
         */ 
        public static var H:uint=600;		
        /**
         * 当前玩家的阵营
         */ 
        public static var userdata:CharacterData;
        
        /**
         * 测试点击用颜色保存器
         */ 
        public static var clickColor:uint;
        
        /**
         * 标准每帧消耗的时间
         */ 
        public static var TPF:Number=1000/60;
        
        /**
         * 时间，用以保存从程序开始运行到现在经过的毫秒数
         */ 
        public static var Timer:uint;
        
        /**
         * 地图尺寸
         */ 
        public static var MAPSIZE:XYArray = new XYArray(3000,3000);
        
        /**
         * 每块地图单元的大小
         */ 
        public static var TILE_SIZE:XYArray = new XYArray(300,300);
        
        /**
         * 脚本保存目录
         */ 
        public static const LUAPATH:String='script/';
        
        /**
         * 地图库文件名
         */ 
        public static const MAPLIBNAME:String = 'MapResource';
        
        /**
         * 资源库文件名，若为空则不加载资源库
         */
        public static var LIBNAME:String = '';
        
        /**
         * 使用资源总数
         */ 
        public static var resourceCount:uint=0;
        
        /**
         * 资源池引用总数
         */ 
        public static var resourcePoolCount:uint=0;
        
        /**
         * 等待加载的资源列表
         */ 
        public static var LOADWAIT:Array = new Array();
        
        /**
         * 背景音乐播放器
         */ 
        public static var bgMusic:BackgroundMusicPlayer = new BackgroundMusicPlayer();
        
        public function Global()
        {
        }
        
        /**
         * 内存整理HACK
         * @example
         * soft.CLEAR();
         * 
         */
        public static function CLEAR():void
        { 
            try
            {
                new LocalConnection().connect("gc");
                new LocalConnection().connect("gc");
            }
            catch (e:Error)
            {
                var shouldTouchHere:Boolean = true;
            }
        }
        
        /**
         * 从库中获取元素
         */ 
        public static function getElement(lib:ApplicationDomain,_name:String,isimg:Boolean=false):*
        {
            if(lib==null) return null;
            var c:Class = lib.getDefinition(_name) as Class;
            
            if(isimg)
                return Cast.bitmap(c);
            else
                return new c();
        }
        
        /**
         * 从角色库中获取角色贴图
         */ 
        public static function getCharacterRes(_name:String):BitmapData
        {
            if(resPool.getResource(_name)!=null) return null;
            
            return getElement(characterLib,LIBNAME+'_'+_name,true);
        }
        /**
         * 从地图库中获取地图素材
         */ 
        public static function getMapRes(_name:String):BitmapData
        {
            if(resPool.getResource(_name)==undefined)
            {
                resPool.addResource(_name,getElement(mapLib,MAPLIBNAME+'_'+_name,true));
            }
            return resPool.getResource(_name) as BitmapData;
        }
        
        public static function getCharacterResImg(_name:String):Bitmap
        {
            _name = LIBNAME+'_'+_name;
            if(resPool.getResource(_name)==undefined)
            {
                resPool.addResource(_name,getElement(characterLib,_name,false));
            }
            return resPool.getResource(_name) as Bitmap;
        }
        
        /**
         * 从资源池中取出资源，若不存在则创建资源
         */ 
        public static function createResource(key:String):void
        {
            if(resPool.getResource(key)==null)
            {
                resPool.addResource(key,getCharacterRes(key));
            }
        }
        
        /**
         * 系统消息
         * @param	_msg	要发送的系统消息
         */ 
        public static function msg(_msg:String):void
        {
            trace("Info:"+_msg);	
        }
        
        /**
         * 获得字符串所占字节数
         * @param	_str	要计算的字符串
         * @param	isutf8	是否UTF8编码
         */ 
        public static function getStrLen(_str:String,isutf8:Boolean=true):uint
        {
            var _len:uint = 0;
            for (var _p:uint = 0; _p<_str.length; _p++)
            {
                _len += _str.charCodeAt(_p)>255 ? (isutf8?3:2) : 1;
            }
            return _len;
        }
        
        public static function GC():void
        { 
            try 
            { 
                var lc1:LocalConnection = new LocalConnection(); 
                var lc2:LocalConnection = new LocalConnection(); 
                lc1.connect('name'); 
                lc2.connect('name2'); 
            }
            catch (e:Error) 
            { 
            }
            
            Global.LOADWAIT.splice(0,Global.LOADWAIT.length);
            System.gc();
        } 
        
    }
}