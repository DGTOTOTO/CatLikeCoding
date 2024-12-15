using UnityEngine;
using UnityEditor;
using System;

public class UserInterface2_GUI : ShaderGUI {
    MaterialEditor editor;
    MaterialProperty[] properties;

    static GUIContent staticLabel = new GUIContent();

    public override void OnGUI(MaterialEditor editor, MaterialProperty[] properties) {
        this.editor = editor;
        this.properties = properties;
        DoMain();
    }

    void DoMain() {
        GUILayout.Label("Main Maps", EditorStyles.boldLabel);
        MaterialProperty mainTex = FindProperty("_MainTex");
        editor.TexturePropertySingleLine(MakeLabel(mainTex, "Albedo(RGB)"), mainTex, FindProperty("_Tint"));
        DoMetallic();
        DoSmoothness();
        DoNormals();
        editor.TextureScaleOffsetProperty(mainTex);
    }

    void DoNormals() {
        MaterialProperty map = FindProperty("_NormalMap");
        // hide bump scale when there's no bump map
        editor.TexturePropertySingleLine(
            MakeLabel(map), map, map.textureValue ? FindProperty("_BumpScale") : null
        );
    }

    // Adjust indent level, make sure to reset it afterwards
    void DoMetallic() {
        MaterialProperty slider = FindProperty("_Metallic");
        EditorGUI.indentLevel += 2;
        editor.ShaderProperty(slider, MakeLabel(slider));
        EditorGUI.indentLevel -= 2;
    }

    void DoSmoothness() {
        MaterialProperty slider = FindProperty("_Smoothness");
        EditorGUI.indentLevel += 2;
        editor.ShaderProperty(slider, MakeLabel(slider));
        EditorGUI.indentLevel -= 2;
    }

    MaterialProperty FindProperty(string name) {
        return FindProperty(name, properties);
    }

    static GUIContent MakeLabel(string text, string tooltip = null) {
        staticLabel.text = text;
        staticLabel.tooltip = tooltip;
        return staticLabel;
    }

    static GUIContent MakeLabel(MaterialProperty property, string tooltip = null) {
        staticLabel.text = property.displayName;
        staticLabel.tooltip = tooltip;
        return staticLabel;
    }
}