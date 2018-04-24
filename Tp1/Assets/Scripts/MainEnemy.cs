using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainEnemy : MonoBehaviour
{
    private Player _mainCharacter;

	// Use this for initialization
	void Start ()
    {
        _mainCharacter = FindObjectOfType<Player>();
		
	}
	
	// Update is called once per frame
	void Update ()
    {
        if (Input.GetKeyUp(KeyCode.Space))
            DestroyFloor();
		
	}

    void DestroyFloor()
    {
        var target = GridFloor.instance.CloseToPlayer(_mainCharacter.transform);
        target.UnAvaliable();
    }
}
