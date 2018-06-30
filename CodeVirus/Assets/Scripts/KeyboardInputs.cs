using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KeyboardInputs : ControllerInput
{
    private Ray _cameraRay = new Ray();
    private RaycastHit _hit;

    public KeyboardInputs(GameObject body, float speed)
    {
        _myBody = body;
        _speed = speed;
    }

    public override void CheckMovement()
    {

        _myBody.transform.position += Vector3.right * Input.GetAxis("Horizontal") * _speed * Time.deltaTime;
        _myBody.transform.position += Vector3.forward * Input.GetAxis("Vertical") * _speed * Time.deltaTime;

        if (Input.mousePosition != null)
            _cameraRay = Camera.main.ScreenPointToRay(Input.mousePosition);

        if (Physics.Raycast(_cameraRay, out _hit))
        {
            if (_hit.transform.gameObject.CompareTag("Ground") || _hit.transform.gameObject.CompareTag("Boss") || _hit.transform.gameObject.CompareTag("Enemy"))
                _myBody.transform.LookAt(new Vector3(_hit.point.x, _myBody.transform.position.y, _hit.point.z));
        }

    }

    public override bool InputShoot()
    {
        return Input.GetMouseButton(0);
    }

}
