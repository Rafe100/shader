using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Shadow : MonoBehaviour
{
    public Shader shadowReplaceShader;
    public RawImage DepthRawImage;
    Camera shadowCamera;
    public RenderTexture shadowMap;
    int smWidth = 1024;
    int smHeight = 1024;
    string shadowMapPropertyName = "_sMap";
    string shadowMapCameraPropertyName = "_cameraProp";
    string shadowCameraWorldToLocalMatrixName = "_CameraW2LMatrix";
    string shadowCameraProjectionMatrixName = "_CameraProjectMatrix";
    int shadowMapPropertyId;
    int shadowMapCameraPropertyId;
    int shadowMapCameraW2LMatrixId;
    int shadowMapCameraProjectMatrixId;
    private void Awake()
    {
        Init();
    }

    void Init()
    {
        if (shadowCamera == null)
        {
            shadowCamera = GetComponent<Camera>();
            if (shadowCamera == null)
            {
                Debug.LogError("need camera component");
                return;
            }
        }
        if (shadowMap == null)
        {
            shadowMap = new RenderTexture(smWidth, smHeight,16, RenderTextureFormat.Shadowmap);
            shadowMap.name = "_sMap";
        }
      
        this.DepthRawImage.texture = shadowMap;
        //shadowCamera.SetReplacementShader(shadowReplaceShader, "");
        shadowMapPropertyId = Shader.PropertyToID(shadowMapPropertyName);
        shadowMapCameraPropertyId = Shader.PropertyToID(shadowMapCameraPropertyName);
        shadowMapCameraW2LMatrixId = Shader.PropertyToID(shadowCameraWorldToLocalMatrixName);
        shadowMapCameraProjectMatrixId = Shader.PropertyToID(shadowCameraProjectionMatrixName);
        Shader.SetGlobalVector(shadowMapCameraPropertyId, new Vector4(shadowCamera.orthographicSize, shadowCamera.nearClipPlane,shadowCamera.farClipPlane));
        Shader.SetGlobalTexture(shadowMapPropertyId, shadowMap);
        Debug.Log("world2LocalMatrix " + shadowCamera.transform.worldToLocalMatrix);
        Debug.Log("worldToCameraMatrix " + shadowCamera.worldToCameraMatrix);
        Debug.Log("cameraProjectionMatrix : " + shadowCamera.projectionMatrix.ToString());
        Debug.Log("after project matrix " + shadowCamera.projectionMatrix * shadowCamera.worldToCameraMatrix);
        Shader.SetGlobalMatrix(shadowMapCameraW2LMatrixId, shadowCamera.worldToCameraMatrix );
        Shader.SetGlobalMatrix(shadowMapCameraProjectMatrixId, shadowCamera.projectionMatrix);
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }


}
