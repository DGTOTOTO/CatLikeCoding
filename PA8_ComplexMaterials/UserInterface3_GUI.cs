using UnityEngine;
using UnityEditor;
using System;
using UnityEngine.UI;

public class UserInterface3_GUI: ShaderGUI {
    MaterialEditor editor;
    MaterialProperty[] properties;

    static GUIContent staticLabel = new GUIContent();
    public override void OnGUI(MaterialEditor editor, MaterialProperty[] properties) {
        this.editor = editor;
        this.properties = properties;
        DoMain();
        DoSecondary();
    }

    void DoMain(){
        GUILayout.Label("Main Map", EditorStyles.boldLabel);
        MaterialProperty mainTex = FindProperty("_MainTex");
        editor.TexturePropertySingleLine(MakeLabel(mainTex, "Albedo(ANKI)"), mainTex, FindProperty("_Tint"));
        DoMetallic();
        DoSmoothness();
        DoNormals();
        editor.TextureScaleOffsetProperty(mainTex);
    }

    void DoNormals() {
        MaterialProperty map = FindProperty("_NormalMap");
        editor.TexturePropertySingleLine(
            MakeLabel(map), map, map.textureValue ? FindProperty("_BumpScale") : null
        );
    }

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

    void DoSecondary() {
        GUILayout.Label("Secondary Maps", EditorStyles.boldLabel);
        MaterialProperty detailTex = FindProperty("_DetailTex");
        editor.TexturePropertySingleLine(MakeLabel(detailTex, "Albedo(RGB) multiplied by 2"), detailTex);
        DoSecondaryNormals();
        editor.TextureScaleOffsetProperty(detailTex);
    }

    void DoSecondaryNormals() {
        MaterialProperty map = FindProperty("_DetailNormalMap");
        editor.TexturePropertySingleLine(MakeLabel(map), map, map.textureValue ? FindProperty("_DetailBumpScale") : null);
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
        staticLabel.text = property.name;
        staticLabel.tooltip = tooltip;
        return staticLabel;
    }
}