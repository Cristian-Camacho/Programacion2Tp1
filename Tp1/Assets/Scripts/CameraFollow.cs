using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    private GameObject playerM;
    private Vector3 offset;

	// Use this for initialization
	void Start ()
    {
        playerM = FindObjectOfType<Player>().gameObject;

        offset = transform.position - playerM.transform.position;
	}
	
	void LateUpdate ()
    {
        transform.position = playerM.transform.position + offset;
    }
}
