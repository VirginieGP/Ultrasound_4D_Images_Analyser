% --- Executes on button press in detection_pics.
function detecter_pics(hObject, eventdata, handles)
% hObject    handle to detection_pics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.graphique);
afficher_graphique(hObject, eventdata, handles);
handles=guidata(hObject);

guidata(hObject, handles);

graphique_selon_axe1_choisi = get(handles.graphique_selon_axe1,'value');
graphique_selon_axe2_choisi = get(handles.graphique_selon_axe2,'value');
graphique_selon_axe3_choisi = get(handles.graphique_selon_axe3,'value');
graphique_selon_axe4_choisi = get(handles.graphique_selon_axe4,'value');

valeur_nombre_de_pics = str2double(get(handles.valeur_nombre_de_pics,'String'));

try
    taille_fenetre_lissage = str2double(get(handles.valeur_taille_fenetre_lissage,'String'));
    if mod(taille_fenetre_lissage,2) == 0
        erreurImpaire.message = 'Fen�tre de taille paire.';
        erreurImpaire.identifier = 'detection_pics_Callback:taille_fenetre_paire';
        error(erreurImpaire);
    end
    
    if ~handles.une_seule_courbe
        erreurPlusieursCourbes.message = 'Plusieurs courbes affich�es.';
        erreurPlusieursCourbes.identifier = 'detection_pics_Callback:plusieurs_courbes_affichees';
        error(erreurPlusieursCourbes);
    end


    taille_fenetre_lissage = str2double(get(handles.valeur_taille_fenetre_lissage,'String'));
    
    courbe_ROI = double(handles.courbe_ROI);
    abscisse_courbe_ROI=double(handles.abscisse_courbe_ROI);
    
    if taille_fenetre_lissage~=1
        filtre_lissage = (1/taille_fenetre_lissage)*ones(1,taille_fenetre_lissage);
        coefficient_filtre = 1;
        courbe_ROI = filter(filtre_lissage,coefficient_filtre,courbe_ROI);
    end

    axes(handles.graphique);
    hold on
    if graphique_selon_axe1_choisi
        [y_maxs,x_maxs,lmhs,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',valeur_nombre_de_pics);
        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',valeur_nombre_de_pics);
        y_maxs=y_maxs';
    elseif graphique_selon_axe2_choisi
        [y_maxs,x_maxs,lmhs,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',valeur_nombre_de_pics);
        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',valeur_nombre_de_pics);
    elseif graphique_selon_axe3_choisi
        [y_maxs,x_maxs,lmhs,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',valeur_nombre_de_pics);
        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',valeur_nombre_de_pics);
    elseif graphique_selon_axe4_choisi
        [y_maxs,x_maxs,lmhs,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',valeur_nombre_de_pics);
        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',valeur_nombre_de_pics);
        y_maxs=y_maxs';
    end
    legend('off');
    hold off


    %Passage de x_maxs en vecteur colonne pour affichage
    x_maxs=x_maxs';
    
    handles.x_maxs=x_maxs;



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
    if valeur_nombre_de_pics>1
        set(handles.choix_de_deux_pics,'Visible','on');
        set(handles.texte_choix_de_deux_pics,'Visible','on');
        set(handles.dpap_affichage,'Visible','on');
        set(handles.texte_dpap,'Visible','on');
        set(handles.unite_dpap,'Visible','on');
        [~,nb_colonnes]=size(liste_de_pics);
        liste_de_pics_cellules=mat2cell(liste_de_pics,ones(1,nombre_de_pics),nb_colonnes);
        combinaisons_indices_de_deux_pics = combnk(1:nombre_de_pics,2);
        [nb_combinaisons,~] = size(combinaisons_indices_de_deux_pics);
        combinaisons_de_deux_pics=cell(nb_combinaisons,1);
        for ligne=1:nb_combinaisons
            combinaisons_de_deux_pics{ligne} = [liste_de_pics_cellules{combinaisons_indices_de_deux_pics(ligne,1),1} ...
                ' & ' liste_de_pics_cellules{combinaisons_indices_de_deux_pics(ligne,2),1}];
        end
        
        set(handles.choix_de_deux_pics,'String',combinaisons_de_deux_pics);
        handles.combinaisons_indices_de_deux_pics = combinaisons_indices_de_deux_pics;
        numero_combinaison_de_deux_pics_choisie = get(handles.choix_de_deux_pics,'Value');
        combinaison_pics_choisis = combinaisons_indices_de_deux_pics(numero_combinaison_de_deux_pics_choisie,:);
        x_plus_grand_des_deux_pics = x_maxs(combinaison_pics_choisis(2));
        x_plus_petit_des_deux_pics = x_maxs(combinaison_pics_choisis(1));
        set(handles.dpap_affichage,'String',num2str(abs(x_plus_grand_des_deux_pics-x_plus_petit_des_deux_pics)));
    else
        set(handles.choix_de_deux_pics,'Visible','off');
        set(handles.texte_choix_de_deux_pics,'Visible','off');
        set(handles.dpap_affichage,'Visible','off');
        set(handles.texte_dpap,'Visible','off');
        set(handles.unite_dpap,'Visible','off');
    end
    set(handles.facteur_temps_I_max,'Enable','on','BackgroundColor','white');
    set(handles.facteur_sous_echantillonnage,'Enable','on','BackgroundColor','white');
    
    handles.detection_pics_effectuee = true;
    guidata(hObject, handles);
catch erreurs
    if (strcmp(erreurs.identifier,'detection_pics_Callback:taille_fenetre_paire'))
        warndlg('Merci d''entrer une taille de fen�tre de lissage impaire.');
        causeException = MException(erreurImpaire.identifier,erreurImpaire.message);
        erreurs = addCause(erreurs,causeException);
        throw(causeException);
    elseif (strcmp(erreurs.identifier,'detection_pics_Callback:plusieurs_courbes_affichees'))
        warndlg('Merci de n''afficher qu''une seule courbe dans la partie ''affichage du graphique''.');
        causeException = MException(erreurPlusieursCourbes.identifier,erreurPlusieursCourbes.message);
        erreurs = addCause(erreurs,causeException);
        throw(causeException);
    end
    rethrow(erreurs);
end