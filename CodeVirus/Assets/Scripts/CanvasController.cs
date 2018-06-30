using System.Collections;
using System.Collections.Generic;
using UnityEngine;
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
            mobileInput.SetActive(false);
         
    }
    

    public void Notify(string action)
    {
        switch (action)
        {
            case "pause":
                pauseMenu.SetActive(true);
                SoundManager.instance.PlaySound(SoundsIDs.ID_PAUSE_ON);
                break;
            case "console":
                console.SetActive(true);
                break;
            case "close-console":
                console.SetActive(false);
                break;
            case "resume":
                SoundManager.instance.PlaySound(SoundsIDs.ID_PAUSE_OFF);
                pauseMenu.SetActive(false);
                break;
            case "gameover":
                defeatMenu.SetActive(true);
                /*if (SystemInfo.deviceType != DeviceType.Handheld)
                    caseNoAds.SetActive(true);*/
                break;
            case "revive":
                defeatMenu.SetActive(false);
                break;
            case "bossHit":
                UpdateBoss();
                break;
            case "playerLifeMod":
                UpdatePlayer();
                break;
            case "Double":
                DoubleFeedback();
                break;
                
        }
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
