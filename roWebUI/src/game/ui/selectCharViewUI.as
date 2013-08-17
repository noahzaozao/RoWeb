/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class selectCharViewUI extends View {
		public var labName:Label;
		public var labJob:Label;
		public var labLv:Label;
		public var labExp:Label;
		public var labHp:Label;
		public var labSp:Label;
		public var labMap:Label;
		public var labStr:Label;
		public var labAgi:Label;
		public var labVit:Label;
		public var labInt:Label;
		public var labDex:Label;
		public var labLuk:Label;
		public var charBg1:Image;
		public var charBg2:Image;
		public var selectBg:Image;
		public var charBg0:Image;
		protected var uiXML:XML =
			<View>
			  <Image url="png.login_interface.win_select2" x="0" y="0"/>
			  <Label text="label" x="68" y="201" width="80" var="labName" name="labName"/>
			  <Label text="label" x="68" y="217" width="80" var="labJob" name="labJob"/>
			  <Label text="label" x="68" y="234" width="80" var="labLv" name="labLv"/>
			  <Label text="label" x="68" y="250" width="80" var="labExp" name="labExp"/>
			  <Label text="label" x="68" y="266" width="80" var="labHp" name="labHp"/>
			  <Label text="label" x="68" y="282" width="80" var="labSp" name="labSp"/>
			  <Label text="label" x="68" y="298" width="80" var="labMap" name="labMap"/>
			  <Label text="label" x="212" y="201" width="80" var="labStr" name="labStr"/>
			  <Label text="label" x="212" y="218" width="80" var="labAgi" name="labAgi"/>
			  <Label text="label" x="212" y="234" width="80" var="labVit" name="labVit"/>
			  <Label text="label" x="212" y="250" width="80" var="labInt" name="labInt"/>
			  <Label text="label" x="212" y="267" width="80" var="labDex" name="labDex"/>
			  <Label text="label" x="212" y="283" width="80" var="labLuk" name="labLuk"/>
			  <Image url="png.comp.blank" x="218" y="40" width="140" height="145" var="charBg1" name="charBg1"/>
			  <Image url="png.comp.blank" x="382" y="40" width="140" height="145" var="charBg2" name="charBg2"/>
			  <Image url="png.login_interface.boxselect" x="55" y="40" var="selectBg" name="selectBg"/>
			  <Image url="png.comp.blank" x="55" y="40" width="140" height="145" var="charBg0" name="charBg0"/>
			  <Button skin="png.basic_interface.btn_ok" x="5" y="334"/>
			  <Button skin="png.basic_interface.btn_cancel" x="53" y="334"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}