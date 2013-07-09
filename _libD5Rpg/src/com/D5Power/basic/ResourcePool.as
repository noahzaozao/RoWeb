/**
 * D5Power Studio FPower 2D MMORPG Engine
 * 第五动力FPower 2D 多人在线角色扮演类网页游戏引擎
 * 
 * copyright [c] 2010 by D5Power.com Allrights Reserved.
 */

package com.D5Power.basic
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.utils.Dictionary;
    
    /**
     * 资源池
     * 
     */ 
    public class ResourcePool
    {
        /**
         * 资源池队列
         */ 
        protected var pool:Dictionary;
        /**
         * 资源链接统计
         */ 
        //protected var poolLink:Dictionary;
        
        protected var MapResList:Array = new Array();
        
        /**
         * 生成资源池
         */ 
        public function ResourcePool()
        {
            pool = new Dictionary();
            //poolLink = new Dictionary();
        }
        /**
         * 向资源池中增加对象
         */ 
        public function addResource(key:*,obj:*):void
        {
            if(pool[key]==null)
            {
                pool[key]=obj;
                if(key.substr(0,3)=='MAP')
                {
                    MapResList.push(key);
                }
            }
        }
        
        /**
         * 清除地图资源
         * @param	id	要清除的地图ID，如果为空则删除全部地图资源
         */ 
        public function clearMapRes(id:String=''):void
        {
            var filter:String = id=='' ? '' : 'MAP'+id;
            
            var temp:Array = new Array();
            for each(var key:String in MapResList)
            {
                if((filter=='' && pool[key]!=null) || (filter!='' && pool[key]!=null && key.split('_')[0]==filter))
                {
                    (pool[key] as BitmapData).dispose();
                    delete pool[key];
                    temp.push(key);
                }
                
            }
            
            var did:int;
            for each(key in temp)
            {
                did = MapResList.indexOf(key);
                if(did!=-1) MapResList.splice(did,1);
            }
        }
        
        /**
         * 从资源池中获取对象
         */ 
        public function getResource(key:*):*
        {
            return pool[key];
        }
        /**
         * 更新资源池中的对象
         */ 
        public function updateResource(key:*,obj:*):void
        {
            dispose(key);
            pool[key] = obj;
        }
        /**
         * 向资源池中减少对象
         */ 
        public function removeResource(key:*):void
        {
            if(pool[key]==null) return;
            dispose(key);
            delete pool[key];
        }
        
        /**
         * 调试用函数。现实当前资源池中全部的资源名
         */ 
        public function showResourceList():void
        {
            trace("Resource Key List In ResourcePool");
            trace("=================================");
            for(var key:String in pool) trace("[Resource]",key);
            trace("=================================");
        }
        
        /**
         * 清除所有资源
         */
        public function clear():void
        {
            for(var key:String in pool)
            {
                dispose(key);
                delete pool[key];
            }
        }
        
        private function dispose(key:*):void
        {
            if(pool[key] is Bitmap)
            {
                (pool[key] as Bitmap).bitmapData.dispose();
            }
            
            if(pool[key] is BitmapData)
            {
                (pool[key] as BitmapData).dispose();
            }
        }
    }
}