using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BombAttack : MonoBehaviour
{
    private float _timerAir;
    private float _timeImpact;
    private float _data;
    private float _damage;
    private Vector3 _targetImpact;
    private Vector3 _middlePoint;
    private Vector3 _originPos;


    public void SetData(Vector3 origin, Vector3 target, float damage, float timeInAir)
    {
        _damage = damage;
        _timeImpact = timeInAir;

        _targetImpact = target;
        _originPos = origin;

        _middlePoint = new Vector3(target.x, origin.y, target.z);

    }


    void Update()
    {
        if (_targetImpact == null) return;

        _data = Mathf.Lerp(0, 1, _timerAir / _timeImpact);
        _timerAir += Time.deltaTime;

        var a = Vector3.Lerp(_originPos, _middlePoint, _data);
        var b = Vector3.Lerp(_middlePoint, _targetImpact, _data);
        transform.position = Vector3.Lerp(a, b, _data);

    }
}
