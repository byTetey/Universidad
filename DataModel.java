package p2;

import org.w3c.dom.*;
import org.xml.sax.*;
import org.xml.sax.SAXException;
import javax.xml.*;
import java.io.*;
import java.util.*;
import javax.xml.parsers.DocumentBuilder;                                                                                                               
import javax.xml.parsers.DocumentBuilderFactory;
import java.net.URL;
import org.json.*;
import p2.DataModel.*;

public class DataModel{

    private static Document document;

    public static Document getDocument(){
        return document;
    }
    
    public static void parsear(String documento){
            try{
                
                DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
                DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
                document = dBuilder.parse(new URL(documento).openStream());
                document.getDocumentElement().normalize();
            }catch (Exception ex) {
                System.out.println("Algo fue mal en la ejecución del servlet: "+ex.toString());
            }
    }
     
    
    public ArrayList<Author> getAuthors(String countryId) {
        // Se encuentran los autores y se relacionan con su pais mediante el identificador

        ArrayList<Author> authors = new ArrayList<Author>();
        Document document = getDocument();

        NodeList listaAutores = document.getElementsByTagName("autor");

        for (int i = 0; i < listaAutores.getLength(); i++) {
            Element authorElement = (Element) listaAutores.item(i);
            String authorCountryId = authorElement.getAttribute("pais");
            String authorName = authorElement.getTextContent().trim();    // ASÍ SE OBTIENE EL TEXTO DEL xml
            String authorBirth = authorElement.getAttribute("nacimiento");
            String authorId = authorElement.getAttribute("identificador");
            // obtener todos los atributos y pasarselos al nuevo onjeto author 
            // Se obtiene el identificador del pais segun el autor
            if (authorCountryId.equals(countryId)){
                Author author = new Author(authorName, authorId,authorBirth, countryId);                   
                authors.add(author);
            }    
        }
        // Ordenar por identificador
        Collections.sort(authors);

        return authors;

    }

    public ArrayList<Author> getAllAuthors() {
        ArrayList<Author> authors = new ArrayList<>();
        Document document = getDocument();
        NodeList listaAutores = document.getElementsByTagName("autor");
    
        for (int i = 0; i < listaAutores.getLength(); i++) {
            Element authorElement = (Element) listaAutores.item(i);
            String authorName = authorElement.getTextContent().trim();
            String authorBirth = authorElement.getAttribute("nacimiento");
            String authorId = authorElement.getAttribute("identificador");
            String authorCountryId = authorElement.getAttribute("pais");
    
            Author author = new Author(authorName,authorId,authorBirth,authorCountryId);
            authors.add(author);
        }
    
        // Ordenar por identificador
        Collections.sort(authors);
    
        return authors;
    }

    public Author getAuthor(String authorId) {  
        Document document = getDocument();
        NodeList listaAutores = document.getElementsByTagName("autor");

    for (int i = 0; i < listaAutores.getLength(); i++) {
        Element authorElement = (Element) listaAutores.item(i);
        String currentAuthorId = authorElement.getAttribute("identificador");

        if (currentAuthorId.equals(authorId)) {
            String authorName = authorElement.getTextContent().trim();
            String authorBirth = authorElement.getAttribute("nacimiento");
            String paisAutor = authorElement.getAttribute("pais");

            Author author = new Author(authorName, authorId, authorBirth, paisAutor);
            return author;
        }
    }

    return null;
    }

