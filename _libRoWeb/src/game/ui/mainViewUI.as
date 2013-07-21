/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	import game.ui.mainViewChildren.chatViewUI;
	import game.ui.mainViewChildren.joystickUI;
	import game.ui.mainViewChildren.mapViewUI;
	import game.ui.mainViewChildren.skillBarViewUI;
	public class mainViewUI extends View {
		public var btnStatus:Button;
		public var btnItem:Button;
		public var btnMap:Button;
		public var btnOption:Button;
		public var btnTask:Button;
		public var btnSkill:Button;
		public var labName:Label;
		public var labJob:Label;
		public var labHpPer:Label;
		public var labSpPer:Label;
		public var labLv:Label;
		public var labJobLv:Label;
		public var labWeightZeny:Label;
		public var hpBar:ProgressBar;
		public var spBar:ProgressBar;
		public var skillBarView:skillBarViewUI;
		public var chatView:chatViewUI;
		public var baseExpBar:ProgressBar;
		public var jobExpBar:ProgressBar;
		public var mapView:mapViewUI;
		public var joyStick:joystickUI;
		private var uiXML:XML =
			<View height="100">
			  <Button skin="png.basic_interface.btn_info" x="0" y="135" var="btnStatus" name="btnStatus"/>
			  <Button skin="png.basic_interface.btn_item" x="108" y="135" var="btnItem" name="btnItem"/>
			  <Button skin="png.basic_interface.btn_map" x="162" y="135" var="btnMap" name="btnMap"/>
			  <Button skin="png.basic_interface.btn_option" x="54" y="153" var="btnOption" name="btnOption"/>
			  <Button skin="png.basic_interface.btn_quest" x="0" y="153" var="btnTask" name="btnTask"/>
			  <Button skin="png.basic_interface.btn_skill" x="54" y="135" var="btnSkill" name="btnSkill"/>
			  <Image url="png.basic_interface.basewin_bg2" x="0" y="0"/>
			  <Label text="name" x="10" y="18" size="12" var="labName" name="labName"/>
			  <Label text="Novice" x="9" y="32" size="12" var="labJob" name="labJob"/>
			  <Label text="HP" x="14" y="48" size="11"/>
			  <Label text="base info window" x="13" y="-2" size="12"/>
			  <Label text="SP" x="13" y="64" size="11"/>
			  <Label text="100%" x="175" y="48" size="11" var="labHpPer" name="labHpPer"/>
			  <Label text="100%" x="175" y="64" size="11" var="labSpPer" name="labSpPer"/>
			  <Label text="Base Lv.1" x="11" y="84" size="9" var="labLv" name="labLv"/>
			  <Label text="Job Lv.1" x="12" y="96" size="9" var="labJobLv" name="labJobLv"/>
			  <Label text="Weight: 0 / 1000 Zeny: 10,000" x="54" y="116" size="11" align="right" var="labWeightZeny" name="labWeightZeny"/>
			  <Button skin="png.basic_interface.btn_sys_base" x="3" y="3"/>
			  <ProgressBar skin="png.basic_interface.progress_gzeblue" x="35" y="52" var="hpBar" name="hpBar"/>
			  <ProgressBar skin="png.basic_interface.progress_gzeblue" x="35" y="69" var="spBar" name="spBar"/>
			  <skillBarView x="350" y="0" var="skillBarView" name="skillBarView"/>
			  <chatView x="0" y="405" var="chatView" name="chatView"/>
			  <ProgressBar skin="png.basic_interface.progress_exp" x="65" y="88" var="baseExpBar" name="baseExpBar"/>
			  <ProgressBar skin="png.basic_interface.progress_exp" x="65" y="100" var="jobExpBar" name="jobExpBar"/>
			  <mapView x="760" y="0" var="mapView" name="mapView"/>
			  <joystick x="0" y="385" var="joyStick" name="joyStick"/>
			</View>;
		override protected function createChildren():void {
			viewClassMap = {"chatView":chatViewUI,"joystick":joystickUI,"mapView":mapViewUI,"skillBarView":skillBarViewUI};
			createView(uiXML);
		}
	}
}