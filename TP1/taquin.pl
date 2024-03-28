/* Fichier du probleme. 

Doit contenir au moins 4 predicats qui seront utilises par A*

   etat_initial(I)                                         % definit l'etat initial

   etat_final(F)                                           % definit l'etat final  

   rule(Rule_Name, Rule_Cost, Before_State, After_State)   % règles applicables

   heuristique(Current_State, Hval)				           % calcul de l'heuristique 


Les autres prédicats sont spécifiques au Taquin.
*/


%:- lib(listut).      % Laisser cette directive en commentaire si vous utilisez Swi-Prolog 
   
                      % Sinon décommentez la ligne si vous utilisez ECLiPSe Prolog :
                      % -> permet de disposer du predicat nth1(N, List, E)
                      % -> permet de disposer du predicat sumlist(List, S)
                      % (qui sont predefinis en Swi-Prolog)

                      
%***************************
%DESCRIPTION DU JEU DU TAKIN
%***************************

   %********************
   % ETAT INITIAL DU JEU
   %********************   
   % format :  initial_state(+State) ou State est une matrice (liste de listes)
   

/*final_state([ [ 1,  2,  3,  4],[ 5,  6,  7,  8],[ 9, 10, 11, 12],[13, 14, 15,vide]]). 
initial_state([ [ 14, 13,  9,  5],
                [ 15,  6,  7,  1],
                [ 12, 10, 11,  2],
                [  8,  4,  3, vide] ]).

*/
initial_state([ [b, h, c],       % C'EST L'EXEMPLE PRIS EN COURS
                [a, f, d],       % 
                [g,vide,e] ]).   % h1=4,   h2=5,   f*=5



% AUTRES EXEMPLES POUR LES TESTS DE  A*

/*
initial_state([ [ a, b, c],        
                [ g, h, d],
                [vide,f, e] ]). % h2=2, f*=2

initial_state([ [b, c, d],
                [a,vide,g],
                [f, h, e]  ]). % h2=10 f*=10
			
initial_state([ [f, g, a],
                [h,vide,b],
                [d, c, e]  ]). % h2=16, f*=20
			
initial_state([ [e, f, g],
                [d,vide,h],
                [c, b, a]  ]). % h2=24, f*=30 

initial_state([ [a, b, c],
                [g,vide,d],
                [h, f, e]]). % etat non connexe avec l'etat final (PAS DE SOLUTION)
*/  


   %******************
   % ETAT FINAL DU JEU
   %******************
   % format :  final_state(+State) ou State est une matrice (liste de listes)
   
final_state([[a, b,  c],
             [h,vide, d],
             [g, f,  e]]).

			 
   %********************
   % AFFICHAGE D'UN ETAT
   %********************
   % format :  write_state(?State) ou State est une liste de lignes a afficher

write_state([]).
write_state([Line|Rest]) :-
   writeln(Line),
   write_state(Rest).
   

%**********************************************
% REGLES DE DEPLACEMENT (up, down, left, right)             
%**********************************************
   % format :   rule(+Rule_Name, ?Rule_Cost, +Current_State, ?Next_State)
   
rule(up,   1, S1, S2) :-
   vertical_permutation(_X,vide,S1,S2).

rule(down, 1, S1, S2) :-
   vertical_permutation(vide,_X,S1,S2).

rule(left, 1, S1, S2) :-
   horizontal_permutation(_X,vide,S1,S2).

rule(right,1, S1, S2) :-
   horizontal_permutation(vide,_X,S1,S2).


couple(S1,S2):-
   rule(_X,1,S1,S2).

   %***********************
   % Deplacement horizontal            
   %***********************
    % format :   horizontal_permutation(?Piece1,?Piece2,+Current_State, ?Next_State)
	
horizontal_permutation(X,Y,S1,S2) :-
   append(Above,[Line1|Rest], S1),
   exchange(X,Y,Line1,Line2),
   append(Above,[Line2|Rest], S2).

   %***********************************************
   % Echange de 2 objets consecutifs dans une liste             
   %***********************************************
   
