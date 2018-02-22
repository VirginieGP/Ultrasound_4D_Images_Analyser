classdef Test_Controleur < matlab.unittest.TestCase
    % Classe de tests unitaires des fonctions du contr�leur
    % Pour l'instant, une seule des m�thodes du contr�leur est
    % partiellement test�e
    
    
    % Class of unitary testing of the controler functions
    % For the moment, only one of the methods of the controller is
    % partially tested
    properties
        modele % on cr�e des fausses donn�es dans le mod�le ...
        
               % Creates fake data in the model...
        controleur % ... pour tester les fonctions du contr�leur
        
                   % ...in order to test the functions of the controller
    end
    
    properties (TestParameter)
        %% On liste toutes les valeurs que peuvent prendre les param�tres
        
        % Listes all the values that the parameters can take
        axe_abscisses_choisi = struct('un', 1,'deux', 2, 'trois', 3, 'quatre',4);
        axe_moyenne_choisi = struct('un','1','deux','2','un_et_deux','1 et 2','pas_de_moyenne','pas de moyenne');
    end
    
    methods (TestMethodTeardown)
        function tout_fermer(cas_de_test)
            %% A la fin de chaque test, on :
            % supprime le mod�le
            
            % Deletes the model at the end of each test
            delete(cas_de_test.modele);
            % ferme l'interface
            
            % Closes the interface
            close(cas_de_test.controleur.vue.ihm);
            % ferme toutes les autres figures cr��es
            
            % Closes all the other figures that have been created
            close all;
            % supprime le contr�leur
            
            % Deletes the controller
            delete(cas_de_test.controleur);
        end
    end
    
    methods (Test)
        function test_definir_graphique(cas_de_test,axe_abscisses_choisi,axe_moyenne_choisi)
            %% On cr��e de fausses donn�es dans le mod�le
            
            % Creates fake data in the model
            
            % On instancie le mod�le
            
            % Instantiates the model
            cas_de_test.modele = Modele;
            
            % On cr�e les objets n�cessaires au test
            % on choisit de simuler une r�gion d'int�r�t polygonale car
            % c'est plus simple
            
            % Creates the objects that are necessary to perform the test
            % we choose to simulate with a polygonal ROI because it is
            % easier
            cas_de_test.modele.creer_region_interet_polygone;
            cas_de_test.modele.creer_volumes_fichier_mat;
            
            % on d�finit une fausse r�gion d'int�r�t
            
            % Defines a fake ROI
            tenseur_ordre3_temps1 = cat(3, [0 0; 0 0], [0 0; 0 0]);
            tenseur_ordre3_temps2 = cat(3, [0 0; 0 0], [0 0; 0 0]);
            
            % on la passe au mod�le apr�s concat�nation des deux pas de
            % temps
            
            % This ROI is passed in the model after the concatenation of
            % the two time-steps
            cas_de_test.modele.region_interet.donnees_4D=cat(4,tenseur_ordre3_temps1...
                ,tenseur_ordre3_temps2);
            
            % on passe le reste des fausses donn�es au mod�le
            
            % The rest of the fake data are passed to the model
            cas_de_test.modele.region_interet.donnees_2D=tenseur_ordre3_temps1;
            cas_de_test.modele.volumes.taille_axes_enregistree = [2,2,2,2];
            cas_de_test.modele.volumes.coordonnee_axe3_selectionnee = 1;
            cas_de_test.modele.volumes.coordonnee_axe4_selectionnee = 1;
            
            cas_de_test.controleur = Controleur(cas_de_test.modele);
            
            %% Test
            cas_de_test.controleur.definir_graphique(axe_abscisses_choisi,axe_moyenne_choisi);
            
            ordonnees_graphique_attendues = [0;0];
            
            cas_de_test.verifyEqual(cas_de_test.modele.ordonnees_graphique,...
                ordonnees_graphique_attendues);
            
        end
    end
    
end