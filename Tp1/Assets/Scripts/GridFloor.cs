using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GridFloor : MonoBehaviour
{
    private List<Floor> _availiavleFloors;
    private List<Floor> _unAvailiavleFloors;

    public static GridFloor instance;

    private void Awake()
    {
        if (instance != null) Destroy(this);
        instance = this;
    }

    // Use this for initialization
    void Start ()
    {
        var childs = GetComponentsInChildren<Floor>();
        foreach (var item in childs)
        {
            _availiavleFloors.Add(item);
        }
	}

    public Floor CloseToPlayer(Transform t)
    {
        float distMin = Mathf.Infinity;
        float distTemp = 0f;
        Floor closer = new Floor();

        foreach (var item in _availiavleFloors)
        {
            distTemp = Vector3.Distance(item.gameObject.transform.position, t.position);
            if(distTemp < distMin)
            {
                closer = item;
                distMin = distTemp;
            }
        }

        _availiavleFloors.Remove(closer);
        _unAvailiavleFloors.Add(closer);

        return closer;
    }

    public void RecoverFloor(Floor f)
    {
        if (_availiavleFloors.Contains(f)) print("suelo ya esta disponible");
        if (!_unAvailiavleFloors.Contains(f)) print("El suelo no esta en la lista de no disponible");

        _unAvailiavleFloors.Remove(f);
        _availiavleFloors.Add(f);
    }
}
