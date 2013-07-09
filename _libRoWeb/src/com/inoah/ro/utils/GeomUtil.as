package  com.inoah.ro.utils {
    import flash.geom.*;
    
    public class GeomUtil {
        
        public static const R_T_D:Number = 57.2957795130823;
        public static const D_T_R:Number = 0.0174532925199433;
        
        /**
         * 弧度换算成角度
         * @param radians
         * @return 
         * 
         */		
        public static function radiansToDegrees(radians:Number):Number{
            return radians * R_T_D;
        }
        
        /**
         * 角度换算成弧度 
         * @param degrees
         * @return 
         * 
         */		
        public static function degreesToRadians(degrees:Number):Number{
            return degrees * D_T_R;
        }
        public static function angleSpeed(p1:Point, p2:Point):Point{
            var radians:Number = Math.atan2((p1.y - p2.y), (p1.x - p2.x));
            return new Point(Math.cos(radians), Math.sin(radians));
        }
        public static function pointAngle(p1:Point, p2:Point):Number{
            return Math.atan2((p1.y - p2.y), (p1.x - p2.x)) * R_T_D;
        }
        /**
         * 根据两点算出弧度 
         * @param p1
         * @param p2
         * @return 
         * 
         */		
        public static function pointRadians(p1:Point, p2:Point):Number{
            return Math.atan2((p1.y - p2.y), (p1.x - p2.x));
        }
        
        /**
         * 根据角度算出该角度上的基本速度点
         * @param angle
         * @return 
         * 
         */		
        public static function angleToSpeed(angle:Number):Point{
            var radians:Number = (angle * D_T_R);
            return new Point(Math.cos(radians), Math.sin(radians));
        }
        
        /**
         * 根据弧度算出该弧度上的基本速度点
         * @param radians
         * @return 
         * 
         */		
        public static function radiansToSpeed(radians:Number):Point{
            return new Point(Math.cos(radians), Math.sin(radians));
        }
        
        /**
         * 根据一定的角度，半径，圆心点算出圆周上的某点 
         * @param p
         * @param angle
         * @param length
         * @return 
         * 
         */		
        public static function getCirclePoint(p:Point, angle:Number, length:Number):Point{
            var radians:Number = angle * D_T_R;
            return p.add(new Point((Math.cos(radians) * length), (Math.sin(radians) * length)));
        }
        
        /**
         * 根据一定的弧度，半径，圆心点算出圆周上的某点 
         * @param p
         * @param radians
         * @param length
         * @return 
         * 
         */		
        public static function getCirclePoint2(p:Point, radians:Number, length:Number):Point{
            return p.add(new Point((Math.cos(radians) * length), (Math.sin(radians) * length)));
        }
        
        /**
         * 两点间线段的长度
         */ 	
        public static function getLineLength(pointFrom:Point,pointTo:Point):Number
        {
            var w:Number = pointTo.x - pointFrom.x;
            var h:Number = pointTo.y - pointFrom.y;
            var l:Number = Math.sqrt(w * w + h * h);
            return l;			
        }
        
        /**
         * 得到从一点到另外一组点里面的最近的点
         * @param pointFrom
         * @param pointsTo
         * @return 
         *  
         */		
        public static function getNearestPoint(pointFrom:Point,pointsTo:Vector.<Point>):Point
        {
            var len:Number = Number.MAX_VALUE;
            var p:Point;
            for(var i:int = 0;pointsTo && i < pointsTo.length;i++)
            {
                var point:Point = pointsTo[i];
                var l:Number = getLineLength(pointFrom,point);
                if(l < len)
                {
                    p = point;
                    len = l;
                }
            }
            return p;
        }
        
        
        /**
         * 两点间线段的角度(0 - 2pi),注意是顺时针方向的
         */ 		
        public static function getLineAngle(pointFrom:Point,pointTo:Point):Number
        {
            var w:Number = pointTo.x - pointFrom.x;
            var h:Number = pointTo.y - pointFrom.y;
            var angle:Number;
            if(h == 0 && w >= 0)
            {
                angle = 0;
            }
            else if(h == 0 && w < 0)
            {
                angle = Math.PI;
            }
            else if(w == 0 && h >= 0)
            {
                angle = Math.PI/2;
            }
            else if(w == 0 && h < 0)
            {
                angle = Math.PI * 3 / 2;
            }
            else
            {
                angle = Math.atan(h/w);
                if(w < 0)
                {
                    angle += Math.PI;
                }
                else if( h < 0)
                {
                    angle += Math.PI * 2;
                }
            }
            return angle;			
        }
        
        /**
         * 运动学相关公式：
         * a = f/m(加速度=力/质量)
         * v = v0 + a * t
         * s = v0 * t + 1/2 * a * (t * t)
         * 速度：300pix/s
         * 加速度：600象素/平方秒
         * @param s 单位：象素pix
         * @param a 
         * @return 时间单位秒
         * 
         */		
        public static function getDuration(s:Number,a:Number):Number
        {
            var duration:Number = Math.sqrt(2 * s / a);
            return duration;	
        }
        
        
        /**
         *得到贝塞尔曲线的顶点连线长度,这个长度不是实际的曲线长度，而是各个顶点线段的长度，不能用于精确计算 
         * @param points
         * @return 
         * 
         */		
        public static function getBezierCurvePointsLength(points:Vector.<Point>):Number
        {
            var len:Number = 0;
            for(var i:int = 0; points && i < points.length; i++)
            {
                if(i < points.length - 1)
                {
                    var p:Point = points[i];
                    var np:Point = points[i + 1];
                    len += getLineLength(p,np);
                }
            }
            return len;
        }
        
        
        public static function getBezierCurvePoint(t:Number,points:Vector.<Point>):Point
        {
            //clear totals
            var x:Number = 0;
            var y:Number = 0;
            //calculate n
            var n:uint = points.length-1;
            //calculate !n
            var factn:Number = factoral(n);
            //loop thru points
            for (var i:uint=0;i<=n;i++)
            {
                //calc binominal coefficent
                var b:Number = factn/(factoral(i)*factoral(n-i));
                //calc powers
                var k:Number = Math.pow(1-t, n-i)*Math.pow(t, i);
                //add weighted points to totals
                x += b*k*points[i].x;
                y += b*k*points[i].y;
            }
            //return result
            return new Point(x, y);
        }
        
        private static  function factoral(value:uint):Number
        {
            //return special case
            if (value==0)
                return 1;
            //calc factoral of value
            var total:Number = value;
            while (--value>1)
                total *= value;
            //return result
            return total;
        }
        
        //线段和矩形的交点
        public static function getIntersectionPointOfLineSegAndRect(startPoint:Point,
                                                                    endPoint:Point,rect:Rectangle):Point
        {
            var p1:Point = new Point(rect.x,rect.y);
            var p2:Point = new Point(rect.x + rect.width,rect.y);
            var p3:Point = new Point(rect.x + rect.width,rect.y + rect.height);
            var p4:Point = new Point(rect.x,rect.y + rect.height);
            
            var point:Point = getIntersectionPointOfTwoLineSeg(startPoint,endPoint,p1,p2);
            if(point)
            {
                return point;
            }
            point = getIntersectionPointOfTwoLineSeg(startPoint,endPoint,p1,p4);
            if(point)
            {
                return point;
            }
            point = getIntersectionPointOfTwoLineSeg(startPoint,endPoint,p3,p2);
            if(point)
            {
                return point;
            }
            point = getIntersectionPointOfTwoLineSeg(startPoint,endPoint,p3,p4);
            if(point)
            {
                return point;
            }									
            return null;
        }
        
        //直线和矩形的交点
        public static function getIntersectionPointsOfStraightLineAndRect(p0:Point,angle:Number,rect:Rectangle):Array
        {
            var p1:Point = new Point(rect.x,rect.y);
            var p2:Point = new Point(rect.x + rect.width,rect.y);
            var p3:Point = new Point(rect.x + rect.width,rect.y + rect.height);
            var p4:Point = new Point(rect.x,rect.y + rect.height);
            
            var points:Array = [];
            
            var point:Point = getIntersectionPointOfStraightLineAndLineSeg(p0,angle,p1,p2);
            
            if(point)
            {
                points.push(point);
            }
            point = getIntersectionPointOfStraightLineAndLineSeg(p0,angle,p1,p4);
            if(point)
            {
                points.push(point);
            }
            point = getIntersectionPointOfStraightLineAndLineSeg(p0,angle,p3,p2);
            if(point)
            {
                points.push(point);
            }
            point = getIntersectionPointOfStraightLineAndLineSeg(p0,angle,p3,p4);
            if(point)
            {
                points.push(point);
            }									
            return points;
        }
        
        /**一元二次方程的解
         * 原式为ax²+bx+c=0
         * 当b²-4ac>=0时有两个根
         *	x1=(-b+√(b²-4ac))/2a
         *	x2=(-b-√(b²-4ac))/2a 
         *	当b²-4ac<0时
         *	x1=x2=-b/2a 
         */
        
        public static function getPointsOnLineDistanceOtherPoint(p1:Point,angle:Number,distance:Number):Array
        {
            try
            {
                var points:Array = [];
                var x1:Number = p1.x;
                var y1:Number = p1.y;
                
                var x2:Number = x1 + distance * Math.sin(angle);
                var y2:Number = y1 + distance * Math.cos(angle);
                
                points.push(new Point(x2,y2));
                
                x2 = x1 - distance * Math.sin(angle);
                y2 = y1 - distance * Math.cos(angle);
                points.push(new Point(x2,y2));
                
                return points;
            }
            catch(err:Error)
            {
                return null;
            }
            return null;
            
        }
        
        /**
         * p1(x1,y1),angle确定的直线的函数是：
         * y = Math.tan(angle) * x + b;
         * y1 = Math.tan(angle) * x1 + b;
         * b = y1 - Math.tan(angle) * x1;
         * ==>
         * y = Math.tan(angle) * x + (y1 - Math.tan(angle) * x1);
         * 
         * p3(x3,y3),p4(x4,y4)两点确定的直线的函数是：
         * y = ((y4-y3)/(x4-x3))*x + (y3*x4 - y4*x3)/(x4-x3)
         * 
         * k1 = Math.tan(angle);
         * b1 = (y1 - Math.tan(angle) * x1)
         * y = k1*x + b1
         * 
         * k2 = (y4-y3)/(x4-x3)
         * b2 = (y3*x4 - y4*x3)/(x4-x3)
         * y = k2*x + b2
         * 
         * x = (b2 - b1)/(k1 - k2)
         * y = k1 *　(b2 - b1)/(k1 - k2) + b1
         */	
        
        public static function getIntersectionPointOfStraightLineAndLineSeg(p1:Point,angle:Number,p3:Point,p4:Point):Point
        {
            try
            {
                var x1:Number = p1.x;
                var y1:Number = p1.y;
                
                var x3:Number = p3.x;
                var y3:Number = p3.y;
                var x4:Number = p4.x;
                var y4:Number = p4.y;
                
                
                var k1:Number = Math.tan(angle);
                var b1:Number = (y1 - Math.tan(angle) * x1);
                
                var k2:Number;
                var b2:Number;
                
                var resultX:Number;
                var resultY:Number;
                
                if(x3 == x4)
                {
                    resultX = x3;
                    resultY = k1 * x3 + b1;					
                }
                else
                {						
                    k2 = (y4-y3)/(x4-x3);
                    b2 = (y3*x4 - y4*x3)/(x4-x3);
                    if((1/Math.abs(k1)) < 0.000001)
                    {
                        resultX = x1;
                        resultY = k2 * x1 + b2;
                    }
                    else
                    {					
                        resultX = int((b2 - b1)/(k1 - k2));
                        resultY =  int(k1 * (b2-b1)/(k1-k2)+b1);
                    }
                }
                
                var point:Point = new Point(resultX,resultY);
                if(isPointBetweenPoints(point,p3,p4))
                {
                    return point;
                }
                return null;
            }
            catch(err:Error)
            {
                return null;
            }
            return null;			
        }
        
        /**
         * p1(x1,y1),p2(x2,y2)两点确定的直线的函数是：
         * y = ((y2-y1)/(x2-x1))*x + (y1*x2 - y2*x1)/(x2-x1)
         * x = ((x2-x1)/(y2-y1))*y + (x1*y2 - x2*y1)/(y2-y1)
         * 
         * p3(x3,y3),p4(x4,y4)两点确定的直线的函数是：
         * y = ((y4-y3)/(x4-x3))*x + (y3*x4 - y4*x3)/(x4-x3)
         * 
         * k1 = (y2-y1)/(x2-x1);
         * b1 = (y1*x2 - y2*x1)/(x2-x1)
         * y = k1*x + b1
         * 
         * k2 = (y4-y3)/(x4-x3)
         * b2 = (y3*x4 - y4*x3)/(x4-x3)
         * y = k2*x + b2
         * 
         * x = (b2 - b1)/(k1 - k2)
         * y = k1 *　(b2 - b1)/(k1 - k2) + b1
         */		
        public static function getIntersectionPointOfTwoLineSeg(p1:Point,p2:Point,
                                                                p3:Point,p4:Point):Point
        {
            try
            {
                var x1:Number = p1.x;
                var y1:Number = p1.y;
                var x2:Number = p2.x;
                var y2:Number = p2.y;
                
                var x3:Number = p3.x;
                var y3:Number = p3.y;
                var x4:Number = p4.x;
                var y4:Number = p4.y;
                
                //平行竖线
                if(x2 == x1 && x4 == x3)
                {
                    return null;
                }				
                
                //平行横线
                if(y2 == y1 && y4 == y3)
                {
                    return null;
                }				
                
                var k1:Number;
                var b1:Number;
                
                var k2:Number;
                var b2:Number;
                
                var resultX:Number;
                var resultY:Number;
                
                if(x2 == x1)
                {
                    k2 = (y4-y3)/(x4-x3);
                    b2 = (y3*x4 - y4*x3)/(x4-x3);
                    resultX = x2;
                    resultY = k2 * x2 + b2;					
                }
                else if(x3 == x4)
                {
                    k1 = (y2-y1)/(x2-x1);
                    b1 = (y1*x2 - y2*x1)/(x2-x1);
                    resultX = x3;
                    resultY = k1 * x3 + b1;					
                }
                else
                {	
                    k1 = (y2-y1)/(x2-x1);
                    b1 = (y1*x2 - y2*x1)/(x2-x1);
                    
                    k2 = (y4-y3)/(x4-x3);
                    b2 = (y3*x4 - y4*x3)/(x4-x3);
                    
                    resultX = int((b2 - b1)/(k1 - k2));
                    resultY =  int(k1 * (b2-b1)/(k1-k2)+b1);
                }
                
                var point:Point = new Point(resultX,resultY);
                if(isPointBetweenPoints(point,p1,p2) && isPointBetweenPoints(point,p3,p4))
                {
                    return point;
                }
                return null;
            }
            catch(err:Error)
            {
                return null;
            }
            return null;
        }
        
        public static function isPointBetweenPoints(point:Point,lineStartPoint:Point,lineEndPoint:Point):Boolean
        {
            try
            {
                if(((point.x <= lineEndPoint.x && point.x >= lineStartPoint.x)
                    || (point.x >= lineEndPoint.x && point.x <= lineStartPoint.x)) && 
                    ((point.y <= lineEndPoint.y && point.y >= lineStartPoint.y)
                        || (point.y >= lineEndPoint.y && point.y <= lineStartPoint.y)))
                {
                    return true;
                }
            }
            catch(err:Error)
            {
                return false;
            }
            return false;
        }
    }
}