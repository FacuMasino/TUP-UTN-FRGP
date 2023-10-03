#ifndef PARCIAL1L_H_INCLUDED
#define PARCIAL1L_H_INCLUDED

void cargarCadena(char *pal, int tam){
    int i;
    fflush(stdin);
    for(i=0; i<tam; i++)
    {
        pal[i]=cin.get();
        if(pal[i]=='\n') break;
    }
    pal[i]='\0';
    fflush(stdin);
}


class Fecha{
private:
    int dia,mes, anio;
public:
    void Cargar(){
        cin>>dia;
        cin>>mes;
        cin>>anio;
    }
    void Mostrar(){
        cout<<dia<<"/";
        cout<<mes<<"/";
        cout<<anio<<endl;
    }
    int getDia(){return dia;}
    int getMes(){return mes;}
    int getAnio(){return anio;}

    void setDia(int d){dia=d;}
    void setMes(int m){mes=m;}
    void setAnio(int a){anio=a;}

};

class Jugador{
private:
    int DNI, claustro, idDeporte, idEquipo;
    char nombre[25], apellido[30];
    char email[30];
    int telefono;
    Fecha inscripcion;
    float matricula;
    bool estado;
public:
    void Cargar(){
        cin>>DNI;
        cargarCadena(nombre,24);
        cargarCadena(apellido,29);
        cargarCadena(email, 29);
        cin>>telefono;
        cin>>claustro;
        cin>>idDeporte;
        cin>>idEquipo;
        inscripcion.Cargar();
        cin>>matricula;
        estado=true;
    }
   int getDNI(){return DNI;}
   int getClaustro(){return claustro;}
   int getIdDeporte(){return idDeporte;}
   int getIdEquipo(){return idEquipo;}
   const char *getNombre(){return nombre;}
   const char *getApellido(){return apellido;}
   bool getEstado(){return estado;}
   Fecha getFechaInscirpcion(){return inscripcion;}

   void setEstado(bool e){estado=e;}

   void Mostrar(){
        cout<<DNI<<endl;
        cout<<nombre<<endl;
        cout<<apellido<<endl;
        cout<<email<<endl;
        cout<<telefono<<endl;
        cout<<claustro<<endl;
        cout<<idDeporte<<endl;
        cout<<idEquipo<<endl;
        inscripcion.Mostrar();
        cout<<matricula<<endl;
   }
};

class Deporte{
private:
    int idDeporte, anioOrigen, idCategoria;
    char nombre[30];
    bool estado;
public:
    void Cargar(){
        cin>>idDeporte;
        cargarCadena(nombre, 29);
        cin>>idCategoria;
        cin>>anioOrigen;
        estado=true;
    }
   int getIdDeporte(){return idDeporte;}
   int getIdCtegoria(){return idCategoria;}
   const char *getNombre(){return nombre;}
   bool getEstado(){return estado;}
    int getAnioOrigen(){return anioOrigen;}
   void setEstado(bool e){estado=e;}
   void Mostrar(){
        cout<<idDeporte<<endl;
        cout<<nombre<<endl;
        cout<<idCategoria<<endl;
        cout<<anioOrigen<<endl;
   }

};

class Equipo{
private:
    int IdEquipo, nivel;
    char nombre[30];
    bool estado;
public:
    void Cargar(){
        cin>>IdEquipo;
        cargarCadena(nombre,29);
        cin>>nivel;
        estado=true;
    }
    int getIdEquipo(){return IdEquipo;}
    int getNivel(){return nivel;}
    const char *getNombre(){return nombre;}
    bool getEstado(){return estado;}

    void setEstado(bool e){estado=e;}
    void Mostrar(){
        cout<<IdEquipo<<endl;
        cout<<nombre<<endl;
        cout<<nivel<<endl;
   }
};

class ArchivoJugadores{
private:
    char nombre[30];
public:
    ArchivoJugadores(const char *n){
        strcpy(nombre, n);
    }
    Jugador leerRegistro(int pos){
        Jugador reg;
        reg.setEstado(false);
        FILE *p;
        p=fopen(nombre, "rb");
        if(p==NULL) return reg;
        fseek(p, sizeof reg*pos,0);
        fread(&reg, sizeof reg,1, p);
        fclose(p);
        return reg;
    }
    int contarRegistros(){
        FILE *p;
        p=fopen(nombre, "rb");
        if(p==NULL) return -1;
        fseek(p, 0,2);
        int tam=ftell(p);
        fclose(p);
        return tam/sizeof(Jugador);
    }
    bool grabarRegistro(Jugador reg){
        FILE *p;
        p=fopen(nombre, "ab");
        if(p==NULL) return false;
        int escribio=fwrite(&reg, sizeof reg,1, p);
        fclose(p);
        return escribio;
    }
};


class ArchivoDeportes{
private:
    char nombre[30];
public:
    ArchivoDeportes(const char *n){
        strcpy(nombre, n);
    }
    Deporte leerRegistro(int pos){
        Deporte reg;
        reg.setEstado(false);
        FILE *p;
        p=fopen(nombre, "rb");
        if(p==NULL) return reg;
        fseek(p, sizeof reg*pos,0);
        fread(&reg, sizeof reg,1, p);
        fclose(p);
        return reg;
    }
    int contarRegistros(){
        FILE *p;
        p=fopen(nombre, "rb");
        if(p==NULL) return -1;
        fseek(p, 0,2);
        int tam=ftell(p);
        fclose(p);
        return tam/sizeof(Deporte);
    }
    bool grabarRegistro(Deporte reg){
        FILE *p;
        p=fopen(nombre, "ab");
        if(p==NULL) return false;
        int escribio=fwrite(&reg, sizeof reg,1, p);
        fclose(p);
        return escribio;
    }
};

class ArchivoEquipos{
private:
    char nombre[30];
public:
    ArchivoEquipos(const char *n){
        strcpy(nombre, n);
    }
    Equipo leerRegistro(int pos){
        Equipo reg;
        reg.setEstado(false);
        FILE *p;
        p=fopen(nombre, "rb");
        if(p==NULL) return reg;
        fseek(p, sizeof reg*pos,0);
        fread(&reg, sizeof reg,1, p);
        fclose(p);
        return reg;
    }
    int contarRegistros(){
        FILE *p;
        p=fopen(nombre, "rb");
        if(p==NULL) return -1;
        fseek(p, 0,2);
        int tam=ftell(p);
        fclose(p);
        return tam/sizeof(Equipo);
    }
    bool grabarRegistro(Equipo reg){
        FILE *p;
        p=fopen(nombre, "ab");
        if(p==NULL) return false;
        int escribio=fwrite(&reg, sizeof reg,1, p);
        fclose(p);
        return escribio;
    }
};

#endif // PARCIAL1L_H_INCLUDED
