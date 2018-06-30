using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;


public class StartUpMenu : MonoBehaviour
{
    public GameObject pageOne;
    public GameObject pageTwo;
    public GameObject pageThree;
    public GameObject pageMobile;

    public void StartGame()
    {
        SceneManager.LoadScene(1, LoadSceneMode.Single);
    }

    public void BackToMain()
    {
        SceneManager.LoadScene(0, LoadSceneMode.Single);
    }

    public void Close()
    {
        Application.Quit();
    }

    public void CreditosOpen()
    {
        pageOne.SetActive(false);
        pageTwo.SetActive(true);
        pageThree.SetActive(false);
        pageMobile.SetActive(false);
    }

    public void BackMenuMain()
    {
        pageOne.SetActive(true);
        pageTwo.SetActive(false);
        pageThree.SetActive(false);
        pageMobile.SetActive(false);
    }

    public void HowToPlay()
    {
        pageOne.SetActive(false);
        pageTwo.SetActive(false);
        if (SystemInfo.deviceType == DeviceType.Handheld)
            pageMobile.SetActive(true);
        else
            pageThree.SetActive(true);
    }
}
