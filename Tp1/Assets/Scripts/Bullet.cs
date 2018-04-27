using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    protected float damage;
    public virtual void Movement() { }

    protected virtual void OnTriggerEnter(Collider other)
    {
        print("AAAAA");
        var component = other.gameObject.GetComponent<IDamaged>();
        if (component != null)
        {
            print("Dañe algo");
            component.TakeHit(damage);
            Destroy(this.gameObject);
        }
        else print("this is not posible damage");
            
    }

    private void OnTriggerStay(Collider other)
    {
        print("VVVVVVVV");
    }

    public void SetDamage(float dam)
    {
        damage = dam;
    }
}
