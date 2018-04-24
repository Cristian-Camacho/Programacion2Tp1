using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Floor : MonoBehaviour
{
    public List<Floor> neigthbors;
    private Vector3 _originalPos;
    public float timerCooldown;
    float _timer = 0f;
    bool _activeCooldown;

	// Use this for initialization
	void Start ()
    {
        _originalPos = transform.position;
		
	}
	
	// Update is called once per frame
	void Update ()
    {
        if(_activeCooldown) _timer -= Time.deltaTime;
        if (_timer < 0f) RestoreFloor();
		
	}

    public void UnAvaliable()
    {
        transform.position -= -Vector3.up * 20f;
        _timer = timerCooldown;
        _activeCooldown = true;
    }

    public void RestoreFloor()
    {
        _activeCooldown = false;
        _timer = 0f;
        transform.position = _originalPos;
        GridFloor.instance.RecoverFloor(this);
    }
}
