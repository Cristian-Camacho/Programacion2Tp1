using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Character : MonoBehaviour , IDamaged
{
	private float _maxLife;
	public float currentLife;
	public float speed;


	void Start () 
	{
		_maxLife = currentLife;
		
	}

	public void TakeHit(float amount) 
	{
		currentLife -= amount;
		if (currentLife <= 0f)
			Die();
	}
	public void Die() 
	{

	}
}
