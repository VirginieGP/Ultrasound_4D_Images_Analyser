function varargout = Bayes4D(varargin)
% BAYES4D M-file for Bayes4D.fig
%      BAYES4D, by itself, creates a new BAYES4D or raises the existing
%      singleton*.
%      H = BAYES4D returns the handle to a new BAYES4D or the handle to
%      the existing singleton*.
%
%      BAYES4D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BAYES4D.M with the given input arguments.
%
%      BAYES4D('Property','Value',...) creates a new BAYES4D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Bayes4D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Bayes4D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Bayes4D

% Last Modified by GUIDE v2.5 25-Jul-2016 16:03:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Bayes4D_OpeningFcn, ...
                   'gui_OutputFcn',  @Bayes4D_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);

if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Bayes4D is made visible.
function Bayes4D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Bayes4D (see VARARGIN)

%Ancien aplio
%DecodeDicomInfo('C:\Documents and Settings\Administrateur\Mes documents\Downloads\AplioXV\DICOM XV\DICOM XV\20160509\S0000004\US000001');
%DecodeDicomInfo('DICOM XV\20160509\S0000004\US000001');

%handles.donnees2 = GetRAWframes_B;
%Choose default command line output for Bayes4D
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Bayes4D wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Bayes4D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in selection_region_interet.
function selection_region_interet_Callback(hObject, eventdata, handles)
% hObject    handle to selection_region_interet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    cla(handles.graphique,'reset'); %Efface le graphique pr�c�dent

    if isfield(handles,'rectangle')
        delete(handles.rectangle); %Efface la r�gion d'int�r�t trac�e pr�c�dente
    end


    if isfield(handles,'ligne')
        delete(handles.ligne);
    elseif isfield(handles,'rectangle_dessine')
        delete(handles.rectangle_dessine);
    end
    
    cla(handles.image.Children);

    image = getimage(handles.image);

    %Conversion des indices de matrice (lignes/colonnes) en coordonn�es
    %cart�siennes par transposition de la matrice
    image = image';

    axes(handles.graphique);


    %On acc�de aux valeurs de coordonn�es par des accesseurs
    valeur_axe1Debut_graphique = get(handles.valeur_axe1Debut_graphique,'Value');
    valeur_axe2Debut_graphique = get(handles.valeur_axe2Debut_graphique,'Value');
    valeur_axe1Fin_graphique = get(handles.valeur_axe1Fin_graphique,'Value');
    valeur_axe2Fin_graphique = get(handles.valeur_axe2Fin_graphique,'Value');
    
    taille_image_axe1 = size(image,1);
    taille_image_axe2 = size(image,2);

    %On enregistre ces donn�es dans le champ 'UserData' des boites
    %correspondantes aux coordonn�es des axes
    set(handles.valeur_axe1Debut_graphique,'UserData',valeur_axe1Debut_graphique);
    set(handles.valeur_axe2Debut_graphique,'UserData',valeur_axe2Debut_graphique);
    set(handles.valeur_axe1Fin_graphique,'UserData',valeur_axe1Fin_graphique);
    set(handles.valeur_axe2Fin_graphique,'UserData',valeur_axe2Fin_graphique);





    %Les Y sont en abscisse et les X en ordonn�es parce que Matlab voie les Y
    %comme des noms de colonne de matrice
    %ce qui n'est pas l'intuition cart�sienne
    %donnees_ROI = image(int16(valeur_axe2Debut_graphique):int16(valeur_axe2Fin_graphique),int16(valeur_axe1Debut_graphique):int16(valeur_axe1Fin_graphique));
    donnees_ROI = image(int16(valeur_axe1Debut_graphique):int16(valeur_axe1Fin_graphique),int16(valeur_axe2Debut_graphique):int16(valeur_axe2Fin_graphique));


    axes(handles.image);

    valeurs_axe1_DebutFin_distinctes = valeur_axe1Debut_graphique~=valeur_axe1Fin_graphique;
    valeurs_axe2_DebutFin_distinctes = valeur_axe2Debut_graphique~=valeur_axe2Fin_graphique;

    if xor(valeurs_axe1_DebutFin_distinctes,valeurs_axe2_DebutFin_distinctes)
        handles.ligne = line([valeur_axe1Debut_graphique,valeur_axe1Fin_graphique],[valeur_axe2Debut_graphique,valeur_axe2Fin_graphique],'Color',[1 0 0]);
    elseif (valeurs_axe1_DebutFin_distinctes && valeurs_axe2_DebutFin_distinctes)
        largeur = valeur_axe1Fin_graphique-valeur_axe1Debut_graphique;
        hauteur = valeur_axe2Fin_graphique-valeur_axe2Debut_graphique;
        handles.rectangle_dessine = rectangle('Position',[valeur_axe1Debut_graphique valeur_axe2Debut_graphique largeur hauteur],'EdgeColor','r');
    end

    handles.donnees_ROI = donnees_ROI;
    handles.valeurs_axe1_DebutFin_distinctes = valeurs_axe1_DebutFin_distinctes;
    handles.valeurs_axe2_DebutFin_distinctes = valeurs_axe2_DebutFin_distinctes;

    guidata(hObject, handles);
