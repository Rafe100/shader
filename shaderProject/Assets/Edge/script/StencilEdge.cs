using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StencilEdge : MonoBehaviour
{
    RenderTexture cameraRenderTexture;
    RenderTexture stencilBufferToColor;
    public Material EdgeProcessMat;
    public Material OutlinePostProcessByStencilMat;
    public Camera mainCamera;
    // Start is called before the first frame update
    void Start()
    {
        //初始化CameraRenderTexture
        cameraRenderTexture = new RenderTexture(Screen.width, Screen.height, 24);
        //初始化stencilBufferToColor
        stencilBufferToColor = new RenderTexture(Screen.width, Screen.height, 24);

        //将Buffer设置到描边材质
        OutlinePostProcessByStencilMat.SetTexture("_StencilBufferToColor", stencilBufferToColor);
        mainCamera.allowMSAA = false;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnPreRender()
    {
        //将摄像机的渲染结果传到 cameraRenderTexture 中
        mainCamera.targetTexture = cameraRenderTexture;
    }
    void OnPostRender()
    {
        //null 意味着 camera 渲染结果直接交付给 FramBuffer
        mainCamera.targetTexture = null;

        //设置 Graphics 的渲染操作目标为 stencilBufferToColor
        //即 Graphics 的 activeColorBuffer 和 activeDepthBuffer 都是 stencilBufferToColor 里的
        Graphics.SetRenderTarget(stencilBufferToColor);
        //将stencilBufferToColor的颜色缓冲区和深度缓冲区清空,并将默认颜色设置为(0,0,0,0)
        GL.Clear(true, true, new Color(0, 0, 0, 0));

        //设置 Graphics 的渲染操作目标
        //即 Graphics 的 activeColorBuffer 是 stencilBufferToColor 的 ColorBuffer
        //Graphics 的 activeDepthBuffer 是 cameraRenderTexture 的 depthBuffer
        Graphics.SetRenderTarget(stencilBufferToColor.colorBuffer, cameraRenderTexture.depthBuffer);

        //提取出纯颜色形式的 StencilBuffer:
        //将 cameraRenderTexture 通过 StencilProcessMat 材质提取出到 Graphics.activeColorBuffer
        //即提取到 stencilBufferToColor 中
        Graphics.Blit(cameraRenderTexture, null, EdgeProcessMat, 0);
        //将 cameraRenderTexture 通过 OutlinePostProcessMat 材质
        //并与材质中的 _StencilBufferToColor 进行边缘检测操作
        //最后输出到 FrameBuffer(null 意味着直接交付给 FramBuffer)
        Graphics.Blit(cameraRenderTexture, null as RenderTexture, OutlinePostProcessByStencilMat);
    }


}
