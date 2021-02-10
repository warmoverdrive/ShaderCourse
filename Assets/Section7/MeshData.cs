using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeshData : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Mesh mesh = GetComponent<MeshFilter>().mesh;
        Vector3[] verticies = mesh.vertices;
        foreach (var v in verticies)
            Debug.Log(v);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
