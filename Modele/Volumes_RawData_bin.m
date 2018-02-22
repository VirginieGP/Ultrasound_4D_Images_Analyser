classdef Volumes_RawData_bin < Volumes
    % Classe concr�te contenant les propri�t�s et m�thodes particuli�res �
    % une volumes import� d'un dossier contenant des fichiers au format
    % .bin format�s en RawData (chaque fichier repr�sentant un pas de temps)
    % et h�ritant des propri�t�s et m�thodes de la classe abstraite Volumes
    
    % Concrete class which contains the properties and the methods that are
    % specific to a volume loaded from a folder containing the .bin format
    % files formatted in RawData(each file representing a time-step) and inheriting the
    % properties and the methods of the abstract class Volumes
    
    properties
        dossier_chargement_par_defaut = 'C:\Users\m_jacqueline\Downloads\4D_Aplio500_Analyser\Raw'
    end
    
    methods (Access = ?Modele)  % Seul un mod�le (instance d'une classe parente) 
                                    % peut construire une instance de Volumes_RawData_bin
                                    
                                % Only a model (instance of a parent /
                                % higher-level class can build an instance
                                % of Volumes_RawData_bin   
        function soi = Volumes_RawData_bin(modele)
            % Constructeur d'une instance de Volumes_RawData_bin, il ne peut n'y en avoir
            % qu'une
            
            % Builder of an instance of Volumes_RawData_bin; there can
            % only be one of it
           soi.modele = modele;
        end
    end
    
    methods
        function charger(soi)
            % Chargement des volumes � partir d'un dossier de fichiers au
            % fichiers au format .bin format�s en RawData 
            % (chaque fichier repr�sentant un pas de temps)
            
            % Loads the volumes form a folder of .bin format files formatted in RawData (each
            % file represents a time-step)
            
            %% On r�cup�re le chemin du dossier � charger
            
            % Gets the pathway of the folder that has to be loaded
            chemin = uigetdir(soi.dossier_chargement_par_defaut,'Dossier contenant les volumes en .bin');
            
            
            soi.chemin_a_afficher=chemin;
            %% On le passe au mod�le pour affichage
            
            % The pathway is given to the model in order to display it
            soi.modele.chemin_donnees=soi.chemin_a_afficher;
            
            %% On pr�pare le terrain pour l'import
            % La fonction dir r�cup�re les donn�es du dossier s�lectionn�
            
            % Preparing for the loading / importantion. The function dir
            % gets the data of the selected folder
            d = dir(chemin);
            
            % On charge Patient_info.txt
            
            %Loads Patient_info.txt
            patient_info_id = fopen(fullfile(chemin,d(3).name));
            
            % On lit Patient_info.txt
            
            % Reads Patient_info.txt
            patient_info = textscan(patient_info_id,'%s',11);
            patient_info = patient_info{1,1};
            range = str2double(patient_info{5});
            azimuth = str2double(patient_info{8});
            elevation = str2double(patient_info{11});
            
            % On calcule le nombre de fichiers dans le dossier
            
            % Computes the number of files in the folder
            nb_fichiers = size(d);
            nb_fichiers = nb_fichiers(1);
            
            % Pr�allocations
            
            % Pre-allocates
            identifiants_fichiers = cell((nb_fichiers-3),1);
            fichiers = cell((nb_fichiers-3),1);

            barre_attente = waitbar(0,'Merci de patienter pendant le chargement des fichiers...');
            
            %% Import
            
            % Loading
            for ifichier = 1:nb_fichiers-3
                % On charge le fichier en cours de traitement
                % Note : pour �viter les fichiers . .. et PatientInfo.txt 
                % on commence au fichier num�ro 4 (cf. code ci-dessous "d(ifichier+3).name")
                
                % Loads the file which is currently under process
                % Note: in order to avoid the . .. files and
                % PatientInfo.txt files, we start with file number 4 (cf.
                % following code "d(ifichier+3).name")
                
                % Ouverture du fichier
                
                % Opens the file
                identifiants_fichiers{ifichier} = fopen(fullfile(chemin,d(ifichier+3).name));
                
                % Lecture
                
                % Reads the file
                fichiers{ifichier} = fread(identifiants_fichiers{ifichier});
                
                % Redimensionnement du fichier au format range x azimuth x
                % elevation conform�ment � la documentation de Toshiba pour
                % les fichiers RawData.
                % Les valeurs de range, azimuth et elevation ont �t� trouv�es
                % dans le fichier PatientInfo.txt
                
                % Resizes the file in a format range x azimuth x elevation,
                % in accordance with the Toshbia documentation for RawData
                % files.
                % The range, azimuth and elevation values have been found
                % in the PatientInfo.txt file.
                fichiers{ifichier} =reshape(fichiers{ifichier},range,azimuth,elevation);
                
                waitbar(ifichier/(nb_fichiers-3));
            end
            
            %% On concat�ne les diff�rents fichiers import�s selon le 4�me axe
            % qui est l'axe du temps. En effet les fichiers correspondent
            % chacun � un pas de temps particulier.
            
            % Concatenates the various files that have been loaded
            % following the 4th axis which is the time axis. Indeed, each
            % file corresponds to a specific time-step.
            donnees_4D = cat(4,fichiers{:});
            
            % On permute les donn�es qui ne sont pas enregistr�es au bon
            % format
            
            % Swaps the data that are not saves in the right format
            donnees_4D = permute(donnees_4D,[2,1,3,4]);
            
            %% On enregistre les donn�es dans les propri�t�s du volumes et du mod�le
            
            % Saves the data in the properties of the volumes and of the
            % model
            soi.donnees = donnees_4D;
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
            
            close(barre_attente);
        end
    end
    
end

