using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Weapon : MonoBehaviour
{
    public float cooldownShoot;
    private float _timerCooldown;
    public float damage;
    public Transform shootPoint;
    private Bullet _myBullet;
    public List<Bullet> posiblesBullets;

	// Use this for initialization
	void Start ()
    {
        _myBullet = posiblesBullets[0];
	}
	
	// Update is called once per frame
	void Update ()
    {
        _timerCooldown += Time.deltaTime;
        if (Input.GetMouseButton(0) && _timerCooldown >= cooldownShoot) { Shoot(); }
	}

    void Shoot()
    {
        _timerCooldown = 0f;
        var bullet = Instantiate(_myBullet, shootPoint.position, shootPoint.rotation);
        bullet.SetDamage(damage);

    }

    public void PowerUpWeapon(float timer)
    {
        _myBullet = posiblesBullets[1];
        StartCoroutine(PowerDownWeapon(timer));
    }

    IEnumerator PowerDownWeapon(float time)
    {
        yield return new WaitForSeconds(time);
        _myBullet = posiblesBullets[0];
        StopCoroutine("PowerDownWeapon");
    }
}
