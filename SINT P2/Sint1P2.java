 package p2; 

 import java.io.*;
 import jakarta.servlet.*;
 import jakarta.servlet.http.*;
 import jakarta.servlet.annotation.*;
 import java.util.*;
 import p2.DataModel.*;
 import org.json.*;

// javac -classpath /home/eetlabs.local/sint/sint1/apache-tomcat-10.0.26/lib/servlet-api.jar:/home/eetlabs.local/sint/sint1/public_html/webapps/WEB-INF/lib/json-20231013.jar *.java

public class Sint1P2 extends HttpServlet {

    private final static String documento_inicial = "http://manolo.webs.uvigo.gal/SINT/libreria.xml";

    DataModel modelo = new DataModel();

    public void init(ServletConfig servletconf){
        try{
            modelo.parsear(documento_inicial); //Pasamos al parser el documento incial
        } catch(Exception e){
            e.printStackTrace();
        }
    }
    /*
    doGet(HttpServletRequest req, HttpServletResponse res) : Método pasa mostrar las screens que el usuario quiera
     */
    public void doGet(HttpServletRequest req, HttpServletResponse res){
        String requestUrl = req.getRequestURI();

        try {
            if(requestUrl.contains("sint1/P2Lib/v1")){
                
            res.setContentType("application/json");
            res.setCharacterEncoding("UTF-8");

                // Resto del código para manejar las solicitudes REST
                if (requestUrl.endsWith("/libros")) {
                    /*  GET /libros : Devolverá un array JSON de elementos libro ordenados por 
                    identificador en sentido creciente */                    
                    JSONArray librosArray = new JSONArray();
                    ArrayList<Book> libros = modelo.getAllBooks(); // SUJETO A CAMBIOS         

                    librosArray = new JSONArray(libros);
                    res.getWriter().println(librosArray.toString());
                    System.out.println(librosArray.toString());
                    res.setStatus(200);                

                } else if (requestUrl.contains("/libros/autor/")) {
                    /*  GET /libros/autor/{id} : Devolverá un array JSON de elementos libro 
                    ordenados por identificador en sentido creciente correspondientes al 
                    autor indicado. En caso de no existir tal autor, devolverá un error 404 */            
                    int ultimoIndice = requestUrl.lastIndexOf("/");

                    String autorId = requestUrl.substring(ultimoIndice + 1);
                    ArrayList<Book> librosAutor = modelo.getBooks(autorId);
                    JSONArray librosArrayAutor = new JSONArray();

                    librosArrayAutor = new JSONArray(librosAutor);
                    
                    res.getWriter().println(librosArrayAutor.toString());
                    System.out.println(librosArrayAutor.toString());
                    res.setStatus(librosArrayAutor.isEmpty() ? 404 : 200);

                } else if (requestUrl.contains("/libro/")) {
                    /*  GET /libro/{id} : Devolverá el libro correspondiente al identificador dado. 
                    En caso de no existir tal libro, devolverá un error 404 */
                    int ultimoIndice = requestUrl.lastIndexOf("/");
                    String libroId = requestUrl.substring(ultimoIndice + 1);
                    Book libro = modelo.getBook(libroId);   
                    ArrayList<Book> libro_s = new ArrayList<Book>();
                    libro_s.add(libro);

                    JSONArray array = new JSONArray();                    
                    array = new JSONArray(libro_s);

                    res.getWriter().println(array.toString());
                    System.out.println(array.toString());
                    res.setStatus(array.isEmpty() ? 404 : 200);          

                } else if (requestUrl.endsWith("/paises")) {
                    /*  GET /paises : Devolverá un array JSON de elementos pais ordenados por 
                    identificador en sentido creciente */
                    JSONArray paisesArray = new JSONArray();
                    ArrayList<Country> paises = modelo.getCountries();
                    paisesArray = new JSONArray(paises);

                    res.getWriter().println(paisesArray.toString());
                    System.out.println(paisesArray.toString());
                    res.setStatus(paisesArray.isEmpty() ? 404 : 200);
            
                } else if (requestUrl.contains("/autores/pais/")) {
                    // GET /autores/pais/{id} :  Devolverá un array de elementos autor ordenados 
                    // por identificador en sentido creciente asociados al país indicado. En caso 
                    // de no existir autores en el país indicado, devolverá un error 404 
                    int ultimoIndice = requestUrl.lastIndexOf("/");
                    String paisId = requestUrl.substring(ultimoIndice + 1);
                    JSONArray autoresArraydeesePais = new JSONArray();
                    
                    ArrayList<Author> autoresPorPais = modelo.getAuthors(paisId);
                    autoresArraydeesePais = new JSONArray(autoresPorPais);
                        
                    res.getWriter().println(autoresArraydeesePais.toString());
                    System.out.println(autoresArraydeesePais.toString());
                    res.setStatus(autoresArraydeesePais.isEmpty() ? 404 : 200);
                                        
                }else if (requestUrl.contains("/pais/")) {
                    // GET /pais/{id}: Devolverá el país correspondiente al identificador dado. 
                    // En caso de no existir tal país, devolverá un error 404
                    int ultimoIndice = requestUrl.lastIndexOf("/");
                    String paisId = requestUrl.substring(ultimoIndice + 1);
                    Country country = modelo.getCountry(paisId);

                    JSONArray array = new JSONArray();
                    ArrayList<Country> PaisLista = new ArrayList<Country>();
                    PaisLista.add(country);
                    array = new JSONArray(PaisLista);

                    res.getWriter().println(array.toString());
                    System.out.println(array.toString());
                    res.setStatus(array.isEmpty() ? 404 : 200);            
                } else if (requestUrl.endsWith("/autores")) {
                    // GET /autores : Devolverá un array JSON de elementos autor ordenados 
                    // por identificador en sentido creciente
                    JSONArray autoresArray = new JSONArray();
                    ArrayList<Author> autoresLista = modelo.getAllAuthors(); // SUJETO A CAMBIOS         
                    autoresArray = new JSONArray(autoresLista);
                    res.getWriter().println(autoresArray.toString());
                    System.out.println(autoresArray.toString());
                    res.setStatus(200);
            
                } else if (requestUrl.contains("/autor/")) {
                    // GET /autor/{id} :  Devolverá el autor correspondiente al identificador dado. 
                    // En caso de no existir tal autor, devolverá un error 404
                    int ultimoIndice = requestUrl.lastIndexOf("/");
                    String autorId = requestUrl.substring(ultimoIndice + 1);
                    Author author = modelo.getAuthor(autorId);

                    JSONArray array = new JSONArray();
                    ArrayList<Author> Autores = new ArrayList<Author>();
                    Autores.add(author);
                    array = new JSONArray(Autores);

                    res.getWriter().println(array.toString());
                    System.out.println(array.toString());
                    res.setStatus(array.isEmpty() ? 404 : 200);

                }  else {
                    // Ruta no válida, devolver código de estado 404
                    res.setStatus(404);
                }
            }else {
                    res.setCharacterEncoding("utf-8");
                    res.setContentType("text/html");

                    PrintWriter out = res.getWriter();  // Permite imprimir en pantalla
                    FrontEnd frontend = new FrontEnd(); // se crea un nuevo objeto frontend para las screens

                    String IPcliente = req.getRemoteAddr();
                    String IpHost = req.getLocalAddr();
                    String navegador = getBrowserName(req.getHeader("User-Agent"));

                    /*  NO SE HA PUESTO NADA O FASE = 0: En esta fase solo recibe indicación de la fase */
                    if( (req.getParameter("fase") == null) || (req.getParameter("fase").equals("0") == true ) ){
                        frontend.doGetFase0(out, documento_inicial, IPcliente, navegador, IpHost);   //
                    }

                    /*  FASE 1: En esta fase solo recibe indicación de la fase  */
                    else if( (req.getParameter("fase") != null) && (req.getParameter("fase").equals("1") == true )   ){
                        
                        ArrayList<Country> countries = modelo.getCountries();
                        frontend.doGetFase1(out, countries);    // Le tenemos que pasar el arraylist de los paises que tenemos
                    }

                    /*  FASE 2: Se recibe como parámetro la	fase y el identificador	del	país */
                    else if((req.getParameter("fase") != null) && (req.getParameter("fase").equals("2") == true )){
                        String paisId = req.getParameter("pais");
                        Country country = modelo.getCountry(paisId);
                        ArrayList<Author> autores =  modelo.getAuthors(paisId);
                        String nombrePais = country.getNombre();                        

                        frontend.doGetFase2(out, nombrePais, autores);      //  pasar los autores segun el pais seleccionado
                    }

                    /*  FASE 3: Se recibe como parámetro la	fase y el identificador	del	autor */
                    else if( (req.getParameter("fase") != null) && (req.getParameter("fase").equals("3")) ){
                        
                        String autorId = req.getParameter("autor");                        
                        Author autor = modelo.getAuthor(autorId);
                        String paisIdAutor = autor.getPais();
                        Country paisAutor = modelo.getCountry(paisIdAutor);
                        ArrayList<Book> librosdelAutor =  modelo.getBooks(autorId);
                        frontend.doGetFase3(out, paisAutor, autor, librosdelAutor);  // pasar los libros del autor y su pais
                    }
                }
            }catch (Exception ex) {
            System.out.println("Algo fue mal en la ejecución del servlet: "+ex.toString());
        }
    }
    private String getBrowserName(String userAgent) {
        if (userAgent == null) {
            return null;
        }
        userAgent = userAgent.toLowerCase();
    
        if (userAgent.contains("msie")) {
            return "Internet Explorer";
        } else if (userAgent.contains("firefox")) {
            return "Firefox";
        } else if (userAgent.contains("chrome")) {
            return "Chrome";
        } else if (userAgent.contains("safari")) {
            return "Safari";
        } else if (userAgent.contains("opera")) {
            return "Opera";
        } else {
            return "Otro navegador";
        }
    } 
}