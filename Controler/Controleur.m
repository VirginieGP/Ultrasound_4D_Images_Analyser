classdef Controleur < handle
    % Le controleur est le chef d'orchestre du programme. C'est cette
    % classe qui est charg�e d'appeler les m�thodes du mod�le (traitement
    % des donn�es) et les m�thodes de la vue (affichage). (Voir 'patron
    % de conception Mod�le Vue Contr�leur' sur internet).
    
    % The controler is the conductor / leader of the program. It is this
    % class which is reponsible for calling the methods of the model (data
    % processing) and the methods of the viw (display).(see
    % 'Model-View-Controller design pattern' on the internet)
  
    
    properties
        modele % le mod�le s'occupe du traitement des donn�es 
        
               % the model deals with data processing / handling
        vue % la vue s'occupe de l'affichage
        
            % the view deals with the display
    end
    
    methods
        function soi = Controleur(modele)
            % Constructeur du contr�leur, qui prend le mod�le en entr�e et
            % qui instancie la vue
            
            % Builder of the controller, which take the model as an entry
            % and instantiates the view
            soi.modele = modele;
            soi.vue = Vue(soi);
        end
        
        function charger_volumes_fichier_mat(soi)
            % charge un fichier au format .mat dans le programme
            
            % charges a .mat format file in the program
            
            % le mod�le instancie un �l�ment de Volumes_fichier_mat
            
            % the model instantiates an element of Volumes_fichier_mat
            soi.modele.creer_volumes_fichier_mat;
            
            % On charge les volumes (la fonction de chargement a le m�me
            % nom mais est impl�ment�e diff�remment suivant 
            % l'instanciation � la ligne pr�c�dente, voir le concept de
            % 'polymorphisme' en programmation orient�e objet, sur
            % internet).
            
            % The volumes are loaded (the loading function has the same
            % name but is implemented differently depending on the
            % instantiation at the previous line, see concept of
            % 'polymorphism' in object-oriented programmation on the
            % internet)
            soi.modele.volumes.charger;
        end
        
        function charger_volumes_dossier_mat(soi)
            % charge un dossier compos� de fichiers au format .mat 
            % dans le programme
            
            % loads a folder composed ot the .mat formatted files into the
            % program
            
            % le mod�le instancie un �l�ment de Volumes_dossier_mat
            
            % the model instantiates an element of Volumes_dossier_mat
            soi.modele.creer_volumes_dossier_mat;
            
            % On charge les volumes (la fonction de chargement a le m�me
            % nom mais est impl�ment�e diff�remment suivant 
            % l'instanciation � la ligne pr�c�dente, voir le concept de
            % 'polymorphisme' en programmation orient�e objet, sur
            % internet).
            
            % The volumes are loaded (the loading function has the same
            % name but is implemented differently depending on the
            % instantiation at the previous line, see concept of
            % 'polymorphism' in object-oriented programmation on the
            % internet)
            soi.modele.volumes.charger;
        end
        
        function charger_volumes_RawData_bin(soi)
            % charge un dossier, compos� de fichiers au format .bin encod�s
            % RawData, dans le programme
            
            % loads a folder composed ot the .bin formatted files encoded
            % RawData, into the program
                        
            % le mod�le instancie un �l�ment de Volumes_RawData_bin
            
            % the model instantiates an element of Volumes_RawData_bin
            soi.modele.creer_volumes_RawData_bin;
            
            % On charge les volumes (la fonction de chargement a le m�me
            % nom mais est impl�ment�e diff�remment suivant 
            % l'instanciation � la ligne pr�c�dente, voir le concept de
            % 'polymorphisme' en programmation orient�e objet, sur
            % internet).
            
            % The volumes are loaded (the loading function has the same
            % name but is implemented differently depending on the
            % instantiation at the previous line, see concept of
            % 'polymorphism' in object-oriented programmation on the
            % internet)
            soi.modele.volumes.charger;
        end
        
        function charger_volumes_VoxelData_bin(soi)
            % charge un dossier, compos� de fichiers au format .bin encod�s
            % VoxelData, dans le programme
            
            % loads a folder composed ot the .bin formatted files encoded
            % VoxelData, into the program
            
            % le mod�le instancie un �l�ment de Volumes_VoxelData_bin
            
            % the model instantiates an element of Volumes_VoxelData_bin
            soi.modele.creer_volumes_VoxelData_bin;
            
            % On charge les volumes (la fonction de chargement a le m�me
            % nom mais est impl�ment�e diff�remment suivant 
            % l'instanciation � la ligne pr�c�dente, voir le concept de
            % 'polymorphisme' en programmation orient�e objet, sur
            % internet).
            
            % The volumes are loaded (the loading function has the same
            % name but is implemented differently depending on the
            % instantiation at the previous line, see concept of
            % 'polymorphism' in object-oriented programmation on the
            % internet)
            soi.modele.volumes.charger;
        end
        
        function mettre_a_jour_image_clavier(soi,eventdata)
            % met � jour l'image affich�e dans le programme si on appuie
            % sur une touche du clavier (soit une fl�che directionnelle
            % pour glisser entre les plans, soit un chiffre pour changer
            % d'orientation du plan)
            
            % Updates the image displayed in the program if the used
            % strikes a key of the keyboard (either an direction arrow to
            % move through the planes, or a digit to change the orientation
            % of the plane)
            
            soi.modele.volumes.mettre_a_jour_image_clavier(eventdata);
        end
        
        function mettre_a_jour_image_bouton(soi,coordonnee_axe3_selectionnee,coordonnee_axe4_selectionnee)
            % met � jour l'image affich�e dans le programme si on entre les
            % coordonn�es sur l'axe 3 et 4 
            % dans la partie "afficher image" de l'interface graphique
            
            % Updates the image displayed in the program if the user enters
            % the coordinates on the axis 3 and 4 in the "afficher image"
            % part of the graphic interface
            
            soi.modele.volumes.mettre_a_jour_image_bouton(coordonnee_axe3_selectionnee,coordonnee_axe4_selectionnee);
        end
        
        function selectionner_manuellement_region_interet(soi,coordonnee_axe1_debut,...
    coordonnee_axe1_fin,coordonnee_axe2_debut,coordonnee_axe2_fin)
            % s�lectionne une r�gion d'int�r�t rectangulaire apr�s avoir
            % entr� les coordonn�es dans l'interface graphique
            
            % Selects a rectangular region of interest after having
            % entered the coordinated in the graphic interface

            % on instancie une r�gion d'int�r�t rectangulaire
            
            % instantiates a rectangular region of interest
            soi.modele.creer_region_interet_rectangle;
            
            % on s�lectionne la r�gion d'int�r�t
            
            % selects a region of interest
            soi.modele.region_interet.selectionner_manuellement(coordonnee_axe1_debut,...
        coordonnee_axe1_fin,coordonnee_axe2_debut,coordonnee_axe2_fin);
  
        end
        
        function selectionner_visuellement_region_interet_rectangulaire(soi)
            % s�lectionne une r�gion d'int�r�t rectangulaire apr�s avoir
            % l'avoir trac� sur l'image (apr�s avoir fait clic droit 
            % sur l'image > s�lectionner une r�gion d'int�r�t > rectangle)
            
            % selects a rectangular region of interest after having traced
            % it on the image (after right click on the image >
            % "s�lectionner une r�gion d'int�r�t" > "rectangle")
            
            % on instancie une r�gion d'int�r�t rectangulaire
            
            % instantiates a rectangular region of interest
            soi.modele.creer_region_interet_rectangle;
            
            % on indique � l'interface que l'on veut effectuer la s�lection
            % sur l'image
            
            % indicates to the interface that we want to make a selection
            % on the image
            soi.vue.choisir_axe_image;
            
            % On s�lectionne la r�gion d'int�r�t en la tra�ant sur l'image
            
            % Selects the region of interest by tracing it on the image
            soi.modele.region_interet.selectionner_visuellement;
        end
        
        function selectionner_visuellement_region_interet_polygonale(soi)
            % s�lectionne une r�gion d'int�r�t polygonale apr�s avoir
            % l'avoir trac� sur l'image (apr�s avoir fait clic droit 
            % sur l'image > s�lectionner une r�gion d'int�r�t > polygone)
            
            % selects a polygonal region of interest after having traced it
            % on the image (after right click on the image >
            % "s�lectionner une r�gion d'int�r�t" > "polygone")
            
            % on instancie une r�gion d'int�r�t polygonale
            
            % instantiates a polygonal region of interest
            soi.modele.creer_region_interet_polygone;
            
            % on indique � l'interface que l'on veut effectuer la s�lection
            % sur l'image
            
            % indicates to the interface that we want to make a selection
            % on the image
            soi.vue.choisir_axe_image;
            
            % On s�lectionne la r�gion d'int�r�t en la tra�ant sur l'image
            
            % selects the region of interest by tracing it on the image
            soi.modele.region_interet.selectionner_visuellement;
        end
        
        function calcul_indices_texture_region_interet(soi,decalage_ligne_matrice_cooccurrence...
                ,decalage_colonne_matrice_cooccurrence)
            % calcule des indices de texture de la r�gion d'int�r�t
            % (entropie, coefficient de variation, indices calcul�s � partir
            % de la matrice de cooccurrence)
            
            % computes the texture indexes of the region of interest
            % (entropy, coefficient of variation, indexed calculted for the
            % co-occurence matrix)
            
            %% calcule l'entropie globale de la r�gion d'int�r�t (sur la
            % matrice de l'image directement, et pas sur une matrice de cooccurrence)
            
            % computes the global entropy on the region of interest
            % (directly on the image matrix, and not on a co-occurence
            % matrix)
            soi.modele.region_interet.calculer_entropie;
            
            %% calcule le coefficient de variation (�cart-type/moyenne) des
            % valeurs d'intensit�s de la r�gion d'int�r�t
            
            % computes the coefficient of variation (standard
            % deviation/mean) of the intensity values of the region of
            % interest)
            soi.modele.region_interet.calculer_coefficient_variation;
            
            %% calcule l'�nergie, le contraste, la corr�lation et l'homog�n�it�
            % de la matrice de cooccurrence des niveaux de gris de la
            % r�gion d'int�r�t
            
            % computes the energy, the contrast, the correlation and the
            % homogeneity of the gray level co-occurence matrix of the
            % region of interest
            soi.modele.region_interet.calculer_statistiques_matrice_cooccurrence(decalage_ligne_matrice_cooccurrence,...
                decalage_colonne_matrice_cooccurrence);
        end
        
        function definir_graphique(soi,axe_abscisses_choisi,axe_moyenne_choisi)
            % enregistre dans les param�tres du mod�le les propri�t�s du
            % graphique
            
            % saves the graph properties in the model parameters
            
            % on instancie le graphique
            
            % instantiates the graph
            soi.modele.creer_graphique(axe_abscisses_choisi,axe_moyenne_choisi);
            
            % on enregistre dans les param�tres du mod�le les propri�t�s du
            % graphique
            
            % saves the graph properties in the model parameters
            soi.modele.graphique.definir;
        end
        
        function detecter_pics(soi,taille_fenetre_lissage,nombre_de_pics)
            % d�tecte le nombre_de_pics souhait�s sur la courbe du
            % graphique liss� avec une taille de fen�tre taille_fenetre_lissage
            % (si taille_fenetre_lissage == 1 alors pas de lissage)
            
            % detects the desired number of peaks on the graph curve
            % smoothed with a window size of taille_fenetre_lissage (if
            % taille_fen�tre_lissage == 1 then there is no smoothing)
            
            % On recalcule le graphique pour �viter que les d�tection de
            % pics pr�c�dentes se superposent
            % Note : cette m�thode n'est pas propre et je devrais plut�t
            % avoir cr�� une fonction de remise � z�ro des param�tres
            % propres � la d�tection de pics (probl�me r�current dans mon
            % programme qui se retrouve pour d'autres objets)
            % mais je ne pense pas avoir le temps de le corriger
            
            % Re-computes the graph to avoid the superposition of the
            % previous detection peaks
            % Note : this method is not very tidy, I should rather have
            % created a reset function of the parameters proper to the peak
            % detection (recurring problem in my program which is also
            % encountered for other objects) but I did not have enough time
            % to fix it
            soi.modele.graphique.definir;
            
            % On instancie l'objet pics qui fait partie des propri�t�s du
            % graphique
            
            % instantiates the peaks object, which belongs to the graph
            % properties
            soi.modele.graphique.creer_pics;
            
            % Pour l'affichage de la d�tection de pics on choisit l'axe
            % d'affichage du graphique 
            
            % Chooses the display axis of the graph for the display of the
            % peak detection
            soi.vue.choisir_axe_affichage_graphique;
            
            % On enl�ve l'affichage des pics ou combinaison de pics 
            % pr�c�demment d�tect�s (on ne devrait n�anmoins pas faire comme �a,
            % et enlever les valeurs dans les param�tres du mod�le et pas dans la vue)
            
            % Removes the display of the peaks or of the combination of
            % peaks previously detected (we should however not proceed that
            % way, and remove the values in the parameters of the model and
            % not in the view)
            soi.vue.mise_a_un_liste_de_pics;
            soi.vue.mise_a_un_liste_de_combinaisons_de_deux_pics;
            
            % On d�tecte les pics
            
            % Detection of the peaks
            soi.modele.graphique.pics.detecter(taille_fenetre_lissage,nombre_de_pics);
        end
        
        function mettre_a_jour_largeur_a_mi_hauteur_pic_choisi(soi,pic_choisi)
            % Quand on change de pic choisi dans la liste d�roulante, on
            % change la valeur de la largeur � mi hauteur du pic choisi
            
            % When the user changes the peak chosen in the scroll-down
            % list, it changes the value of the full-width half-maximum of
            % the chosen peak
            
            soi.modele.graphique.pics.mettre_a_jour_largeur_a_mi_hauteur_pic_choisi(pic_choisi);
        end
        
        function mettre_a_jour_distance_pic_a_pic_choisie(soi,numero_combinaison_de_deux_pics_choisie)
            % Quand on change de combinaisons de pics choisie 
            % dans la liste d�roulante, on
            % change la valeur de la distance pic � pic choisie
            
            % When the user changes the combination of peaks chosen in the
            % scroll-down list, it changes the value of the chosen
            % peak-to-peak distance
            
            soi.modele.graphique.pics.mettre_a_jour_distance_pic_a_pic_choisie(numero_combinaison_de_deux_pics_choisie);
        end
        
        function definir_et_sauvegarder_sous_echantillonnage(soi,facteur_temps_intensite_maximale,facteur_sous_echantillonnage)
            % On definit les param�tres du sous echantillonnage et on le
            % sauvegarde dans un fichier
            
            % Sets the sub-sampling parameters and saves them in a file
            
            % On instancie un sous_echantillonnage
            
            % Instantiates  sub-sampling (sous_echantillonnage)
            soi.modele.creer_sous_echantillonnage;
            
            % On d�finit les param�tres du sous-�chantillonnage (quels temps
            % sauvegarder)
            
            % Defines the sub-sampling parameters (which times have to be
            % saved)
            soi.modele.sous_echantillonnage.definir(facteur_temps_intensite_maximale,facteur_sous_echantillonnage);
            
            % On sauvegarde les donn�es sous-echantillonn�es
            
            % Saves sub-sampled data
            soi.modele.sous_echantillonnage.sauvegarder;
        end
        
        function previsualiser_sous_echantillonnage(soi,facteur_temps_intensite_maximale,facteur_sous_echantillonnage)
            % On calcule les param�tres du sous-echantillonnage sans pour
            % autant sauvegarder le fichier sous-echantillonn� : cela
            % permet  � l'utilisateur de rapidement voir comment le
            % sous-echantillonnage a �t� effectu�
            
            % Computes the sub-sampling parameters whithout saving the
            % sub-sampled file : this enables the user to see quickly how
            % the sub-sampling has been made
            
            % On instancie le sous-echantillonnage
            
            % Instantiates the sub-sampling
            soi.modele.creer_sous_echantillonnage;
            
            % On d�finit les param�tre du sous-echantillonnage
            
            % Defines the sub-sampling parameters
            soi.modele.sous_echantillonnage.definir(facteur_temps_intensite_maximale,facteur_sous_echantillonnage);
        end
        
        function exporter_graphique(soi)
            % On enregistre le graphique dans un format image � l'endroit
            % s�lectionn� par l'utilisateur
            
            % Saves the graph in an image file format in the folder
            % selected by the user
            
            soi.modele.graphique.exporter;
        end
        
        function exporter_image(soi)
            % On enregistre l'image ultrasonore affich�e 
            % dans un format image � l'endroit s�lectionn� par l'utilisateur
            
            % Saves the ultrasound image that is displayed in a image file
            % format in a folder selected by the user
            
            soi.modele.exporter_image;
        end
        
        function exporter_interface(soi)
            % On enregistre toute l'interface du programme dans un format 
            % image dans fichier dont l'endroit est s�lectionn� par
            % l'utilisateur
            
            % Saves the whole interface of the program in a image file
            % format  in a folder selected by the user
            
            soi.modele.exporter_interface;
        end
        
        function afficher_aide(soi)
            % On affiche l'aide du programme
            
            % Displays the help features
            
            soi.vue.aide;
        end
        
    end
end

