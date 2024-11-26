using UnityEngine;
using UnityEditor;

// a custom inspector: extends(继承) "UnityEditor.ShaderGUI"
public class UserInterface1_GUI: ShaderGUI {
    // To show the properties of our material, have to access them in our methods
    MaterialEditor editor;
    MaterialProperty[] properties;

    // Creat a method to configure the contents of label
    static GUIContent staticLabel = new GUIContent();

    // To replace the default inspector: override the ShaderGUI.OnGUI method
    public override void OnGUI(MaterialEditor editor, MaterialProperty[] properties) {
        this.editor = editor;
        this.properties = properties;
        DoMain();
    }

    void DoMain() {
        GUILayout.Label("Main Maps", EditorStyles.boldLabel);
        MaterialProperty mainTex = FindProperty("_MainTex");
        editor.TexturePropertySingleLine(MakeLabel(mainTex, "Albedo(RGB)"), mainTex, FindProperty("_Tint"));
    }

    MaterialProperty FindProperty(string name) {
        return FindProperty(name, properties);
    }

    // Make the tooltip optional
    static GUIContent MakeLabel(string text, string tooltip = null) {
        staticLabel.text = text;
        staticLabel.tooltip = tooltip;
        return staticLabel;
    }
    
    // Creat a MakeLabel variant
    static GUIContent MakeLabel(MaterialProperty property, string tooltip = null) {
        staticLabel.text = property.displayName;
        staticLabel.tooltip = tooltip;
        return staticLabel;
    }
}