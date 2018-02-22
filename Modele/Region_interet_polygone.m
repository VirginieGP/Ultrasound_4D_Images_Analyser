classdef Region_interet_polygone < Region_interet
    % Classe concr�te contenant les propri�t�s et m�thodes particuli�res �
    % une r�gion d'int�r�t de forme polygonale et h�ritant des propri�t�s
    % et m�thodes de la classe abstraite Region_interet
    
    % Concrete class which contains the properties and methods that are
    % specific to a polygonal ROI and having the properties and methods of
    % the abstract class "Region_interet" (ROI)
    properties
        masque_binaire_4D % Masque contenant vrai pour les valeurs � l'int�rieur
                            % de la r�gion d'int�r�t, et faux pour les
                            % autres
                            
                           % Mask made of "true" for the values inside the
                           % ROI, and "false" for the others
        polygone
    end
    
    methods (Access = ?Modele)  %% Seul un mod�le (instance d'une classe parente) 
                                    % peut construire une instance de Region_interet_polygone
                                    
                                % Only a model (instance of a parent /
                                % higher-level class) can build an instance
                                % of Region_interet_polygone
        function soi = Region_interet_polygone(modele)
            % Constructeur d'une instance de Region_interet_polygone, il ne peut n'y en avoir
            % qu'une
            
            % Builder of an instance of Region_interet_polygone; there can
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
            %% On importe la donn�e utile
            
            % Loads the useful data
            taille_axes = soi.modele.volumes.taille_axes_enregistree;
            
            %% On commence � tracer le polygone
            
            % Starts to trace the polygon
            soi.polygone=impoly;
            
            %% Si jamais l'utilisateur change de vue en plein milieu de sa
            % s�ance de tra�age de polygone, on renvoie une erreur
            
            % Displays an error if the user changes view while tracing the
            % polygon
            if isempty(soi.polygone)
                erreur_ROI_pas_choisi.message = 'La r�gion d''int�r�t n''a pas �t� d�limit�e avant le changement de vue.';
                erreur_ROI_pas_choisi.identifier = 'polygone_Callback:ROI_pas_choisi';
                error(erreur_ROI_pas_choisi);
            end
            
            %% On cr�e un masque bool�en (.==1 dans la zone d'int�r�t choisie,
            % .==0 en dehors) � partir de la r�gion d'int�r�t 
            
            % Creates a boolean mask (.==1 in the chosen zone of interest,
            % .==0 outside) from the ROI
            masque_binaire_2D=soi.polygone.createMask();
            
            %% On convertit le masque qui a �t� dessin� sur l'image affich�e en
            % coordonn�es cart�siennes, en un masque adapt� � nos donn�es en coordonn�es
            % "indices de matrice" (voir sch�ma dans la documentation)
            
            % Converts the mask which has been drawn on the image displayed
            % in cartesian coordinates, and a mask adapted to our data in
            % "index of matrix" coordinates (see scheme in the
            % documentation folder)
            masque_binaire_2D=masque_binaire_2D';
            
            %% On �largit le masque � toute la matrice 4D, en r�p�tant notre s�lection
            % sur les diff�rentes tranches et aux diff�rents temps
            % Etape qui prend beaucoup de temps (environ 3 secondes),
            % une optimisation est peut-�tre possible.
            
            % Enlarges the mask to the whole 4D matrix, by repeating our
            % selection on the different slices and at the different times
            % This step takes a lot of time (around 3 seconds), an
            % optimisation may be possible.
            soi.masque_binaire_4D = repmat(masque_binaire_2D,1,1,taille_axes(3),taille_axes(4));
        catch erreurs
            %% On g�re les erreurs lev�es
            
            % Manages the errors that were found
         if (strcmp(erreurs.identifier,'polygone_Callback:ROI_pas_choisi'))
            causeException = MException(erreur_ROI_pas_choisi.identifier,erreur_ROI_pas_choisi.message);
            erreurs = addCause(erreurs,causeException);
            delete(soi.polygone);
         end
         % On affiche les erreurs qui n'auraient pas �t� g�r�es
         
         % Displays the errors that have not been managed / sorted out
         rethrow(erreurs);
        end

        end
                    
         function enregistrer(soi)
             % On enregistre le volume correspondant � la r�gion d'int�r�t 
             % trac�e en utilisant le masque binaire pr�c�demment d�fini
             
             % Saves the volume corresponding to the ROI that has been
             % traced by using the binary mask defined previously
             
            %% On importe les donn�es n�cessaires
            
            % Loads the data that are necessary
            volumes = soi.modele.volumes;
            donnees_4D=volumes.donnees;
            
            %% On s�lectionne les donn�es s�lectionn�es par la r�gion d'int�r�t
            % en utilisant en filtrage bool�en
            
            % Selects the data selected by the ROI by using a boolean
            % filter
            donnees_4D(soi.masque_binaire_4D==0) = NaN;
            
            %% On enregistre les donn�es qui nous int�ressent en les mettant
            % dans les propri�t�s de nos objets
            
            % Saves the data that interest us by putting them in the
            % properties of our objects
            soi.donnees_4D = donnees_4D;
            soi.modele.donnees_region_interet = donnees_4D;
            soi.donnees_2D = donnees_4D(:,:,volumes.coordonnee_axe3_selectionnee,...
            volumes.coordonnee_axe4_selectionnee);
         end
         
    end
    
end

