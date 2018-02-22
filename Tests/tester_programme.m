function tester_programme
% Lancer cette fonction pour effectuer les tests du programmes que l'on a
% programm�

% Launch this function to perform the tests that have been programmed
%% On importe les tests de Test_Controleur.m

% Imports the tests of Test_Controleur.m
batterie_de_test = matlab.unittest.TestSuite.fromFile('Tests/Test_Controleur.m');

%% On importe une biblioth�que de Matlab qui permet de param�trer les tests

% Imports a Matlab library that enables to configure the tests
import matlab.unittest.selectors.HasParameter

%% Formule logique qui permet de ne tester que les valeurs de propri�t�s qui
% sont valides pour un choix de r�gion d'int�r�t polygonale

% Logical formula that enables to test only the properties values that are
% valid for a polygonal ROI
parametrage = HasParameter('Property','axe_moyenne_choisi', 'Name','un_et_deux') & ...
    (HasParameter('Property','axe_abscisses_choisi', 'Name','trois') | ...
    HasParameter('Name','quatre'));

%% On donne les param�tres � la batterie de test

% Gives the paramters to the battery of tests
batterie_de_test_parametree = batterie_de_test.selectIf(parametrage);

%% On lance les tests

% Launches the tests
batterie_de_test_parametree.run;
end

