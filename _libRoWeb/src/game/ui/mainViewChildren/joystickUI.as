/**Created by Morn,Do not modify.*/
package game.ui.mainViewChildren {
	import morn.core.components.*;
	public class joystickUI extends Dialog {
		public var btnUpLeft:Button;
		public var btnUpRight:Button;
		public var btnDownLeft:Button;
		public var btnDownRight:Button;
		public var btnUp:Button;
		public var btnDown:Button;
		public var btnRight:Button;
		public var btnLeft:Button;
		private var uiXML:XML =
			<Dialog>
			  <Button label="label" skin="png.comp.button" x="766" y="0" width="96" height="96"/>
			  <Button label="label" skin="png.comp.button" x="670" y="80" width="96" height="96"/>
			  <Button label="label" skin="png.comp.button" x="766" y="160" width="96" height="96"/>
			  <Button label="label" skin="png.comp.button" x="862" y="80" width="96" height="96"/>
			  <Button label="label" skin="png.comp.button" x="0" y="0" width="96" height="96" var="btnUpLeft" name="btnUpLeft"/>
			  <Button label="label" skin="png.comp.button" x="192" y="0" width="96" height="96" var="btnUpRight" name="btnUpRight"/>
			  <Button label="label" skin="png.comp.button" x="0" y="160" width="96" height="96" var="btnDownLeft" name="btnDownLeft"/>
			  <Button label="label" skin="png.comp.button" x="192" y="160" width="96" height="96" var="btnDownRight" name="btnDownRight"/>
			  <Button label="label" skin="png.comp.button" x="96" y="0" width="96" height="96" var="btnUp" name="btnUp"/>
			  <Button label="label" skin="png.comp.button" x="96" y="160" width="96" height="96" var="btnDown" name="btnDown"/>
			  <Button label="label" skin="png.comp.button" x="192" y="80" width="96" height="96" var="btnRight" name="btnRight"/>
			  <Button label="label" skin="png.comp.button" x="0" y="80" width="96" height="96" var="btnLeft" name="btnLeft"/>
			</Dialog>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}