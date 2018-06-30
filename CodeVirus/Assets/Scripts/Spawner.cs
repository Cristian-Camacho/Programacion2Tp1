using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spawner : MonoBehaviour, IUpdateable
{
    private Enemy _tipe1;
    private Enemy _tipe2;
    public float timerSpawn;
    private float currentTime;
    public int activate = 0;

    void Start()
    {
        _tipe1 = Resources.Load("Kamikaze", typeof(Kamikaze)) as Kamikaze;
        _tipe2 = Resources.Load("Camper", typeof(Camper)) as Camper;

        GameController.instance.AddUpdateble(this);
    }

    public void UpdateMe()
    {
        if (activate == 0) return;

        currentTime += Time.deltaTime;
        if (currentTime >= timerSpawn)
        {
            if (activate >= 1)
                SpawnKamikaze();
            if (activate >= 2)
                SpawnCamper(GridFloor.instance.RandomAvaiable());
        }
    }

    void SpawnKamikaze()
    {
        currentTime = 0f;
        var tempFloor = GridFloor.instance.CloseToTransform(GameController.instance.MyHero().transform);
        var spawnTrans = DropPos(tempFloor);
        if(spawnTrans != null)
           Instantiate(_tipe1, new Vector3(spawnTrans.position.x, transform.position.y, spawnTrans.position.z), Quaternion.identity);
    }

    private Transform DropPos(Floor f)
    {
        int firstN = Random.Range(0, f.neigthbors.Count);
        var SecondN = f.neigthbors[firstN].neigthbors[Random.Range(0, f.neigthbors[firstN].neigthbors.Count)];

        if (SecondN.ImNotAvaiable())
        {
            if (f.neigthbors[firstN] != null)
                return DropPos(f.neigthbors[firstN]);
            else return null;
        }
        else
        {
            return SecondN.transform;
        }
    }

    void SpawnCamper(Floor f)
    {
        var floorAvaiable = f;
        var floorPlayer = GridFloor.instance.CloseToTransform(GameController.instance.MyHero().transform);
        if (floorPlayer.neigthbors.Contains(floorAvaiable)) SpawnCamper(GridFloor.instance.RandomAvaiable());
        else
        {
            Instantiate(_tipe2, new Vector3(floorAvaiable.transform.position.x, transform.position.y, floorAvaiable.transform.position.z), Quaternion.identity);
        }
    }
    
}