    public ArrayList<Book> getBooks(String authorId) {
        // Se encuentran los libros y se relacionan con su autor mediante el identificador

        ArrayList<Book> books = new ArrayList<Book>();
        Document document = getDocument();
        NodeList listaLibros = document.getElementsByTagName("libro");

        for (int i = 0; i < listaLibros.getLength(); i++) {
            Element bookElement = (Element) listaLibros.item(i);
            String bookAuhtorId = bookElement.getAttribute("autor");
            String bookId = bookElement.getAttribute("identificador");
            String bookISBN = bookElement.getAttribute("ISBN");
            String bookDisp = bookElement.getAttribute("disponible");
            String bookName = bookElement.getTextContent().trim();
            // Se obtiene el identificador del libro segun el autor
            // Si authorId es nulo o vacío, obtén todos los libros
            // Si authorId no es nulo y coincide con el autor del libro, añádelo a la lista
        //    if (bookAuhtorId.equals(authorId)){
            if (bookAuhtorId.equals(authorId)) {
            // comprobar si esta considicion de if esta bien
                Book book = new Book(bookName,bookISBN, bookId, bookAuhtorId, bookDisp);
                books.add(book);
            }    
        }
        // Ordenar por identificador
        Collections.sort(books);

        return books;
    }

    public Book getBook(String bookId) {
        Document document = getDocument();
        NodeList listaLibros = document.getElementsByTagName("libro");
    
        for (int i = 0; listaLibros != null && i < listaLibros.getLength(); i++) {
            Element libroElement = (Element) listaLibros.item(i);
            String currentLibroId = libroElement.getAttribute("identificador");
    
            if (currentLibroId.equals(bookId)) {
                String libroName = libroElement.getTextContent().trim();
                String libroAuthorId = libroElement.getAttribute("autor");
                String libroISBN = libroElement.getAttribute("ISBN");
                String libroDisp = libroElement.getAttribute("disponible");
    
                Book book = new Book(libroName, libroISBN, bookId, libroAuthorId, libroDisp);
                return book;
            }
        }    
        return null;
    }


    public ArrayList<Book> getAllBooks() {
        // Se obtienen todos los libros sin considerar el autor
    
        ArrayList<Book> libros = new ArrayList<Book>();
        Document document = getDocument();
        NodeList listaLibros = document.getElementsByTagName("libro");
    
        for (int i = 0; i < listaLibros.getLength(); i++) {
            Element bookElement = (Element) listaLibros.item(i);
            String bookAuhtorId = bookElement.getAttribute("autor");
            String bookId = bookElement.getAttribute("identificador");
            String bookISBN = bookElement.getAttribute("ISBN");
            String bookName = bookElement.getTextContent().trim();
            String bookDisp = bookElement.getAttribute("disponible");
    
            Book book = new Book(bookName,bookISBN,bookId,bookAuhtorId,bookDisp);
            libros.add(book);
        }
    
        // Ordenar por identificador
        Collections.sort(libros);
    
        return libros;
    }  

    public ArrayList<Country> getCountries() {
        
        ArrayList<Country> countries = new ArrayList<Country>();
        Document document = getDocument();
        NodeList listaPaises  = document.getElementsByTagName("pais");

        for (int i = 0; i < listaPaises .getLength(); i++) {
            Element countryElement = (Element) listaPaises .item(i);
            String countryName = countryElement.getTextContent().trim();
            String countryId = countryElement.getAttribute("identificador");
            Country country = new Country(countryName,countryId);            
            countries.add(country);
        }
        // Ordenar por identificador
        Collections.sort(countries);
        return countries;
    }    

    // Encuentra el nombre del pais a partir del identificador de pais
    public Country getCountry(String countryId) {
        Country pais = new Country();
        Document document = getDocument();
        NodeList listaPaises = document.getElementsByTagName("pais");
    
        for (int i = 0; i < listaPaises.getLength(); i++) {
            Element countryElement = (Element) listaPaises.item(i);
            String currentCountryId = countryElement.getAttribute("identificador");
            String nombre = countryElement.getTextContent().trim();
            if (currentCountryId.equals(countryId)) {
                // Se encontró el país con el identificador dado
                pais.setNombre(nombre);
                pais.setIdentificador(currentCountryId);
            }
        }return pais;

    }

    public static class Book implements Comparable<Book>, Serializable{

