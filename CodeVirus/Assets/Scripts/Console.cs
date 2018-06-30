using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Console : MonoBehaviour
{
    public delegate void Commands();
    public static Console instance;
    public InputField inputField;
    public Text backText;
    public Scrollbar verticalScrollbar;

    private Dictionary<string, Commands> _myCommands = new Dictionary<string, Commands>();
    private Dictionary<string, string> _description = new Dictionary<string, string>();


    private void OnEnable()
    {
        inputField.Select();
        inputField.ActivateInputField();
        inputField.text = "";
    }

    private void Awake()
    {
        if (instance != null) Destroy(this);
        instance = this;
    }

    // Use this for initialization
    void Start ()
    {
        AddCommand(ShowHelp, "HELP", "Muestra todos los comandos disponbles");
        AddCommand(ClearConsole, "CLEAR", "Limpia la consola de comandos");
	}

    public void AddCommand(Commands action, string key, string description) 
    {
        _myCommands.Add(key, action);
        _description.Add(key, description);
    }

    public void RemoveCommand(string key)
    {
        _myCommands.Remove(key);
        _description.Remove(key);
    }

    private void ClearConsole()
    {
        backText.text = "";
    }

    private void ShowHelp()
    {
        string r = "\n";
        foreach (var item in _description)
            r+= item.Key + ": " + item.Value + "\n";
        backText.text += r + "\n";
    }

    public void TakeInput()
    {
        var te = inputField.text.ToUpper();
        if (_myCommands.ContainsKey(te))
        {
            _myCommands[te]();
            backText.text += "\n" + "Commando " + te + " activado" + "\n";
        }
        else
            backText.text += "Comando erroneo" + "\n";

        inputField.text = "";
        verticalScrollbar.value = 0;
    }


}
