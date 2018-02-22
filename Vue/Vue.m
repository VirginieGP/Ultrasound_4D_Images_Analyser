classdef Vue < handle
    % La Vue est la classe qui s'occupe de l'affichage des donn�es mises �
    % jour dans le mod�le
    
    % The "Vue" (View) is the class which deals with the display of the
    % data which have been updated in the model
    properties
        interface_homme_machine % aussi appel�e interface graphique
        
                                % also called graphic interface
        modele
        controleur
    end
    
    properties (Access = private)
        gris = [0.83,0.82,0.78] % d�finition de la couleur grise en encodage
                                % rouge-vert-bleu (RVB)
                                
                                % definition of the grey color in RGB
                                % (red-green-blue)encoding 
    end
    
    methods
        function soi = Vue(controleur)
            %Constructeur de la vue
            
            % Builder of the view
            soi.controleur = controleur;
            soi.modele = controleur.modele;
            
            
            %% On instancie l'interface homme machine et on lui passe comme
            % argument le controleur
            
            % Instantiates the Man-machine interface and gives it the
            % controler as an argument
            soi.interface_homme_machine = Ultrasound_4D_Images_Analyser('controleur',soi.controleur);
            
            
            %% On pirate MATLAB en changeant ses variables Java pour que les
            % bulles d'aide ne disparaissent plus au bout de 10 secondes
            
            % Hacks Matlab by changing its Java variables so that the help
            % popupwindows last more than 10 seconds
            
            % On appelle une m�thode statique pour obtenir un objet ToolTipManager
            
            % Calls a statistical method in order to obtain a
            % TollTipManager object
            tm = javax.swing.ToolTipManager.sharedInstance; 
            
            % On prend le plus grand entier sign� cod� sur 32 bits soit
            % 2^31 (le 32�me bit correspond au signe)
            
            % Takes the biggest 32-bits signed integer 
            % which is 2^31 (the 32nd bit corresponds to the sign)
            long_temps_de_disparition = intmax('int32');
            
            % On param�tre le temps de d�sapparation (qui est lui-m�me
            % un entier sign� cod� sur 32-bit) pour qu'il vale
            % long_temps_de_disparation
            
            % Sets the dismiss delay (which is a 32-bit signed
            % integer) so that is equals to "long_temps_de_disparition"
            % (long dimiss delay / time before the popup disappears)
            javaMethodEDT('setDismissDelay',tm,long_temps_de_disparition);
            
            % On param�tre le temps d'apparition pour qu'il soit instantan�
            % (�gal � 0 secondes)
            
            % Sets the apparition delay to 0 seconds (instantaneous)
            javaMethodEDT('setInitialDelay',tm,0);
           
            
            %% On observe les changements de param�tres de mod�le, et le cas
            % �ch�ant, on appelle la m�thode statique
            % reagir_aux_observations (elle appartient � cette classe)
            
            % Observes the changes in the paramter settings of the model
            % and calls the static method "reagir_aux_observations" (react
            % to observations. This method belongs to this class)
            addlistener(soi.modele,'image','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'chemin_donnees','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'donnees_region_interet','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'entropie_region_interet','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'coefficient_variation_region_interet','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'energie_matrice_cooccurrence_region_interet','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'ordonnees_graphique','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'largeur_a_mi_hauteur_pic_choisi','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'distance_pic_a_pic_choisie','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'vecteur_temps_sous_echantillonnage','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'chemin_enregistrement_export_graphique','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'chemin_enregistrement_export_image','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'chemin_enregistrement_export_interface','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            
        end
    end
    
    methods (Static)
        function reagir_aux_observations(soi,information_propriete_modifiee,evenement)
            % Selon la propri�t� du mod�le qui est modifi�e, on affiche ce
            % qui est n�cessaire dans l'interface homme machine
            
            % Depending on the property of the model that is modified,
            % displays what is necessay in the man-machine interface
            
            % On r�cup�re l'objet dont la propri�t� a �t� modifi�e
            % (dans notre cas il sera toujours le mod�le)
            
            % Gets the object whose property has been modified (in this
            % case it will always be the model)
            objet_concerne = evenement.AffectedObject;
            
            % On r�cup�re l'objet dont les propri�t�s d�finissent
            % l'interface graphique : handles (voir le site de Matlab,
            % partie GUI pour plus d'informations)
            
            % Gets the object whose properties define the graphic interface
            % : handles (cf Matlab website about GUI for more information)
            handles = guidata(soi.interface_homme_machine);
            
            % Selon le nom de la propri�t� du mod�le qui est modifi�e, 
            % on affiche ce qui est n�cessaire dans l'interface homme machine
            
            % Depending on the name of the model property that has been
            % modified, displays what is necessary in the man-machine
            % interface
            switch information_propriete_modifiee.Name
                
                case 'image'
                    % on se positionne dans l'axe de l'affichage de l'image
                    
                    % Takes position in the display axis of the image
                    axes(handles.image);
                    
                    %% On op�re une translation sur l'image r�cup�r�e du
                    % mod�le pour passer du syst�mes de coordonn�es
                    % "indices de matrice" � "cart�siennes"
                    
                    % Performs a translation on the image taken from the
                    % model in order to swap from "matrix index"
                    % coordinates to "cartesian" coordinates
                    image_a_afficher=objet_concerne.image';
                    
                    %% On force l'affichage des axes de l'image
                    
                    % Sets the display of the axes on the image
                    iptsetpref('ImshowAxesVisible','on');
                    
                    %% On affiche l'image 
                    
                    % Displays the image
                    imshow(image_a_afficher);
                    
                    %% On lie les l'�chelle des donn�es � l'�chelle de
                    % couleur d'affichage par une fonction lin�aire
                    
                    % Connects the data scale to the color scale by a
                    % linear function
                    set(handles.image.Children,'CDataMapping','direct');
                    
                    %% On r�cup�re le menu contextuel cr�� via l'outil GUIDE
                    % et on le place de l'enfant de l'affichage de l'image
                    % Cela permet d'avoir le menu contextuel qui apparait
                    % au-dessus de l'image, et non en-dessous comme par
                    % d�faut
                    
                    % Gets the context menu created using the GUIDE tool
                    % and places it in the child of the image display
                    % This enables to have the context menu appear overhead 
                    % the image instead of under the image (default)
                    menu_contextuel = get(handles.image,'UIContextMenu');
                    set(handles.image.Children,'UIContextMenu',menu_contextuel);
                    
                    %% Selon l'orientation du plan choisi (vue_choisie)
                    % on change le titre de l'image, et le nom des axes
                    
                    % Changes the title of the image and the names of the
                    % axes depending on the orientation of the plane that
                    % has been chosen (vue_choisie)
                    switch objet_concerne.volumes.vue_choisie
                        case 0 % plan axial % axial plane
                            axe1='X';
                            axe2='Y';
                            axe3='Z';
                            axe4='Temps';
                            title({'Plan axial', [axe3 '=' num2str(objet_concerne.volumes.coordonnee_axe3_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(3)) ', ' axe4 '=' num2str(objet_concerne.volumes.coordonnee_axe4_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(4))]});
                        case 1 % plan lat�ral % lateral plane
                            axe1='X';
                            axe2='Z';
                            axe3='Y';
                            axe4='Temps';
                            title({'Plan lat�ral',[axe3 '=' num2str(objet_concerne.volumes.coordonnee_axe3_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(3)) ', ' axe4 '=' num2str(objet_concerne.volumes.coordonnee_axe4_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(4))]});
                        case 2 % plan transverse % transverse plane
                            axe1='Y';
                            axe2='Z';
                            axe3='X';
                            axe4='Temps';
                            title({'Plan transverse', [axe3 '=' num2str(objet_concerne.volumes.coordonnee_axe3_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(3)) ', ' axe4 '=' num2str(objet_concerne.volumes.coordonnee_axe4_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(4))]});
                        case 3 % plan x-temps % x-time plane
                            axe1='Temps';
                            axe2='X';
                            axe3='Z';
                            axe4='Y';
                            title({'Plan x-temps', [axe3 '=' num2str(objet_concerne.volumes.coordonnee_axe3_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(3)) ', ' axe4 '=' num2str(objet_concerne.volumes.coordonnee_axe4_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(4))]});
                        case 4 % plan y-temps % y-time plane
                            axe1='Temps';
                            axe2='Y';
                            axe3='Z';
                            axe4='X';
                            title({'Plan y-temps', [axe3 '=' num2str(objet_concerne.volumes.coordonnee_axe3_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(3)) ', ' axe4 '=' num2str(objet_concerne.volumes.coordonnee_axe4_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(4))]});
                        case 5 % plan z-temps % z-time plane
                            axe1='Temps';
                            axe2='Z';
                            axe3='Y';
                            axe4='X';
                            title({'Plan z-temps', [axe3 '=' num2str(objet_concerne.volumes.coordonnee_axe3_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(3)) ', ' axe4 '=' num2str(objet_concerne.volumes.coordonnee_axe4_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(4))]});
                    end;
                    
                    %% On affiche la l�gende de l'axe des abscisses de l'image
                    
                    % Displays the caption of the X-axis of the image
                    if strcmp(axe1,'Temps')
                        % Si le temps est en abscisses, l'unit� est le pas de temps
                        
                        % If the time is the X-axis, the unit is the
                        % time-step
                        xlabel([axe1,' (en pas de temps)']);
                    else
                        % Sinon, ce sont des pixels
                        
                        % otherwise, the unit is the pixels
                        xlabel([axe1,' (en pixels)']);
                    end
                    
                    %% On affiche la l�gende des ordonn�es de l'image
                    
                    % Displays the caption of the Y-axis of the image
                    ylabel([axe2, ' (en pixels)']);
                    
                    %% On remet � z�ro l'affichage
                    % Cela est utile si on a d�j� affich� une image et fait
                    % des calculs dessus, et que l'on veut afficher une
                    % autre image
                    % Note : remettre � z�ro l'affichage n'est pas une
                    % bonne m�thode, j'aurais d� plut�t remettre � z�ro les
                    % propri�t�s du mod�le et laisser l'affichage se mettre
                    % � jour par les observateurs inclus dans la vue. Mais
                    % j'ai fait le mauvais choix au d�but, et je manque de
                    % temps maintenant pour tout changer.
                    
                    % Resets the display
                    % This is useful if an image has already been displayed
                    % and some computation performed, and that the user
                    % wants to display another image
                    % Note : resetting the display is not a good method, I
                    % should rather have reset the properties of the model
                    % and let the display update using the observers
                    % included in the view. But I made the wrong choice
                    % when I first wrote this code, and do not have enough
                    % time left to change everything.
                    gris = soi.gris;
                    set(handles.affichage_entropie,'String',[],'BackgroundColor',gris);
                    set(handles.affichage_coefficient_variation,'String',[],'BackgroundColor',gris);
                    set(handles.affichage_contraste,'String',[],'BackgroundColor',gris);
                    set(handles.affichage_correlation,'String',[],'BackgroundColor',gris);
                    set(handles.affichage_energie,'String',[],'BackgroundColor',gris);
                    set(handles.affichage_homogeneite,'String',[],'BackgroundColor',gris);
                    set(handles.decalage_ligne,'Enable','inactive','BackgroundColor',gris);
                    set(handles.decalage_colonne,'Enable','inactive','BackgroundColor',gris);
                    set(handles.choix_du_pic,'String',' ');
                    set(handles.valeur_taille_fenetre_lissage,'String','1','Enable','inactive','BackgroundColor',gris);
                    set(handles.valeur_nombre_de_pics,'String','1','Enable','inactive','BackgroundColor',gris);
                    set(handles.lmh_affichage,'String',[],'Enable','inactive','BackgroundColor',gris);
                    set(handles.choix_de_deux_pics,'String',' ');
                    set(handles.dpap_affichage,'String',[],'Enable','inactive','BackgroundColor',gris);
                    set(handles.facteur_temps_I_max,'Enable','inactive','BackgroundColor',gris);
                    set(handles.facteur_sous_echantillonnage,'Enable','inactive','BackgroundColor',gris);
                    set(handles.valeur_axe1Debut_graphique,'String',[],'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Debut_graphique,'String',[],'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe1Fin_graphique,'String',[],'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Fin_graphique,'String',[],'enable','on','BackgroundColor','white');
                    
                    %% Quand on fait des modifications de l'orientation du plan,
                    % ou quand on glisse entre les plans, on doit mettre �
                    % jour l'affichage. C'est ce qu'on fait ici.
                    
                    % Updates the display when the user modifies the
                    % orientation of the plane or when he scrolls through
                    % the planes.
                    set(handles.valeur_axe3_image,'String',objet_concerne.volumes.coordonnee_axe3_selectionnee,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe4_image,'String',objet_concerne.volumes.coordonnee_axe4_selectionnee,'enable','on','BackgroundColor','white');
                    set(handles.axe1_graphique,'String',axe1);
                    set(handles.axe2_graphique,'String',axe2);
                    set(handles.abscisses_axe1,'String',axe1);
                    set(handles.abscisses_axe2,'String',axe2);
                    set(handles.abscisses_axe3,'String',axe3);
                    set(handles.abscisses_axe4,'String',axe4);
                    set(handles.moyenne_axe1,'String',axe1);
                    set(handles.moyenne_axe2,'String',axe2);
                    set(handles.moyenne_axe1et2,'String',[axe1, ' et ', axe2]);
                    set(handles.texte_axe3_image,'String',axe3);
                    set(handles.texte_axe4_image,'String',axe4);
                    set(handles.texte_decalage_axe1,'String',['en ', axe1]);
                    set(handles.texte_decalage_axe2,'String',['en ', axe2]);
                    set(handles.maximum_axe1_1,'String',['/',num2str(objet_concerne.volumes.taille_axes(1))]);
                    set(handles.maximum_axe1_2,'String',['/',num2str(objet_concerne.volumes.taille_axes(1))]);
                    set(handles.maximum_axe2_1,'String',['/',num2str(objet_concerne.volumes.taille_axes(2))]);
                    set(handles.maximum_axe2_2,'String',['/',num2str(objet_concerne.volumes.taille_axes(2))]);
                    set(handles.total_axe3_image,'String',['sur ', num2str(objet_concerne.volumes.taille_axes(3))]);
                    set(handles.total_axe4_image,'String',['sur ', num2str(objet_concerne.volumes.taille_axes(4))]);
                    set(handles.valeur_axe1Debut_graphique,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Debut_graphique,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe1Fin_graphique,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Fin_graphique,'enable','on','BackgroundColor','white');
                case 'chemin_donnees'
                    % On affiche le chemin des donn�es � charger
                    % s�lectionn�
                    
                    % Displays the pathway of the data that have to be
                    % loaded selected by the user
                    set(handles.chemin_dossier,'String',objet_concerne.chemin_donnees);
                    
                case 'donnees_region_interet'
                    %% On efface le graphique pr�c�dent
                    
                    % Clears the previous graph
                    cla(handles.affichage_graphique,'reset');
                    
                    %% On efface la region d'int�r�t trac�e pr�c�demment
                    
                    % Clears the previously traced ROI
                    cla(handles.image.Children);

                    if isfield(handles,'rectangle_trace')
                        delete(handles.rectangle_trace);
                    end

                    if isfield(handles,'polygone_trace')
                        delete(handles.polygone_trace);
                    end
                    
                    %% On choisit les axes de l'image
                    
                    % Chooses the axes of the image
                    axes(handles.image);
                    
                    %% Si on a choisi une r�gion d'int�r�t rectangulaire
                    
                    % If the user has chosen a rectangular region of
                    % interest
                    if isa(objet_concerne.region_interet,'Region_interet_rectangle')
                        %% On affiche les coordonn�es de d�but et de fin 
                        % du rectangle, sur ses deux axes
                        
                        % Displays the coordinates of the beginning and of
                        % the end of the rectangle, on both axes
                        set(handles.valeur_axe1Debut_graphique,'String',...
                            num2str(objet_concerne.region_interet.coordonnee_axe1_debut));
                        set(handles.valeur_axe2Debut_graphique,'String',...
                            num2str(objet_concerne.region_interet.coordonnee_axe2_debut));
                        set(handles.valeur_axe1Fin_graphique,'String',...
                            num2str(objet_concerne.region_interet.coordonnee_axe1_fin));
                        set(handles.valeur_axe2Fin_graphique,'String',...
                            num2str(objet_concerne.region_interet.coordonnee_axe2_fin)); 
                        
                        %% On affiche un rectangle rouge sur l'image correspondant
                        % � la r�gion d'int�r�t pr�c�demment d�finie
                        
                        % Displays a red rectangle on the image
                        % corresponding to the ROI specified previouly
                        handles.rectangle_trace = rectangle('Position',...
                            [objet_concerne.region_interet.coordonnee_axe1_debut...
                            objet_concerne.region_interet.coordonnee_axe2_debut...
                            objet_concerne.region_interet.largeur_axe1...
                            objet_concerne.region_interet.hauteur_axe2],'EdgeColor','r');
                        
                        %% Si on a choisit une r�gion d'int�r�t rectangulaire
                        % on permet tous les choix d'axes de moyennes et
                        % d'abscisses
                        
                        % If the chosen ROI is rectangular, enables all the
                        % axes for means and for X-axis
                        set(handles.moyenne_axe1,'Visible','on');
                        set(handles.moyenne_axe2,'Visible','on');
                        set(handles.pas_de_moyenne,'Visible','on');
                        set(handles.abscisses_axe1,'Visible','on');
                        set(handles.abscisses_axe2,'Visible','on');
                        
                    %% Si on a choisi une r�gion d'int�r�t polygonale
                    
                    % If the user has chose the shape of the ROI to be a
                    % polygon
                    elseif isa(objet_concerne.region_interet,'Region_interet_polygone')
                        % On utilise un bloc try... catch pour g�rer les
                        % erreurs
                        
                        % Uses a try...catch bloc to manage the errors
                        try
                            % On r�cup�re la taille courante des axes
                            
                            % Gets the current size of the axes
                            taille_axes = objet_concerne.volumes.taille_axes;
                            
                            % On obtient les positions du polygone
                            
                            % Gets the positions of the polygon
                            positions_polygone=getPosition(objet_concerne.region_interet.polygone);
                            
                            %% On d�tecte si le polygone sort de l'espace de l'image
                            % et on renvoie une erreur le cas �ch�ant
                            
                            % Detects whether the polygon trespasses the
                            % space of the image and returns an error if it
                            % is the case
                            nb_positions_polygone = size(positions_polygone,1);
                            maximum_axe1=taille_axes(1);
                            maximum_axe2=taille_axes(2);
                            for i=1:nb_positions_polygone
                                X_pos_i=positions_polygone(i,1);
                                Y_pos_i=positions_polygone(i,2);
                                if X_pos_i<1 || X_pos_i>maximum_axe1 || Y_pos_i<1 || Y_pos_i>maximum_axe2
                                    erreur_sortie_de_image.message = 'La r�gion d''int�r�t d�passe de l''image.';
                                    erreur_sortie_de_image.identifier = 'polygone_Callback:sortie_de_image';
                                    error(erreur_sortie_de_image);
                                end
                            end
                            
                            %% On trace le polygone sur l'image
                            
                            % Traces the polygon on the image
                            ordre_des_points=1:nb_positions_polygone;
                            polygone_trace=patch('Faces',ordre_des_points,'Vertices',positions_polygone,'FaceColor','none','EdgeColor','red');
                            handles.polygone_trace=polygone_trace;
                            
                            %% On efface l'objet de s�lection de la r�gion d'int�r�t
                            
                            % Deletes the object of selection of the ROI
                            delete(objet_concerne.region_interet.polygone);
                         catch erreurs
                            if (strcmp(erreurs.identifier,'polygone_Callback:sortie_de_image'))
                                %% Si on est sorti de l'image pendant la s�lection,
                                % on envoie un avertissement et on
                                % supprimer l'objet de s�lection de la
                                % r�gion d'int�r�t
                                
                                % If the selection has gone out of the
                                % image while proceeding to the selection,
                                % returns a warning and deletes the object
                                % of selection of the ROI
                                warndlg('Merci d''entrer une r�gion d''int�r�t incluse dans l''image.');
                                causeException = MException(erreur_sortie_de_image.identifier,erreur_sortie_de_image.message);
                                erreurs = addCause(erreurs,causeException);
                                delete(objet_concerne.region_interet.polygone);
                            end
                            % On envoie les erreurs qui n'auraient pas �t�
                            % trait�es
                            
                            % Reissues the errors that have not been
                            % managed / dealt with
                            rethrow(erreurs);
                        end
                        
                        %% Si on a choisit une r�gion d'int�r�t polygonale,
                        % on ne peut pas choisir tous les axes d'abscisses
                        % et d'affichage de l'image
                        
                        % If the user has chosen a polygonal shape for the
                        % region of interst, not all the axes can be chosen
                        % for the X-axis and the display of the image
                        set(handles.moyenne_axe1et2,'Value',1);
                        set(handles.moyenne_axe1,'Visible','off');
                        set(handles.moyenne_axe2,'Visible','off');
                        set(handles.pas_de_moyenne,'Visible','off');

                        set(handles.abscisses_axe4,'Value',1);
                        set(handles.abscisses_axe1,'Visible','off');
                        set(handles.abscisses_axe2,'Visible','off');  
                    end
                    
                    %% Une fois la r�gion d'int�r�t choisie, on peut calculer les indices de texture
                    
                    % Once the ROI has been chosen, the texture indexes can
                    % be computed
                    set(handles.affichage_entropie,'BackgroundColor','white','String',[]);
                    set(handles.affichage_coefficient_variation,'String',[],'BackgroundColor','white');
                    set(handles.affichage_contraste,'String',[],'BackgroundColor','white');
                    set(handles.affichage_correlation,'String',[],'BackgroundColor','white');
                    set(handles.affichage_energie,'String',[],'BackgroundColor','white');
                    set(handles.affichage_homogeneite,'String',[],'BackgroundColor','white');
                    set(handles.decalage_ligne,'Enable','on','BackgroundColor','white');
                    set(handles.decalage_colonne,'Enable','on','BackgroundColor','white');
                    
                    %% On remet � z�ro l'affichage des param�tres futurs dans le cas
                    % o� on n'est pas � la premi�re image affich�e
                    % Note : remettre � z�ro l'affichage n'est pas une
                    % bonne m�thode, j'aurais d� plut�t remettre � z�ro les
                    % propri�t�s du mod�le et laisser l'affichage se mettre
                    % � jour par les observateurs inclus dans la vue. Mais
                    % j'ai fait le mauvais choix au d�but, et je manque de
                    % temps maintenant pour tout changer.
                    
                    % Resets the display of the future parameters in case
                    % of it is not the first displayed image
                    % Note : resetting the display is not a good method, I
                    % should rather have reset the properties of the model
                    % and let the display update using the observers
                    % included in the view. But I made the wrong choice
                    % when I first wrote this code, and do not have enough
                    % time left to change everything.
                    gris = soi.gris;
                    set(handles.facteur_temps_I_max,'Enable','inactive','BackgroundColor',gris);
                    set(handles.facteur_sous_echantillonnage,'Enable','inactive','BackgroundColor',gris);
                    set(handles.valeur_taille_fenetre_lissage,'String','1','Enable','inactive','BackgroundColor',gris);
                    set(handles.valeur_nombre_de_pics,'String','1','Enable','inactive','BackgroundColor',gris);
                    set(handles.choix_du_pic,'String',' ');
                    set(handles.lmh_affichage,'String',[],'Enable','inactive','BackgroundColor',gris);
                    set(handles.choix_de_deux_pics,'String',' ');
                    set(handles.dpap_affichage,'String',[],'Enable','inactive','BackgroundColor',gris);
                    
                case 'entropie_region_interet'
                    % On affiche l'entropie calcul�e
                    
                    % Displays the computed entropy
                    set(handles.affichage_entropie,'String',num2str(objet_concerne.entropie_region_interet));
                case 'coefficient_variation_region_interet'
                    % On affiche le coefficient de variation dans la r�gion
                    % d'int�r�t
                    
                    % Displays the coefficient of variation in the ROI
                    set(handles.affichage_coefficient_variation,'String',num2str(objet_concerne.coefficient_variation_region_interet));
                case 'energie_matrice_cooccurrence_region_interet'
                    % On affiche les indices calcul�s sur la matrice de cooccurrences
                    
                    % Displays the computed co-occurence matrix indexes
                    set(handles.affichage_energie,'String',num2str(objet_concerne.energie_matrice_cooccurrence_region_interet));
                    set(handles.affichage_contraste,'String',num2str(objet_concerne.contraste_matrice_cooccurrence_region_interet));
                    set(handles.affichage_correlation,'String',num2str(objet_concerne.correlation_matrice_cooccurrence_region_interet));
                    set(handles.affichage_homogeneite,'String',num2str(objet_concerne.homogeneite_matrice_cooccurrence_region_interet));
                case 'ordonnees_graphique'
                    
                    
                    %% On efface la/les courbe(s) pr�c�dentes
                    
                    % Deletes previous curves
                    cla(handles.affichage_graphique);
                    
                    %% On affiche la/les courbes
                    
                    % Displays the curve(s)
                    axes(handles.affichage_graphique);
                    hold on
                    plot(objet_concerne.graphique.abscisses,objet_concerne.graphique.ordonnees,'displayname','Courbe originale','HitTest', 'off');
                    if get(handles.points_de_donnees,'Value')
                        plot(objet_concerne.graphique.abscisses,objet_concerne.graphique.ordonnees,'black+','displayname','Point de donn�es','HitTest', 'off');
                    end
                    hold off
                    
                    %% On affiche le titre
                    
                    % Displays the title
                   
                    % Selon le nombre de courbes, on affiche un titre
                    % diff�rent (au singulier ou au pluriel)
                    
                    % Displays a different title depending on the number of
                    % curves (singular or plural)
                    if objet_concerne.graphique.une_seule_courbe
                        titre='Courbe d''intensit�';
                    else
                        titre='Courbes d''intensit�';
                    end
                    
                    title(titre);
                    
                    %% On affiche la l�gende des abscisses
                    
                    % Displays the X-axis caption
                    
                    % Explication sur la variable ordre_axes :
                    % 1 repr�sente X, 2 -> Y, 3 -> Z, 4 -> Temps
                    % L'ordre des axes est signifi� par l'ordre
                    % dans la liste qu'est la variable ordre_axes.
                    % Par exemple, ordre_axes = [1,2,3,4] correspond � une
                    % image affich�e avec en abscisses X, en
                    % ordonn�es Y, en 3�me dimension Z
                    % et en 4�me dimension le temps
                    
                    % Explanation on the variable "ordre_axes" (axes order)
                    % :
                    % 1 is X, 2 -> Y, 3 -> Z, 4 -> time
                    % The order of the axes is given by the order in the
                    % list ordre_axes.
                    % For instance, ordre_axes = [1,2,3,4] corresponds to
                    % an image displayed with X as X-axis, Y as Y-axis, Z
                    % as 3nd dimension and time as 4th dimension
                    ordre_axes=objet_concerne.volumes.ordre_axes;
                    
                    axe_abscisses_choisi = objet_concerne.graphique.axe_abscisses_choisi;
                    
                    legende_abscisses = ...
                                  objet_concerne...
                                  .graphique...
                                  .noms_axes_legende_abscisses(...
                                  ordre_axes(axe_abscisses_choisi));
                    
                    xlabel(legende_abscisses);
                    
                    %% On affiche la l�gende des ordonnees
                    
                    % Displays the Y-axis caption
                    
                    switch objet_concerne.graphique.axe_moyenne_choisi
                        case '1'
                            legende_ordonnees={'Intensit� (en niveaux)',...
                        ['moyenn�e sur ',objet_concerne.graphique.noms_axes(ordre_axes(1)),' dans la r�gion d''int�r�t']};
                        case '2'
                            legende_ordonnees={'Intensit� (en niveaux)',...
                        ['moyenn�e sur ',objet_concerne.graphique.noms_axes(ordre_axes(2)),' dans la r�gion d''int�r�t']};
                        case '1 et 2'
                            legende_ordonnees={'Intensit� (en niveaux)',...
                        ['moyenn�e sur ',objet_concerne.graphique.noms_axes(ordre_axes(1)),' et ',objet_concerne.graphique.noms_axes(ordre_axes(2))],...
                        ' dans la r�gion d''int�r�t'};
                        case 'pas de moyenne'
                            legende_ordonnees='Intensit� (en niveaux)';
                    end
                     
                    ylabel(legende_ordonnees);
                    
                    %% On indique les nouvelles fonctionnalit�s disponibles dans l'interface_homme_machine
                    
                    % Shows the new features available in the
                    % "interface_homme_machine" (man-machine interface)
                    
                    set(handles.choix_du_pic,'enable','on','BackgroundColor','white');
                    set(handles.choix_de_deux_pics,'enable','on','BackgroundColor','white');
                    set(handles.lmh_affichage,'BackgroundColor','white');
                    set(handles.dpap_affichage,'BackgroundColor','white');
                    set(handles.valeur_taille_fenetre_lissage,'enable','on','BackgroundColor','white');
                    set(handles.valeur_nombre_de_pics,'enable','on','BackgroundColor','white');
                    
                    %% On enl�ve les fonctionnalit�s pas encore disponibles
                    % Note : remettre � z�ro l'affichage n'est pas une
                    % bonne m�thode, j'aurais d� plut�t remettre � z�ro les
                    % propri�t�s du mod�le et laisser l'affichage se mettre
                    % � jour par les observateurs inclus dans la vue. Mais
                    % j'ai fait le mauvais choix au d�but, et je manque de
                    % temps maintenant pour tout changer.
                    
                    % Removes the features that are still available
                    % Note : resetting the display is not a good method, I
                    % should rather have reset the properties of the model
                    % and let the display update using the observers
                    % included in the view. But I made the wrong choice
                    % when I first wrote this code, and do not have enough
                    % time left to change everything.
                    
                    gris = soi.gris;
                    set(handles.facteur_temps_I_max,'Enable','inactive','BackgroundColor',gris);
                    set(handles.facteur_sous_echantillonnage,'Enable','inactive','BackgroundColor',gris);
                    
                case 'largeur_a_mi_hauteur_pic_choisi'
                    
                    %% On affiche la liste des pics et la largeur � mi hauteur du pic choisi
                    
                    % Displays the list of the peaks and the full-width
                    % half-maximum of the chosen peak
                    set(handles.choix_du_pic,'String',objet_concerne.graphique.pics.liste);
                    set(handles.lmh_affichage,'String', objet_concerne.largeur_a_mi_hauteur_pic_choisi);
                    
                    %% on montre que l'on peut maintenant sous-�chantillonner les donn�es
                    
                    % Shows that the data can be sub-sampled now
                    set(handles.facteur_temps_I_max,'Enable','on','BackgroundColor','white');
                    set(handles.facteur_sous_echantillonnage,'Enable','on','BackgroundColor','white');
                    
                case 'distance_pic_a_pic_choisie'
                    
                    %% On affiche la liste des combinaisons de pics 
                    % et la distance pics � pics de la combinaison choisie
                    
                    % Displays the list of the peaks pairings and the
                    % peak-to-peak distance of the chosen pairing
                    set(handles.choix_de_deux_pics,'String',objet_concerne.graphique.pics.liste_combinaisons_de_deux_pics);
                    set(handles.dpap_affichage,'String',objet_concerne.distance_pic_a_pic_choisie);
                    
                case 'vecteur_temps_sous_echantillonnage'
                    %% On efface le graphique pr�c�dent
                    
                    % Deletes the previous graph
                    cla(handles.affichage_graphique);
                    
                    %% On affiche le sous-�chantillonnage par des points
                    % de donn�es sur le graphique
                    % Quand il y a un point, cela veut dire que ce pas de
                    % temps est sauvegard�.
                    % Qu'il n'y en a pas, le pas de temps n'est pas
                    % sauvegard�.
                    
                    % Displays the sub-sampling by dots on the graph
                    % The presence of a dot means that this time-step is
                    % saved. When there is no dot, the time-step is not
                    % saved.

                    axes(handles.affichage_graphique);
                    hold on
                    %% On r�affiche la courbe originale
                    
                    % Re-displays the original curve
                    plot(objet_concerne.graphique.abscisses,objet_concerne.graphique.ordonnees,'displayname','Courbe originale','HitTest', 'off');
                    
                    %% On r�cup�re les param�tres du sous-�chantillonnage
                    
                    % Gets the sub-sampling parameters
                    vecteur_t_ech_normal = objet_concerne.vecteur_temps_echantillonnage_normal;
                    vecteur_t_ssech = objet_concerne.vecteur_temps_sous_echantillonnage;
                    
                    %% Si le point est noir, il correspond � la partie de
                    % l'enregistrement non sous-�chantillon�
                    
                    % Black dots correspond to the part of the record that
                    % is not sub-sampled
                    points_ech_normal = plot(vecteur_t_ech_normal,objet_concerne.graphique.ordonnees(vecteur_t_ech_normal),'black+','displayname','Pas sous-�chantillonn�','HitTest', 'off');
                    
                    %% Si il est rouge, il appartient � la partie de
                    % l'enregistrement sous-�chantillonn�
                    
                    % Red dots correspond to the part of the record that
                    % is sub-sampled
                    points_ssech = plot(vecteur_t_ssech,objet_concerne.graphique.ordonnees(vecteur_t_ssech),'red+','displayname','Sous-�chantillonn�','HitTest', 'off');
                    legend([points_ech_normal,points_ssech]);
                    hold off
                    
                case 'chemin_enregistrement_export_graphique'
                    %% On enregistre le graphique
                    
                    % Saves the graph
                    export_fig(handles.affichage_graphique, objet_concerne.chemin_enregistrement_export_graphique);
                case 'chemin_enregistrement_export_image'
                    %% On enregistre l'image
                    
                    % Saves the image
                    export_fig(handles.image, objet_concerne.chemin_enregistrement_export_image);
                case 'chemin_enregistrement_export_interface'
                    %% On enregistre l'interface enti�re
                    
                    % Saves the whole interface
                    export_fig(handles.figure1, objet_concerne.chemin_enregistrement_export_interface);
                    
            end
        %% On enregistre les modifications faites � l'interface
        
        % Saves the modifications made to the interface
        guidata(handles.figure1,handles);
        end
        
        function aide
            % On affiche un message d'aide
            
            % Displays a help popup message
            
            msgbox({'L''aide sp�cifique aux diff�rentes fonctionnalit�s du programme est accessible en passant le pointeur de la souris', ...
                'sur les points d''interrogation blancs, entour�s de rectangles bleu layette, diss�min�s dans l''interface graphique.', ...
                '', ...
                'Une documentation plus d�taill�e est accessible sur mon d�p�t GitHub', ...
                'accessible � l''adresse suivante : https://github.com/MaxandreJ/Ultrasound_4D_Images_Analyser ', ...
                'sur la page o� vous arrivez en allant sur ce lien, et dans le dossier "Documentation"', ...
                '', ...
                'Aide sp�cifique aux commandes au clavier :', ...
                '',...
                'Les axes et les orientations de plans sont d�finis par rapport � la sonde et non par rapport � l''objet �tudi�', ...
                '(voir sch�mas explication_axes et explication_plans dans le dossier documentation de mon r�pertoire Github).',... 
                'Le passage entre les orientations de plans est permise par les touches du clavier suivantes :', ...
            '0 : plan axial (Y en ordonn�es et X en abscisses) ;', ...
            '1 : plan lat�ral (Z en ordonn�es et X en abscisses) ;', ...
            '2 : plan transverse (Z en ordonn�es et Y en abscisses);', ...
            '3 : plan x-temps (X en ordonn�es et le temps en abscisses);', ...
            '4 : plan y-temps (Y en ordonn�es et le temps en abscisses);', ...
            '5 : plan z-temps (Z en ordonn�es et le temps en abscisses).', ...
            '',...
            'Pour une m�me orientation de plan, on peut glisser entre les plans par les fl�ches multidirectionnelles du clavier :',...
            'fl�ches gauche et droite pour glisser selon le premier axe mentionn� dans le titre de l''image ;',...
            'fl�ches bas et haut pour glisser selon le deuxi�me axe mentionn� dans le titre de l''image.', ...
            '', ...
            'Programme r�alis� par Maxandre Jacqueline, pendant son stage de fin d''�tude � l''�cole Centrale Paris', ...
            'sous la supervision de St�phanie Pitre-Champagnat, �quipe 3, UMR 8081 "IR4M", CNRS', ...
            'et en collaboration avec Virginie Grand-Perret, doctorante, et Natalie Lassau, chef de service � l''h�pital Gustave Roussy � Paris.', ...
            'Vous pouvez me joindre � l''adresse maxandre.jacqueline@me.com .'})
        end
        
    end
    
    methods
        function choisir_axe_image(soi)
            % On s�lectionne les axes de l'image (pour affichage)
            
            % Selects the image axes (for display)
            handles = guidata(soi.interface_homme_machine);
            axes(handles.image);
        end
        
        function choisir_axe_affichage_graphique(soi)
            % On s�lectionne les axes du graphique (pour affichage)
            
            % Selects the graph axes (for display)
            handles = guidata(soi.interface_homme_machine);
            axes(handles.affichage_graphique);
        end
        
        function mise_a_un_liste_de_pics(soi)
            % On s�lectionne le premier pic de la liste des choix de pics
            % Pour �viter l'erreur suivante : je choisis le deuxi�me pic
            % d�tect�, puis je veux d�tecter un seul pic : mon choix du
            % deuxi�me pic n'est plus valide
            % Note : il aurait mieux fallu faire une remise � z�ro au sein
            % du mod�le
            
            % We select the first choice within the list of peaks
            % To avoid the following error : I choose the 2nd detected
            % peak, then I want to detect only one peak : my choice of the
            % 2nd peak is not valid anymore
            % Note : it would have been better to do a reset in the model
            

            handles = guidata(soi.interface_homme_machine);
            set(handles.choix_du_pic,'Value',1);
        end
        
        function mise_a_un_liste_de_combinaisons_de_deux_pics(soi)
            % On s�lectionne la premi�re combinaison de pics
            % de la liste des combinaisons de pics
            % Note : il aurait mieux fallu faire une remise � z�ro au sein
            % du mod�le
            
            % Selects the firt pair of peaks in the list of pairs of peaks
            % Note : it would have been better to do a reset in the model
            
            handles = guidata(soi.interface_homme_machine);
            set(handles.choix_de_deux_pics,'Value',1);
        end
        
    end
    
end