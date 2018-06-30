using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DropBooster : MonoBehaviour, IUpdateable
{
    public int typeBoost;
    public float timer;
    public float healAmount;
    public Vector3 rotate;
    public GameObject doubleShoot;
    public GameObject heal;
    public void SetType(int typ)
    {
        if (typ == 1)
        {
            typeBoost = typ;
            rotate = new Vector3(0, 0, 0);
            heal.SetActive(true);
        }
        else if (typ == 2)
        {
            typeBoost = typ;
            rotate = new Vector3(0, 3, 3);
            doubleShoot.SetActive(true);
        }

        GameController.instance.AddUpdateble(this);
    }

    public void UpdateMe()
    {
        transform.Rotate(rotate);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            if (typeBoost == 1)
            {
                SoundManager.instance.PlaySound(SoundsIDs.ID_HEAL_PICKUP);
                GameController.instance.MyHero().Heal(healAmount);
            }
            else if (typeBoost == 2)
            {
                SoundManager.instance.PlaySound(SoundsIDs.ID_POWERUP);
                GameController.instance.MyHero().MyWeapon().PowerUpWeapon(timer);
            }

            GameController.instance.RemoveUpdateable(this);
            Destroy(this.gameObject);
        }
    }
}
