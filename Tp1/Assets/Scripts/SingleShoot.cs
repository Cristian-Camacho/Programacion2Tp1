using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SingleShoot : Bullet
{
    public float speed;

	void Update ()
    {
        Movement();		
	}

    public override void Movement()
    {
        transform.position += transform.forward * speed * Time.deltaTime;
    }

    protected override void OnTriggerEnter(Collider other)
    {
        base.OnTriggerEnter(other);
    }
}
