using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Weapon : MonoBehaviour, IUpdateable, IObservable
{
    public float cooldownShoot;
    private float _timerCooldown;
    private List<IObserver> _observers;
    public float damage;
    public Transform shootPoint;
    private Bullet _myBullet;
    public List<Bullet> posiblesBullets;
    public ControllerInput control;

	// Use this for initialization
	void Start ()
    {
        _myBullet = posiblesBullets[0];
        _observers = new List<IObserver>();
        Subscribe(CanvasController.instance);
        GameController.instance.AddUpdateble(this);
        Console.instance.AddCommand(PowerUpWeapon, "POWERWEAPON", "Change Bullet for a period of time");
	}
	
    public void UpdateMe()
    {
        _timerCooldown += Time.deltaTime;
        if (_timerCooldown >= cooldownShoot && control != null)
        {
            if(control.InputShoot() || GameController.instance.CanAutoShoot())
                Shoot();
        }
    }

    void Shoot()
    {
        _timerCooldown = 0f;
        SoundManager.instance.PlaySound(SoundsIDs.ID_SHOOT);
        var bullet = Instantiate(_myBullet).OriginPosition(shootPoint.position).RotationStart(Quaternion.identity).SetDamage(damage).ForwardDirection(shootPoint.forward);
        bullet.IgnoreMyDamage(GameController.instance.MyHero().gameObject.GetComponent<Collider>());
    }

    private void PowerUpWeapon()
    {
        PowerUpWeapon(20f);
    }

    public void PowerUpWeapon(float timer)
    {
        _myBullet = posiblesBullets[1];
        foreach (var obs in _observers)
        {
            obs.Notify("Double");
        }
        StartCoroutine(PowerDownWeapon(timer));
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

    IEnumerator PowerDownWeapon(float time)
    {
        yield return new WaitForSeconds(time);
        _myBullet = posiblesBullets[0];
        foreach (var obs in _observers)
        {
            obs.Notify("Double");
        }
        StopCoroutine("PowerDownWeapon");
    }
}
