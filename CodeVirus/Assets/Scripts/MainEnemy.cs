using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainEnemy : MonoBehaviour, IDamaged, IUpdateable, IObservable
{
    public float totalLife;
    public float attackSpeed;
    public float powerDamage;
    public float timerDestroyFloor;
    private float _timerAttack = 0f;
    private float _currentLife;
    private Player _mainCharacter;
    public Transform attackPoint;
    private BombAttack _attackSphere;
    private GameObject _feedbackTarget;
    private List<IObserver> _observers;

	// Use this for initialization
	void Start ()
    {
        _currentLife = totalLife;
        _mainCharacter = FindObjectOfType<Player>();
        _attackSphere = Resources.Load("BombAttack", typeof(BombAttack)) as BombAttack;
        _feedbackTarget = Resources.Load("TargetedHexagon", typeof(GameObject)) as GameObject;
        _timerAttack = attackSpeed;
        _observers = new List<IObserver>();
        GameController.instance.AddUpdateble(this);
        Subscribe(CanvasController.instance);
    }
     

    public void UpdateMe()
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
        return _currentLife;
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

    public void TakeHit(float amount)
    {
        _currentLife -= amount / (2.5f * GameController.instance.CurrentFase());
        SoundManager.instance.PlaySound(SoundsIDs.ID_ENEMY2_DESTROY);
        foreach (var obs in _observers)
        {
            obs.Notify("bossHit");
        }
        if (_currentLife < 0f) Die();
    }

    public void Die()
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
