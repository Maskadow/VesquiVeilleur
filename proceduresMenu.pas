unit proceduresMenu;

interface

uses sdl,sdl_image, SDL_MIXER, sdl_ttf,sdl_gfx,sysutils,crt;

//initialisation des constantes et Types
const
SURFACEWIDTH =1080; // largeur en pixels de la surface de jeu 
SURFACEHEIGHT =720; // hauteur en pixels de la surface de jeu 
IMAGEWIDTH =720; // largeur en pixels de l’image
IMAGEHEIGHT =720; // hauteur en pixels de l’image 

AUDIO_FREQUENCY:INTEGER=22050;
AUDIO_FORMAT:WORD=AUDIO_S16;
AUDIO_CHANNELS:INTEGER=2;
AUDIO_CHUNKSIZE:INTEGER=4096;
	
Type TTextureSheet=record // definition du type record des différentes textures
        VVintro,VVaccueil:PSDL_Surface;
    end;
Type PTextureSheet=^TTextureSheet; //definition du type pointeur qui visera les textures dans le recorde de textures
 
//déclaration des signatures des procédures utilisées dans le bloc "Menu"
procedure lancerpartie;
procedure chargerpartie;
procedure listeparties;
procedure extras;
procedure menu;



implementation
//codage des procédures utilisées dans tout le bloc "Menu"

/////////////////CHARGER PARTIE////////////////////
procedure chargerpartie;
begin
end;

/////////////////LANCER PARTIE////////////////////
procedure lancerpartie;
begin
end;

/////////////////LISTE PARTIE////////////////////
procedure listeparties;
begin
end;

/////////////////EXTRAS////////////////////
procedure extras;
begin
end;


/////////////////MENU////////////////////
procedure initialise(var window: PSDL_SURFACE); //initialisation de la fenêtre de jeu en 1080/720
begin
SDL_Init(SDL_INIT_VIDEO); //chargement bibliothèque
SDL_Init(SDL_INIT_AUDIO); //chargement bibliothèque
window :=SDL_SetVideoMode(SURFACEWIDTH,SURFACEHEIGHT,32,SDL_SWSURFACE); //init de la fenêtre (largeur,hauteur,PAS TOUCHER,type de fenêtre)
end;

function initTextures():PTextureSheet; //initalisation dans la mémoire de toutes les textures
var newTextureSheet : PTextureSheet;
begin
    new(newTextureSheet);
    newTextureSheet^.VVintro:=IMG_Load('ressources/VVnoir.png'); //un pointeur sur VVintro
    newTextureSheet^.VVaccueil:=IMG_Load('ressources/VVaccueil.png'); //un pointeur sur VVaccueil
    initTextures:=newTextureSheet; //retour de la fonction
end;

procedure afficheTexture (window,aTexture: PSDL_SURFACE);
var destination_rect : TSDL_RECT;
begin
destination_rect.x:=(SURFACEWIDTH-IMAGEWIDTH) div 2; //set coo angle haut gauche x
destination_rect.y:=(SURFACEHEIGHT-IMAGEHEIGHT) div 2; //set coo angle haut gauche y
destination_rect.w:=IMAGEWIDTH; //set largeur
destination_rect.h:=IMAGEHEIGHT; //set hauteur
SDL_BlitSurface(aTexture,NIL,window,@destination_rect); //chargement de la texture(variable texture,NIL,fenêtre,caractéristiques de destination_rect)
SDL_Flip(window); //Afficher la texture sur la fenêtre
end;

procedure termine_window (var window: PSDL_SURFACE );
begin
SDL_FreeSurface (window); //vider la memoire correspondant a la fenêtre
SDL_Quit (); //decharger la bibliotheque
end;

procedure termine_VVload (VVloadIMAGE: PSDL_SURFACE );
begin
SDL_FreeSurface (VVloadIMAGE); //vider la memoire correspondant a l’image 
SDL_Quit (); //decharger la bibliotheque
end;


procedure son(var sound : pMIX_MUSIC);
begin
if MIX_OpenAudio(AUDIO_FREQUENCY, AUDIO_FORMAT,AUDIO_CHANNELS,AUDIO_CHUNKSIZE)<>0 then HALT; //charger la bibliothèque
sound := MIX_LOADMUS('ressources/VVload.wav'); //Charger le fichier son
Delay(100);
MIX_VolumeMusic(MIX_MAX_VOLUME); //choisir le volume
MIX_PlayMusic(sound,1); //lancer le son si on met -1 le son tourne en boucle
end;



procedure menu;
{var choix: Integer;}
var music: pMIX_MUSIC=NIL; //var pour les sons
fenetre: PSDL_SURFACE; //notre fenêtr en question
key:TSDL_KeyboardEvent; //un évènement qui peut se faire trigger
suite: boolean; //booléen vérifiant le trigger de l'event
textures:PTextureSheet; //n'importe quelle texture que l'on veut charger
begin
textures:=initTextures(); //on initialise les textures
initialise(fenetre); //on initialise la fenêtre
son(music); //play le son
suite:=False;
while not suite do
  begin
    SDL_Delay(10); //On se limite a 100 fps
	afficheTexture(fenetre,textures^.VVintro); //On affiche la texture VVintro
    SDL_PollEvent(@key); //On lit un evenement et on agit en consequence
    if key.keysym.sym =SDLK_RETURN then //Si la touche presée est "entrée" suite devient vraie
		suite:=True;	
  end;
  
Delay(100);


repeat
	suite:=False;
	while not suite do
		begin
		afficheTexture(fenetre,textures^.VVaccueil); //On affiche la texture VVaccueil
		SDL_PollEvent(@key); //On lit un evenement et on agit en consequence
			case key.keysym.sym of
			SDLK_1: begin writeln('Le 1'); end;
			SDLK_2: begin writeln('Le 2'); end;
			SDLK_3: begin writeln('Le 3'); end;
			SDLK_4: begin suite:=True; writeln('Le 4'); end;
			end;
		end;
until (key.keysym.sym=SDLK_4);

end;
end.



