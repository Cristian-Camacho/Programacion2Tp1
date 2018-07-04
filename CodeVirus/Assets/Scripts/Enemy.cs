using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : Character
{
    [Range(0, 100)]
    public float dropChance;

    public DropBooster drop;
    public GameObject feedbackDead;

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
    public override void TakeHit(float amount)
    {
        FeedbackHit();
        base.TakeHit(amount);
    }

    protected override void Feedback()
    {
        base.Feedback();
        SoundManager.instance.PlaySound(SoundsIDs.ID_ENEMY1_DESTROY);
    }

    protected void FeedbackHit()
    {
        var feed = Instantiate(feedbackDead, transform.position, Quaternion.identity);
        Destroy(feed, 1f);
        SoundManager.instance.PlaySound(SoundsIDs.ID_MINION_HIT);

    }

    public override void UpdateMe() { }

}