catch erreurs
    if (strcmp(erreurs.identifier,'MATLAB:badsubscript'))
        warndlg('Merci d''entrer une r�gion d''int�r�t incluse dans l''image.');
        messsage_erreur = 'La r�gion d''int�r�t d�passe de l''image.';
        cause_erreur = MException('MATLAB:badsubscript',messsage_erreur);
        erreurs = addCause(erreurs,cause_erreur);
    end
    rethrow(erreurs);
end





% --- Executes during object creation, after setting all properties.
function graphique_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: place code in OpeningFcn to populate graphique



function valeur_axe1Debut_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_axe1Debut_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);
    

% Hints: get(hObject,'String') returns contents of valeur_axe1Debut_graphique as text
%        str2double(get(hObject,'String')) returns contents of valeur_axe1Debut_graphique as a double


% --- Executes during object creation, after setting all properties.
function valeur_axe1Debut_graphique_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_axe1Debut_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%set(hObject,'String','32');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valeur_axe2Debut_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_axe2Debut_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);


% Hints: get(hObject,'String') returns contents of valeur_axe2Debut_graphique as text
%        str2double(get(hObject,'String')) returns contents of valeur_axe2Debut_graphique as a double


% --- Executes during object creation, after setting all properties.
function valeur_axe2Debut_graphique_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_axe2Debut_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%set(hObject,'String','32');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ZDebut_Callback(hObject, eventdata, handles)
% hObject    handle to ZDebut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of ZDebut as text
%        str2double(get(hObject,'String')) returns contents of ZDebut as a double


% --- Executes during object creation, after setting all properties.
function ZDebut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZDebut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valeur_axe1Fin_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_axe1Fin_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of valeur_axe1Fin_graphique as text
%        str2double(get(hObject,'String')) returns contents of valeur_axe1Fin_graphique as a double


% --- Executes during object creation, after setting all properties.
function valeur_axe1Fin_graphique_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_axe1Fin_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%set(hObject,'String','72');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valeur_axe2Fin_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_axe2Fin_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of valeur_axe2Fin_graphique as text
%        str2double(get(hObject,'String')) returns contents of valeur_axe2Fin_graphique as a double


% --- Executes during object creation, after setting all properties.
function valeur_axe2Fin_graphique_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_axe2Fin_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%set(hObject,'String','72');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ZFin_Callback(hObject, eventdata, handles)
% hObject    handle to ZFin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of ZFin as text
%        str2double(get(hObject,'String')) returns contents of ZFin as a double


% --- Executes during object creation, after setting all properties.
function ZFin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZFin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate image


% --- Executes on button press in afficherImage.
function afficherImage_Callback(hObject, eventdata, handles)
%Affiche l'image dans handles.image 
%correspondant � la coordonn�e dans l'axe 3 et l'axe 4
%choisie dans les champs correspondants.
% hObject    handle to afficherImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%R�cup�re les coordonn�es de l'axe 3 et l'axe 4 choisis par l'utilisateur
%et les convertit en entier sign�s cod�s sur 16 bits
coordonnee_axe3 = int16(str2double(get(handles.valeur_axe3_image,'String')));
coordonnee_axe4 = int16(str2double(get(handles.valeur_axe4_image,'String')));

