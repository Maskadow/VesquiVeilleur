unit proceduresJeu;

interface

uses esthetique,init,sdl,sdl_image, SDL_MIXER, sdl_ttf,sdl_gfx,sysutils,crt;

//initialisation des constantes et Types
const MAX = 100;
	UP = #72;
	DOWN = #80;
	LEFT = #75;
	RIGHT = #77;
	SpawnX = 13; //spawn X du joueur
	SpawnY = 1;	 //spawn Y du joueur
	SpawnZ = 1;	 //spawn Z du joueur
	SPRITESIZE=48; {taille des sprites}

Type cellule = record
Mur : Boolean;
Score : Integer;
end;

Type Lab = array[1..MAX,1..MAX] of cellule; //declaration tableau en 2d pour un chunk
type direction=(gauche,droite,haut,bas);

Type	Coord = record 		//structure pour definir des coo: joueurs,veilleurs,sortie etc
		x,y,z : Integer;
		dir : direction;
		step : Integer;
	end;

Type Characters = (Agathe,Dorian,Yoann);
Type Cartes = (Felling,Cateliers);


Type	parametresGame = record 		//structure pour definir des coo: joueurs,veilleurs,sortie etc
		nomJoueur: String;
		intelligenceVeilleur: String;
		perso: String;
		carte: String;
		nomPartie: String;
		
	end;
	
//déclaration des signatures des procédures utilisées dans le bloc "Jeu"
procedure Jeu(jWindow:PSDL_SURFACE;jTextures:PTextureSheet);





implementation
//codage des procédures utilisées dans tout le bloc "Jeu"


procedure settings(var param: parametresGame; var f:Text);
begin
  Clrscr;
  Assign(f,'parties/beta.txt');
  
  {Writeln('C''est quoi ton petit nom ?');
  readln(param.nomJoueur);
  
  repeat
  Writeln();
  Writeln('Tu veux quel niveau de difficulte pour cette partie ?');
  Writeln('Facile,Difficile');
  readln(param.intelligenceVeilleur);
  if (param.intelligenceVeilleur<>'Facile') and (param.intelligenceVeilleur<>'Difficile') then
  writeln('Niveau incorrect veuillez ecrire Facile ou Difficile')
  until (param.intelligenceVeilleur='Facile') or (param.intelligenceVeilleur='Difficile');
  
  repeat
  Writeln();
  Writeln('CHOSE YOU CHARACTER !');
  Writeln('Agathe,Dorian,Yoann');
  readln(param.perso);
  if (param.perso<>'Agathe') and (param.perso<>'Dorian') and (param.perso<>'Yoann') then
  writeln('Personnage incorrect veuillez ecrire Agathe ou Dorian ou Yoann')
  until (param.perso='Agathe') or (param.perso='Dorian') or (param.perso='Yoann');}
  
  repeat
  Writeln();
  Writeln('C''est quoi ton binks mon reuf?');
  Writeln('Felling,Cateliers');
  readln(param.carte);
  if (param.carte<>'Felling') and (param.carte<>'Cateliers') then
  writeln('Carte incorrecte veuillez ecrire Felling ou Cateliers')
  until (param.carte='Felling') or (param.carte='Cateliers');
  
  Rewrite(f);
	{Writeln();
	Writeln(f,'Nom de joueur: '); 
	Writeln(f,param.nomJoueur);  Writeln(f,'');
	Writeln(f,'Niveau de difficulte: '); 
	Writeln(f,param.intelligenceVeilleur);  Writeln(f,'');
	Writeln(f,'Personnage: ');
	Writeln(f,param.perso);  Writeln(f,'');}
	Writeln(f,'Carte: ');
	Writeln(f,param.carte);  Writeln(f,'');
  Close(f);
  
  writeln('Comment veux tu appeler ta partie ?');
  readln(param.nomPartie);
  param.nomPartie:= 'parties/'+param.nomPartie+'.txt';
  Rename (f,param.nomPartie);
end;


procedure jchargementInitial (nameCarte: String; var jJoueur : Coord;var sets : parametresGame;var maxZ : Integer);
var fichier :Text;
begin
	sets.carte := nameCarte;
	nameCarte := nameCarte + '/' + nameCarte + '.txt';
	writeln(nameCarte);
	assign(fichier,nameCarte);
	reset(fichier);
	read(fichier,maxZ);
	readln(fichier,jJoueur.x);
	readln(fichier,jJoueur.y);
	readln(fichier,jJoueur.z);
	
  jJoueur.dir:=bas;
  jJoueur.step:=0;
