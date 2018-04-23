﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : Character
{
	private Ray _cameraRay;
	private RaycastHit _hit;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () 
	{
		Movement();
	}

	private void Movement() 
	{
		transform.position += transform.right * Input.GetAxis("Horizontal") * speed * Time.deltaTime;
		transform.position += transform.forward * Input.GetAxis("Vertical") * speed * Time.deltaTime;
		
		if (Input.GetMouseButton(0)) 
		{
			_cameraRay = Camera.main.ScreenPointToRay(Input.mousePosition);
			if (Physics.Raycast(_cameraRay, out _hit)) 
			{
				if (_hit.transform.gameObject.CompareTag("Ground"))
					//transform.LookAt(_hit.point);
					transform.LookAt (new Vector3(_hit.point.x, transform.position.y, _hit.point.z));
			}
		}
	}
}