using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Advertisements;

public class GameController : MonoBehaviour, IObservable
{

    public static GameController instance;
    private List<IUpdateable> _updateables;
    private List<IObserver> _observers;
    private MainEnemy _mainBoss;
    private Player _hero;
    private int fase = 1;
    public AudioSource mainSound;
    private bool paused = false;
    private bool autoShoot = false;

    // Use this for initialization
    void Awake()
    {
        if (instance != null) Destroy(this);
        instance = this;
        _updateables = new List<IUpdateable>();
        _observers = new List<IObserver>();
        SoundManager.instance.CreateChannels();
    }

    void Start()
    {
        Advertisement.Initialize("2648159");
        _mainBoss = FindObjectOfType<MainEnemy>();
        _hero = FindObjectOfType<Player>();
        mainSound.clip = SoundManager.instance.clips[SoundsIDs.ID_FASE_1];
        mainSound.Play();
    }

    void Update()
    {
        if (!paused)
        {
            if (Input.GetKeyUp(KeyCode.LeftControl)) OpenConsole();
            else if (Input.GetKeyUp(KeyCode.Escape)) PauseGame();
        }else
        {
            if (Input.GetKeyUp(KeyCode.LeftControl)) OpenConsole();
            else if (Input.GetKeyUp(KeyCode.Escape)) CloseConsole();
        }



        if (!paused && _updateables.Count > 0)
        {
            foreach (var upts in _updateables)
            {
                upts.UpdateMe();
            }
        }

        if (CurrentLifeBossPercentage() <= 0.8f && fase == 1)
            ActivateFase2();

        if (CurrentLifeBossPercentage() <= 0.4f && fase == 2)
            ActivateFase3();
    }

    public void OpenConsole()
    {
        foreach (var obs in _observers)
        {
            obs.Notify("console");
        }
        
         PauseGame();
    }

    public void CloseConsole()
    {
        foreach (var obs in _observers)
        {
            obs.Notify("close-console");
        }

        ResumeGame();
    }

    public void PauseGame()
    {
        foreach (var obs in _observers)
        {
            obs.Notify("pause");
        }
            paused = true;
    }

    public void ResumeGame()
    {
        foreach (var obs in _observers)
        {
            obs.Notify("resume");
        }
            paused = false;
    }

    public void AddUpdateble(IUpdateable me)
    {
        _updateables.Add(me);
    }

    public void RemoveUpdateable(IUpdateable me)
    {
        _updateables.Remove(me);
    }

    public Player MyHero()
    {
        return _hero;
    }

    public MainEnemy MainBoss()
    {
        return _mainBoss;
    }

    public float CurrentFase()
    {
        return (float)fase;
    }

    public void AudioOn(bool active)
    {
        Debug.Log("audio " + active);
        Camera.main.GetComponent<AudioListener>().enabled = active;
    }

    public void AutoShoot(bool active)
    {
        autoShoot = active;
    }

    public bool CanAutoShoot()
    {
        return autoShoot;
    }

    public void ActivateFase2()
    {
        SoundManager.instance.PlaySound(SoundsIDs.ID_FASE_UP);
        gameObject.GetComponent<Spawner>().activate = 1;
        mainSound.clip = SoundManager.instance.clips[SoundsIDs.ID_FASE_2];
        mainSound.Play();
        fase = 2;
    }


    public void ActivateFase3()
    {
        SoundManager.instance.PlaySound(SoundsIDs.ID_FASE_UP);
        gameObject.GetComponent<Spawner>().activate = 2;
        mainSound.clip = SoundManager.instance.clips[SoundsIDs.ID_FASE_3];
        mainSound.Play();
        fase = 3;
    }
    public float CurrentLifeBossPercentage()
    {
        return _mainBoss.CurrentLife() / _mainBoss.totalLife;
    }

    public float CurrentLifePlayer()
    {
        if (_hero.MaxLifePlayer() == 0) return 1;
        else return _hero.currentLife / _hero.MaxLifePlayer();
    }

    public void Victory()
    {
        SceneManager.LoadScene(2, LoadSceneMode.Single);
    }

    public void Defeat()
    {
        paused = true;
        foreach (var item in _observers)
        {
            item.Notify("gameover");
        }

    }

    private void PlayerRevive()
    {
        foreach (var item in _observers)
        {
            item.Notify("revive");
        }
        var enemies = FindObjectsOfType<Enemy>();
        for (int i = 0; i < enemies.Length; i++)
        {
            RemoveUpdateable(enemies[i]);
            Destroy(enemies[i].gameObject);
        }
        var bullets = FindObjectsOfType<Bullet>();
        for (int j = 0; j < bullets.Length; j++)
        {
            RemoveUpdateable(bullets[j]);
            Destroy(bullets[j].gameObject);
        }

        paused = false;
        _hero.GetComponent<Rigidbody>().useGravity = false;
        _hero.Revive();
        _hero.MyWeapon().PowerUpWeapon(10f);

    }

    public void ShowRewardedVideo()
    {
        if (Advertisement.IsReady("rewardedVideo"))
        {
            var opt = new ShowOptions { resultCallback = HandlerAd };
            Advertisement.Show("rewardedVideo", opt);
        }
    }

    private void HandlerAd(ShowResult result)
    {

        if (result == ShowResult.Finished)
            PlayerRevive();
    }


    public void Subscribe(IObserver observer)
    {
        if (!_observers.Contains(observer))
            _observers.Add(observer);
    }

    public void Unsubscribe(IObserver observer)
    {
        if (_observers.Contains(observer))
            _observers.Remove(observer);
    }
}
