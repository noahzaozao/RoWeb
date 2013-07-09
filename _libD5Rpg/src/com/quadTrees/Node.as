package com.quadTrees {
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class Node {
        
        private var _rect:Rectangle;
        private var _owner:Node;
        private var _cellSize:Number;
        private var _nodeX:Number;
        private var _nodeY:Number;
        private var _nodeA:Node;
        private var _nodeB:Node;
        private var _nodeC:Node;
        private var _nodeD:Node;
        private var _hash:Hash;
        public var level:int = -1;
        public var id:String;
        private var tree:QuadTrees;
        
        public function Node(){
            super();
            this.hash = new Hash();
        }
        public function get owner():Node{
            return (this._owner);
        }
        public function get hash():Hash{
            return (this._hash);
        }
        public function set hash(value:Hash):void{
            this._hash = value;
        }
        public function get nodeY():Number{
            return (this._nodeY);
        }
        public function get nodeX():Number{
            return (this._nodeX);
        }
        public function get rect():Rectangle{
            return (this._rect);
        }
        public function get cellSize():Number{
            return (this._cellSize);
        }
        public function get length():Number{
            return (this.hash.length);
        }
        public function set cellSize(value:Number):void{
            this._cellSize = value;
        }
        public function get nodeD():Node{
            var cx:Number = (this._nodeX + (this.rect.width / 4));
            var cy:Number = (this._nodeY + (this.rect.height / 4));
            var x:Number = this._nodeX;
            var y:Number = this._nodeY;
            var rect:Rectangle = new Rectangle(x, y, (this.rect.width / 2), (this.rect.height / 2));
            this._nodeD.setUp(this.tree, cx, cy, rect, this);
            return (this._nodeD);
        }
        public function get nodeC():Node{
            var cx:Number = (this._nodeX - (this.rect.width / 4));
            var cy:Number = (this._nodeY + (this.rect.height / 4));
            var x:Number = (this._nodeX - (this.rect.width / 2));
            var y:Number = this._nodeY;
            var rect:Rectangle = new Rectangle(x, y, (this.rect.width / 2), (this.rect.height / 2));
            this._nodeC.setUp(this.tree, cx, cy, rect, this);
            return (this._nodeC);
        }
        public function get nodeB():Node{
            var cx:Number = (this._nodeX + (this.rect.width / 4));
            var cy:Number = (this._nodeY - (this.rect.height / 4));
            var x:Number = this._nodeX;
            var y:Number = (this._nodeY - (this.rect.height / 2));
            var rect:Rectangle = new Rectangle(x, y, (this.rect.width / 2), (this.rect.height / 2));
            this._nodeB.setUp(this.tree, cx, cy, rect, this);
            return (this._nodeB);
        }
        public function get nodeA():Node{
            var cx:Number = (this._nodeX - (this.rect.width / 4));
            var cy:Number = (this._nodeY - (this.rect.height / 4));
            var x:Number = (this._nodeX - (this.rect.width / 2));
            var y:Number = (this._nodeY - (this.rect.height / 2));
            var rect:Rectangle = new Rectangle(x, y, (this.rect.width / 2), (this.rect.height / 2));
            this._nodeA.setUp(this.tree, cx, cy, rect, this);
            return (this._nodeA);
        }
        public function addChild(value:DisplayObject, key:String):void{
            this.hash.put(value, key);
        }
        public function setUp(tree:QuadTrees, nodeX:Number, nodeY:Number, rect:Rectangle, owner:Node=null):void{
            this.tree = tree;
            this._nodeX = nodeX;
            this._nodeY = nodeY;
            this._rect = rect;
            this._cellSize = int((rect.width / 2));
            this._owner = owner;
            this.id = ((int((rect.x / rect.width)) + "-") + int((rect.y / rect.height)));
            if (this._owner){
                this.level = (owner.level + 1);
            };
            if ((this._nodeA == null)){
                this._nodeA = new Node();
            };
            if ((this._nodeB == null)){
                this._nodeB = new Node();
            };
            if ((this._nodeC == null)){
                this._nodeC = new Node();
            };
            if ((this._nodeD == null)){
                this._nodeD = new Node();
            };
        }
        public function project(minSize:Number):void{
            var i:String;
            var target:DisplayObject;
            if (int(this.rect.width) > minSize){
                if (int((this.rect.width / 2)) <= minSize){
                    this.tree.nodes.put(this, ((int((this.rect.x / this.rect.width)) + "-") + int((this.rect.y / this.rect.height))));
                };
                for (i in this.hash.hashMap) {
                    target = this.hash.hashMap[i];
                    if (target){
                        INoder(target).node = this;
                        if (this.nodeA.rect.containsPoint(new Point(target.x, target.y))){
                            this.nodeA.addChild(target, i);
                        } else {
                            if (this.nodeB.rect.containsPoint(new Point(target.x, target.y))){
                                this.nodeB.addChild(target, i);
                            } else {
                                if (this.nodeC.rect.containsPoint(new Point(target.x, target.y))){
                                    this.nodeC.addChild(target, i);
                                } else {
                                    if (this.nodeD.rect.containsPoint(new Point(target.x, target.y))){
                                        this.nodeD.addChild(target, i);
                                    };
                                };
                            };
                        };
                    };
                };
                this.nodeA.project(minSize);
                this.nodeB.project(minSize);
                this.nodeC.project(minSize);
                this.nodeD.project(minSize);
            };
        }
        public function drawBound(g:Graphics, rect:Rectangle, color:uint, f:Boolean=false):void{
            if (this.rect){
                g.lineStyle(1, color);
                if (f){
                    g.beginFill(0, 0.2);
                };
                g.drawRect(rect.topLeft.x, rect.topLeft.y, rect.width, rect.height);
            };
        }
        
    }
}