// AlanZucconi.com: http://www.alanzucconi.com/?p=4539
using UnityEngine;
using System.Collections;
 
[ExecuteInEditMode]
public class ApplyShader : MonoBehaviour
{
    public Material material;
    public RenderTexture texture;
    private RenderTexture buffer;

    public Texture initialTexture; // first texture

    void Start ()
    {
        Graphics.Blit(initialTexture, texture);

        buffer = new RenderTexture(texture.width, texture.height, texture.depth, texture.format);
    }
    
    // Postprocess the image
    public void UpdateTexture()
    {
        Graphics.Blit(texture, buffer, material);
        Graphics.Blit(buffer, texture);
    }

    // Updates regularly
    private float lastUpdateTime = 0;
    public float updateInterval = 0.1f; // s
    public void Update ()
    {
        if (Time.time > lastUpdateTime + updateInterval)
        {
            UpdateTexture();
            lastUpdateTime = Time.time;
        }
    }
}
