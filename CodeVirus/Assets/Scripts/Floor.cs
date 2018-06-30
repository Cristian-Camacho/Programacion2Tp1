using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Floor : MonoBehaviour, IDamaged, IUpdateable
{
    public List<Floor> neigthbors;
    private Vector3 _originalPos;
    public float timeToRestore;
    private float _timerDesintegrate;
    float _timer;
    bool _activeCooldown;
    public float radiusNeight;
    public LayerMask floorMask;
    private Renderer _myRenderer;
    public bool inmunity;

	// Use this for initialization
	void Start ()
    {
        _originalPos = transform.position;
        if(neigthbors.Count == 0)
            GetNeigthbors();
        _myRenderer = gameObject.GetComponent<Renderer>();

        GameController.instance.AddUpdateble(this);
	}

    private void GetNeigthbors()
    {
        neigthbors.Clear();
        var close = Physics.OverlapSphere(transform.position, radiusNeight, floorMask);
        foreach (var item in close)
        {
            if (item.gameObject != this.gameObject)
            {
                neigthbors.Add(item.gameObject.GetComponent<Floor>());
            }
        }
    }

    
    public void UpdateMe()
    {
        if (!inmunity)
        {
            if (_activeCooldown)
            {
                _timer += Time.deltaTime;
                _myRenderer.material.SetFloat("_ColorChange", Mathf.Clamp(Mathf.Sin(Time.time), 0f, 1f));
                if (_timer >= _timerDesintegrate) Die();
            }
        }
    }

    /// <summary>
    /// En caso de que cooldown este activado, va a devolver que su condicion es falsa para que no sea usado.
    /// </summary>
    public bool ImNotAvaiable()
    {
        return _activeCooldown;
    }

    public void RestoreFloor()
    {
        StopCoroutine(WaitToRestore());
        _activeCooldown = false;
        transform.position = _originalPos;
        _myRenderer.material = GridFloor.instance.materialsFloor[1];
        GridFloor.instance.RecoverFloor(this);
    }

    public void TakeHit(float amount)
    {
        if (!inmunity)
        {
            if (_activeCooldown) return;
            _timerDesintegrate = amount;
            _activeCooldown = true;
            _myRenderer.material = GridFloor.instance.materialsFloor[2];
            GridFloor.instance.DeleteFloor(this);
        }
    }

    public void Die()
    {
        SoundManager.instance.PlaySound(SoundsIDs.ID_DESTROY_FLOOR);
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
