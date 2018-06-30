using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DualShoot : Bullet
{ 

    protected override void OnTriggerEnter(Collider other)
    {
        var component = other.gameObject.GetComponent<IDamaged>();
        if (component != null)
        {
            component.TakeHit(damage);
            component.TakeHit(damage);
        }
        GameController.instance.RemoveUpdateable(this);
        Destroy(this.gameObject);
    }
}
