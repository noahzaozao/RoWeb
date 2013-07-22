package com.inoah.ro.maps
{
    import flash.geom.Rectangle;
    
    public class QTree
    {
        /**
         * 第1象限
         */
        public var q1:QTree;
        /**
         * 第2象限
         */
        public var q2:QTree;
        /**
         * 第3象限
         */
        public var q3:QTree;
        /**
         * 第4象限
         */
        public var q4:QTree;
        /**
         * 父节点
         */
        public var parent:QTree;
        /**
         * 起始节点
         */
        public var root:QTree;
        /**
         * 图形范围 
         */
        public var rect:Rectangle;
        /**
         * 数据
         */
        public var data:Array = [];
        
        /**
         * @param	rect	节点范围
         * @param	deep	节点深度
         * @param	myroot	根节点引用
         */ 
        public function QTree(area:Rectangle,deep:uint = 6,myroot:QTree=null)
        {
            rect = area;
            if(myroot!=null)
            {
                root = myroot;
            }else{
                root = this;
            }
            
            createChildren(deep);
        }
        
        /**
         * 创建树结构 
         * @param deep
         * 
         */
        protected function createChildren(deep:int):void
        {
            if (deep == 0)
                return;
            
            const hw:Number = rect.width / 2;
            const hh:Number = rect.height / 2;
            
            q1 = new QTree(new Rectangle(rect.x + hw, rect.y, hw, hh),deep-1,root);
            q2 = new QTree(new Rectangle(rect.x + hw, rect.y + hh, hw, hh),deep-1,root);
            q3 = new QTree(new Rectangle(rect.x, rect.y + hh, hw, hh),deep-1,root);
            q4 = new QTree(new Rectangle(rect.x, rect.y, hw, hh),deep-1,root);
            
            q1.parent = q2.parent = q3.parent = q4.parent = this;
        }
        
        /**
         * 是否有子树 
         * @return 
         * 
         */
        public function get hasChildren():Boolean
        {
            return q1 && q2 && q3 && q4;
        }
        
        /**
         * 添加一个数据 
         * @param v
         * @param x
         * @param y
         * @return 
         * 
         */
        public function add(v:*, x:Number, y:Number):QTree
        {
            if (!isIn(x,y))
                return null;
            
            if (hasChildren)
            {
                return q1.add(v,x,y) || q2.add(v,x,y) || q3.add(v,x,y) || q4.add(v,x,y);
            }
            else
            {
                data.push(v);
                return this;
            }
        }
        
        /**
         * 删除一个数据，坐标为NaN则会进行遍历查找 
         * @param v
         * @param x
         * @param y
         * @return 
         * 
         */
        public function remove(v:*, x:Number = NaN, y:Number = NaN):QTree
        {
            if (!isIn(x,y))
                return null;
            
            if (hasChildren)
            {
                return q1.remove(v,x,y) || q2.remove(v,x,y) || q3.remove(v,x,y) || q4.remove(v,x,y);
            }
            else
            {
                var index:int = data.indexOf(v);
                if (index!=-1)
                {
                    data.splice(index, 1);
                    return this;
                }
                else
                {
                    return null;
                }
            }
        }
        
        /**
         * 检测是否还在当前区间内，并返回新的区间 
         * @param v
         * @param x
         * @param y
         * @return 
         * 
         */
        public function reinsert(v:*, x:Number, y:Number):QTree
        {
            if (!isIn(x,y))
            {
                var result:QTree = root.add(v,x,y);
                if (result)
                {
                    remove(v);
                    return result;
                }
            }
            return this;
        }
        
        /**
         * 判断坐标是否在界限内，设为NaN则不做限制 
         * @param x
         * @param y
         * @return 
         * 
         */
        public function isIn(x:Number, y:Number):Boolean
        {
            return (isNaN(x) || x >= rect.x && x < rect.right) && (isNaN(y) || y >= rect.y && y < rect.bottom);
        }
        
        /**
         * 获得一个范围内的所有数据
         * 
         * @param rect
         * 
         */
        public function getDataInRect(rect:Rectangle):Array
        {
            if (!this.rect.intersects(rect))
                return [];
            
            var result:Array = data.concat();
            if (hasChildren)
            {
                result.push.apply(null,q1.getDataInRect(rect));
                result.push.apply(null,q2.getDataInRect(rect));
                result.push.apply(null,q3.getDataInRect(rect));
                result.push.apply(null,q4.getDataInRect(rect));
            }
            return result;
        }
    }
}