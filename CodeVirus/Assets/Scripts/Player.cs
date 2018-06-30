using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : Character, IObservable
{

    public float speed;
    private Weapon _myweapon;
    public GameObject model;
    private bool godLike = false;
    private Vector3 _starterPos;
    private List<IObserver> _observers;
    private Rigidbody _MyRigidbody;
    public ControllerInput _myController;

    protected override void Start()
    {
        base.Start();
        _starterPos = transform.position;
        _MyRigidbody = GetComponent<Rigidbody>();
        _myweapon = gameObject.GetComponentInChildren<Weapon>();
        _observers = new List<IObserver>();
        if (SystemInfo.deviceType == DeviceType.Handheld)
            _myController = new MobileInputs(this.gameObject, speed, model);
        else
            _myController = new KeyboardInputs(this.gameObject, speed);
  
        _myweapon.control = _myController;
        Subscribe(CanvasController.instance);
        Console.instance.AddCommand(RestoreLife, "HEALING", "Recupera la vida al maximo");
        Console.instance.AddCommand(GodLike, "GODLIKE", "Activa y desactiva la inmunidad al daño");
    }

    public override void UpdateMe()
    {
        if (_myController != null)
            _myController.CheckMovement();
    }

    public float MaxLifePlayer()
    {
        return _maxLife;
    }

    public Weapon MyWeapon()
    {
        return _myweapon;
    }

    public override void Die()
    {

        _MyRigidbody.useGravity = false;
        RemoveMe();
        GameController.instance.Defeat();
    }

    public void Revive()
    {
        RestoreLife();
        GameController.instance.AddUpdateble(this);
        _MyRigidbody.velocity = Vector3.zero;
        _MyRigidbody.useGravity = true;
        transform.position = _starterPos;
    }

    public void GodLike()
    {
        godLike = !godLike;
    }

    public override void TakeHit(float amount)
    {
        SoundManager.instance.PlaySound(SoundsIDs.ID_HERO_HIT);
        Feedback();
        if (godLike) amount -= amount;
        foreach (var obs in _observers)
        {
            obs.Notify("playerLifeMod");
        }
        base.TakeHit(amount);
    }

    public void Heal(float h)
    {
        currentLife += h;
        if (currentLife > _maxLife) currentLife = _maxLife;
        foreach (var obs in _observers)
        {
            obs.Notify("playerLifeMod");
        }
    }

    public void RestoreLife()
    {
        currentLife = _maxLife;
        foreach (var obs in _observers)
        {
            obs.Notify("playerLifeMod");
        }
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
