using Godot;
using System;

//  ! STUDENT VERSION !
// don't use for real grannyx : incomplete, out-of-date
// see gdscript version instead
public class Models : Node
{
	//used only from C# scripts : autoload+export doesn't allow static-like access
//	public static int unitHeight = 1;

	//used from gdscript : autoload+static members not recognized (null/zero values)
	[Export] public int unitHeight = 1;
	[Export] public int unitWidth = 20;
	[Export] public float expBase = 2.7f;
	[Export] public int columnsCount = 1;
	[Export] public float zoomX = .4f;
	[Export] public float zoomY = .3f;
	
	[Export] public string comments;
	[Export] public string tutoYComments;
	[Export] public string tutoYBisComments;
	[Export] public string tutoRecap;

	[Signal]
	delegate void base_changed();
	[Signal]
	delegate void columns_count_changed();
	[Signal]
	delegate void zoom_x_changed();
	[Signal]
	delegate void zoom_y_changed();
	[Signal]
	delegate void comments_changed();
	
	//for static access from c#
	public static Models d;
	
	public override void _Ready()
	{
		d = (Models)(GetNode("/root/Models"));
	}
	
//	//for static access from c#
//	public static float ZoomX()
//	{
//		return me.zoomX;
//	}
//	public static float ZoomY()
//	{
//		return me.zoomY;
//	}
//	public static int UnitWidth()
//	{
//		return me.unitWidth;
//	}
//	public static float ExpBase()
//	{
//		return me.expBase;
//	}
//	public static int ColumnsCount()
//	{
//		return me.columnsCount;
//	}
	
	public void _on_base_changed(float newBase)
	{
		expBase = newBase;
		EmitSignal("base_changed");
		updateComments();
		EmitSignal("comments_changed");
	}

	public void _on_columns_count_changed(int x)
	{
		columnsCount = x + 1;
		EmitSignal("columns_count_changed");
		updateComments();
		EmitSignal("comments_changed");
	}

	public void _on_zoom_x_changed(float newZoomX)
	{
		zoomX = newZoomX;
		EmitSignal("zoom_x_changed");
	}

	public void _on_zoom_y_changed(float newZoomY)
	{
		zoomY = newZoomY;
		EmitSignal("zoom_y_changed");
	}

	public void _on_locale_chosen(int langI)
	{
		string locale = (string)((TranslationServer.GetLoadedLocales())[langI]);
		TranslationServer.SetLocale(locale);
		updateComments();
		EmitSignal("comments_changed");
	}

	public void updateComments()
	{
		var sm = GetNode("/root/StringMisc");
		sm.Call("updateComments");
	}

//	public void humanizeIntString(string digits)
//	{
//	}
//
	public string humanizeFloat(float floatVal)
	{
		var sm = GetNode("/root/StringMisc");
		var res = sm.Call("humanizeFloat", floatVal);
		return (string)res;
	}
//
//	// digits = "k", with 0 < k < 1, eg. "0.020"
//	public void humanizeDecimals(string digits)
//	{
//	}

}
