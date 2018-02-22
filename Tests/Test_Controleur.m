classdef Test_Controleur < matlab.unittest.TestCase
    % Classe de tests unitaires des fonctions du contrôleur
    % Pour l'instant, une seule des méthodes du contrôleur est
    % partiellement testée
    
    
    % Class of unitary testing of the controler functions
    % For the moment, only one of the methods of the controller is
    % partially tested
    properties
        modele % on crée des fausses données dans le modèle ...
        
               % Creates fake data in the model...
        controleur % ... pour tester les fonctions du contrôleur
        
                   % ...in order to test the functions of the controller
    end
    
    properties (TestParameter)
        %% On liste toutes les valeurs que peuvent prendre les paramètres
        
        % Listes all the values that the parameters can take
        axe_abscisses_choisi = struct('un', 1,'deux', 2, 'trois', 3, 'quatre',4);
        axe_moyenne_choisi = struct('un','1','deux','2','un_et_deux','1 et 2','pas_de_moyenne','pas de moyenne');
    end
    
    methods (TestMethodTeardown)
        function tout_fermer(cas_de_test)
            %% A la fin de chaque test, on :
            % supprime le modèle
            
            % Deletes the model at the end of each test
            delete(cas_de_test.modele);
            % ferme l'interface
            
            % Closes the interface
            close(cas_de_test.controleur.vue.ihm);
            % ferme toutes les autres figures créées
            
            % Closes all the other figures that have been created
            close all;
            % supprime le contrôleur
            
            % Deletes the controller
            delete(cas_de_test.controleur);
        end
    end
    
    methods (Test)
        function test_definir_graphique(cas_de_test,axe_abscisses_choisi,axe_moyenne_choisi)
            %% On créée de fausses données dans le modèle
            
            % Creates fake data in the model
            
            % On instancie le modèle
            
            % Instantiates the model
            cas_de_test.modele = Modele;
            
            % On crée les objets nécessaires au test
            % on choisit de simuler une région d'intérêt polygonale car
            % c'est plus simple
            
            % Creates the objects that are necessary to perform the test
            % we choose to simulate with a polygonal ROI because it is
            % easier
            cas_de_test.modele.creer_region_interet_polygone;
            cas_de_test.modele.creer_volumes_fichier_mat;
            
            % on définit une fausse région d'intérêt
            
            % Defines a fake ROI
            tenseur_ordre3_temps1 = cat(3, [0 0; 0 0], [0 0; 0 0]);
            tenseur_ordre3_temps2 = cat(3, [0 0; 0 0], [0 0; 0 0]);
            
            % on la passe au modèle après concaténation des deux pas de
            % temps
            
            % This ROI is passed in the model after the concatenation of
            % the two time-steps
            cas_de_test.modele.region_interet.donnees_4D=cat(4,tenseur_ordre3_temps1...
                ,tenseur_ordre3_temps2);
            
            % on passe le reste des fausses données au modèle
            
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