using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class CanvasController : MonoBehaviour, IObserver
{
    public static CanvasController instance;
    public Image playerLife;
    public Image bossLifeBar;
    public GameObject feedbackDoubleShoot;
    public GameObject console;
    public GameObject pauseMenu;
    public GameObject defeatMenu;
    public GameObject mobileInput;
    public Stick moveStick;
    public Stick aimStick;
    public GameObject caseNoAds;
    public Button adButton;
    private Dictionary<string, Action> _actions;

    private void Awake()
    {
        
        if (instance == null) instance = this;
    }

    private void Start()
    {

        GameController.instance.Subscribe(this);
        feedbackDoubleShoot.SetActive(false);
        pauseMenu.SetActive(false);
        console.SetActive(false);
        defeatMenu.SetActive(false);
        if (SystemInfo.deviceType == DeviceType.Handheld)
            mobileInput.SetActive(true);
        else
        {
            adButton.enabled = false;
            mobileInput.SetActive(false);
            caseNoAds.SetActive(true);
        }

        CreateDictionary();
    }

    private void CreateDictionary()
    {
        _actions = new Dictionary<string, Action>();

        _actions.Add("pause", PauseGame);
        _actions.Add("resume", ResumeGame);
        _actions.Add("close-console", CloseConsole);
        _actions.Add("console", OpenConsole);
        _actions.Add("gameover", EndGame);
        _actions.Add("revive", EndGame);
        _actions.Add("bossHit", UpdateBoss);
        _actions.Add("playerLifeMod", UpdatePlayer);
        _actions.Add("Double", DoubleFeedback);
    }
    

    public void Notify(string action)
    {
        if (_actions.ContainsKey(action))
            _actions[action]();
    }

    void PauseGame()
    {
        pauseMenu.SetActive(true);
        SoundManager.instance.PlaySound(SoundsIDs.ID_PAUSE_ON);
    }

    void ResumeGame()
    {
        SoundManager.instance.PlaySound(SoundsIDs.ID_PAUSE_OFF);
        pauseMenu.SetActive(false);
    }

    void OpenConsole()
    {
        console.SetActive(true);
    }

    void CloseConsole()
    {
        console.SetActive(false);
    }

    void EndGame()
    {
        defeatMenu.SetActive(!defeatMenu.activeSelf);
    }

    public void DoubleFeedback()
    {
        if (feedbackDoubleShoot.activeSelf)
            feedbackDoubleShoot.SetActive(false);
        else if (!feedbackDoubleShoot.activeSelf)
            feedbackDoubleShoot.SetActive(true);

    }

    public void UpdateBoss()
    {
        bossLifeBar.fillAmount = GameController.instance.CurrentLifeBossPercentage();
    }

    public void UpdatePlayer()
    {
        playerLife.fillAmount = GameController.instance.CurrentLifePlayer();
    }

    public void GoToMainMenu()
    {
        SoundManager.instance.PlayMenuButtomSound();
        SceneManager.LoadScene(0, LoadSceneMode.Single);
    }

    public void RestartGame()
    {
        SoundManager.instance.PlayMenuButtomSound();
        SceneManager.LoadScene(1, LoadSceneMode.Single);
    }
}
