classdef Volumes_fichier_mat < Volumes
    % Classe concr�te contenant les propri�t�s et m�thodes particuli�res �
    % une volumes import� d'un fichier au format .mat
    % et h�ritant des propri�t�s et m�thodes de la classe abstraite Volumes
    
    % Concrete class which contains the properties and the methods that are
    % specific to a volume loaded from a .mat format file and inheriting the
    % properties and the methods of the abstract class Volumes
    
    properties
    end
    
    methods (Access = ?Modele)  % Seul un mod�le (instance d'une classe parente) 
                                    % peut construire une instance de Volumes_fichier_mat
                                    
                                % Only a model (instance of a parent /
                                % higher-level class can build an instance
                                % of Volumes_fichier_mat
        function soi = Volumes_fichier_mat(modele)
            % Constructeur d'une instance de Volumes_fichier_mat, il ne peut n'y en avoir
            % qu'une
            
            % Builder of an instance of Volumes_fichier_mat; there can
            % only be one of it
           soi.modele = modele;
        end
    end
    
    methods
        
        function charger(soi)
            % Chargement des volumes � partir d'un fichier au format .mat
            
            % Loads the volumes form a .mat format file
            
            % On r�cup�re le fichier � charger
            
            % Gets the pathway of the file that has to be loaded
            [nom_du_fichier, chemin_du_dossier] = uigetfile({'*.mat'},'Choix des volumes 4D en format .mat');
            
            %% On enregistre le chemin dans les propri�t�s du volumes et du mod�le
            
            % Saves the pathway in the properties of the volumes and of the
            % model
            soi.chemin_a_afficher=[chemin_du_dossier, nom_du_fichier];
            soi.modele.chemin_donnees=soi.chemin_a_afficher;
            
            %% On charge le fichier qui est une structure
            
            % Loads the file, which is a structure
            cellules_donnees_4D = struct2cell(load([chemin_du_dossier, nom_du_fichier], '-mat'));
            
            %% On enregistre les donn�es dans les propri�t�s du volumes et du mod�le
            
            % Saves the data in the properties of the volumes and of the
            % model
            soi.donnees = cellules_donnees_4D{1}; 
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
        end
    end
    
end