%On affiche l'image dans handles.image
axes(handles.image); %choix de l'endroit o� on affiche l'image
imshow4(handles.volumes,hObject,handles,coordonnee_axe3,coordonnee_axe4); %Appel de la fonction d'affichage d'image 4D

%On ajoute la possibilit� de faire un clic droit sur l'image pour afficher
%un menu contextuel qui permet de s�lectionner une r�gion d'int�r�t
uicontextmenu = get(handles.image,'UIContextMenu'); %le menu contextuel est cr�� sur l'axe gr�ce � GUIDE...
set(handles.image.Children,'UIContextMenu',uicontextmenu); %mais doit �tre r�cup�r� puis reparam�tr� pour fonctionner sur l'image qui s'affiche sur l'axe.

%Une fois l'image s�lectionn�e, on peut permettre � l'utilisateur de
%choisir une r�gion d'int�r�t, ce qu'on lui indique visuellement en passant
%du gris au blanc les �l�ments graphiques correspondants. On utilise pour
%cela des mutateurs d'objets enregistr�s dans handles.
set(handles.valeur_axe1Debut_graphique,'enable','on','BackgroundColor','white');
set(handles.valeur_axe2Debut_graphique,'enable','on','BackgroundColor','white');
set(handles.valeur_axe1Fin_graphique,'enable','on','BackgroundColor','white');
set(handles.valeur_axe2Fin_graphique,'enable','on','BackgroundColor','white');
%set(handles.coupeSelonX,'enable','on','BackgroundColor','white');
%set(handles.coupeSelonY,'enable','on','BackgroundColor','white');
%set(handles.sommeX,'enable','on','BackgroundColor','white');
%set(handles.sommeY,'enable','on','BackgroundColor','white');

%On sauvegarde les modifications que l'on a fait dans handles dans la
%figure handles.figure1
guidata(handles.figure1,handles);




function valeur_axe3_image_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_axe3_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of valeur_axe3_image as text
%        str2double(get(hObject,'String')) returns contents of valeur_axe3_image as a double
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function valeur_axe3_image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_axe3_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sommeX.
function sommeX_Callback(hObject, eventdata, handles)
% hObject    handle to sommeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.sommeX = get(hObject,'Value');
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of sommeX


% --- Executes on button press in sommeY.
function sommeY_Callback(hObject, eventdata, handles)
% hObject    handle to sommeY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.sommeY = get(hObject,'Value');
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of sommeY


% --- Executes on button press in heterogeneite.
function heterogeneite_Callback(hObject, eventdata, handles)
% hObject    handle to heterogeneite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%On acc�de aux choix de coupes par des accesseurs
%coupeSelonX = get(handles.coupeSelonX,'Value');
%coupeSelonY = get(handles.coupeSelonY,'Value');

somme_axe1_choisie = logical(get(handles.somme_axe1,'value'));
somme_axe2_choisie = logical(get(handles.somme_axe2,'value'));

if somme_axe1_choisie || somme_axe2_choisie
    set(handles.pas_de_somme,'value',1);
    afficherGraphique_Callback(hObject, eventdata, handles);
end

courbes = get(handles.graphique,'Children');
[nombre_de_courbes ~]=size(courbes);
somme_des_distances=0;
for i=1:nombre_de_courbes
    for j=i+1:nombre_de_courbes
        Y=abs(courbes(i).YData-courbes(j).YData);
        somme_des_distances=sum(Y)+somme_des_distances;
    end
end
somme_des_distances_normalises_nombre_de_courbes=somme_des_distances/(2^nombre_de_courbes);

set(handles.affichage_somme_des_distances,'String',num2str(somme_des_distances_normalises_nombre_de_courbes));

%Pour utilisation de l'entropie l'image doit avoir 256 niveaux
donnees_ROI_8bits=uint8(handles.donnees_ROI);
entropie_region_interet=entropy(donnees_ROI_8bits);
set(handles.affichage_entropie,'String',num2str(entropie_region_interet));
guidata(handles.figure1,handles);




