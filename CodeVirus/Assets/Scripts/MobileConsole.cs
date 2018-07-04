using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MobileConsole : MonoBehaviour
{

    public bool opener;

    void Start()
    {
        if (SystemInfo.deviceType != DeviceType.Handheld)
        {
            Destroy(this);
        }

    }
    
    public void Update()
    {
        if (Input.touches.Length >= 4)
        {
            Debug.Log("Console " + Input.touches.Length);
            if (opener) GameController.instance.OpenConsole();
            else if (!opener) GameController.instance.CloseConsole();
        }
    }

}
