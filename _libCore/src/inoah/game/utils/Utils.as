package  inoah.game.utils
{
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.media.Sound;
    import flash.system.ApplicationDomain;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    /**
     * 公共功能
     * @author noah
     */	
    public class Utils {
        /**
         * 从加载器中获取MovieClip 
         * @param name
         * @param loader
         * @return 
         */		
        public static function getMovieClipFromLoader(name:String, loader:Loader):MovieClip	{
            var r:DisplayObject = getDisplayObjectFromLoader(name, loader);
            return ((r == null) ? null : (r as MovieClip));
        }
        /**
         * 从加载器中获取Sprite
         * @param name
         * @param loader
         * @return 
         */		
        public static function getSpriteFromLoader(name:String, loader:Loader):Sprite {
            var r:DisplayObject = getDisplayObjectFromLoader(name, loader);
            return ((r == null) ? null : (r as Sprite));
        }
        /**
         * 从加载器中获取SimpleButton 
         * @param name
         * @param loader
         * @return 
         */		
        public static function getSimpleButtonFromLoader(name:String, loader:Loader):SimpleButton{
            var r:DisplayObject = getDisplayObjectFromLoader(name, loader);
            return ((r == null) ? null : (r as SimpleButton));
        }
        /**
         * 从加载器中获取Sound
         * @param name
         * @param loader
         * @return 
         */		
        public static function getSoundFromLoader(name:String, loader:Loader):Sound	{
            var classReference:Class = getClassFromLoader(name,loader);
            return new classReference() as Sound;
        }
        /**
         * 从加载器中获取BitmapData
         */
        private static var _bmdPacket:Dictionary = new Dictionary(true);
        public static function getBitmapDataFromLoader(name:String, loader:Loader,isCache:Boolean = false):BitmapData{
            if (_bmdPacket[name]){
                return _bmdPacket[name];
            }
            //
            var bmd:BitmapData;
            var classReference:Class = getClassFromLoader(name, loader);
            if (classReference){
                try	{
                    bmd = new classReference(0, 0) as BitmapData;
                }catch(e:Error){
                    trace("Utils getBitmapDataFromLoader error:" + e.toString());
                }
            }else{
                return null;
            }
            if(isCache)	{
                if (bmd){
                    _bmdPacket[name] = bmd;
                }
            }
            return bmd;
        }
        /**
         * 从加载器中获取Class
         * @param name
         * @param loader
         * @return 
         */		
        public static function getClassFromLoader(name:String, loader:Loader):Class	{
            var app:ApplicationDomain = loader.contentLoaderInfo.applicationDomain;
            if(app.hasDefinition(name))	{
                return app.getDefinition(name)as Class;
            }else{
                trace("Utils getClassFromLoader not hasDefinition:"+name);
            }
            return null;
        }
        /**
         * 从加载器中获取DisplayObject
         * @param name
         * @param loader
         * @return 
         */		
        public static function getDisplayObjectFromLoader(name:String, loader:Loader):DisplayObject	{
            var classReference:Class = getClassFromLoader(name, loader);
            if (classReference != null)	{
                try	{
                    return new classReference() as DisplayObject;
                }catch(e:Error)	{
                    trace("Utils getDisplayObjectFromLoader error:" + e.toString());
                    return null;
                }
            }
            return null;
        }
        /**
         * 返回 name 参数指定的类的类
         * @param name
         * @return 
         */		
        public static function getClass(name:String):Class{
            try{
                var ClassReference:Class = getDefinitionByName(name)as Class;
            }catch(e:Error)	{
                trace("getClass " + name + "error" + e.message);
                return null;
            }
            return ClassReference;
        }
        /**
         * 返回 DisplayObject 指定的类的类
         * @param obj
         * @return 
         */		
        public static function getClassByObject(obj:DisplayObject):Class{
            try	{
                var mcs:Class = getClassFromLoader(getQualifiedClassName(obj), obj.loaderInfo.loader)as Class;
            }catch(e:Error)	{
                trace("getClass " + obj.toString() + "error" + e.message);
                return null;
            }
            return mcs;
        }
        /**
         * 获取loader的内容的Class
         * @param loader
         * @return Class
         */
        public static function getLoaderClass(loader:Loader):Class{
            return loader.contentLoaderInfo.applicationDomain.getDefinition(getQualifiedClassName(loader.content))as Class;
        }
        /**
         * 深度复制对象 
         * @param fromObj
         * @param toObj
         */		
        public static function copyObjectValue(fromObj:Object, toObj:Object):void{
            var n:String;
            for (n in fromObj) {
                toObj[n] = fromObj[n];
            }
        }
    }
}