exchange(X,Y,[X,Y|List], [Y,X|List]).
exchange(X,Y,[Z|List1],  [Z|List2] ):-
   exchange(X,Y,List1,List2).

   %*********************
   % Deplacement vertical            
   %*********************
   
vertical_permutation(X,Y,S1,S2) :-
   append(Above, [Line1,Line2|Below], S1), % decompose S1
   delete(N,X,Line1,Rest1),    % enleve X en position N a Line1,   donne Rest1
   delete(N,Y,Line2,Rest2),    % enleve Y en position N a Line2,   donne Rest2
   delete(N,Y,Line3,Rest1),    % insere Y en position N dans Rest1 donne Line3
   delete(N,X,Line4,Rest2),    % insere X en position N dans Rest2 donne Line4
   append(Above, [Line3,Line4|Below], S2). % recompose S2 

   %***********************************************************************
   % Retrait d'une occurrence X en position N dans une liste L (resultat R) 
   %***********************************************************************
   % use case 1 :   delete(?N,?X,+L,?R)
   % use case 2 :   delete(?N,?X,?L,+R)   
   
delete(1,X,[X|L], L).
delete(N,X,[Y|L], [Y|R]) :-
   delete(N1,X,L,R),
   N is N1 + 1.

   
   
   %*******************
   % PARTIE A COMPLETER
   %*******************
   
   %*******************************************************************
   % Coordonnees X(colonne),Y(Ligne) d'une piece P dans une situation U
   %*******************************************************************
	% format : coordonnees(?Coord, +Matrice, ?Element)
	% Définit la relation entre des coordonnees [Ligne, Colonne] et un element de la matrice
	/*
	Exemples
	
	?- coordonnees(Coord, [[a,b,c],[d,e,f]],  e).        % quelles sont les coordonnees de e ?
	Coord = [2,2]
	yes
	
	?- coordonnees([2,3], [[a,b,c],[d,e,f]],  P).        % qui a les coordonnees [2,3] ?
	P=f
	yes
	*/
	
	coordonnees([L,C], Mat, Elt) :-   %********
      nth1(L,Mat,Ligne), 
      nth1(C,Ligne, Elt).

											 
   %*************
   % HEURISTIQUES
   %*************
   
heuristique(U,H) :-
    heuristique1(U, H).  % au debut on utilise l'heuristique 1 
%   heuristique2(U, H).  % ensuite utilisez plutot l'heuristique 2  
   
   
   %****************
   %HEURISTIQUE no 1
   %****************
   % Nombre de pieces mal placees dans l'etat courant U
   % par rapport a l'etat final F
   
   
   % Suggestions : définir d'abord le prédicat coordonnees(Piece,Etat,Lig,Col) qui associe à une pièce présente dans Etat
   % ses coordonnees (Lig= numero de ligne, Col= numero de Colonne)
   
   % Definir ensuite le predicat malplace(P,U,F) qui est vrai si les coordonnes de P dans U et dans F sont differentes.
   % On peut également comparer les pieces qui se trouvent aux mêmes coordonnees dans U et dans H et voir s'il sagit de la
   % même piece.
   
    % Definir enfin l'heuristique qui détermine toutes les pièces mal placées (voir prédicat findall) 
	% et les compte (voir prédicat length)
   heuristique1_aux2([],[],0).
   heuristique1_aux2([vide|_],_,0).
   heuristique1_aux2([L|T], [L|T2],N):-
      heuristique1_aux2(T,T2,N),
      !.
   %Si on a le meme tete de liste on passe au suivant 
   heuristique1_aux2([L1|T], [_L2|T2],N):-
      write([L1|T]),
      heuristique1_aux2(T,T2,N1),
      N is N1 + 1.
   %sinon on incremente le nombre de pieces mal placées


   heuristique1_aux(U,U,0).
   heuristique1_aux([H1|T1],[H2|T2],N) :- 
      heuristique1_aux2(H1,H2,N1),
      heuristique1_aux(T1,T2,N2),
      N is N1 +N2.
   %calcul de piece mal placé en parcourons les listes T1 et T2
      
   heuristique1(U,H):-  
      final_state(Fin),
      heuristique1_aux(U,Fin,H).
   %%Calcul lheuristique pour letat U en fonction de Fin
   %****************
   %HEURISTIQUE no 2
   %****************
   
   % Somme des distances de Manhattan à parcourir par chaque piece
   % entre sa position courante et sa positon dans letat final
   heuristique2_choice(Lettre,P,Ini,Fin):-
      nth1(L,Ini,Ligne), 
      nth1(C,Ligne, Lettre),
      nth1(L2,Fin,Ligne2), 
      nth1(C2,Ligne2, Lettre),
      P is abs(L-L2) + abs(C-C2).
