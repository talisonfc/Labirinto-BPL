
int n=20, m=20;
int w, h;
int ws = 420, hs=420;
int d = 10; //Deslocamento

int[][] matrix;
                  
Estado EI = new Estado(0,0);                 
Estado EF = new Estado(9,6);

Labirinto lab = new Labirinto();
ArrayList<Estado> solucao = new ArrayList<Estado>();

void setup(){
   size(420,420); 
   matrix = new int[n][m];
   w=(ws-2*d)/n;
   h=(hs-2*d)/m;
   background(255,255,255);
}

ArrayList<Estado> expande(Estado e){
  matrix[e.getX()][e.getY()] = -1;
  ArrayList<Estado> filhos = new ArrayList<Estado>();
  String est = "";
  for(int k=0; k<4; k++){
    Estado temp = new Estado(e.getX(),e.getY());
    switch(k){
      case 0:{
        est = "DESCER";
        temp.setY(temp.getY()+1);
        break;
      }
      case 1:{
        est = "SUBIR";
        temp.setY(temp.getY()-1);
        break;
      }
      case 2:{
        est = "DIREITA";
        temp.setX(temp.getX()+1);
        break;
      }
      case 3:{
        est = "ESQUERDA";
        temp.setX(temp.getX()-1);
        break; 
      }
    }
    
    if(!temp.estadoInvalido(n,m)){
      if(temp.estadoValido(matrix)){
        //println(est);
        filhos.add(temp);
      }
    }
  }
  return filhos;
}

boolean estadoObjetivo(Estado e){
  return (e.getX()==EF.getX() && e.getY()==EF.getY())?true:false; 
}

boolean bpl(Estado e, int l){
  if(estadoObjetivo(e)) return true;
  if(l<0) return false;
  ArrayList<Estado> filhos = expande(e);
  for(Estado t: filhos){
    if(bpl(t,l-1)) {
      solucao.add(t);
      return true;
    }
  }
  return false;
}

void processamento(){
   lab.drawLabirinto(n,m,w,h,d,matrix);
   lab.fim(w,h,d,EF);
   if(i==0){
     if(bpl(EI,n*m)){
       solucao.add(EI);
       print("Solução encontrada");
     }
     else{
       print("Solução não encontrada");
     }
     i=1;
   }
   else{
     lab.inicio(w,h,d,solucao.get(solucao.size()-j-1));
     //delay(500);
   }
   j++;
   if((j)==solucao.size()) j=0;
}

void condicoesIniciais(){
  lab.drawLabirinto(n,m,w,h,d,matrix);
  if(defEI==0) lab.inicio(w,h,d,e);
  else lab.inicio(w,h,d,EI);
  if(defEI!=0)
    if(defEF==0) lab.fim(w,h,d,e);
    else lab.fim(w,h,d,EF);
  
  //Definindo estado inicial
  if(mousePressed && mouseButton==LEFT && defEI==0){
    EI.setX(e.getX());
    EI.setY(e.getY());
    defEI=-1;
  }
  if(defEI==0){
    e.setX(mouseX/w);
    e.setY(mouseY/h);
  }
  
  //Definindo estado final
  if(mousePressed && mouseButton==RIGHT && defEF==0){
    EF.setX(e.getX());
    EF.setY(e.getY());
    defEF=-1;
  }
  if(defEI==-1 && defEF==0){
    e.setX(mouseX/w);
    e.setY(mouseY/h);
  }
  
  //Definindo as paredes
  if(mousePressed && mouseButton==LEFT && defEI!=0 && defEF!=0){
    if(e.getX()<n && e.getY()<m)
      matrix[e.getX()][e.getY()]=1;
  }
  if(defEI!=0 && defEF!=0){
    e.setX(mouseX/w);
    e.setY(mouseY/h);
  }
  if(keyPressed) solver=-1;
}

int i=0, j=0;
int defEI=0, defEF=0;
int solver = 0;
Estado e = new Estado();

void draw(){
  if(solver == 0){
    condicoesIniciais();
  }
  else{
    processamento();
  }
}