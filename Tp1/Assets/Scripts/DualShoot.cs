using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DualShoot : Bullet
{
    public float speed;
    public float rotationSpeed;
    public GameObject ball1;
    public GameObject ball2;
	
	// Update is called once per frame
	void Update ()
    {
        Movement();
	}

    public override void Movement()
    {
        var tempo = Mathf.Cos(Time.time);
        var tempo2 = Mathf.Sin(Time.time);
        print ("pos rota " + tempo);

        ball1.transform.position += new Vector3(tempo* rotationSpeed , 0,0);
        ball2.transform.position+= new Vector3(tempo2* rotationSpeed , 0,0);

        transform.position += transform.forward * speed * Time.deltaTime;
    }

    protected override void OnTriggerEnter(Collider other)
    {
        base.OnTriggerEnter(other);
    }
}