/*calcule la distance de Manhattan entre la position actuelle dune pièce 
et sa position finale. Elle utilise nth1 pour obtenir les coordonnees de la lettre dans les deux etats, puis calcule la distance de Manhattan qui le cout
*/
   heuristique2(U,H):-
      findall(P2,(coordonnees(_P, U, X), X\=vide,final_state(Fin),  heuristique2_choice(X,P2,U,Fin)),Liste),
      sumlist(Liste,H).
/* calcul heuristique 2 pour letat courant U. On utilise findall pour obtenir une liste des distances de Manhattan de chaque piece 
   par rapport a sa position finale, puis utilise sumlist pour obtenir la somme de ces distances, qui est le cout heuristique total
*/
/*
% etat final du taquin 3x3 

final_state([ [a, b,  c],
              [h,vide,d],
              [g, f,  e] ]).




% etat final du taquin 4x4 

final_state([ [ 1,  2,  3,  4],[ 5,  6,  7,  8],[ 9, 10, 11, 12],[13, 14, 15,vide]]).  



% Etats initiaux du Taquin 3*3

initial_state([ [a,  b, c],
                [g,  h, d],
                [vide,f, e] ]). %f*=2

initial_state([ [b, h, c],
                [a, f, d],
                [g,vide,e] ]). %f*=5

initial_state([ [b, c, d],
                [a,vide,g],
                [f, h, e]  ]). %f*=10
			
initial_state([ [f, g, a],
                [h,vide,b],
                [d, c, e]  ]). %f*=20				

initial_state([ [e, f, g],
                [d,vide,h],
                [c, b, a]  ]). % f*=30

initial_state([ [a, b, c],
                [g,vide,d],
                [h, f, e]]). 
				

%Etats du Taquin 4*4
				
initial_state([ [  5,  1,  2,  3],[  9,  6,  7,  4],[ 13, 10, 11,  8],[ 14, 15, 12, vide] ]).  %f*=12
				
initial_state([ [  9,  5,  1,  2],
                [ 13,  6,  7,  3],
                [ 14, 10, 11,  4],
                [ 15, 12,  8, vide] ]).  %f*=24
				

initial_state([ [vide,  9,  1,  4],
                [ 14, 13,  2,  3],
                [ 15, 10,  5,  7],
                [ 11, 12,  6,  8] ]).  %f*=34				

initial_state([ [ 13,  9,  5,  1],
                [ 14,  6,  7,  2],
                [ 15, 10, 11,  3],
                [ 12,  8,  4, vide] ]).  %f*=36

initial_state([ [ 14, 13,  9,  5],
                [ 15,  6,  7,  1],
                [ 12, 10, 11,  2],
                [  8,  4,  3, vide] ]).  %f*=48 	

initial_state([ [ 15, 14, 13,  9],
                [ 12,  6,  7,  5],
                [  8, 10, 11,  1],
                [  4,  3,  2, vide] ]).  %f*=60

initial_state([ [ 15, 14, 13,  9],
                [ 12,  6,  7,vide],
                [  8, 10, 11,  5],
                [  4,  3,  2,  1] ]).   %f*=62		
				
initial_state([ [ 15, 14, 13,  9],
                [ 12,vide,  5, 11],
                [  8,  7,  6, 10],
                [  4,  3,  2,  1] ]).   %f*=88 (théorique) ERROR: Stack limit (1.0Gb) exceeded	
				


*/