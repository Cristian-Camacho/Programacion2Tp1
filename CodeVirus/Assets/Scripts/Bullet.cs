using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour, IUpdateable
{
    protected float damage;
    public float speed;

    void Start()
    {
        GameController.instance.AddUpdateble(this);
    }

    protected virtual void OnTriggerEnter(Collider other)
    {
        var component = other.gameObject.GetComponent<IDamaged>();
        if (component != null)
        {
            component.TakeHit(damage);
        }
        
        GameController.instance.RemoveUpdateable(this);
        Destroy(this.gameObject);
    }

    public Bullet OriginPosition(Vector3 pos)
    {
        transform.position = pos;
        return this;
    }

    public Bullet RotationStart(Quaternion quad)
    {
        transform.rotation = quad;
        return this;
    }

    public Bullet ForwardDirection(Vector3 ford)
    {
        transform.forward = ford;
        return this;
    }

    public Bullet IgnoreMyDamage(Collider ignoreCollision)
    {
        Physics.IgnoreCollision(gameObject.GetComponent<Collider>(), ignoreCollision);
        return this;
    }

    public Bullet SetDamage(float dam)
    {
        damage = dam;
        return this;
    }

    public virtual void Movement()
    {
        transform.position += transform.forward * speed * Time.deltaTime;
    }

    public virtual void UpdateMe()
    {
        Movement();
    }
    
}
