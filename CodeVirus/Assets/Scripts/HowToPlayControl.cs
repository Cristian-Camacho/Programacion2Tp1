using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HowToPlayControl : MonoBehaviour
{
    public List<GameObject> mobile;
    public List<GameObject> pc;
    private List<GameObject> _usage;
    private int currentPage = 0;
    public GameObject mobileMenu;
    public GameObject pcMenu;
    public GameObject next;
    public GameObject previuos;

    // Use this for initialization
    void Start()
    {
        _usage = new List<GameObject>();
        if (SystemInfo.deviceType == DeviceType.Handheld)
        {
            _usage = mobile;
            mobileMenu.SetActive(true);
        }
        else {
            _usage = pc;
            pcMenu.SetActive(true);
        }
    }

    public void NextPage()
    {
        if (currentPage < _usage.Count -1)
        {
            _usage[currentPage].SetActive(false);
            currentPage++;
            _usage[currentPage].SetActive(true);
        }
        Check();
    }

    void Check()
    {
        if (currentPage == 0)
            previuos.SetActive(false);
        else previuos.SetActive(true);

        if (currentPage >= _usage.Count - 1)
            next.SetActive(false);
        else next.SetActive(true);
    }

    public void RestartMenu()
    {
        _usage[currentPage].SetActive(false);
        currentPage = 0;
        Check();
        _usage[currentPage].SetActive(true);
    }

    public void PreviousPage()
    {
        if (currentPage > 0)
        {
            _usage[currentPage].SetActive(false);
            currentPage--;
            _usage[currentPage].SetActive(true);
        }
        Check();
    }
}
