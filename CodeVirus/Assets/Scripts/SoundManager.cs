using UnityEngine;
using System.Collections.Generic;

public class SoundManager : MonoBehaviour
{

    public static SoundManager instance;

    public AudioClip[] clips;

    public int channelCount;
    private List<AudioSource> channels;
    public const int NO_CHANNEL = -1;


    void Awake()
    {

        if (instance == null)
        {
            instance = this;
        }
        else
        {
            //Component.Destroy(this);
            Debug.LogError("SoundManager ERROR: hay dos instancias de la clase en la escena");
        }
    }
    // Use this for initialization
    void Start()
    {
        CreateChannels();
    }

    public void CreateChannels()
    {
        channels = new List<AudioSource>();

        for (int i = 0; i < channelCount; i++)
        {
            //GameObject.FindGameObjectWithTag("MainCamera")
            channels.Add(Camera.main.gameObject.AddComponent<AudioSource>());
        }
    }

    private int FindEmptyChannel()
    {
        for (int i = 0; i < channels.Count; i++)
        {
            if (channels[i].isPlaying == false)
            {
                return i;
            }
        }

        return NO_CHANNEL;
    }

    public void PlayMenuButtomSound()
    {
        PlaySound(SoundsIDs.ID_BUTTOM_PRESS);
    }

    public void PlaySound(int id)
    {
        PlaySound(id, 1, false);
    }

    public void PlaySound(int id, float vol)
    {
        PlaySound(id, vol, false);
    }

    public void PlaySound(int id, bool loop)
    {
        PlaySound(id, 1, loop);
    }


    public void PlaySound(int id, float vol, bool loop)
    {

        int empty = FindEmptyChannel();

        if (empty == NO_CHANNEL)
        {
            Debug.LogWarning("SoundManager: No hay canales disponibles. Pruebe aumentar la variable channelCount.");
            return;
        }

        if (id > clips.Length)
        {
            Debug.LogError("SoundManager:  ERROR el id: " + id + " no existe en la definicion de los clips. Revise la variable clips.");
            return;
        }

        channels[empty].clip = clips[id];
        channels[empty].volume = vol;
        channels[empty].loop = loop;

        channels[empty].Play();
    }

    public void Stop()
    {
        for (int i = 0; i < channels.Count; i++)
        {
            channels[i].Stop();
        }
    }

    public void Stop(int channelID)
    {
        channels[channelID].Stop();
    }
}

public class SoundsIDs : MonoBehaviour
{

    public const int ID_SHOOT = 0;
    public const int ID_HERO_HIT = 1;
    public const int ID_ENEMY_SHOOT = 2;
    public const int ID_ENEMY1_DESTROY = 3;
    public const int ID_ENEMY2_DESTROY = 4;
    public const int ID_IMPACT_FLOOR = 5;
    public const int ID_DESTROY_FLOOR = 6;
    public const int ID_HEAL_PICKUP = 7;
    public const int ID_POWERUP = 8;
    public const int ID_BUTTOM_PRESS = 9;
    public const int ID_PAUSE_ON = 10;
    public const int ID_PAUSE_OFF = 11;
    public const int ID_FASE_UP = 12;

    public const int ID_FASE_1 = 13;
    public const int ID_FASE_2 = 14;
    public const int ID_FASE_3 = 15;

    public const int ID_MAINBOSS_HIT = 16;
    public const int ID_MINION_HIT = 17;
}

