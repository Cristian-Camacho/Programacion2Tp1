using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BombAttack : Bullet
{
    public GameObject feedbackAttack;
    private float _timerAir;
    private float _timeImpact;
    private float _data;
    private Floor _targetImpact;
    private Vector3 _middlePoint;
    private Vector3 _originPos;
    private float _floorTimeToDie;

    public void SetData(Vector3 origin, Floor target, float damag, float timeInAir, float timeToDestroyFloor,Collider ignoreCollision)
    {
        SetDamage(damag);
        _timeImpact = timeInAir;
        _targetImpact = target;
        _originPos = origin;
        _floorTimeToDie = timeToDestroyFloor;

        _middlePoint = new Vector3(target.gameObject.transform.position.x, origin.y, target.gameObject.transform.position.z);

        IgnoreMyDamage(ignoreCollision);
    }

    public override void UpdateMe()
    {
        base.UpdateMe();
        if (Vector3.Distance(transform.position, _targetImpact.gameObject.transform.position) < 1f)
            ImpactFloor();
    }

    protected override void OnTriggerEnter(Collider other)
    {
        if(other.GetComponent<IDamaged>() != null)
        {

            if (other.gameObject.CompareTag("Player")) other.GetComponent<Player>().TakeHit(damage);

            ImpactFloor();
        }
        GameController.instance.RemoveUpdateable(this);
        Destroy(this.gameObject);
    }

    private void ImpactFloor()
    {
        int amountN = 0;
        List<Floor> floorsAlive = new List<Floor>();
        foreach (var item in _targetImpact.neigthbors)
        {
            if(item != null)
            {
                if (item.ImNotAvaiable()) return;
                else{
                    amountN++;
                    floorsAlive.Add(item);
                }
            }
        }
        int selected = Random.Range(0, amountN);
        _targetImpact.TakeHit(_floorTimeToDie);
        floorsAlive[selected].TakeHit(_floorTimeToDie);
        SoundManager.instance.PlaySound(SoundsIDs.ID_IMPACT_FLOOR);
        var feedback = Instantiate(feedbackAttack, transform.position, Quaternion.identity);
        Destroy(feedback, 1.5f);
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
