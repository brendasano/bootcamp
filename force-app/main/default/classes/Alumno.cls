feat: creacion de alumno y llamada de datos
public class Alumno {
    public String nombre;
    public String apellido;
    public Integer edad;

    public Alumno(){
        nombre='';
        apellido='';
        edad=0;
    }
    public Alumno (String n, String a, Integer e){
        nombre=n;
        apellido=a;
        edad=e;
    }
    public String obtieneInf(){

        return 'nombre= '+nombre+', apellido = '+', edad= '+edad;
    }
}