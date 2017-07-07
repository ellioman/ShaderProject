using UnityEditor;

public static class HelperExtensions
{
    public static bool Contains(this string[] array, string key)
    {
        for (int i = 0; i < array.Length; i++)
        {
            if (array[i] == key)
                return true;
        }
        return false;
    }

    public static MaterialProperty GetByName(this MaterialProperty[] properties, string name)
    {
        for (int i = 0; i < properties.Length; i++)
        {
            if (properties[i].name == name)
                return properties[i];
        }

        return null;
    }
}