% --- Executes during object creation, after setting all properties.
function khi2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to khi2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in coupeSelonX.
function coupeSelonX_Callback(hObject, eventdata, handles)
% hObject    handle to coupeSelonX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.coupeSelonX = get(hObject,'Value');
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of coupeSelonX


% --- Executes on button press in coupeSelonY.
function coupeSelonY_Callback(hObject, eventdata, handles)
% hObject    handle to coupeSelonY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.coupeSelonY = get(hObject,'Value');
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of coupeSelonY


% --- Executes on button press in detection_pics.
function detection_pics_Callback(hObject, eventdata, handles)
% hObject    handle to detection_pics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%On enl�ve l'�ventuel r�sultat d'une ex�cution pr�c�dente
[nombre_de_lignes_affichees_graphique ~] = size(handles.graphique.Children);
if nombre_de_lignes_affichees_graphique>1
    delete(handles.graphique.Children(1:4));
end

guidata(hObject, handles);

try
    taille_fenetre_lissage = str2double(get(handles.valeur_taille_fenetre_lissage,'String'));
    if mod(taille_fenetre_lissage,2) == 0
        erreurImpaire.message = 'Fen�tre de taille paire.';
        erreurImpaire.identifier = 'detection_pics_Callback:taille_fenetre_paire';
        error(erreurImpaire);
    end

    %On acc�de aux valeurs des coordonn�es
    valeur_axe1Debut_graphique = get(handles.valeur_axe1Debut_graphique,'UserData');
    valeur_axe2Debut_graphique = get(handles.valeur_axe2Debut_graphique,'UserData');
    valeur_axe1Fin_graphique = get(handles.valeur_axe1Fin_graphique,'UserData');
    valeur_axe2Fin_graphique = get(handles.valeur_axe2Fin_graphique,'UserData');

    %%Lissage de la courbe
    %On acc�de la taille de fen�tre de lissage choisie (si ==1 pas de lissage)

    taille_fenetre_lissage = str2double(get(handles.valeur_taille_fenetre_lissage,'String'));

    donnees_ROI = double(handles.donnees_ROI);

    if taille_fenetre_lissage~=1
        filtre_lissage = (1/taille_fenetre_lissage)*ones(1,taille_fenetre_lissage);
        coefficient_filtre = 1;
        donnees_ROI_lissees = filter(filtre_lissage,coefficient_filtre,donnees_ROI);
    else
        donnees_ROI_lissees = donnees_ROI;
    end

    axes(handles.graphique);
    hold on
    if handles.graphique_selon_axe1
        [y_maxs,x_maxs,lmhs,~] = findpeaks(donnees_ROI_lissees,double(valeur_axe1Debut_graphique):double(valeur_axe1Fin_graphique));
        findpeaks(donnees_ROI_lissees,double(valeur_axe1Debut_graphique):double(valeur_axe1Fin_graphique),'Annotate','extents');
        y_maxs=y_maxs';
    elseif handles.graphique_selon_axe2
        [y_maxs,x_maxs,lmhs,~] = findpeaks(donnees_ROI_lissees,double(valeur_axe2Debut_graphique):double(valeur_axe2Fin_graphique));
        findpeaks(donnees_ROI_lissees,double(valeur_axe2Debut_graphique):double(valeur_axe2Fin_graphique),'Annotate','extents');
    end
    legend(gca,'off');
    hold off


    %Passage de x_maxs en vecteur colonne pour affichage
    x_maxs=x_maxs';



    %Affichage de la liste de pics dans la premi�re liste d�roulante
    [nombre_de_pics ~] = size(y_maxs);
    crochet_ouvrant = repmat('[', nombre_de_pics , 1);
    virgule = repmat(', ',nombre_de_pics,1);
    crochet_fermant = repmat(']',nombre_de_pics,1);
    liste_de_pics = [crochet_ouvrant num2str(x_maxs) virgule ...
        num2str(y_maxs) crochet_fermant];
    set(handles.choix_du_pic,'String',liste_de_pics);
    pic_choisi = get(handles.choix_du_pic,'Value');
    set(handles.lmh_affichage,'String',lmhs(pic_choisi));
    handles.lmhs=lmhs;

    %Affichage des combinaisons de deux pics dans la deuxi�me liste d�roulante
    combinaisons_de_deux_pics = combnk(1:nombre_de_pics,2);
    set(handles.choix_de_deux_pics,'String',num2str(combinaisons_de_deux_pics));
    handles.combinaisons_de_deux_pics = combinaisons_de_deux_pics;
    numero_combinaison_de_deux_pics_choisie = get(handles.choix_de_deux_pics,'Value');
    combinaison_pics_choisis = combinaisons_de_deux_pics(numero_combinaison_de_deux_pics_choisie,:);
    x_plus_grand_des_deux_pics = x_maxs(combinaison_pics_choisis(2));
    x_plus_petit_des_deux_pics = x_maxs(combinaison_pics_choisis(1));
    set(handles.dpap_affichage,'String',num2str(x_plus_grand_des_deux_pics-x_plus_petit_des_deux_pics));

    handles.x_maxs=x_maxs;
    guidata(hObject, handles);
