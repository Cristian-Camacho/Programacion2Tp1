using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Floor : MonoBehaviour, IDamaged
{
    public List<Floor> neigthbors;
    private Vector3 _originalPos;
    public float timeToRestore;
    private float _timerDesintegrate;
    float _timer;
    bool _activeCooldown;

	// Use this for initialization
	void Start ()
    {
        _originalPos = transform.position;
		
	}

    // Update is called once per frame
    void Update()
    {
        if (_activeCooldown)
        {
            _timer += Time.deltaTime;
            if (_timer >= _timerDesintegrate) Die();
        }
    }

    /// <summary>
    /// En caso de que active cooldown este activado, va a devolver que su condicion es falsa para que no sea usado.
    /// </summary>
    public bool MyCondicion()
    {
        return !_activeCooldown;
    }

    public void RestoreFloor()
    {
        StopCoroutine(WaitToRestore());
        _activeCooldown = false;
        transform.position = _originalPos;
        GridFloor.instance.RecoverFloor(this);
    }

    public void TakeHit(float amount)
    {
        if (_activeCooldown) return;
        _timerDesintegrate = amount;
        _activeCooldown = true;
    }

    public void Die()
    {
        transform.position -= -Vector3.up * 20f;
        _timer = 0f;
        StartCoroutine(WaitToRestore());
    }

    IEnumerator WaitToRestore()
    {
        yield return new WaitForSeconds(timeToRestore);
        RestoreFloor();
    }
}