        private String titulo;
        private String identificador;
        private String autor;
        private String ISBN;
        private String disponible;     
        /* 
         libro: Contendrá el propio nombre del libro como elemento y, adicionalmente, los siguientes atributos:
         Cada una de estas entradas contendrá los atributos:
         identificador. Será una serie de caracteres numéricos de longitud hasta 10 
         disponible. Un valor que tomará el valor “si” o “no”. Este atributo no será obligatorio.
         autor. Será el identificador del autor y se corresponderá (o no) con el de algún 
         autor indicado en la parte correspondiente.
         ISBN. Será el código ISBN del propio libro
        */
        public Book(){ //Constructor vacío

        }
     
        //Constructor
        public Book(String titulo, String ISBN, String identificador, String autor, String disponible){
            this.titulo = titulo;
            this.ISBN = ISBN;
            this.identificador = identificador;
            this.autor = autor;
            this.disponible = disponible;
        }

        /* Getters */
        public String getTitulo(){
            return titulo;
        }

        public String getISBN(){
            return ISBN;
        }

        public String getIdentificador(){
            return identificador;
        }

        public String getAutor(){
            return autor;
        }

        public String getDisponible(){
            return disponible;
        }

        
        /* SETTERS */

        public void setTitulo(String newTitulo){
            titulo=newTitulo;
        }

        public void setISBN(String newISBN){
            ISBN=newISBN;
        }

        public void setIdentificador(String newIdentificador){
            identificador=newIdentificador;
        }

        public void setAutor(String newAutor){
            autor=newAutor;
        }

        public void setDisponible(String newDisponible){
            disponible=newDisponible;
        }

        /* CompareTo de dos libros, se ordena:
            -Por identificador
            -de menor a mayor
        */
        public int compareTo(Book book){
            // Comparamos los identificadores de los libros 
            return this.identificador.compareTo(book.getIdentificador());
            
        }
    }

    public static class Author implements Comparable<Author>, Serializable{

        public Author(){ //Constructor vacío
    
        }
    
        private String nombre;
        private String identificador;
        private String nacimiento;
        private String pais;
    
        public Author(String nombre, String identificador, String nacimiento, String pais){
            this.nombre = nombre;
            this.identificador= identificador;
            this.nacimiento=nacimiento;
            this.pais = pais;
        }
    
        /* Getters */
        public String getNombre(){
            return nombre;
        }
    
        public String getIdentificador(){
            return identificador;
        }
    
        public String getNacimiento(){
            return nacimiento;
        }
        public String getPais(){
            return pais;
        }
    
        /* SETTERS */
        public void setNombre(String newNombre){
            nombre=newNombre;
        }
    
        public void setIdentificador(String newIdentificador){
            identificador=newIdentificador;
        }
    
        public void setNacimiento(String newNacimiento){
            nacimiento=newNacimiento;
        }
        public void setPais(String newPais){
            pais=newPais;
        }
    
        /* CompareTo de dos autores, se ordena:
            -Por el número de identificador ( de menor a mayor )
        */
        public int compareTo(Author author){
         
            // Comparamos los identificadores de los autores directamente
            return this.identificador.compareTo(author.getIdentificador());            
        }    
    }

    public static class Country implements Comparable<Country>, Serializable{

        public Country(){ //Constructor vacío    
        }
    
        private String nombre;
        private String identificador;
            
        public Country(String nombre, String identificador){
            this.nombre = nombre;
            this.identificador= identificador;
        }
    
        /* Getters */
        public String getNombre(){
            return nombre;
        }
    
        public String getIdentificador(){
            return identificador;
        }
    
        /* SETTERS */
        public void setNombre(String newNombre){
            nombre=newNombre;
        }
    
        public void setIdentificador(String newIdentificador){
            identificador=newIdentificador;
        }
    
        /* CompareTo de dos autores, se ordena:
            -Por el número de identificador ( de menor a mayor )
        */
        public int compareTo(Country country){
        
            // Comparamos los identificadores de los paises directamente
            return  this.identificador.compareTo(country.getIdentificador());
        }    
    }
}

