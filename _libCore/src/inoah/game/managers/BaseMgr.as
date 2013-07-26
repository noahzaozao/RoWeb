package inoah.game.managers
{
    import inoah.game.interfaces.IMgr;
    import flash.events.EventDispatcher;
    import flash.utils.getQualifiedClassName;
    
    /**
     * 主管理器基类 
     * @author inoah
     */    
    public class BaseMgr extends EventDispatcher
    {
        protected static var _instance:BaseMgr;
        
        public static function get instance() : BaseMgr
        {
            if (_instance == null)
            {
                _instance = new BaseMgr ();    
            }
            return _instance;
        }
        
        /**
         * 服务集合索引ID列表 
         */        
        protected var _mgrSetsNames:Vector.<String>;
        
        /**
         * 服务集合列表
         */        
        protected var _mgrSets:Vector.<Vector.<IMgr>>;
        
        /**
         * 服务集合列表中每个集合的索引列表
         */        
        protected var _mgrIndexs:Vector.<Vector.<String>>;
        
        /**
         * 当前的服务集合名称
         */        
        protected var _currentMgrSetName:String;
        
        /**
         * 当前的服务集合中服务的ID索引列表 
         */        
        protected var _currentMgrIndex : Vector.<String>;
        
        /**
         * 当前的服务集合中的服务列表
         */        
        protected var _currentMgrSet: Vector.<IMgr>;
        
        /**
         * 测试模式 
         */		
        protected var _debugMode:Boolean = true;
        
        /**
         * 构造 
         * @param 单例限制
         */        
        public function BaseMgr()
        {
            if(_instance!=null)
            {
                throw new Error("Mgr is a singleton class!!");
            }
            
            _mgrSetsNames = new Vector.<String>();
            _mgrIndexs = new Vector.<Vector.<String>>();
            _mgrSets = new Vector.<Vector.<IMgr>>();
            // always add a "game" mgr set
            this.useMgrSet ("game");
            
        }
        
        /**
         * 切换当前使用的服务集合 
         * @param id        服务集合的ID
         * 如果没有找到指定ID的服务集合则会自动添加一个ID为所指定的新的服务集合
         */        
        public function useMgrSet(id:String):void
        {
            var setIndex:int = _mgrSetsNames.indexOf (id);
            _currentMgrSetName = id;
            
            if (setIndex < 0)
            {
                _mgrSetsNames.push (_currentMgrSetName);
                _currentMgrSet = new Vector.<IMgr>();
                _mgrSets.push (_currentMgrSet);
                _currentMgrIndex = new Vector.<String>();
                _mgrIndexs.push (_currentMgrIndex);
                return
            }
            
            _currentMgrSet = _mgrSets[setIndex];
            _currentMgrIndex = _mgrIndexs[setIndex];
            
        }
        
        /**
         * 添加一个服务到当前的服务集合
         * @param guid          服务的绝对唯一ID
         * @param mgr       要添加的服务
         * @param replace       是否替换已经存在的服务
         * 
         */        
        public function addMgr(guid:String, mgr:IMgr, replace:Boolean = true) : void
        {
            var index:int = _currentMgrIndex.indexOf (guid);
            if (index < 0)
            {
                _currentMgrIndex.push (guid);
                _currentMgrSet.push (mgr);
                return;
            }
            
            if (replace == false)
            {
                return;
            }
            
            _currentMgrSet[index].dispose ();
            _currentMgrSet[index] = mgr;
            
        }
        
        /**
         * 从当前的服务集合中移除一个服务
         * @param guid      服务的绝对唯一ID
         */        
        public function removeMgr(guid:String) : void
        {
            var index:int = _currentMgrIndex.indexOf (guid);
            if (index < 0)
            {
                return;
            }
            
            _currentMgrIndex.splice (index, 1);
            _currentMgrSet.splice (index, 1)[0].dispose ();
        }
        
        /**
         * 从当前的服务集合中取得一个服务 
         * @param guid       服务的绝对唯一ID
         * @return  一个已经注册的服务
         */        
        public function getMgr(guid:String) : IMgr
        {
            var index:int = _currentMgrIndex.indexOf (guid);
            if (index < 0)
            {
                return null;
            }
            
            return _currentMgrSet[index];
        }
        
        /**
         * 当前服务的版本名
         */
        public function get currentMgrSetName():String
        {
            return _currentMgrSetName;
        }
        
        /**
         * 测试模式输出
         * @param str
         */		
        public function debugTrace(str:String):void 
        {
            if( getDebugMode )
            {
                trace( str );
            }
        }
        /**
         * 
         */		
        public function classTrace( methodStr:String, cls:Object):void
        {
            var className:String = getQualifiedClassName( cls );
            debugTrace(  "[" + methodStr + "]" + className + "" );
        }
        /**
         * 获取是否测试模式
         * @return 
         */		
        public function get getDebugMode():Boolean 
        {
            return _debugMode;
        }
    }
}