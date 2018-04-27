using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainEnemy : MonoBehaviour, IDamaged
{
    public float totalLife;
    public float attackSpeed;
    public float powerDamage;
    public float _timerAttack = 0f;
    public float _currentLife;
    private Player _mainCharacter;
    public Transform attackPoint;
    public BombAttack _attackSphere;

	// Use this for initialization
	void Start ()
    {
        _currentLife = totalLife;
        _mainCharacter = FindObjectOfType<Player>();
        _attackSphere = Resources.Load("BombAttack", typeof(BombAttack)) as BombAttack;
	}
	
	// Update is called once per frame
	void Update ()
    {
        if (_timerAttack > 0f)
            _timerAttack -= Time.deltaTime;
        else if (_timerAttack < 0f) _timerAttack = 0f;

        if (Input.GetKeyUp(KeyCode.Space) && _timerAttack == 0f)
            ShootPlayer();

        //DestroyFloor();
		
	}
    

    private void ShootPlayer()
    {
        _timerAttack = attackSpeed;
        var atk = Instantiate(_attackSphere, attackPoint.position, Quaternion.identity);
        var dir = GridFloor.instance.CloseToPlayer(_mainCharacter.transform);
        atk.SetData(attackPoint.position, dir, powerDamage, attackSpeed, this.gameObject.GetComponent<Collider>());


    }

    public void TakeHit(float amount)
    {
        _currentLife -= amount / amount;
        if (_currentLife < 0f) Die();
    }

    public void Die()
    {
    }
}
