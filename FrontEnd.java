 package p2; 

 import java.io.*;
 import javax.xml.parsers.*;
 import jakarta.servlet.*;
 import jakarta.servlet.http.*;
 import java.util.*;
 import org.w3c.dom.*;
 import p2.DataModel.*;

 public class FrontEnd {

    /* Screen en modo browser para la Fase 0 */
    public void doGetFase0(PrintWriter out, String documento, String IPcliente, String navegador, String IpHost) {
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta charset='utf-8'>");
        out.println("<link rel='stylesheet' href='p2/hojaestilos.css'>");
        out.println("<title>Servicio de consulta de libros</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Servicio de consulta de información </h1>");
        String[] Nombre_fich = documento.split("/");    // documento.split(regex:"/");
        String nombre_fich = Nombre_fich[Nombre_fich.length-1];
        out.println("<h2> Fichero procesado : " + nombre_fich+"</h2>");
        out.println("<h2> Ip del cliente : "+ IPcliente+"</h2>");
        out.println("<h2> Navegador del cliente : "+ navegador+"</h2>");
        out.println("<h2> Ip del host : "+ IpHost+"</h2>");
        out.println("<button type=\"button\" id=\"avanzar\" onclick=\"location.href=\'P2Lib?fase=1';\">Avanzar</button>");
        out.println("<hr>");
        out.println("<h5>Autor: &Oacute;scar David Aponte Santaclara</h5>");
        out.println("</body>");
        out.println("</html>");

    }

    /* Screen en modo browser para la Fase 1 : Mostramos todos los países encontrados */
    public void doGetFase1(PrintWriter out, ArrayList<Country> countries){

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta charset='utf-8'>");
        out.println("<link rel='stylesheet' href='p2/hojaestilos.css'>");
        out.println("<title>Servicio de consulta de libros</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Servicio de consulta de información</h1>");
        out.println("<h2>Fase 1</h2>");
        out.println("<h2>Seleccione el país:</h2>");
        out.println("<ol>");

        for (int y=0; y < countries.size(); y++){
            out.println("<li><p><a href='P2Lib?fase=2&pais="+countries.get(y).getIdentificador()+"'>" +countries.get(y).getNombre()+ "</a></p></li>");
        }
        
        out.println("</ol>");
        out.println("<br>");
        out.println("<br>");    
        out.println("<button type=\"button\" id=\"atras\" onclick=\"location.href=\'P2Lib\';\">Anterior</button>");
        out.println("<hr>");
        out.println("<h5>Autor: &Oacute;scar David Aponte Santaclara</h5>");
        out.println("</body>");
        out.println("</html>");

    }

    /* Screen en modo browser para la Fase 2: Mostramos todos los autores de el pais recibido */
    public void doGetFase2(PrintWriter out, String country, ArrayList<Author> autores){
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta charset='utf-8'>");
        out.println("<link rel='stylesheet' href='p2/hojaestilos.css'>");
        out.println("<title>Servicio de consulta de libros</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Servicio de consulta de información</h1>");
        out.println("<h2>Fase 2</h2>");
        out.println("<h2>Consultando infromación de país: "+country+"</h2>");
        out.println("<h2>Seleccione el autor:</h2>");
        out.println("<ol>");

        for (int y=0; y < autores.size(); y++){
                out.println("<li><p><a href='P2Lib?fase=3&autor="+autores.get(y).getIdentificador()+"'> "+autores.get(y).getNombre() +" </a> Nacido en"+autores.get(y).getNacimiento()+"</p></li>");
            }
        
        out.println("</ol>");
        out.println("<br>");
        out.println("<br>");    
        out.println("<button type=\"button\" id=\"atras\" onclick=\"location.href=\'P2Lib?fase=1\';\">Anterior</button>");
        out.println("<hr>");
        out.println("<h5>Autor: &Oacute;scar David Aponte Santaclara</h5>");
        out.println("</body>");
        out.println("</html>");
    }

    /* Screen en para la Fase 3 : Mostramos los libros de un autor */
    public void doGetFase3(PrintWriter out,Country paisAutor, Author autor, ArrayList<Book> libros){

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta charset='utf-8'>");
        out.println("<link rel='stylesheet' href='p2/hojaestilos.css'>");
        out.println("<title>Servicio de consulta de libros</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Servicio de consulta de información</h1>");
        out.println("<h2>Fase 3</h2>");
        out.println("<h3>Consultado información de país: " + paisAutor.getNombre() +"</h3>");
        out.println("<h3>Consultado información de autor: " + autor.getNombre()+"</h3>");
        out.println("<h4>Lista de libros:</h4>");
        out.println("<ol>");

        for (int i=0; i < libros.size(); i++){
            if ("no".equals(libros.get(i).getDisponible())){
                out.println("<li><p class='no-disponible'> "+libros.get(i).getTitulo()+ " ISBN: "+libros.get(i).getISBN()+"</p></li>");
            }else{
                out.println("<li><p class='disponible'>"+libros.get(i).getTitulo()+ " ISBN: "+libros.get(i).getISBN()+"</p></li>");
            }
        }
        out.println("</ol>");
        out.println("<br>");
        out.println("<br>");    
        out.println("<button type=\"button\" id=\"atras\" onclick=\"location.href=\'P2Lib?fase=2&pais="+autor.getPais()+"\';\">Anterior</button>");
        out.println("<hr>");
        out.println("<h5>Autor: &Oacute;scar David Aponte Santaclara</h5>");
        out.println("</body>");
        out.println("</html>");
    }
 }