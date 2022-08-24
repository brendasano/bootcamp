feat: Alumno Crea una clase alumno con sus caracteristicas
public class Alumno {
    //Variable o Propiedades
    public String nombre;
    public String apellido;
    public Integer edad;
    
    
    //Constructores
    public Alumno(){
        nombre='';
        apellido='';
        edad=0;
    }
    public Alumno(String n, String a, Integer e){
        nombre = n;
        apellido = a;
        edad = e;    
    }
    
    //metodos
    public string obtieneInf(){
        String cadena = 'Nombre=' + nombre + ' Apellido=' + apellido + ' Edad=' + edad;
        System.debug(cadena);
        return cadena;
    }

}