catch ME
    if (strcmp(ME.identifier,'detection_pics_Callback:taille_fenetre_paire'))
        warndlg('Merci d''entrer une taille de fen�tre de lissage impaire.');
        causeException = MException(erreurImpaire.identifier,erreurImpaire.message);
        ME = addCause(ME,causeException);
        throw(causeException);
    end
    rethrow(ME)
end
    



function lmh_affichage_Callback(hObject, eventdata, handles)
% hObject    handle to lmh_affichage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: get(hObject,'String') returns contents of lmh_affichage as text
%        str2double(get(hObject,'String')) returns contents of lmh_affichage as a double


% --- Executes during object creation, after setting all properties.
function lmh_affichage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lmh_affichage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function chemin_dossier_Callback(hObject, eventdata, handles)
% hObject    handle to chemin_dossier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chemin_dossier as text
%        str2double(get(hObject,'String')) returns contents of chemin_dossier as a double


% --- Executes during object creation, after setting all properties.
function chemin_dossier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chemin_dossier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chargement.
function chargement_Callback(hObject, eventdata, handles)
% hObject    handle to chargement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
chemin_dossier = uigetdir('C:\Users\m_jacqueline\Downloads\4D_Aplio500_Analyser\Raw','Dossier contenant les volumes en .bin');
set(handles.chemin_dossier,'String',chemin_dossier);