close(fichier);
end;


procedure jchargementChunk (sets : parametresGame ; Z : Integer; var laby : Lab; var maxX, maxY : Integer ; var sortie, jVeilleur,spawn, jJoueur : Coord);

var fic: Text ;
   i, j	: Integer;
   str,name	: string;
begin
	name := sets.carte + '/' + char(Z+48) + '.txt';
	{name := 'Felling/essai chunk 2.txt';}
	if (FileExists(name)) then
	begin
		assign(fic,name);
		reset(fic);
		{Lecture de la taille X et Y du labyrinthe}
		read(fic,maxX);
		readln(fic,maxY);
		if (maxX < 1) or (maxX > MAX) or (maxY < 1) or (maxY > MAX) then
		begin
			writeln('Tailles invalides');
			halt();
		end;

		{Lecture de toutes les cases du labyrinthe}
		j := 1;
		while (not eof(fic)) do
		begin
			readln(fic,str);
			for i := 1 to maxX do
				if (str[i] = '1') then
					laby[i][j].Mur := true
				else
				begin
					laby[i][j].Mur := false;
					if (str[i] = 'S') then
					begin
						sortie.x := i;
						sortie.y := j;
					end
					else if  (str[i] = 'M') then
					begin
						jVeilleur.x := i;
						jveilleur.y := j;
					end
				end;
			j := j+1;
		end;
	end
	else
	begin
		writeln('Erreur le fichier n''existe pas');
		halt();
	end;
	close(fic);
end; { chargement }



