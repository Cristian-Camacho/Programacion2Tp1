using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Destroyed : MonoBehaviour
{

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
            other.GetComponent<Player>().Die();
        else if (!other.gameObject.CompareTag("Ground"))
        {
            if (other.GetComponent<Character>() != null)
                other.GetComponent<Character>().RemoveMe();
            Destroy(other.gameObject);
        }
    }
}
