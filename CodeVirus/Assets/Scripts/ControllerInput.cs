using UnityEngine;

public abstract class ControllerInput 
{
    protected float _speed;
    protected GameObject _myBody;

    public abstract void CheckMovement();

    public abstract bool InputShoot();
}
