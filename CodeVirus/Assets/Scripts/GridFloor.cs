using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GridFloor : MonoBehaviour
{
    private List<Floor> _availiavleFloors = new List<Floor>();
    private List<Floor> _unAvailiavleFloors = new List<Floor>();

    private float _inmunityTimer;
    public static GridFloor instance;

    public Material normalFloor, damagedFloor;
    public Dictionary<int, Material> materialsFloor;

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

        if(normalFloor != null && damagedFloor != null)
        {
            materialsFloor = new Dictionary<int, Material>();
            materialsFloor.Add(1, normalFloor);
            materialsFloor.Add(2, damagedFloor);
        }

        Console.instance.AddCommand(FloorInmunity, "CANTOUCHTHIS", "El piso no se rompe por un periodo de tiempo");
	}

    public Floor CloseToTransform(Transform t)
    {
        float distMin = Mathf.Infinity;
        float distTemp = 0f;
        Floor closer = null;

        foreach (var item in _availiavleFloors)
        {
            distTemp = Vector3.Distance(item.gameObject.transform.position, t.position);
            if(distTemp < distMin)
            {
                closer = item;
                distMin = distTemp;
            }
        }

        return closer;
    }

    public Floor RandomAvaiable()
    {
        return _availiavleFloors[Random.Range(0, _availiavleFloors.Count)];
    }

    public void RecoverFloor(Floor f)
    {
       
        _unAvailiavleFloors.Remove(f);
        _availiavleFloors.Add(f);
    }

    public void DeleteFloor(Floor f)
    {
        
        _unAvailiavleFloors.Add(f);
        _availiavleFloors.Remove(f);

    }

    public void FloorInmunity()
    {
        FloorInmunity(20f);
    }

    public void FloorInmunity(float duration)
    {
        foreach (var item in _unAvailiavleFloors)
        {
            item.RestoreFloor();
        }

        foreach (var f in _availiavleFloors)
        {
            f.inmunity = true;
        }
        _inmunityTimer += duration;
    }

    private void Update()
    {
        if (_inmunityTimer > 0f)
        {
            _inmunityTimer -= Time.deltaTime;
            if (_inmunityTimer < 0f) EndInmunity();
        }
    }

    void EndInmunity()
    {
        _inmunityTimer = 0f;
        foreach (var f in _availiavleFloors)
        {
            f.inmunity = false;
        }
        
    }
}
