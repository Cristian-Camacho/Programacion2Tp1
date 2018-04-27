using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BombAttack : Bullet
{
    private float _timerAir;
    private float _timeImpact;
    private float _data;
    private Floor _targetImpact;
    private Vector3 _middlePoint;
    private Vector3 _originPos;
    public float floorTimeToDie;

    public void SetData(Vector3 origin, Floor target, float damag, float timeInAir, Collider ignoreCollision)
    {
        SetDamage(damag);
        _timeImpact = timeInAir;

        _targetImpact = target;
        _originPos = origin;

        _middlePoint = new Vector3(target.gameObject.transform.position.x, origin.y, target.gameObject.transform.position.z);

        Physics.IgnoreCollision(gameObject.GetComponent<Collider>(), ignoreCollision);
    }

    void Update()
    {
        Movement();
    }

    protected override void OnTriggerEnter(Collider other)
    {
        base.OnTriggerEnter(other);
        int amountN = 0;
        List<Floor> floorsAlive = new List<Floor>();
        foreach (var item in _targetImpact.neigthbors)
        {
            if (!item.MyCondicion()) return;
            amountN++;
            floorsAlive.Add(item);
        }
        int selected = Random.Range(0, amountN);
        floorsAlive[selected].TakeHit(floorTimeToDie);
    }

    public override void Movement()
    {
        if (_targetImpact == null) return;

        _data = Mathf.Lerp(0, 1, _timerAir / _timeImpact);
        _timerAir += Time.deltaTime;

        var a = Vector3.Lerp(_originPos, _middlePoint, _data);
        var b = Vector3.Lerp(_middlePoint, _targetImpact.gameObject.transform.position, _data);
        transform.position = Vector3.Lerp(a, b, _data);
    }

}
