using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MobileInputs : ControllerInput
{
    public Stick stick;
    public Stick stickAim;
    private float angle;
    protected GameObject _myModel;

    public MobileInputs(GameObject body, float speed, GameObject model)
    {
        _myBody = body;
        _speed = speed;
        _myModel = model;
        stickAim = CanvasController.instance.aimStick;
        stick = CanvasController.instance.moveStick;
    }

    public override void CheckMovement()
    {
        
        _myBody.transform.position += Vector3.right * stick.stickValue.normalized.x * _speed * Time.deltaTime;
        _myBody.transform.position += Vector3.forward * stick.stickValue.normalized.y * _speed * Time.deltaTime;

        if(stickAim.rotateModel)
        {
            if(stickAim.stickValue != Vector3.zero)
                angle = (Mathf.Atan2(stickAim.stickValue.x, -stickAim.stickValue.y) * 180 / Mathf.PI) * -1f;
            _myModel.transform.eulerAngles = new Vector3(0, angle,0);

        }
    }



    public override bool InputShoot()
    {   
        return stickAim.inTouch;
    }
}
