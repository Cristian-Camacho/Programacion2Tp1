using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainEnemy : Character, IObservable
{
    public float totalLife;
    public float attackSpeed;
    public float powerDamage;
    public float timerDestroyFloor;
    private float _timerAttack = 0f;
    private Player _mainCharacter;
    public Transform attackPoint;
    private BombAttack _attackSphere;
    private GameObject _feedbackTarget;
    private List<IObserver> _observers;

    // Use this for initialization
    protected override void Start()
    {
        currentLife = totalLife;
        _mainCharacter = FindObjectOfType<Player>();
        _attackSphere = Resources.Load("BombAttack", typeof(BombAttack)) as BombAttack;
        _feedbackTarget = Resources.Load("TargetedHexagon", typeof(GameObject)) as GameObject;
        _timerAttack = attackSpeed;
        _observers = new List<IObserver>();
        GameController.instance.AddUpdateble(this);
        Subscribe(CanvasController.instance);
    }


    public override void UpdateMe()
    {
        if (_timerAttack > 0f)
            _timerAttack -= Time.deltaTime;
        else if (_timerAttack < 0f)
        {
            _timerAttack = 0f;
            ShootPlayer();
        }
    }

    public float CurrentLife()
    {
        return currentLife;
    }
    

    private void ShootPlayer()
    {
        _timerAttack = attackSpeed;
        SoundManager.instance.PlaySound(SoundsIDs.ID_ENEMY_SHOOT);
        var atk = Instantiate(_attackSphere, attackPoint.position, Quaternion.identity);
        var dir = GridFloor.instance.CloseToTransform(_mainCharacter.transform);
        atk.SetData(attackPoint.position, dir, powerDamage, attackSpeed, timerDestroyFloor,this.gameObject.GetComponent<Collider>());
        var feedback = Instantiate(_feedbackTarget, dir.transform.position, dir.transform.rotation);
        Destroy(feedback, timerDestroyFloor);
    }

    public override void TakeHit(float amount)
    {
        currentLife -= amount / (2.5f * GameController.instance.CurrentFase());
        Feedback();
        SoundManager.instance.PlaySound(SoundsIDs.ID_ENEMY2_DESTROY);
        foreach (var obs in _observers)
        {
            obs.Notify("bossHit");
        }
        if (currentLife < 0f) Die();
    }

    public override void Die()
    {
        GameController.instance.RemoveUpdateable(this);
        GameController.instance.Victory();
    }

    public void Subscribe(IObserver observer)
    {
        if (!_observers.Contains(observer))
            _observers.Add(observer);
    }

    public void Unsubscribe(IObserver observer)
    {
        if (_observers.Contains(observer))
            _observers.Remove(observer);
    }
}
