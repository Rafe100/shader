using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LogMatrix : MonoBehaviour
{

    private void Awake()
    {
        Debug.Log("L_2_W_Matrix :" + transform.localToWorldMatrix);
        Debug.Log("W_2_L_Matrix :" + transform.worldToLocalMatrix);
        Camera cam = transform.GetComponent<Camera>();
        if(cam != null)
        {
            Debug.Log("worldToCameraMatrix :" + cam.worldToCameraMatrix);
        }
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
