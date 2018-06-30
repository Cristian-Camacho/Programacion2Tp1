using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Camper : Enemy
{
    public float damage;
    public float timerShoot;
    public Bullet bulle;
    public Transform shootPoint;
    private float _timer;
    private RaycastHit _hit;

    public override void UpdateMe()
    {
        _timer += Time.deltaTime;
        if (_timer >= timerShoot)
        {
            Shoot();
        }
    }


    void Shoot()
    {
        if (transform == null) return;

        var pointShoot = new Vector3(GameController.instance.MyHero().transform.position.x, shootPoint.position.y, GameController.instance.MyHero().transform.position.z);
        shootPoint.LookAt(pointShoot);
        if (Physics.Raycast(shootPoint.position, shootPoint.forward,out _hit))
        {
            if (_hit.collider.gameObject.CompareTag("Player"))
            {
                _timer = 0f;
                SoundManager.instance.PlaySound(SoundsIDs.ID_ENEMY_SHOOT);
                var b = Instantiate(bulle).OriginPosition(shootPoint.position).RotationStart(shootPoint.rotation).SetDamage(damage);
                b.IgnoreMyDamage(gameObject.GetComponent<Collider>());
            }
        }
    }
}
