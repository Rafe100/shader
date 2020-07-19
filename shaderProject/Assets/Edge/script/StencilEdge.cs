using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StencilEdge : MonoBehaviour
{
    RenderTexture CameraRenderTexture;
    RenderTexture Buffer;
    public Material EdgeDetectionMaterial;
    public Material StencilprocessMaterial;
    public Camera mainCamera;
    // Start is called before the first frame update
    void Start()
    {
        //初始化CameraRenderTexture
        CameraRenderTexture = new RenderTexture(Screen.width, Screen.height, 24);
        //初始化Buffer
        Buffer = new RenderTexture(Screen.width, Screen.height, 24);

        //将Buffer设置到描边材质
        EdgeDetectionMaterial.SetTexture("_StencilTex", Buffer);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnPreRender()
    {
        mainCamera.targetTexture = CameraRenderTexture;
    }
    void OnPostRender()
    {
        mainCamera.targetTexture = null;

        //将渲染目标设置为Buffer
        Graphics.SetRenderTarget(Buffer);
        //将Buff的颜色缓冲区和深度缓冲区清空,并将默认颜色设置为(0,0,0,0)
        GL.Clear(true, true, new Color(0, 0, 0, 0));

        //将渲染目标设置为Buffer的颜色缓冲区和CameraRenderTexture的深度缓冲区
        Graphics.SetRenderTarget(Buffer.colorBuffer, CameraRenderTexture.depthBuffer);
        //根据 Stencil Buffer的值选择性渲染
        Graphics.Blit(CameraRenderTexture, null, StencilprocessMaterial, 0);
        //描边
        //Graphics.Blit(CameraRenderTexture, null as RenderTexture, EdgeDetectionMaterial);
    }


}
