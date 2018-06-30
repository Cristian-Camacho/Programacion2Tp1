using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class Stick : MonoBehaviour, IDragHandler, IEndDragHandler, IPointerDownHandler, IPointerUpHandler
{

    private Vector3 originalPosition;
    public Vector3 stickValue;
    public float separation;
    public bool inTouch = false;
    public bool rotateModel = false;

    public void OnDrag(PointerEventData eventData)
    {
        stickValue = Vector3.ClampMagnitude((Vector3)eventData.position - originalPosition, separation);
        this.transform.position = stickValue + originalPosition;
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        this.transform.position = originalPosition;
        stickValue = Vector3.zero;
    }

    void Start()
    {
        originalPosition = this.transform.position;
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        inTouch = true;
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        inTouch = false;
    }
}
