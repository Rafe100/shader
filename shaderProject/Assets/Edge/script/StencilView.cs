using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class StencilView : MonoBehaviour
{
    
    public Material EdgeProcessMat;
    public Camera MainCamera;
    public RawImage ImageToRT;
    RenderTexture cameraRenderTexture;
    RenderTexture stencilBufferToColor;
    // Start is called before the first frame update
    void Start()
    {
        if(MainCamera == null)
        {
            Debug.LogError("the camera component is null");
            return;
        }
        cameraRenderTexture = new RenderTexture(Screen.width, Screen.height, 24);
        stencilBufferToColor = new RenderTexture(Screen.width, Screen.height, 24);
        float uiHeight = 200.0f;
        ImageToRT.rectTransform.sizeDelta = new Vector2(Screen.width * uiHeight / Screen.height, uiHeight);
        ImageToRT.texture = cameraRenderTexture;
        MainCamera.allowMSAA = false;
    }


    private void OnPreRender()
    {
        MainCamera.targetTexture = cameraRenderTexture;
    }
    void OnPostRender()
    {
        MainCamera.targetTexture = null;
        Graphics.SetRenderTarget(stencilBufferToColor.colorBuffer, cameraRenderTexture.depthBuffer);
        Graphics.Blit(cameraRenderTexture, EdgeProcessMat);
        Graphics.Blit(stencilBufferToColor, null as RenderTexture);
    }


}
