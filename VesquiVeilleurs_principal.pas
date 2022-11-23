program VesquiVeilleurs_principal;

uses esthetique,init,sdl,sdl_image,SDL_MIXER,sysutils,crt,proceduresJeu;





var
fenetre:PSDL_SURFACE; //variable de la fenêtre c'est une surface
textures:PTextureSheet; //variable de n'importe quelle texture ou sprite c'est un pointeur qui vise un record de textures
{sounds:PSoundSheet;} //variable de n'importe quelle son ou musique c'est un pointeur qui vise un record de sons 
{music: pMIX_MUSIC=NIL;} //variable que l'on évitera d'utiliser mais qui solutionnerai le pb de "sounds"
largeur:Integer; //variable de la largeur de la fenetre dans l'unité init
hauteur:Integer; //variable de la hauteur de la fenetre dans l'unité init
suite: boolean; //variable booléene qu'on utilisera pour les boucles d'affichage
key:TSDL_KeyboardEvent; //un évènement qui peut se faire trigger par le clavier
event:PSDL_Event; //un évènement qui peut se faire trigger par le clavier


begin
largeur:=SURFACEWIDTH; //on set la largeur de la fenêtre
hauteur:=SURFACEHEIGHT; //on set la hauteur de la fenêtre
initialiseWindow(largeur,hauteur,fenetre); //initialisation de la fenetre en question dans la mémoire
textures:=initTextures(); //intialisation de toutes les textures dans la mémoire
event:=initEvent(); //initialisation du trigger event en pointeur
{sounds:=initSounds();} //intialisation de tous les sons dans la mémoire

{music:= MIX_LOADMUS('ressources/VVload.wav');
playSound(50,1,music); //play le son
delay(100);
playSound(MIX_MAX_VOLUME,1,music);
playSound(50,1,sounds^.VVload);}               //aucune de ces procedures ne fonctionne actuellement peut être en raison d'un pb de variable


suite:=False;
while not suite do
  begin
    SDL_Delay(10); //On se limite a 100 fps
	afficheTexture(fenetre,textures^.VVintro,Midx,Midy,IMAGEWIDTH,IMAGEHEIGHT); //On affiche la texture VVintro
    SDL_PollEvent(@key); //On lit un evenement et on agit en consequence
    if key.keysym.sym =SDLK_RETURN then //Si la touche presée est "entrée" suite devient vraie 
		suite:=True;	
  end; //fin de boucle
  



repeat

SDL_Delay(10);
afficheTexture(fenetre,textures^.VVaccueil,Midx,Midy,IMAGEWIDTH,IMAGEHEIGHT); //On affiche la texture VVaccueil

suite:=false;
while not suite do
	begin
		while SDL_PollEvent(event) = 1 do
			begin
			if event^.type_=SDL_KEYDOWN then
			begin
				case event^.key.keysym.sym of
				ONE: begin  suite:=True; 
							termine(fenetre,textures^.VVaccueil);
							Jeu(fenetre,textures);
							delay(1000);
							initialiseWindow(largeur,hauteur,fenetre); //initialisation de la fenetre en question dans la mémoire
							textures:=initTextures(); //intialisation de toutes les textures dans la mémoire
							event:=initEvent();
 end;
				TWO: begin writeln('Le 2'); end;
				THREE: begin suite:=True; extra(fenetre,textures);writeln('Le 3'); end;
				FOUR: begin suite:=True; outro(fenetre,textures); Delay(90); writeln('That''s all folks ~.~'); end; //on lance la fin du programme
				end;
			end;
			end;
	end;
until (event^.key.keysym.sym=FOUR); //fin du menu fin du programme 
end.

