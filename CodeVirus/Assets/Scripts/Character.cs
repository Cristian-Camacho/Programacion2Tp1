using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Character : MonoBehaviour , IDamaged, IUpdateable
{
	protected float _maxLife = 100;
	public float currentLife;
    public GameObject dieFeedback;

    protected virtual void Start () 
	{
		currentLife = _maxLife;
        GameController.instance.AddUpdateble(this);
	}

	public virtual void TakeHit(float amount) 
	{
		currentLife -= amount;
		if (currentLife <= 1f)
			Die();
	}

    protected virtual void Feedback()
    {
        var feed = Instantiate(dieFeedback, transform.position, Quaternion.identity);
        Destroy(feed, 1.5f);
    }


    public abstract void Die();

    public abstract void UpdateMe();

    public void RemoveMe()
    {
        GameController.instance.RemoveUpdateable(this);
    }
}