procedure jdrawScene(screen:PSDL_Surface; p_texture_sheet: PTextureSheet; player, mechant : coord);
{On affiche la scène de jeu à l'écran}
var i,j:Integer;
    destination_rect, sprite_rect:TSDL_RECT;
    player_sprite:PSDL_Surface;
begin

       case player.z of
       1:begin
			destination_rect.x:=midX;
            destination_rect.y:=midY;
            destination_rect.w:=SURFACEWIDTH;
            destination_rect.h:=SURFACEHEIGHT;
            SDL_BlitSurface(p_texture_sheet^.chunk1,NIL,screen,@destination_rect)
         end;
			
       2:begin
			destination_rect.x:=midX;
            destination_rect.y:=midY;
            destination_rect.w:=SURFACEWIDTH;
            destination_rect.h:=SURFACEHEIGHT;
            SDL_BlitSurface(p_texture_sheet^.chunk2,NIL,screen,@destination_rect)
         end;
         
       3:begin
			destination_rect.x:=midX;
            destination_rect.y:=midY;
            destination_rect.w:=SURFACEWIDTH;
            destination_rect.h:=SURFACEHEIGHT;
            SDL_BlitSurface(p_texture_sheet^.chunk3,NIL,screen,@destination_rect)
         end;
         
       4:begin
			destination_rect.x:=midX;
            destination_rect.y:=midY;
            destination_rect.w:=SURFACEWIDTH;
            destination_rect.h:=SURFACEHEIGHT;
            SDL_BlitSurface(p_texture_sheet^.chunk4,NIL,screen,@destination_rect)
         end;
         end; //fin case of
       
        
       
       {Rectangle de la surface où viendra se placer le sprite du heros}
       destination_rect.x:=(player.x*SPRITESIZE)+(midX-SPRITESIZE);
       destination_rect.y:=(player.y*SPRITESIZE)-SPRITESIZE;
       destination_rect.w:=SPRITESIZE;
       destination_rect.h:=SPRITESIZE;
       {On choisit la ligne de la texture suivant son orientation}
       case player.dir of
           droite: sprite_rect.y := SPRITESIZE;
           gauche:  sprite_rect.y := 0;
           bas:  sprite_rect.y := SPRITESIZE*3;
           haut:  sprite_rect.y := SPRITESIZE*2;
       end;
       sprite_rect.x := player.step * SPRITESIZE;
       sprite_rect.w := SPRITESIZE;
       sprite_rect.h := SPRITESIZE;
       
		player_sprite:=p_texture_sheet^.anim;
       
       {On ajoute sur la surface}
       SDL_BlitSurface(player_sprite,@sprite_rect,screen,@destination_rect);
       
       
       {Rectangle de la surface où viendra se placer le sprite du méchant}
       destination_rect.x:=mechant.x*SPRITESIZE;
       destination_rect.y:=mechant.y*SPRITESIZE;
       destination_rect.w:=SPRITESIZE;
       destination_rect.h:=SPRITESIZE;
       SDL_BlitSurface(p_texture_sheet^.badguy,NIL,screen,@destination_rect);
  
       
       {On a finit le calcul on bascule la surface à l'écran}
       SDL_Flip(screen )

end;

procedure jdeplacementJoueur(key: TSDL_KeyboardEvent; l: lab; mX,mY,mZ:Integer; var jJoueur: Coord; Z: Integer);
begin

    Z := jJoueur.z ;
    
    case key.keysym.sym of
        SDLK_LEFT:  begin
        jJoueur.step := (jJoueur.step+1);
                        jJoueur.dir:=gauche;
                        if (jJoueur.x > 0) and (l[jJoueur.x-1][jJoueur.y].Mur <> true) then
                            jJoueur.x:=jJoueur.x-1;
                            if jJoueur.x = 0 then 
									begin
										jJoueur.z := jJoueur.z - 1;
										jJoueur.x := mX;
									end;
									writeln(jJoueur.x,' ',jJoueur.y,' ',jJoueur.z);
                    end;
                    
                    
        SDLK_RIGHT:  begin
        jJoueur.step := (jJoueur.step+1);
                        jJoueur.dir:=droite;
                        if (jJoueur.x < mX + 1) and (l[jJoueur.x+1][jJoueur.y].Mur <> true) then
									jJoueur.x := jJoueur.x + 1;
								if jJoueur.x = mX + 1 then 
									begin
										jJoueur.z := jJoueur.z + 1;
										jJoueur.x := 1;
									end;
									writeln(jJoueur.x,' ',jJoueur.y,' ',jJoueur.z);
                    end;
						
									
        SDLK_DOWN:  begin
        jJoueur.step := (jJoueur.step+1);
                        jJoueur.dir:=bas;
                       if (jJoueur.y < mY + 1) and (l[jJoueur.x][jJoueur.y+1].Mur <> true) then
									jJoueur.y := jJoueur.y + 1;
								if jJoueur.y = mY + 1 then
									begin
										jJoueur.z := jJoueur.z + mZ;
										jJoueur.y := 1;
									end;
									writeln(jJoueur.x,' ',jJoueur.y,' ',jJoueur.z);
                    end;
                    
                    
        SDLK_UP:  begin
        jJoueur.step := (jJoueur.step+1);
                        jJoueur.dir:=haut;
                       if (jJoueur.y > 0) and (l[jJoueur.x][jJoueur.y-1].Mur <> true) then
									jJoueur.y := jJoueur.y - 1;
								if jJoueur.y = 0 then 
									begin
										jJoueur.z := jJoueur.z - mZ;
										jJoueur.y := mY;
									end;
									writeln(jJoueur.x,' ',jJoueur.y,' ',jJoueur.z);
                    end;
    end;

end;

procedure Jeu(jWindow:PSDL_SURFACE;jTextures:PTextureSheet);
var sets:parametresGame;
	fic:Text;                                                                               
	largeur:Integer; //variable de la largeur de la fenetre dans l'unité init
	hauteur:Integer; //variable de la hauteur de la fenetre dans l'unité init
	maxX, maxY,maxZ, Z : integer;
	laby	       : Lab;
	jVeilleur,jJoueur,spawn,sortie	: Coord;
	jevent: TSDL_Event; {Un événement}
begin
Z:=0;
settings(sets,fic);

largeur:=SURFACEWIDTH; //on set la largeur de la fenêtre
hauteur:=SURFACEHEIGHT; //on set la hauteur de la fenêtre
initialiseWindow(largeur,hauteur,jWindow); //initialisation de la fenetre en question dans la mémoire
jTextures:=initTextures(); //intialisation de toutes les textures dans la mémoire

SDL_EnableKeyRepeat(10,100);

jchargementInitial(sets.carte,jJoueur,sets,maxZ);

repeat
	SDL_Delay(5);
	jJoueur.step:=(jJoueur.step) mod 5;
	jchargementChunk(sets,jJoueur.z,laby,maxX,maxY,sortie,jVeilleur,spawn,jJoueur);
	jdrawScene(jWindow,jTextures,jJoueur,jVeilleur);
		repeat
			while SDL_Pollevent(@jevent) <> 0 do
			begin
			if jevent.type_=SDL_KEYDOWN then
			jdeplacementJoueur(jevent.key,laby,maxX,maxY,maxZ,jJoueur,Z);
			end;
		until(Z<>jJoueur.z);
until (jJoueur.x=sortie.x) and (jJoueur.y= sortie.y);
end;

end.
