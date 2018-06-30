using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Kamikaze : Enemy
{
    public float speed;
    public float damage;
    public float explosionRadius;
    public float timeToExplote;
    public float timeDestroyFloor;
    public GameObject fireFeed;
    private Transform _target;
    private bool _startExplosion;
    private bool _grounded = false;

    protected override void Start()
    {
        base.Start();
        _target = GameController.instance.MyHero().transform;
        fireFeed.SetActive(false);
    }

    public override void UpdateMe()
    {
        if (this == null)
        {
            GameController.instance.RemoveUpdateable(this);
            Destroy(this);
        }

        if (!_startExplosion && _grounded)
        {
            transform.position += transform.forward * speed * Time.deltaTime;
            transform.LookAt(_target.position);
        }

        if (Vector3.Distance(_target.position, transform.position) < explosionRadius / 2) StartCoroutine(Explosion());
    }

    
    IEnumerator Explosion()
    {
        _startExplosion = true;
        fireFeed.SetActive(true);
        yield return new WaitForSeconds(timeToExplote);

        var sphe = Physics.OverlapSphere(transform.position, explosionRadius);
        foreach (var item in sphe)
        {
            if (item.CompareTag("Player"))
                item.GetComponent<IDamaged>().TakeHit(damage);
        }
        var f = GridFloor.instance.CloseToTransform(this.transform);
        f.TakeHit(timeDestroyFloor);
        Feedback();
        GameController.instance.RemoveUpdateable(this);
        Destroy(this.gameObject);
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Ground")) _grounded = true;
        if (collision.gameObject.CompareTag("Enemy")) _grounded = true;
    }
}
