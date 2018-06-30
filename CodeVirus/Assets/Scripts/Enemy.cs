using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : Character
{
    [Range(0, 100)]
    public float dropChance;

    public DropBooster drop;

    public override void Die()
    {
        float chance = Random.Range(0, 100);
        if (chance < dropChance)
        {
            var dro = Instantiate(drop, transform.position, Quaternion.identity);
            if (chance % 2 == 0) dro.SetType(1);
            else dro.SetType(2);
        }

        Feedback();
        RemoveMe();
        Destroy(this.gameObject);
    }

    protected override void Feedback()
    {
        base.Feedback();
        SoundManager.instance.PlaySound(SoundsIDs.ID_ENEMY1_DESTROY);
    }

    public override void UpdateMe() { }

}