d = dir(chemin_dossier);
disp(d(3).name);
if ispc
    patient_info_id = fopen([chemin_dossier,'\',d(3).name]);
elseif ismac
    patient_info_id = fopen([chemin_dossier,'/',d(3).name]);
else
    disp('Tu utilises Linux, il va falloir des petites modifications dans ma fonction chargement pour que �a marche');
end
patient_info = textscan(patient_info_id,'%s',11);
patient_info = patient_info{1,1};
range = str2num(patient_info{5});
azimuth = str2num(patient_info{8});
elevation = str2num(patient_info{11});
assignin('base', 'patient_info', patient_info);
disp(patient_info);
nb_fichiers = size(d);
nb_fichiers = nb_fichiers(1);
%Les fichiers saufs patientInfo.txt
identifiants_fichiers = cell((nb_fichiers-3),1);
fichiers = cell((nb_fichiers-3),1);

%Pour �viter les fichiers . .. et PatientInfo.txt on commence au fichier
%num�ro 4
for ifichier = 1:nb_fichiers-3
    %disp(['1706 exports matlab Virginie\Donn�es export�es\1648550067\RawData_Vol', num2str(i), '.bin']);
    disp([chemin_dossier,d(ifichier+3).name]);
    %identifiants_fichiers{i}=fopen(['1706 exports matlab Virginie\Donn�es export�es\1648550067\RawData_Vol', num2str(i),'.bin']);
    if ispc
        identifiants_fichiers{ifichier}=fopen([chemin_dossier,'\',d(ifichier+3).name]);
    elseif ismac
        identifiants_fichiers{ifichier}=fopen([chemin_dossier,'/',d(ifichier+3).name]);
    end
    fichiers{ifichier}=fread(identifiants_fichiers{ifichier});
    fichiers{ifichier} =reshape(fichiers{ifichier},range,azimuth,elevation);
end
assignin('base', 'fichiers', fichiers);
volumes = cat(4,fichiers{:});
handles.volumes = volumes;


handles.nb_fichiers = nb_fichiers-3;

set(handles.valeur_axe3_image,'enable','on','BackgroundColor','white','String','1');
set(handles.valeur_axe4_image,'enable','on','BackgroundColor','white','String','1');
handles.vue_choisie = 0;

guidata(hObject, handles);
afficherImage_Callback(hObject, eventdata, handles);

% --- Executes on selection change in choix_du_pic.
function choix_du_pic_Callback(hObject, eventdata, handles)
% hObject    handle to choix_du_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pic_choisi = get(handles.choix_du_pic,'Value');
set(handles.lmh_affichage,'String',handles.lmhs(pic_choisi));
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns choix_du_pic contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choix_du_pic


% --- Executes during object creation, after setting all properties.
function choix_du_pic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choix_du_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in choix_de_deux_pics.
function choix_de_deux_pics_Callback(hObject, eventdata, handles)
% hObject    handle to choix_de_deux_pics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns choix_de_deux_pics contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choix_de_deux_pics

numero_combinaison_de_deux_pics_choisie = get(handles.choix_de_deux_pics,'Value');
combinaison_pics_choisis = handles.combinaisons_de_deux_pics(numero_combinaison_de_deux_pics_choisie,:);
x_plus_grand_des_deux_pics = handles.x_maxs(combinaison_pics_choisis(2));
x_plus_petit_des_deux_pics = handles.x_maxs(combinaison_pics_choisis(1));
set(handles.dpap_affichage,'String',num2str(x_plus_grand_des_deux_pics-x_plus_petit_des_deux_pics));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function choix_de_deux_pics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choix_de_deux_pics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dpap_affichage_Callback(hObject, eventdata, handles)
% hObject    handle to dpap_affichage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dpap_affichage as text
%        str2double(get(hObject,'String')) returns contents of dpap_affichage as a double


% --- Executes during object creation, after setting all properties.
function dpap_affichage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dpap_affichage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valeur_axe4_image_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_axe4_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valeur_axe4_image as text
%        str2double(get(hObject,'String')) returns contents of valeur_axe4_image as a double


% --- Executes during object creation, after setting all properties.
function valeur_axe4_image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_axe4_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Ligne_Callback(hObject, eventdata, handles)
% hObject    handle to Ligne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imline;


% --------------------------------------------------------------------
function Rectangle_Callback(hObject, eventdata, handles)
% hObject    handle to Rectangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


rectangle = imrect;

position_rectangle = getPosition(rectangle);
x_min=position_rectangle(1);
y_min=position_rectangle(2);
largeur=position_rectangle(3);
hauteur=position_rectangle(4);
x_max = x_min + largeur;
y_max = y_min + hauteur;

%On arrondit les valeurs des coordonn�es s�lectionn�es
x_min=int16(round(x_min));
y_min=int16(round(y_min));
x_max=int16(round(x_max));
y_max=int16(round(y_max));

set(handles.valeur_axe1Debut_graphique,'Value',x_min,'String',num2str(x_min));
set(handles.valeur_axe2Debut_graphique,'Value',y_min,'String',num2str(y_min));
set(handles.valeur_axe1Fin_graphique,'Value',x_max,'String',num2str(x_max));
set(handles.valeur_axe2Fin_graphique,'Value',y_max,'String',num2str(y_max));
handles.rectangle = rectangle;
guidata(hObject,handles);





% --------------------------------------------------------------------
function ContexteImage_Callback(hObject, eventdata, handles)
% hObject    handle to ContexteImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function VueSagitale_Callback(hObject, eventdata, handles)
% hObject    handle to VueSagitale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ChangementVue_Callback(hObject, eventdata, handles)
% hObject    handle to ChangementVue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ChoixDeLaVue_Callback(hObject, eventdata, handles)
% hObject    handle to ChoixDeLaVue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ChoixDuROI_Callback(hObject, eventdata, handles)
% hObject    handle to ChoixDuROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function VueTransversale_Callback(hObject, eventdata, handles)
% hObject    handle to VueTransversale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imline;


% --------------------------------------------------------------------
function SelectionVue_Callback(hObject, eventdata, handles)
% hObject    handle to SelectionVue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Aide_Callback(hObject, eventdata, handles)
% hObject    handle to Aide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox({'Le passage entre les types de coupes est permise par les touches du clavier suivantes :', ...
'0 : coupe frontale (Y en fonction de X) ;', ...
'1 : coupe transversale (Z en fonction de X) ;', ...
'2 : coupe sagittale (Z en fonction de Y);', ...
'3 : coupe de X en fonction du temps ;', ...
'4 : coupe de Y en fonction du temps ;', ...
'5 : coupe de Z en fonction du temps.', ...
'',...
'Pour une m�me coupe, on peut glisser entre les plans par les fl�ches multidirectionnelles du clavier :',...
'fl�ches gauche et droite pour glisser selon le premier axe mentionn� dans le titre de l''image ;',...
'fl�ches bas et haut pour glisser selon le deuxi�me axe mentionn� dans le titre de l''image.'})




function affichage_somme_des_distances_Callback(hObject, eventdata, handles)
% hObject    handle to affichage_somme_des_distances (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of affichage_somme_des_distances as text
%        str2double(get(hObject,'String')) returns contents of affichage_somme_des_distances as a double


% --- Executes during object creation, after setting all properties.
function affichage_somme_des_distances_CreateFcn(hObject, eventdata, handles)
% hObject    handle to affichage_somme_des_distances (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uitoggletool6_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = rotate3d(handles.image);



function affichage_entropie_Callback(hObject, eventdata, handles)
% hObject    handle to affichage_entropie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of affichage_entropie as text
%        str2double(get(hObject,'String')) returns contents of affichage_entropie as a double


% --- Executes during object creation, after setting all properties.
function affichage_entropie_CreateFcn(hObject, eventdata, handles)
% hObject    handle to affichage_entropie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valeur_taille_fenetre_lissage_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_taille_fenetre_lissage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valeur_taille_fenetre_lissage as text
%        str2double(get(hObject,'String')) returns contents of valeur_taille_fenetre_lissage as a double



% --- Executes during object creation, after setting all properties.
function valeur_taille_fenetre_lissage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_taille_fenetre_lissage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in graphique_selon_axe1.
function graphique_selon_axe1_Callback(hObject, eventdata, handles)
% hObject    handle to graphique_selon_axe1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
somme_axe1_choisie = logical(get(handles.somme_axe1,'value'));
if somme_axe1_choisie
    set(handles.somme_axe1,'value',0);
    set(handles.somme_axe2,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of graphique_selon_axe1


% --- Executes on button press in graphique_selon_axe2.
function graphique_selon_axe2_Callback(hObject, eventdata, handles)
% hObject    handle to graphique_selon_axe2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
somme_axe2_choisie = logical(get(handles.somme_axe2,'value'));
if somme_axe2_choisie
    set(handles.somme_axe2,'value',0);
    set(handles.somme_axe1,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of graphique_selon_axe2


% --- Executes on button press in somme_axe1.
function somme_axe1_Callback(hObject, eventdata, handles)
% hObject    handle to somme_axe1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
graphique_selon_axe1_choisi = logical(get(handles.graphique_selon_axe1,'value'));
if graphique_selon_axe1_choisi
    set(handles.graphique_selon_axe1,'value',0);
    set(handles.graphique_selon_axe2,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of somme_axe1


% --- Executes on button press in somme_axe2.
function somme_axe2_Callback(hObject, eventdata, handles)
% hObject    handle to somme_axe2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
graphique_selon_axe2_choisi = logical(get(handles.graphique_selon_axe2,'value'));
if graphique_selon_axe2_choisi
    set(handles.graphique_selon_axe2,'value',0);
    set(handles.graphique_selon_axe1,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of somme_axe2


% --- Executes on button press in afficher_graphique.
function afficher_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to afficher_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



donnees_ROI=handles.donnees_ROI;

valeur_axe1Debut_graphique = get(handles.valeur_axe1Debut_graphique,'UserData');
valeur_axe2Debut_graphique = get(handles.valeur_axe2Debut_graphique,'UserData');
valeur_axe1Fin_graphique = get(handles.valeur_axe1Fin_graphique,'UserData');
valeur_axe2Fin_graphique = get(handles.valeur_axe2Fin_graphique,'UserData');

somme_axe1 = get(handles.somme_axe1,'Value');
somme_axe2 = get(handles.somme_axe2,'Value');

if somme_axe1
    donnees_ROI = sum(donnees_ROI,1);
elseif somme_axe2
    donnees_ROI = sum(donnees_ROI,2);
    %Pour avoir toujours des donn�es en ligne
    donnees_ROI = donnees_ROI';
end
%Enlever les dimensions inutiles laiss�es par la somme
donnees_ROI = squeeze(donnees_ROI);

graphique_selon_axe1 = get(handles.graphique_selon_axe1,'Value');
graphique_selon_axe2 = get(handles.graphique_selon_axe2,'Value');


axes(handles.graphique);
%Probl�me coordonn�es cart�siennes/matrice ici
if graphique_selon_axe1
    plot(int16(valeur_axe1Debut_graphique):int16(valeur_axe1Fin_graphique),donnees_ROI,'displayname','Courbe originale','HitTest', 'off');
elseif graphique_selon_axe2
    donnees_ROI = donnees_ROI';
    plot(int16(valeur_axe2Debut_graphique):int16(valeur_axe2Fin_graphique),donnees_ROI,'displayname','Courbe originale','HitTest', 'off');
end

ylabel('Intensit� (en niveaux)'); %L'axe des ordonn�es repr�sente toujours les niveaux

ligne = xor(handles.valeurs_axe1_DebutFin_distinctes,handles.valeurs_axe2_DebutFin_distinctes);
une_seule_courbe = ligne || somme_axe1 || somme_axe2;

if une_seule_courbe
    title('Courbe d''intensit�');
else
    title('Courbes d''intensit�');
end

%D�termination du nom de l'axe des abscisses du graphique
coupe_frontale = 0;
coupe_transverse = 1;
coupe_sagittale = 2;
coupe_X_temps = 3;
coupe_Y_temps = 4;
coupe_Z_temps = 5;

switch handles.vue_choisie
    case coupe_frontale
        if graphique_selon_axe1
            xlabel('X (en pixels)');
        elseif graphique_selon_axe2
            xlabel('Y (en pixels)');
        end
    case coupe_transverse
        if graphique_selon_axe1
            xlabel('X (en pixels)');
        elseif graphique_selon_axe2
            xlabel('Z (en pixels)');
        end
    case coupe_sagittale
        if graphique_selon_axe1
            xlabel('Y (en pixels)');
        elseif graphique_selon_axe2
            xlabel('Z (en pixels)');
        end
    case coupe_X_temps
        if graphique_selon_axe1
            xlabel('Temps (en num�ro de volume)');
        elseif graphique_selon_axe2
            xlabel('X (en pixels)');
        end
    case coupe_Y_temps
        if graphique_selon_axe1
            xlabel('Temps (en num�ro de volume)');
        elseif graphique_selon_axe2
            xlabel('Y (en pixels)');
        end
    case coupe_Z_temps
        if graphique_selon_axe1
            xlabel('Temps (en num�ro de volume)');
        elseif graphique_selon_axe2
            xlabel('X (en pixels)');
        end
end

set(handles.choix_du_pic,'enable','on','BackgroundColor','white');
set(handles.choix_de_deux_pics,'enable','on','BackgroundColor','white');
set(handles.lmh_affichage,'BackgroundColor','white');
set(handles.dpap_affichage,'BackgroundColor','white');
set(handles.valeur_taille_fenetre_lissage,'enable','on','BackgroundColor','white');
guidata(handles.figure1,handles);




% --------------------------------------------------------------------
function sauvegarde_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to sauvegarde_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[nom_du_fichier,chemin] = uiputfile({'*.png';'*.jpeg';'*.bmp';'*.tiff';'*.pdf';'*.eps'});
dossier_principal=pwd;
cd(chemin);
export_fig(handles.graphique, nom_du_fichier);
cd(dossier_principal)

% --------------------------------------------------------------------
function ContexteGraphique_Callback(hObject, eventdata, handles)
% hObject    handle to ContexteGraphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
