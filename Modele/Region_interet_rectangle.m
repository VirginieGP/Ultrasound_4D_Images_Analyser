classdef Region_interet_rectangle < Region_interet
    % Classe concr�te contenant les propri�t�s et m�thodes particuli�res �
    % une r�gion d'int�r�t de forme rectangulaire et h�ritant des propri�t�s
    % et m�thodes de la classe abstraite Region_interet
    
    % Concrete class which contains the properties and methods that are
    % specific to a rectangular ROI and having the properties and methods of
    % the abstract class "Region_interet" (ROI)
    
    properties
       %% Coordonn�es de d�but et de fin pour chacun des axes de la r�gion d'int�r�t.
       % La r�gion d'int�r�t est d�limit�e de 1 (coord_axe1_debut) 
       % � 10 (coord_axe1_fin) sur l'axe 1 et de 15 (coord_axe2_debut) 
       % � 30 (coord_axe2_fin) sur l'axe 2
       
       % Beginning (d�but) and end (fin) coordinates for each of the axes
       % of the ROI
       % The ROI is delineated from 1 (coord_axe1_debut) to 10
       % (coord_axe1_fin) on axis 1 and from 15 (coord_axe2_debut) to 30
       % (coord_axe2_fin) on axis 2
        coordonnee_axe1_debut
        coordonnee_axe2_debut
        coordonnee_axe1_fin
        coordonnee_axe2_fin
        %% Largeur et hauteur de la r�gion d'int�r�t
        
        % Width and height of the ROI
        largeur_axe1
        hauteur_axe2
    end
    
    properties (Dependent)
        %% Propri�t�s logiques, vraies si les coordonn�es de la r�gion d'int�r�t
        % sont distinctes pour la r�gion d'int�r�t.
        
        % Logical properties; "true" if the coordinates of the ROI are
        % different for the ROI
        coordonnees_axe1_distinctes
        coordonnees_axe2_distinctes
    end
    
    methods (Access = ?Modele)  %% Seul un mod�le (instance d'une classe parente) 
                                    % peut construire une instance de
                                    % Region_interet_rectangle
                                    
                                % Only a model (instance of a parent /
                                % higher-level class) can build an instance
                                % of Region_interet_rectangle
        function soi = Region_interet_rectangle(modele)
            % Constructeur d'une instance de Region_interet_rectangle, il ne peut n'y en avoir
            % qu'une
            
            % Builder of an instance of Region_interet_rectangle; there can
            % only be one of it
           soi.modele = modele;
        end
    end
    
    
    methods
        
        function tracer(soi)
            % Pour tracer une r�gion d'int�r�t visuellement
            
            % To trace a ROI visually
            
            % On utilise un bloc try...catch pour g�rer les erreurs
            
            % Uses a try...catch bloc to manage the errors
                try
                    %% On commence � tracer le rectangle
                    
                    % Starts to trace the rectangle
                    objet_rectangle = imrect;
                    
                    %% Si jamais l'utilisateur change de vue en plein milieu de sa
                    % s�ance de tra�age de rectangle, on renvoie une erreur
                    
                    % Displays an error if the user changes view while tracing the
                    % rectangle
                    if isempty(objet_rectangle)
                        erreur_ROI_pas_choisi.message = 'La r�gion d''int�r�t n''a pas �t� d�limit�e avant le changement de vue.';
                        erreur_ROI_pas_choisi.identifier = 'Rectangle_Callback:ROI_pas_choisi';
                        error(erreur_ROI_pas_choisi);
                    end
                    
                    %% On obtient et calcule les coordonn�es de la r�gion d'int�r�t
                    
                    % Obtains and computes the coordinates of the ROI
                    position_rectangle = getPosition(objet_rectangle);
                    
                    valeur_axe1Debut_graphique=position_rectangle(1);
                    valeur_axe2Debut_graphique=position_rectangle(2);
                    soi.largeur_axe1=position_rectangle(3);
                    soi.hauteur_axe2=position_rectangle(4);
                    valeur_axe1Fin_graphique = valeur_axe1Debut_graphique + soi.largeur_axe1;
                    valeur_axe2Fin_graphique = valeur_axe2Debut_graphique + soi.hauteur_axe2;

                    %% On arrondit les valeurs des coordonn�es s�lectionn�es
                    
                    % Round up the values of the selected coordinates
                    soi.coordonnee_axe1_debut=int16(round(valeur_axe1Debut_graphique));
                    soi.coordonnee_axe2_debut=int16(round(valeur_axe2Debut_graphique));
                    soi.coordonnee_axe1_fin=int16(round(valeur_axe1Fin_graphique));
                    soi.coordonnee_axe2_fin=int16(round(valeur_axe2Fin_graphique));
                    
                    %% On supprime le rectangle de s�lection
                    
                    % Deletes the selection rectangle
                    delete(objet_rectangle);
                catch erreurs
                    %% On g�re les erreurs lev�es
                    
                    % Manages the errors that were found
                    if (strcmp(erreurs.identifier,'Rectangle_Callback:ROI_pas_choisi'))
                        causeException = MException(erreur_ROI_pas_choisi.identifier,erreur_ROI_pas_choisi.message);
                        erreurs = addCause(erreurs,causeException);
                        % On supprime le rectangle de s�lection
                        
                        % Deletes the selection rectangle
                        delete(objet_rectangle);
                    end
                    % On affiche les erreurs qui n'auraient pas �t� g�r�es
                    
                    % Displays the errors that have not been managed / sorted out
                    rethrow(erreurs);
                end

        end
                    
         function enregistrer(soi)
              % On enregistre le volume correspondant � la r�gion d'int�r�t 
             % trac�e en utilisant les coordonn�es de d�but et de fin
             % pr�alablement d�finies
             
             % Saves the volume correspondig to the traced ROI by using the
             % beginning and end coordinates that were defined previously
             
             % On utilise un bloc try...catch pour g�rer les erreurs
             
             % Uses a try...catch bloc to manage the errors
             try
                %% On importe les donn�es utiles
                
                % Loads the data that is useful
                volumes = soi.modele.volumes;
                
                assert(~isnan(soi.coordonnee_axe1_debut) && ~isnan(soi.coordonnee_axe1_fin) ...
                && ~isnan(soi.coordonnee_axe2_debut) && ~isnan(soi.coordonnee_axe2_fin),...
                'Region_interet_rectangle_enregistrer:coordonnees_vides',...
                'Aucune coordonn�e n''a �t� entr�e.');   
                
                %% On s�lectionne les volumes � l'int�rieur de la zone d'int�r�t
                
                % Selects the volumes inside the ROI
                volumes_ROI=volumes.donnees(int16(soi.coordonnee_axe1_debut):...
                    int16(soi.coordonnee_axe1_fin),...
                    int16(soi.coordonnee_axe2_debut):int16(soi.coordonnee_axe2_fin),:,:);
                
                %% On enregistre les donn�es qui nous int�ressent en les mettant
                % dans les propri�t�s de nos objets
                
                % Saves the data that interest us by putting them in the
                % properties of our objects
                soi.donnees_4D = volumes_ROI;
                soi.modele.donnees_region_interet = soi.donnees_4D;
                % On enregistre les donnn�es situ�es dans la zone d'int�r�t
                % et sur l'image courante
                
                % Saves the data located in the ROI and in the current
                % image
                soi.donnees_2D = soi.donnees_4D(:,:,volumes.coordonnee_axe3_selectionnee,...
                volumes.coordonnee_axe4_selectionnee);
             catch erreurs
                 %% On g�re les erreurs lev�es
                 
                 % Manages the errors that were found
                if (strcmp(erreurs.identifier,'MATLAB:badsubscript'))
                    warndlg('Merci d''entrer une r�gion d''int�r�t incluse dans l''image.');
                    messsage_erreur = 'La r�gion d''int�r�t d�passe de l''image.';
                    cause_erreur = MException('MATLAB:badsubscript',messsage_erreur);
                    erreurs = addCause(erreurs,cause_erreur);
                elseif (strcmp(erreurs.identifier,'Region_interet_rectangle_enregistrer:coordonnees_vides'))
                    warndlg(['Merci d''entrer des coordonn�es de d�but et de fin ', ...
                    'de la r�gion d''int�r�t pour chacun des deux axes.']);
                    throw(erreurs);
                end
                % On affiche les erreurs qui n'auraient pas �t� g�r�es
                
                % Displays the errors that have not been managed / sorted out
                rethrow(erreurs);
             end
         end
         
         
        function valeur = get.coordonnees_axe1_distinctes(soi)
            % Les coordonn�es sur l'axe 1 sont distinctes si la coordonn�e
            % de d�but est diff�rente de la coordonn�e de fin
            
            % The coordinates on axis 1 are distinct if the beginning
            % coordinate is different form the end coordinate
            valeur = (soi.coordonnee_axe1_debut~=soi.coordonnee_axe1_fin);
        end

        function valeur = get.coordonnees_axe2_distinctes(soi)
            % Les coordonn�es sur l'axe 2 sont distinctes si la coordonn�e
            % de d�but est diff�rente de la coordonn�e de fin
            
            % The coordinates on axis 2 are distinct if the beginning
            % coordinate is different form the end coordinate
            valeur = (soi.coordonnee_axe2_debut~=soi.coordonnee_axe2_fin);
        end
    end
    
   

end

