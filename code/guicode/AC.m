function varargout = AC(varargin)
%
% AC MATLAB code for AC.fig
%
%      This is the main function of the whole software Acycle.
%
%      Acycle is a a time-series analysis software for paleoclimate projects
%      By Mingsong Li, Penn State, (c) 2017-2018
%
%      Websites: mingsongli.com/acycle
%                 github.com/mingsongli/acycle
%
%%
%      AC, by itself, creates a new AC or raises the existing
%      singleton*.
%
%      H = AC returns the handle to a new AC or the handle to
%      the existing singleton*.
%
%      AC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AC.M with the given input arguments.
%
%      AC('Property','Value',...) creates a new AC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AC

% Last Modified by GUIDE v2.5 29-Dec-2018 12:37:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AC_OpeningFcn, ...
                   'gui_OutputFcn',  @AC_OutputFcn, ...
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


% --- Executes just before AC is made visible.
function AC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AC (see VARARGIN)

set(gcf,'Name','ACYCLE v0.2.6')
set(gcf,'DockControls', 'off')
set(gcf,'Color', 'white')
set(0,'Units','normalized') % set units as normalized
set(gcf,'units','norm') % set location
set(gcf,'position',[0.5,0.1,0.45,0.8]) % set position
set(handles.popupmenu1,'position', [0.75,0.945,0.24,0.04])
set(handles.axes_up,'position',    [0.02,0.945,0.06,0.05])
set(handles.axes_folder,'position',[0.106,0.945,0.065,0.05])
set(handles.axes_openfolder,'position',[0.02,0.902,0.045,0.038])
set(handles.axes_plot,'position',  [0.2,0.945,0.06,0.05])
set(handles.axes_populate,'position',[0.28,0.945,0.06,0.05])
set(handles.axes_refresh,'position',[0.36,0.945,0.06,0.05])
set(handles.axes_robot,'position',  [0.44,0.945,0.06,0.05])
set(handles.edit_acfigmain_dir,'position',       [0.07,0.9,0.91,0.04])
set(handles.listbox_acmain,'position',    [0.02,0.008,0.96,0.884])
if ismac
    handles.slash_v = '/';
    %set(handles.listbox_acmain,'FontSize',0.019)
elseif ispc
    handles.slash_v = '\';
    %set(handles.listbox_acmain,'FontSize',0.019)
end

handles.acfigmain = gcf;  %handles of the ac main window
%if isdeployed
    copyright;
%end
figure(handles.acfigmain)
%guidata(hObject, handles);
h=get(gcf,'Children');  % get all content
h1=findobj(h,'FontUnits','norm');  % find all font units as points
set(h1,'FontUnits','points','FontSize',12);  % set as norm
h2=findobj(h,'FontUnits','points');  % find all font units as points
set(h2,'FontUnits','points','FontSize',11.5);  % set as norm
% set icons
axes(handles.axes_up);
menu_up = imread('menu_up.png');
im = image(menu_up);
set(im, 'ButtonDownFcn',@axes_up_ButtonDownFcn)
set(handles.axes_up,'visible', 'off');

axes(handles.axes_folder);
menu_folder = imread('menu_folder.png');
im_folder = image(menu_folder);
set(im_folder, 'ButtonDownFcn',@axes_folder_ButtonDownFcn)
set(handles.axes_folder,'visible', 'off');

axes(handles.axes_openfolder);
menu_openfolder = imread('menu_open.png');
im_openfolder = image(menu_openfolder);
set(im_openfolder, 'ButtonDownFcn',@axes_openfolder_ButtonDownFcn)
set(handles.axes_openfolder,'visible', 'off');

axes(handles.axes_refresh);
menu_refresh = imread('menu_refresh.png');
im_refresh = image(menu_refresh);
set(im_refresh, 'ButtonDownFcn',@axes_refresh_ButtonDownFcn)
set(handles.axes_refresh,'visible', 'off');

axes(handles.axes_plot);
menu_plot = imread('menu_plot.png');
im_plot = image(menu_plot);
set(im_plot, 'ButtonDownFcn',@axes_plot_ButtonDownFcn)
set(handles.axes_plot,'visible', 'off');

axes(handles.axes_populate);
menu_populate = imread('menu_expand.png');
im_populate = image(menu_populate);
set(im_populate, 'ButtonDownFcn',@axes_populate_ButtonDownFcn)
set(handles.axes_populate,'visible', 'off');

axes(handles.axes_robot);
menu_refresh = imread('menu_robot.png');
im_refresh = image(menu_refresh);
set(im_refresh, 'ButtonDownFcn',@axes_robot_ButtonDownFcn)
set(handles.axes_robot,'visible', 'off');

% Choose default command line output for AC
handles.output = hObject;
path_root = pwd;
set(handles.edit_acfigmain_dir,'String',path_root);
handles.foldname = 'foldname'; % default file name

handles.path_temp = [path_root,handles.slash_v,'temp'];
handles.working_folder = [handles.path_temp,handles.slash_v,handles.foldname];
% if ad_pwd.txt exist; then go to this folder
if exist('ac_pwd.txt', 'file') == 2
    fileID = fopen('ac_pwd.txt','r');
    formatSpec = '%s';
    ac_pwd = fscanf(fileID,formatSpec);
    if isdir(ac_pwd)
        cd(ac_pwd)
    end
    fclose(fileID);
else
    ac_pwd_str = which('refreshcolor.m');
    [ac_pwd_dir,~,~] = fileparts(ac_pwd_str);
    fileID = fopen(fullfile(ac_pwd_dir,'ac_pwd.txt'),'w');
    fprintf(fileID,'%s',pwd);
    fclose(fileID);
end
%
refreshcolor;
cd(path_root) %back to root path

handles.doubleclick = 0;
handles.unit = 'unit'; % default file name
handles.unit_type = 0;
handles.t1 = 55;
handles.f1 = 0.0;
handles.f2 = 0.06;
handles.sr1 = 1;
handles.sr2 = 30;
handles.srstep = .1;
handles.nsim = 2000;
handles.red = 2;
handles.adjust = 0;
handles.slices = 1;
handles.index_selected = 1;
handles.pad = 50000;
handles.prewhiten_linear = 'notlinear';
handles.prewhiten_lowess = 'notlowess';
handles.prewhiten_rlowess = 'notrlowess';
handles.prewhiten_loess = 'notloess';
handles.prewhiten_rloess = 'notloess';
handles.prewhiten_polynomial2 = 'not2nd';
handles.prewhiten_polynomialmore = 'notmore';
handles.MTMtabtchi = 'notabtchi';
handles.nw = 2;
handles.copycut = 'copy';
handles.nplot = 0;
handles.filetype = {'.txt','.csv',''};
handles.acfig = gcf;
handles.math_sort = 1;
handles.math_unique = 1;
handles.math_deleteempty = 1;
handles.math_derivative = 1;
assignin('base','unit',handles.unit)
assignin('base','unit_type',handles.unit_type)
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = AC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function axes_up_CreateFcn(hObject, eventdata, handles)

% --- Executes on selection change in listbox_acmain.
function listbox_acmain_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_acmain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_acmain contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_acmain

persistent chk
if isempty(chk)
      chk = 1;
      pause(0.35); %Add a delay to distinguish single click from a double click
      if chk == 1
          chk = [];
          handles.doubleclick = 0;
      end
else
      chk = [];
      handles.doubleclick = 1;
end

        
if handles.doubleclick
    index_selected = get(hObject,'Value');
    file_list = get(hObject,'String');
    filename = file_list{index_selected};
%debug
%    disp(filename)
    try
        % try to open the folder, if selected item is a folder.
        CDac_pwd; % cd working dir
        filename1 = strrep2(filename, '<HTML><FONT color="blue">', '</FONT></HTML>');
        filename = fullfile(ac_pwd,filename1);
        cd(filename)
        refreshcolor;
        cd(pre_dirML);
        disp(['>>  Change directory to < ', filename1, ' >'])
    catch
        [~,dat_name,ext] = fileparts(filename);
        filetype = handles.filetype;
        if isdeployed
            %filetype = {'.txt',''};
            if strcmp(ext,'.fig')
                try uiopen(filename,1);
                catch
                end
            % Deployed gui will die if one want to double click to open a csv file. 
            elseif strcmp(ext,'.csv')
                fileID = fopen('ac_pwd.txt','r');
                formatSpec = '%s';
                ac_pwd = fscanf(fileID,formatSpec);   % AC window folder dir
                fclose(fileID);
                if ispc
                    winopen(ac_pwd);
                elseif ismac
                    system(['open ',ac_pwd]);
                end
            else
                try open(filename)
                catch
                    if ispc
                        try winopen(filename)
                        catch
                            try uiopen(filename,1)
                            catch
                                fileID = fopen('ac_pwd.txt','r');
                                formatSpec = '%s';
                                ac_pwd = fscanf(fileID,formatSpec);   % AC window folder dir
                                fclose(fileID);
                                winopen(ac_pwd);
                            end
                        end
                    elseif ismac
                        try system(['open ',filename]);
                        catch
                            fileID = fopen('ac_pwd.txt','r');
                            formatSpec = '%s';
                            ac_pwd = fscanf(fileID,formatSpec);   % AC window folder dir
                            fclose(fileID);
                            system(['open ',ac_pwd]);
                        end
                    end
                end
            end
        else
            %if sum(strcmp(ext,handles.filetype)) > 0
            if strcmp(ext,'.fig')
                try
                    %openfig(filename);
                    uiopen(filename,1);
                    set(gcf,'Name',[dat_name,ext])
                catch
                end
               
            elseif sum(strcmp(ext,{'.jpg','.jpeg','.JPG','.JPEG','.png','.PNG','.tif','.TIF'})) > 0
                try 
                    im_name = imread(filename);
                    figure;
                    imshow(im_name)
                    set(gcf,'Name',[dat_name,ext])
                catch
                end
            elseif strcmp(ext,{'.pdf','.ai','.ps'})
                try
                    %open(filename);
                    uiopen(filename,1);
                    %set(gcf,'Name',[dat_name,ext])
                catch
                end
            elseif strcmp(ext,{'.doc','.docx','.ppt','.pptx','.xls','.xlsx'})
                try
                    %open(filename);
                    uiopen(filename,1);
                    %set(gcf,'Name',[dat_name,ext])
                catch
                end
            elseif sum(strcmp(ext,filetype)) > 0
                try
                    %open(filename);
                    uiopen(filename,1);
                    set(gcf,'Name',[dat_name,ext])
                catch
                end
            else
                try uiopen(filename,1);
                    set(gcf,'Name',[dat_name,ext])
                catch
                    fileID = fopen('ac_pwd.txt','r');
                    formatSpec = '%s';
                    ac_pwd = fscanf(fileID,formatSpec);   % AC window folder dir
                    fclose(fileID);
                    if ispc
                        winopen(ac_pwd);
                    elseif ismac
                        system(['open ',ac_pwd]);
                    else
                        
                    end
                end
            end
        end
    end
else
    handles.index_selected  = get(hObject,'Value');
end
guidata(hObject,handles)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over listbox_acmain.
function listbox_acmain_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to listbox_acmain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function listbox_acmain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_acmain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_acfigmain_dir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_acfigmain_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_acfigmain_dir as text
%        str2double(get(hObject,'String')) returns contents of edit_acfigmain_dir as a double
address = get(hObject,'String');
CDac_pwd;
if isdir(address);
    cd(address)
else
    errordlg('Error: address not exist')
end
d = dir; %get files
set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
refreshcolor;
cd(pre_dirML);
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit_acfigmain_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_acfigmain_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function menu_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function menu_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function menu_edit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function menu_plotall_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function menu_plotall_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function menu_plot_Callback(hObject, eventdata, handles)
% hObject    handle to menu_plotall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = handles.index_selected;  % read selection in listbox 1
nplot = length(plot_selected);   % length
% check
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        if isdir(plot_filter_s)
            return
        else
            [~,dat_name,ext] = fileparts(plot_filter_s);
            check = 0;
            if sum(strcmp(ext,handles.filetype)) > 0
                check = 1; % selection can be executed 
            elseif strcmp(ext,'.fig')
                plot_filter_s = char(contents(plot_selected(1)));
                openfig(plot_filter_s);
            elseif strcmp(ext,{'.pdf','.ai','.ps'})
                plot_filter_s = char(contents(plot_selected(1)));
                open(plot_filter_s);
            elseif sum(strcmp(ext,{'.jpg','.jpeg','.JPG','.JPEG','.png','.PNG','.tif','.TIF'})) > 0
                try 
                    im_name = imread(plot_filter_s);
                    figure;
                    imshow(im_name)
                    set(gcf,'Name',[dat_name,ext])
                catch
                end
            end
        end
    else
        return
    end
end
plotsucess = 0;
if check == 1;
    figf = figure;
    hold on;
    for i = 1:nplot
        plot_no = plot_selected(i);
        plot_filter_s1 = char(contents(plot_no));
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s1);
        %disp(plot_filter_s)
    try
        data_filterout = load(plot_filter_s);
    catch       
        fid = fopen(plot_filter_s);
        try data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', Inf);
            fclose(fid);
            if iscell(data_ft)
                try
                    data_filterout = cell2mat(data_ft);
                catch
                    fid = fopen(plot_filter_s,'at');
                    fprintf(fid,'%d\n',[]);
                    fclose(fid);
                    fid = fopen(plot_filter_s);
                    data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', Inf);
                    fclose(fid);
                    try
                        data_filterout = cell2mat(data_ft);
                    catch
                        warndlg(['Check data: ',dat_name],'Data Error!')
                    end
                end
            end
        catch
            warndlg({'Cannot find the data.'; 'Folder Name may NOT include any space'})
        end
        
    end     

        data_filterout = data_filterout(~any(isnan(data_filterout),2),:);
        
        try plot(data_filterout(:,1),data_filterout(:,2:end),'LineWidth',1)
            plotsucess = 1;
            % save current data for R 
            assignin('base','currentdata',data_filterout);
            %datar =[];
            datar = num2str(data_filterout(1,2));
            for ii=2:length(data_filterout(:,1));
                r1 =data_filterout(ii,2); 
                datar = [datar,',',num2str(r1)];
            end
            assignin('base','currentdataR',datar);
            %
        catch
            errordlg([plot_filter_s1,' : data error. Check data'],'Data Error')
            if plotsucess > 0
            else
                close(figf)
                continue
                %break
            end   
        end
    end
    set(gca,'XMinorTick','on','YMinorTick','on')
    if handles.unit_type == 0;
        xlabel(['Unit (',handles.unit,')'])
    elseif handles.unit_type == 1;
        xlabel(['Depth (',handles.unit,')'])
    else
        xlabel(['Time (',handles.unit,')'])
    end
    title(plot_filter_s1)
    hold off
    set(gcf,'color','w');
end
guidata(hObject,handles)


% --------------------------------------------------------------------
function menu_SwapPlot_Callback(hObject, eventdata, handles)
% hObject    handle to menu_SwapPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = handles.index_selected;  % read selection in listbox 1
nplot = length(plot_selected);   % length
% check
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s1 = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s1, '<HTML><FONT color="blue">', '</FONT></HTML>');
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        if isdir(plot_filter_s)
            return
        else
            [~,~,ext] = fileparts(plot_filter_s);
            check = 0;
            if sum(strcmp(ext,handles.filetype)) > 0
                check = 1; % selection can be executed 
            elseif strcmp(ext,'.fig')
                plot_filter_s = char(contents(plot_selected(1)));
                openfig(plot_filter_s);
            elseif strcmp(ext,{'.pdf','.ai','.ps'})
                plot_filter_s = char(contents(plot_selected(1)));
                open(plot_filter_s);
            end
        end
    else
        return
    end
end

if check == 1;
    figure;
    hold on;
    for i = 1:nplot
        plot_no = plot_selected(i);
        plot_filter_s = char(contents(plot_no));
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
          %  data_filterout = load(plot_filter_s);
    try
        fid = fopen(plot_filter_s);
        data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
        fclose(fid);
        if iscell(data_ft)
            try
                data_filterout = cell2mat(data_ft);
            catch
                fid = fopen(plot_filter_s,'at');
                fprintf(fid,'%d\n',[]);
                fclose(fid)
                fid = fopen(plot_filter_s);
                data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', Inf);
                fclose(fid);
                data_filterout = cell2mat(data_ft);
            end
        end
    catch
        data_filterout = load(plot_filter_s);
    end
            
            data_filterout = data_filterout(~any(isnan(data_filterout),2),:);
            plot(data_filterout(:,2),data_filterout(:,1),'LineWidth',1);
    end
    if handles.unit_type == 0;
        ylabel(['Unit (',handles.unit,')'])
    elseif handles.unit_type == 1;
        ylabel(['Depth (',handles.unit,')'])
    else
        ylabel(['Time (',handles.unit,')'])
    end
    title(plot_filter_s1)
    set(gca,'XMinorTick','on','YMinorTick','on')
    hold off
end
set(gcf,'color','w');
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function menu_basic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function menu_basic_Callback(hObject, eventdata, handles)
% hObject    handle to menu_basic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function menu_math_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function menu_math_Callback(hObject, eventdata, handles)
% hObject    handle to menu_math (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function menu_help_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CDac_pwd;
cd ..;
address = pwd;
set(handles.edit_acfigmain_dir,'String',address);
refreshcolor;
cd(pre_dirML);
guidata(hObject,handles)

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_content = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = handles.index_selected;  % read selection in listbox 1; minus 2 for listbox
nplot = length(plot_selected);   % length
if plot_selected > 2
    if nplot > 1
        open_data = 'Tips: Select ONE folder';
        h = helpdlg(open_data,'Tips: Close');
        uiwait(h);
    else
        plot_filter_selection = char(list_content(plot_selected));
        if ~exist(plot_filter_selection,'dir')==1
            h = helpdlg('This is NOT a folder','Tips: Close');
            uiwait(h);
        else
            cd(plot_filter_selection)
            address = pwd;
            set(handles.edit_acfigmain_dir,'String',address);
        end
        refreshcolor;
    end
end
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch str{val};
case 'unit' % User selects unit.
   handles.unit = 'unit';
   handles.unit_type = 0;
case 'm' % User selects m.
   handles.unit = 'm';
   handles.unit_type = 1;
case 'dm' % User selects dm.
   handles.unit = 'dm';
   handles.unit_type = 1;
case 'cm' % User selects cm.
    handles.unit = 'cm';
    handles.unit_type = 1;
case 'mm' % User selects mm.
   handles.unit = 'mm';
   handles.unit_type = 1;
case 'ft' % User selects ft.
   handles.unit = 'ft';
   handles.unit_type = 1;
case 'km' % User selects km.
   handles.unit = 'km';
   handles.unit_type = 1;
case 'yr' % User selects year.
   handles.unit = 'yr';
   handles.unit_type = 2;
case 'kyr' % User selects kilo-year.
   handles.unit = 'kyr';
   handles.unit_type = 2;
case 'myr' % User selects million years.
   handles.unit = 'myr';
   handles.unit_type = 2;
end
assignin('base','unit',handles.unit)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_read_Callback(hObject, eventdata, handles)
% hObject    handle to menu_read (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
filename = 'UpdateLog.txt';
url = 'https://github.com/mingsongli/acycle/blob/master/doc/UpdateLog.txt';
if isdeployed
    web(url,'-browser')
else
    try uiopen(filename,1);
    catch
        if ispc
            try open(filename)
            catch
                try winopen(filename)
                catch
                    try web(url,'-browser')
                    catch
                    end
                end
            end
        elseif ismac
                try system(['open ',filename]);
                catch
                    try web(url,'-browser')
                    catch
                    end
                end
        else
            web(url,'-browser')
        end
    end
end

% --------------------------------------------------------------------
function menu_manuals_Callback(hObject, eventdata, handles)
% hObject    handle to menu_manuals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = 'AC_Users_Guide.pdf';
url = 'https://github.com/mingsongli/acycle/blob/master/doc/AC_Users_Guide.pdf';

try uiopen(filename,1);
catch
    try open(filename)
    catch
        if ispc
            try winopen(filename)
            catch
                try web(url,'-browser')
                catch
                end
            end
        elseif ismac
            try system(['open ',filename]);
            catch
                try web(url,'-browser')
                catch
                end
            end
        end
    end
end


% --------------------------------------------------------------------
function menu_findupdates_Callback(hObject, eventdata, handles)
% hObject    handle to menu_findupdates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
url = 'https://mingsongli.com/acycle';
web(url,'-browser')
url = 'https://github.com/mingsongli/acycle';
web(url,'-browser')

% --------------------------------------------------------------------
function menu_contact_Callback(hObject, eventdata, handles)
% hObject    handle to menu_contact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
copyright

% --------------------------------------------------------------------
function menu_selectinterval_Callback(hObject, eventdata, handles)
% hObject    handle to menu_selectinterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
%if and ((min(plot_selected) > 2), (nplot == 1))
if min(plot_selected) > 2
    for i = 1:nplot
        data_name = char(contents(plot_selected(i)));
        data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0
            GETac_pwd; data_name = fullfile(ac_pwd,data_name);
            data = load(data_name);
            time = data(:,1);
            value = data(:,2);
            npts = length(time);

            prompt = {'Enter the START of interval:','Enter the END of interval:','Apply to ALL? (1 = yes)'};
            dlg_title = 'Input Select interval';
            num_lines = 1;
            defaultans = {num2str(time(1)),num2str(time(npts)),'0'};
            options.Resize='on';
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
            if ~isempty(answer)
                xmin_cut = str2double(answer{1});
                xmax_cut = str2double(answer{2});
                ApplyAll = str2double(answer{3});
                
                if ApplyAll == 1
                    for ii = 1:nplot
                        data_name = char(contents(plot_selected(ii)));
                        data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
                        if isdir(data_name) == 1
                        else
                            [~,dat_name,ext] = fileparts(data_name);
                            disp(['>>  Processing ',data_name])
                            if sum(strcmp(ext,handles.filetype)) > 0
                                GETac_pwd; data_name = fullfile(ac_pwd,data_name);
                                data = load(data_name);
                                time = data(:,1);
                                if or (max(time) < xmin_cut, min(time) > xmax_cut)
                                    errordlg(['No overlap between selected interval and ',dat_name],'Error')
                                    disp('      Error, no overlap')
                                    continue
                                end
                                if and (min(time) > xmin_cut, max(time) < xmax_cut)
                                    disp('      Selected interval too large, skipped')
                                    continue
                                end
                                [current_data] = select_interval(data,xmin_cut,xmax_cut); 
                                name1 = [dat_name,'-',num2str(xmin_cut),'-',num2str(xmax_cut),ext];  % New name
                                CDac_pwd; % cd ac_pwd dir
                                dlmwrite(name1, current_data, 'delimiter', ',', 'precision', 9);
                            end
                        end
                    end
                    d = dir; %get files
                    set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                    refreshcolor;
                    cd(pre_dirML); % return to matlab view folder
                    return
                else
                    
                    if or (max(time) < xmin_cut, min(time) > xmax_cut)
                        errordlg(['No overlap between selected interval and ',dat_name],'Error')
                        disp('      Error, no overlap')
                        return
                    end
                    if and (min(time) > xmin_cut, max(time) < xmax_cut)
                        disp('Selected interval too large, skipped')
                        return
                    end
                    [current_data] = select_interval(data,xmin_cut,xmax_cut); 
                    name1 = [dat_name,'-',num2str(xmin_cut),'-',num2str(xmax_cut),ext];  % New name
                    %csvwrite(name1,current_data)

                    CDac_pwd; % cd ac_pwd dir
                    dlmwrite(name1, current_data, 'delimiter', ',', 'precision', 9);
                    d = dir; %get files
                    set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                    refreshcolor;
                    cd(pre_dirML); % return to matlab view folder
                end
            end
        end
        end
    end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_oversampling_Callback(hObject, eventdata, handles)
% hObject    handle to menu_interp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
        if isdir(data_name) == 1
        else
        [~,~,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0
            GETac_pwd; data_name = fullfile(ac_pwd,data_name);
            data = load(data_name);
            time = data(:,1);
            %dt = median(diff(time));
            dtmin = min(diff(time));
            dtmax = max(diff(time));
            dlg_title = 'Interpolation';
            prompt = {'Tested sampling rate 1:','Tested sampling rate 2:',...
                'Number of tested sampling rates','Number of simulation'};
            num_lines = 1;
            defaultans = {num2str(0.5*dtmin),num2str(5*dtmax),'100','1000'};
            options.Resize='on';
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
            
            if ~isempty(answer)
                sr1 = str2double(answer{1});
                sr2 = str2double(answer{2});
                raten = str2double(answer{3});
                nsim = str2double(answer{4});
                [sr_sh_5] = OversamplingTest(data,sr1,sr2,raten,nsim);
            end
        end
        end
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menu_interp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function menu_interp_Callback(hObject, eventdata, handles)
% hObject    handle to menu_interp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
disp(['Select ',num2str(nplot),' data'])
    
for nploti = 1:nplot
    if plot_selected > 2
    data_name_all = (contents(plot_selected));
    data_name = char(data_name_all{nploti});
%if and ((min(plot_selected) > 2), (nplot == 1))
    %data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
        [~,dat_name,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0

        try
            fid = fopen(data_name);
            data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
            fclose(fid);
            if iscell(data_ft)
                try
                    data = cell2mat(data_ft);
                catch
                    fid = fopen(data_name,'at');
                    fprintf(fid,'%d\n',[]);
                    fclose(fid)
                    fid = fopen(data_name);
                    data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', Inf);
                    fclose(fid);
                    data = cell2mat(data_ft);
                end
            end
        catch
            data = load(data_name);
        end 
            time = data(:,1);
            srmean = mean(diff(time));
            dlg_title = 'Interpolation';
            prompt = {'New sample rate:'};
            num_lines = 1;
            defaultans = {num2str(srmean)};
            options.Resize='on';
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
            
            if ~isempty(answer)
                interpolate_rate = str2double(answer{1});
                data_interp = interpolate(data,interpolate_rate);
                name1 = [dat_name,'-rsp',num2str(interpolate_rate),ext];  % New name
                % cd ac_pwd dir
                CDac_pwd
                dlmwrite(name1, data_interp, 'delimiter', ',', 'precision', 9); 
                % csvwrite(name1,data_interp)
                d = dir; %get files
                set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                refreshcolor;
                cd(pre_dirML); % return to matlab view folder
            end
        end
        end
    end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_norm_Callback(hObject, eventdata, handles)
% hObject    handle to menu_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
        [~,dat_name,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0
            data = load(data_name);
            time = data(:,1);
            value = (data(:,2)-mean(data(:,2)))/std(data(:,2));
            data1 = [time,value];
            name1 = [dat_name,'-stand',ext];
            %csvwrite(name1,data1)
            % cd ac_pwd dir
            CDac_pwd
            dlmwrite(name1, data1, 'delimiter', ',', 'precision', 9); 
            d = dir; %get files
            set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
            refreshcolor;
            cd(pre_dirML); % return to matlab view folder
        end
        end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_clip_Callback(hObject, eventdata, handles)
% hObject    handle to menu_clip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
disp(['Select ',num2str(nplot),' data'])
%if and ((min(plot_selected) > 2), (nplot == 1))
for nploti = 1:nplot
    if plot_selected > 2
        data_name_all = (contents(plot_selected));
        data_name = char(data_name_all{nploti});
        data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
        disp(['>>  Processing clipping:', data_name]);
        GETac_pwd; 
        data_name = fullfile(ac_pwd,data_name);
    
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
            if sum(strcmp(ext,handles.filetype)) > 0
                try
                    fid = fopen(data_name);
                    data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
                    fclose(fid);
                    if iscell(data_ft)
                        try
                            data = cell2mat(data_ft);
                        catch
                            fid = fopen(data_name,'at');
                            fprintf(fid,'%d\n',[]);
                            fclose(fid);
                            fid = fopen(data_name);
                            data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', Inf);
                            fclose(fid);
                            data = cell2mat(data_ft);
                        end
                    end
                catch
                    data = load(data_name);
                end

                prompt = {'Threshold value'; 'Keep high/low? (1=high; 0=low)'};
                dlg_title = 'Clipping:';
                num_lines = 1;
                defaultans = {num2str(nanmean(data(:,2))), '1'};
                options.Resize='on';
                answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
                    if ~isempty(answer)

                        clip_value = str2double(answer{1});
                        clip_high  = str2double(answer{2});

                        time = data(:,1);
                        y = data(:,2);
                        n = length(time);
                        if clip_high == 1
                            for i = 1:n
                                if y(i) > clip_value
                                    y(i) = y(i) - clip_value;
                                else
                                    y(i) = 0;
                                end
                            end
                            name1 = [dat_name,'-clip',num2str(clip_value),'+',ext];
                        else
                            for i = 1:n
                                if y(i) > clip_value
                                    y(i) = 0;
                                else
                                    y(i) = y(i) - clip_value;
                                end
                            end
                            name1 = [dat_name,'-clip<',num2str(clip_value),'-',ext];
                        end

                            data1 = [time,y];
                            CDac_pwd
                            dlmwrite(name1, data1, 'delimiter', ',', 'precision', 9);
                            d = dir; %get files
                            set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                            refreshcolor;
                            cd(pre_dirML); % return to matlab view folder
                    else
                        errordlg('Error, input must be a positive integer')
                    end
                end
        end
    end
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_log10_Callback(hObject, eventdata, handles)
% hObject    handle to menu_log10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
        [~,dat_name,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0
            data = load(data_name);
            time = data(:,1);
            value = log10(data(:,2));
            data1 = [time,value];
            name1 = [dat_name,'-log10',ext];
            %csvwrite(name1,data1)
            % cd ac_pwd dir
            CDac_pwd
            dlmwrite(name1, data1, 'delimiter', ',', 'precision', 9); 
            d = dir; %get files
            set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
            refreshcolor;
            cd(pre_dirML); % return to matlab view folder
        end
        end
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to menu_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0

        try
            fid = fopen(data_name);
            data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
            fclose(fid);
            if iscell(data_ft)
                data = cell2mat(data_ft);
            end
        catch
            data = load(data_name);
        end 

            time = data(:,1);
            value = data(:,2);
            npts = length(time);
            dlg_title = 'Smooth';
            prompt = {'Number of points (3, 5, 7, ...):'};
            num_lines = 1;
            defaultans = {'3'};
            options.Resize='on';
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
            if ~isempty(answer)
                smooth_v = str2double(answer{1});
                data(:,2) = movemean(data(:,2),smooth_v,'omitnan');
                name1 = [dat_name,'-',num2str(smooth_v),'ptsm',ext];  % New name
                %csvwrite(name1,data)
                % cd ac_pwd dir
                CDac_pwd
                dlmwrite(name1, data, 'delimiter', ',', 'precision', 9); 
                d = dir; %get files
                set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                refreshcolor;
                cd(pre_dirML); % return to matlab view folder
            end
        end
        end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_bootstrap_Callback(hObject, eventdata, handles)
% hObject    handle to menu_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0

        try
            fid = fopen(data_name);
            data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
            fclose(fid);
            if iscell(data_ft)
                data = cell2mat(data_ft);
            end
        catch
            data = load(data_name);
        end 

            time = data(:,1);
            value = data(:,2);
            span_d = (time(end)-time(1))*.3;
            dlg_title = 'Bootstrap';
            prompt = {'Window (unit)','Method: "loess/lowess/rloess/rlowess"',...
                'Number of bootstrap'};
            num_lines = 1;
            defaultans = {num2str(span_d),'loess','1000'};
            options.Resize='on';
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
            if ~isempty(answer)
                span_v = str2double(answer{1});
                method = (answer{2});
                bootn = str2double(answer{3});
                %q = char(39);
                %method = strcat(q,method1,q)
                if bootn*length(time) >= 100000
                    warndlg('Large number of bootstrap simulations. Please Wait ...','Bootstrap');
                end
                
                span = span_v/(time(end)-time(1));
                [meanboot,bootstd,bootprt] = smoothciML(time,value,method,span,bootn);
                
                data(:,2) = meanboot;
                data(:,3) = bootstd;
                data(:,4) = 2*bootstd;
                data1 = [time,bootprt];
                name = [dat_name,'-',num2str(span_v),'-',method,'-',num2str(bootn),'-bootstp-meanstd',ext];  % New name
                name1 = [dat_name,'-',num2str(span_v),'-',method,'-',num2str(bootn),'-bootstp-percentile',ext];
                
                disp(['>>  Save [time, mean, std, 2std] as :',name])
                disp(['>>  Save [time, percentiles] as :',name1])
                disp('>>        Percentiles are ')
                disp('>>        [0.5,2.275,15.865,50,84.135,97.725,99.5]')
                CDac_pwd
                dlmwrite(name, data, 'delimiter', ',', 'precision', 9); 
                dlmwrite(name1, data1, 'delimiter', ',', 'precision', 9); 
                d = dir; %get files
                set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                refreshcolor;
                cd(pre_dirML); % return to matlab view folder
            end
        end
        end
end
guidata(hObject, handles);

% % --------------------------------------------------------------------
% function menu_gp_Callback(hObject, eventdata, handles)
% % hObject    handle to menu_smooth (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
% plot_selected = get(handles.listbox_acmain,'Value');
% nplot = length(plot_selected);   % length
% if and ((min(plot_selected) > 2), (nplot == 1))
%     data_name = char(contents(plot_selected));
%     data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
%     GETac_pwd; data_name = fullfile(ac_pwd,data_name);
%         if isdir(data_name) == 1
%         else
%             [~,dat_name,ext] = fileparts(data_name);
%         if sum(strcmp(ext,handles.filetype)) > 0
% 
%         try
%             fid = fopen(data_name);
%             data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
%             fclose(fid);
%             if iscell(data_ft)
%                 data = cell2mat(data_ft);
%             end
%         catch
%             data = load(data_name);
%         end 
%         
%             x = data(:,1);
%             y = data(:,2);
%                 
%             dlg_title = 'Gaussian Process';
%             prompt = {'X_1','X_n','Sampling rate (default = median)'};
%             num_lines = 1;
%             defaultans = {num2str(min(x)),num2str(max(x)),num2str(median(diff(x)))};
%             options.Resize='on';
%             answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
%             if ~isempty(answer)
%                 x_1 = str2double(answer{1});
%                 x_2 = str2double(answer{2});
%                 sr = str2double(answer{3});
%                 x_n = (x_2-x_1)/sr; 
%                 % gaussian process
%                 
%                 z = linspace(x_1,x_2,round(x_n))';
%                 %
%                 meanfunc = {@meanSum, {@meanLinear, @meanConst}}; 
%                 covfunc = @covSEiso;
%                 likfunc = @likGauss;
%                 % hyp
%                 hyp.cov = [0; 0]; 
%                 hyp.mean = [0; 0]; 
%                 hyp.lik = log(0.1);
%                 disp('>>  Minimize hyperparameters ...')
%                 hyp = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, x, y);
%                 % gp
%                 [m s2] = gp(hyp, @infGaussLik, meanfunc, covfunc, likfunc, x, y, z);
%                 
%                 data1 = [z,m,sqrt(s2)];
%                 name1 = [dat_name,'-gp-meanstd',ext];  % New name
%                 % plot
%                 figure;
%                 f = [m+2*sqrt(s2); flip(m-2*sqrt(s2),1)];
%                 f1 = [m+sqrt(s2); flip(m-sqrt(s2),1)];
%                 fill([z; flip(z,1)], f, [7 7 7]/8,'LineStyle','none')
%                 hold on;
%                 fill([z; flip(z,1)], f1, [6 6 6]/8,'LineStyle','none')
%                 plot(z, m,'k'); plot(x, y, 'b+');
%                 xlabel(handles.unit);ylabel('Value');title([dat_name,'-gp-mean+-std'])
%                 
%                 disp(['>>  Save [mean, std] as :',name1])
%                 CDac_pwd
%                 dlmwrite(name1, data1, 'delimiter', ',', 'precision', 9); 
%                 d = dir; %get files
%                 set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
%                 refreshcolor;
%                 cd(pre_dirML); % return to matlab view folder
%             end
%         end
%         end
% end
% guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_1stdiff_Callback(hObject, eventdata, handles)
% hObject    handle to menu_1stdiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
            if sum(strcmp(ext,handles.filetype)) > 0
                data = load(data_name);
                time = data(:,1);
                value = data(:,2);
                npts = length(time);
                time1 = time(1:npts-1,1);
                value1 = diff(value);
                data1 = [time1,value1];

                name1 = [dat_name,'-1stdiff',ext];
                CDac_pwd
                dlmwrite(name1, data1, 'delimiter', ',', 'precision', 9); 
                d = dir; %get files
                set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                refreshcolor;
                cd(pre_dirML); % return to matlab view folder
        end
        end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_derivative_Callback(hObject, eventdata, handles)
% hObject    handle to menu_derivative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
disp(['Select ',num2str(nplot),' data'])
%if and ((min(plot_selected) > 2), (nplot == 1))
for nploti = 1:nplot
if plot_selected > 2
    data_name_all = (contents(plot_selected));
    data_name = char(data_name_all{nploti});
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    disp(['>>  Processing derivative:', data_name]);
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0
            try
                fid = fopen(data_name);
                data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
                fclose(fid);
                if iscell(data_ft)
                    try
                        data = cell2mat(data_ft);
                    catch
                        fid = fopen(data_name,'at');
                        fprintf(fid,'%d\n',[]);
                        fclose(fid);
                        fid = fopen(data_name);
                        data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', Inf);
                        fclose(fid);
                        data = cell2mat(data_ft);
                    end
                end
            catch
                data = load(data_name);
            end

            prompt = {'Derivative (1=1st, 2=2nd ...)'};
            dlg_title = 'Approximate Derivatives:';
            num_lines = 1;
            defaultans = {num2str(handles.math_derivative)};
            options.Resize='on';
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
            if ~isempty(answer)
                derivative_n = str2double(answer{1});
                % check
                int_gt_0 = @(n) (rem(n,1) == 0) & (n > 0);
                math_derivative = int_gt_0(derivative_n);
                
                if math_derivative == 1
                    data = data(~any(isnan(data),2),:); % remove NaN values
                    data = sortrows(data);
                    time  = data(:,1);
                    value = data(:,2);
                    for i=1:derivative_n
                        value= diff(value)./diff(time);
                        time = time(1:length(time)-1,1);
                    end
                    data1 = [time,value];
                    % remember settings
                    handles.math_derivative = derivative_n;
                    name1 = [dat_name,'-',num2str(derivative_n),'derv',ext];
                    % cd ac_pwd dir
                    CDac_pwd
                    dlmwrite(name1, data1, 'delimiter', ',', 'precision', 9);
                    d = dir; %get files
                    set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                    refreshcolor;
                    cd(pre_dirML); % return to matlab view folder
                else
                    errordlg('Error, input must be a positive integer')
                end
            end
        end
        end
end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function menu_period_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function menu_period_Callback(hObject, eventdata, handles)
% hObject    handle to menu_period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,~,ext] = fileparts(data_name);
            if sum(strcmp(ext,handles.filetype)) > 0
                current_data = load(data_name);
                handles.current_data = current_data;
                handles.data_name = data_name;
                guidata(hObject, handles);
                evofftGUI(handles);
            end
        end
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menu_power_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function menu_power_Callback(hObject, eventdata, handles)
% hObject    handle to menu_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,~,ext] = fileparts(data_name);
            if sum(strcmp(ext,handles.filetype)) > 0
                current_data = load(data_name);
                handles.current_data = current_data;
                handles.data_name = data_name;
                guidata(hObject, handles);
                spectrum(handles);
            end
        end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_wavelet_Callback(hObject, eventdata, handles)
% hObject    handle to menu_clip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
disp(['Select ',num2str(nplot),' data'])
%if and ((min(plot_selected) > 2), (nplot == 1))
for nploti = 1:nplot
    if plot_selected > 2
        data_name_all = (contents(plot_selected));
        data_name = char(data_name_all{nploti});
        data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
        disp(['>>  Processing clipping:', data_name]);
        GETac_pwd; 
        data_name = fullfile(ac_pwd,data_name);
    
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
            if sum(strcmp(ext,handles.filetype)) > 0
                try
                    fid = fopen(data_name);
                    data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
                    fclose(fid);
                    if iscell(data_ft)
                        try
                            data = cell2mat(data_ft);
                        catch
                            fid = fopen(data_name,'at');
                            fprintf(fid,'%d\n',[]);
                            fclose(fid);
                            fid = fopen(data_name);
                            data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', Inf);
                            fclose(fid);
                            data = cell2mat(data_ft);
                        end
                    end
                catch
                    data = load(data_name);
                end
                
                time = data(:,1);
                timelen = time(end)-time(1);
                sst = data(:,2);
                dt = mean(diff(time));
                prompt = {['Period range from (',handles.unit,')']; ['Period range to (',handles.unit,')'];...
                    'Pad (1=yes,0=no)'; 'Discrete scale spacing (default)'};
                dlg_title = '1D Wavelet transform';
                num_lines = 1;
                defaultans = {num2str(2*dt),num2str(timelen), '1', '0.1'};
                options.Resize='on';
                answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
                    if ~isempty(answer)

                        pt1 = str2double(answer{1});
                        pt2 = str2double(answer{2});
                        pad  = str2double(answer{3});
                        dss  = str2double(answer{4});
                        figwave = figure;
                        [~,~,~]= waveletML(sst,time,pad,dss,pt1,pt2);
                        name1 = [dat_name,'-wavelet.fig'];
                        disp(['>>  Save as: ',name1])
                        CDac_pwd
                        try savefig(figwave,name1)
                        catch
                            disp('>>  Eh ... Wavelet figure unsaved ...')
                        end
                        d = dir; %get files
                        set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                        refreshcolor;
                        cd(pre_dirML); % return to matlab view folder
                    else
                        
                    end
                end
        end
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function menu_filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function menu_filter_Callback(hObject, eventdata, handles)
% hObject    handle to menu_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
            if sum(strcmp(ext,handles.filetype)) > 0
                current_data = load(data_name);
                handles.current_data = current_data;
                handles.data_name = data_name;
                handles.dat_name = dat_name;
                guidata(hObject, handles);
                ft(handles);
            end
        end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_AM_Callback(hObject, eventdata, handles)
% hObject    handle to menu_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length

if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    dat_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,dat_name);
        if isdir(data_name) == 1
            disp('>>  Error: select the data file not a folder')
        else
            [~,~,ext] = fileparts(data_name);
            if sum(strcmp(ext,handles.filetype)) > 0
                data = load(data_name);
                
                t=data(:,1);
                dt=t(2)-t(1);
                nyquist = 1/(2*dt);
                fl = 0;
                fh = nyquist;
                fc = 1/2*nyquist;

                [tanhilb,~,~] = tanerhilbertML(data,fc,fl,fh);

                data_am = [tanhilb(:,1), tanhilb(:,3)];
                
                name1 = [dat_name,'-AM',ext];
                name2 = [dat_name,'-AMf',ext];
                CDac_pwd
                dlmwrite(name1, data_am, 'delimiter', ',', 'precision', 9);
                dlmwrite(name2, [tanhilb(:,1), tanhilb(:,2)], 'delimiter', ',', 'precision', 9);
                disp('>>  See main window for amplitude modulation')
                d = dir; %get files
                set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                refreshcolor;
                cd(pre_dirML); % return to matlab view folder
            
            end
        end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_age_Callback(hObject, eventdata, handles)
% hObject    handle to menu_age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
agescale(handles)


% --------------------------------------------------------------------
function menu_dynos_Callback(hObject, eventdata, handles)
% hObject    handle to menu_dynos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
            if sum(strcmp(ext,handles.filetype)) > 0

                current_data = load(data_name);
                handles.current_data = current_data;
                handles.data_name = data_name;
                handles.dat_name = dat_name;
                guidata(hObject, handles);
                DYNOS(handles);
            end
        end
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_corrcoef_Callback(hObject, eventdata, handles)
% hObject    handle to menu_corrcoef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
    if isdir(data_name) == 1
    else
        [dat_dir,dat_name,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0
            
            data = load(data_name);
            time = data(:,1);
            npts = length(time);
            sr_all = diff(time);
            sr_equal = abs((max(sr_all)-min(sr_all))/2);
            if sr_equal > eps('single')
                warndlg({'Data problem detected.';...
                    'Try "Math->Sort&Unique" or "Math->Interpolation" first...'},'Data: Warning');
            end
            % set zeropadding
            if npts <= 2500
                handles.pad = 5000;
            elseif npts <= 5000 && npts > 2500
                handles.pad = 10000;
            else
                handles.pad = fix(npts/5000) * 5000 + 5000;
            end
            if strcmp(handles.unit,'m')
            elseif strcmp(handles.unit, 'unit')
                warndlg({'Unit of the selected data is "unit"'; ...
                    '(see pop-up menu at top right corner of Acycle main window)';...
                    'Acycle assumes the real UNIT is "m"';'If this is not true, please correct.'},'Unit Warning');
            elseif strcmp(handles.unit,'dm')
                warndlg({'Unit of the selected data is "dm"'; ...
                    '(see pop-up menu at top right corner of Acycle main window)';...
                    'Acycle transformed the data, now the unit of "m"'},'Unit transformed');
                data(:,1) = data(:,1) * 0.1; % dm to m
            elseif strcmp(handles.unit,'cm')
                warndlg({'Unit of the selected data is "cm"'; ...
                    '(see pop-up menu at top right corner of Acycle main window)';...
                    'Acycle transformed the data, now the unit of "m"'},'Unit transformed');
                data(:,1) = data(:,1) * 0.01; % cm to m
            elseif strcmp(handles.unit,'mm')
                warndlg({'Unit of the selected data is "mm"'; ...
                    '(see pop-up menu at top right corner of Acycle main window)';...
                    'Acycle transformed the data, now the unit of "m"'},'Unit transformed');
                data(:,1) = data(:,1) * 0.001; % cm to m
            else
                warndlg('UNIT of the data MUST be "m/dm/cm/mm"!.','Unit Error')
            end
            
            prompt = {'DATA: AGE of the data in Ma',...
                'TARGET: MAX frequency (default)',...
                'TARGET: Zero padding: (default)'};
            dlg_title = 'STEP 1: TARGET: Correlation coefficient';
            num_lines = 1;
            %defaultans = {num2str(handles.t1),num2str(handles.t2),'0','0.06','1','0.6','0.5'};
            defaultans = {num2str(handles.t1),num2str(handles.f2),num2str(handles.pad)};
            options.Resize='on';
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
            if ~isempty(answer)
                t1 = 1000 * str2double(answer{1});
                f1 = handles.f1;
                f2 = str2double(answer{2});
                pad = str2double(answer{3});
                p1 = 1;  % power of eccentricity
                p2 = .6;  % power of obliquity
                p3 = .5;  % power of precession
                if t1 < 0
                    errordlg('Error: Age of the data must be no smaller than 0')
                    return;
                elseif t1 == 0 
                    t1 = 1;
                elseif t1 > 4500000
                    errordlg('Error: Age of the data is too large')
                end
                    age = t1;
                    
                if t1 > 249000
                    %%
                    prompt = {'Orbital solutions: Berger89 = 1; La04/La10 = 2; User-defined = 3',...
                        'OR user defined 7 orbital parameters, space delimited',...
                        'Online resource for user-defined parameters'};
                    waltham15 = 'http://nm2.rhul.ac.uk/wp-content/uploads/2015/01/Milankovitch.html';
                    dlg_title = 'STEP 2: t2 >= 249 Ma, choose orbital options';
                    num_lines = 1;
                    defaultans = {'1','405 125 95 ',waltham15};
                    options.Resize='on';
                    answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
                    if ~isempty(answer)
                        optionOS = str2double(answer{1});
                        optionUD = str2num(answer{2});
                        if optionOS == 2
                            % Ages for orbit7, equations follow Yao et al., 2015
                            % EPSL and Laskar et al., 2004 A&A                        
                            age_obl = 41 - 0.0332 * age/1000;
                            age_p1 = 22.43 - 0.0108 * age/1000;
                            age_p2 = 23.75 - 0.0121 * age/1000;
                            age_p3 = 19.18 - 0.0079 * age/1000;
                            orbit7 = [405 125 95 age_obl age_p2 age_p1 age_p3];
                            target = period2spectrum(orbit7,t1-1000,t1+1000,1,f1,f2,1,pad);
                        elseif optionOS == 3 || length(optionUD) == 7
                            if length(optionUD) < 4
                                errorlog('Error: too few parameters!')
                            elseif length(optionUD) > 7
                                errorlog('Error: too many parameters!')
                            else
                                orbit7 = optionUD;
                                target = period2spectrum(orbit7,t1-1000,t1+1000,1,f1,f2,1,pad);
                            end
                        else
                            orbit7 = getBerger89Period(age/1000);
                            target = period2spectrumB(orbit7,t1-1000,t1+1000,1,f1,f2,1,pad);
                        end

                    end
                else
                    % Generate target using La2004 solution
                    age_obl = 41 - 0.0332 * age/1000;
                    age_p1 = 22.43 - 0.0108 * age/1000;
                    age_p2 = 23.75 - 0.0121 * age/1000;
                    age_p3 = 19.18 - 0.0079 * age/1000;
                    orbit7 = [405 125 95 age_obl age_p2 age_p1 age_p3];
                    if and(t1 <= 248000,t1 > 1000)
                        target = gentarget(4,t1-1000,t1+1000,f1,f2,p1,p2,p3,pad,1);
                    elseif t1 > 248000
                        target = gentarget(4,247000,249000,f1,f2,p1,p2,p3,pad,1);
                    elseif t1 <= 1000
                        target = gentarget(4,1,2000,f1,f2,p1,p2,p3,pad,1);
                    end
                end
                
                prompt = {'DATA: MIN  sedimentation rate (cm/kyr)',...
                    'DATA: MAX  sedimentation rate (cm/kyr)',...
                    'DATA: STEP sedimentation rate (cm/kyr)',...
                    'Number of simulations (e.g., 200, 600, 2000)',...
                    'Remove red noise: 0 = No, 1 = x/AR(1), 2 = x-AR(1)',...
                    'Split series: 1, 2, 3, ...'};
                if t1 >= 249
                    dlg_title = 'STEP 3: DATA: Correlation coefficient';
                else
                    dlg_title = 'STEP 2: DATA: Correlation coefficient';
                end
                num_lines = 1;
                defaultans = {num2str(handles.sr1),num2str(handles.sr2),num2str(handles.srstep),...
                   num2str(handles.nsim),num2str(handles.red),num2str(handles.slices)};
               
                options.Resize='on';
                answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
                if ~isempty(answer)
                    srm = mean(diff(data(:,1)));
                    pad1 = pad;
                    sr1 = str2double(answer{1});
                    sr2 = str2double(answer{2});
                    srstep = str2double(answer{3});
                    nsim = str2double(answer{4});
                    red = str2double(answer{5});
                    adjust = 0;
                    slices = str2double(answer{6});
                    plotn = 1;
                    %corrmethod = str2double(answer{9});
                    corrmethod = 1;  % 1= 'Pearson'; else = 'Spearman'
                    
                    handles.t1 = t1/1000;
                    handles.f1 = f1;
                    handles.f2 = f2;
                    handles.srm = srm;
                    handles.sr1 = sr1;
                    handles.sr2 = sr2;
                    handles.srstep = srstep;
                    handles.nsim = nsim;
                    handles.red = red;
                    handles.adjust = adjust;
                    handles.slices = slices;
                    handles.pad = pad1;

                    f = figure;
                    ax1 = subplot(2,1,1);   % plot power spectrum of target series
                    % subplot 2 will be spectra of slices see below "corrcoefslices_rank" line
                    plot(ax1,target(:,1),target(:,2),'LineWidth',1)
                    xlim(ax1,[f1 f2])
                    xlabel(ax1,'Frequency (cycle/kyr)')
                    ylabel(ax1,'Power')
                    set(ax1,'XMinorTick','on','YMinorTick','on')
                    title(ax1,'Target power spectrum')
                    assignin('base','target',target)
                    if corrmethod == 1
                        method = 'Pearson';
                    else
                        method = 'Spearman';
                    end
                    disp('>> Wait ...')
                    tic
                    [corrCI,corr_h0,corry] = corrcoefslices_rank(data,target,orbit7,srm,pad1,sr1,sr2,srstep,adjust,red,nsim,plotn,slices,method);
                    assignin('base','corrCI',corrCI)
                    assignin('base','corr_h0',corr_h0)
                    assignin('base','corry',corry)
                    
                    param0 = ['Target age is ',num2str(t1),' ka. Zero padding is ',num2str(pad), '. Freq. is ',num2str(f1),'-',num2str(f2),' cycles/kyr'];
                    param1 = ['Tested sedimentation rate step is ', num2str(srstep),' cm/kyr from ',num2str(sr1),' to ',num2str(sr2),' cm/kyr'];
                    param2 = ['Data: number of slices is ', num2str(slices),'. Number of simulations is ',num2str(nsim),'. Zero padding is ',num2str(pad1)];
                    if corrmethod == 1
                        param3 = ['Adjust: ', num2str(adjust),'. Remove red: ',num2str(red),'. Correlation method: Pearson'];
                    else
                        param3 = ['Adjust: ', num2str(adjust),'. Remove red: ',num2str(red),'. Correlation method: Spearman'];
                    end
                    param4 = ['Data: ',num2str(data(1,1)),' to ',num2str(data(end,1)),'m. Sampling rate: ', num2str(srm),'. Number of data points: ', num2str(npts)];
                    disp('')
                    disp(' - - - - - - - - - - - - - Summary - - - - - - - - - - - ')
                    disp(data_name);
                    disp(param0);
                    disp('Seven astronomical cycles are:')
                    disp(orbit7);
                    disp(param1);
                    disp(param2);
                    disp(param3);
                    disp(param4);
                    disp(' - - - - - - - - - - - - - - End - - - - - - - - - - - - ')
                    disp('>> Writing log file ...')
                    disp('>> Done')
                    toc
                    CDac_pwd;
                    % Log name
                    log_name = [dat_name,'-',num2str(nsim),'sim-',num2str(slices),'slice-COCO-log',ext];
                    log_name_coco = [dat_name,'-',num2str(nsim),'sim-',num2str(slices),'slice-COCO.fig'];
                    %log_file_exist = which(log_name); 
                    if exist([pwd,handles.slash_v,log_name]) || exist([pwd,handles.slash_v,log_name_coco])
                        for i = 1:100
                            log_name = [dat_name,'-',num2str(nsim),'sim-',num2str(slices),'slice-COCO-log-',num2str(i),ext];
                            log_name_coco = [dat_name,'-',num2str(nsim),'sim-',num2str(slices),'slice-COCO-',num2str(i),'.fig'];
                            if exist([pwd,handles.slash_v,log_name]) || exist([pwd,handles.slash_v,log_name_coco])
                            else
                                break
                            end
                        end
                    end
                    savefig(log_name_coco) % save ac.fig automatically
                    % open and write log into log_name file
                    fileID = fopen(fullfile(dat_dir,log_name),'w+');
                    fprintf(fileID,'%s\n',' - - - - - - - - - - - - - Summary - - - - - - - - - - -');
                    fprintf(fileID,'%s\n',datestr(datetime('now')));
                    fprintf(fileID,'%s\n',log_name);
                    fprintf(fileID,'%s\n',param0);
                    fprintf(fileID,'%s\n','Seven astronomical cycles are:');
                    fprintf(fileID,'%s\n\n',mat2str(orbit7));
                    fprintf(fileID,'%s\n',param1);
                    fprintf(fileID,'%s\n',param2);
                    fprintf(fileID,'%s\n',param3);
                    fprintf(fileID,'%s\n',param4);
                    fprintf(fileID,'%s\n',' - - - - - - - - - - - - - - End - - - - - - - - - - - -');
                    fclose(fileID);
                    
                    d = dir; %get files
                    set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                    refreshcolor;
                    cd(pre_dirML);
                end
            end
        end
    end
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_ecoco_Callback(hObject, eventdata, handles)
% hObject    handle to menu_ecoco (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
saveacfigyes = 0;
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
        [dat_dir,dat_name,ext] = fileparts(data_name);
        handles.dat_name = dat_name;
        handles.ext = ext;
        if sum(strcmp(handles.ext,handles.filetype)) > 0
            
            data = load(data_name);
            time = data(:,1);
            npts = length(time);
            sr_all = diff(time);
            sr_equal = abs((max(sr_all)-min(sr_all))/2);
            if sr_equal > eps('single')
                warndlg('Data problem detected. Try "Math->Sort&Unique" and "Math->Interpolation" first ...','Warning');
            end
            
            % check unit
            if strcmp(handles.unit,'m')
            elseif strcmp(handles.unit, 'unit')
                warndlg({'Unit of the selected data is "unit"'; ...
                    '(see pop-up menu at top right corner of Acycle main window)';...
                    'Acycle assumes the real UNIT is "m"';'If this is not true, please correct.'},'Unit Warning');
            elseif strcmp(handles.unit,'dm')
                warndlg({'Unit of the selected data is "dm"'; ...
                    '(see pop-up menu at top right corner of Acycle main window)';...
                    'Acycle transformed the data, now the unit of "m"'},'Unit transformed');
                data(:,1) = data(:,1) * 0.1; % dm to m
            elseif strcmp(handles.unit,'cm')
                warndlg({'Unit of the selected data is "cm"'; ...
                    '(see pop-up menu at top right corner of Acycle main window)';...
                    'Acycle transformed the data, now the unit of "m"'},'Unit transformed');
                data(:,1) = data(:,1) * 0.01; % cm to m
            elseif strcmp(handles.unit,'mm')
                warndlg({'Unit of the selected data is "mm"'; ...
                    '(see pop-up menu at top right corner of Acycle main window)';...
                    'Acycle transformed the data, now the unit of "m"'},'Unit transformed');
                data(:,1) = data(:,1) * 0.001; % cm to m
            else
                warndlg('UNIT of the data MUST be "m/dm/cm/mm"!.','Unit Error')
            end
            
            prompt = {'TARGET: What is the age of the data in Ma (e.g., 55):',...
                'TARGET: MAX frequency (default)',...
                'TARGET: Zero-padding: (default)'};
            dlg_title = 'Evolutionary COrrelation COefficient: TARGET';
            num_lines = 1;
            defaultans = {num2str(handles.t1),num2str(handles.f2),'5000'};
            options.Resize='on';
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
            if ~isempty(answer)
                t1 = 1000*str2double(answer{1});
                f1 = handles.f1;
                f2 = str2double(answer{2});
                pad = str2double(answer{3});
                p1 = 1; % 
                p2 = .6;
                p3 = .5;
                if t1 < 0
                    errordlg('Error: Age of the data must be no smaller than 0')
                    return;
                elseif t1 == 0 
                    t1 = 1;
                elseif t1 > 4500000
                    errordlg('Error: Age of the data is too large')
                    return;
                end
                % age for orbit7
                age = t1;
                
                if age > 249000
                    prompt = {'Orbital solutions: Berger89 = 1; La04/La10 = 2; User-defined = 3',...
                        'OR user defined 7 orbital parameters, space delimited',...
                        'Online resource for user-defined parameters'};
                    waltham15 = 'http://nm2.rhul.ac.uk/wp-content/uploads/2015/01/Milankovitch.html';
                    dlg_title = 'Note: t2 >= 249 Ma, choose orbital options';
                    num_lines = 1;
                    defaultans = {'1','405 125 95 ',waltham15};
                    options.Resize='on';
                    
                    answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
                    if ~isempty(answer)
                        optionOS = str2double(answer{1});
                        optionUD = str2num(answer{2});
                        if optionOS == 2
                            % Ages for orbit7, equations follow Yao et al., 2015
                            % EPSL and Laskar et al., 2004 A&A                        
                            age_obl = 41 - 0.0332 * age/1000;
                            age_p1 = 22.43 - 0.0108 * age/1000;
                            age_p2 = 23.75 - 0.0121 * age/1000;
                            age_p3 = 19.18 - 0.0079 * age/1000;
                            orbit7 = [405 125 95 age_obl age_p2 age_p1 age_p3];
                            target = period2spectrum(orbit7,t1-1000,t1+1000,1,f1,f2,1,pad);
                        elseif optionOS == 3 || length(optionUD) == 7
                            if length(optionUD) < 4
                                errorlog('Error: too few parameters!')
                            elseif length(optionUD) > 7
                                errorlog('Error: too many parameters!')
                            else
                                orbit7 = optionUD;
                                target = period2spectrum(orbit7,t1-1000,t1+1000,1,f1,f2,1,pad);
                            end
                        else
                            orbit7 = getBerger89Period(age/1000);
                            target = period2spectrumB(orbit7,t1-1000,t1+1000,1,f1,f2,1,pad);
                        end

                    end
                else
                    % Generate target using La2004 solution
                    age_obl = 41 - 0.0332 * age/1000;
                    age_p1 = 22.43 - 0.0108 * age/1000;
                    age_p2 = 23.75 - 0.0121 * age/1000;
                    age_p3 = 19.18 - 0.0079 * age/1000;
                    orbit7 = [405 125 95 age_obl age_p2 age_p1 age_p3];
                    if and(t1 <= 248000,t1 > 1000)
                        target = gentarget(4,t1-1000,t1+1000,f1,f2,p1,p2,p3,pad,1);
                    elseif t1 > 248000
                        target = gentarget(4,247000,249000,f1,f2,p1,p2,p3,pad,1);
                    elseif t1 <= 1000
                        target = gentarget(4,1,2000,f1,f2,p1,p2,p3,pad,1);
                    end
                end

                prompt = {'DATA: Running window (m)',...
                    'DATA: Number of sliding steps (#)',...
                    'DATA: MIN  sedimentation rate (cm/kyr)',...
                    'DATA: MAX  sedimentation rate (cm/kyr)',...
                    'DATA: STEP sedimentation rate (cm/kyr)',...
                    'Number of simulations (e.g., 200, 600, 2000)',...
                    'Remove red noise: 0 = No, 1 = x/AR(1), 2 = x-AR(1)'};
                dlg_title = 'Evolutionary Correlation Coefficient (eCOCO): DATA';
                num_lines = 1;
                eCOCO_win = 0.25*(data(end,1)-data(1,1));
                step = ceil(npts/300); % number of sliding windows
                
                defaultans = {num2str(eCOCO_win),num2str(step),...
                    num2str(handles.sr1),num2str(handles.sr2),num2str(handles.srstep),...
                    num2str(handles.nsim),num2str(handles.red)};
                
                options.Resize='on';
                answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
                
                if ~isempty(answer)
                    window = str2double(answer{1});
                    srm = mean(diff(data(:,1)));
                    step = str2double(answer{2});
                    pad1 = pad;
                    sr1 = str2double(answer{3});
                    sr2 = str2double(answer{4});
                    srstep = str2double(answer{5});
                    nsim = str2double(answer{6});
                    red = str2double(answer{7});
                    delinear = 0;
                    adjust = 0;
                    slices = 1;
                    plotn = 1;
                    disp('>> Wait ...')
                    
                    handles.acfig = gcf; % read info of AC main window
                    
                    tic
                    [prt_sr,out_depth,out_ecc,out_ep,out_eci,out_ecoco,out_ecocorb,out_norbit] = ...
                        ecoco(data,target,orbit7,window,srm,step,delinear,red,pad1,sr1,sr2,srstep,nsim,adjust,slices,plotn);

                    param0 = ['Target age is ',num2str(t1),' ka. Zero padding is ',num2str(pad),'. Frequency: ',num2str(f1),'-',num2str(f2),' cycles/kyr'];
                    param1 = ['Sliding window is ',num2str(window),' m. Number of sliding steps is ', num2str(step),'. Sliding step is',num2str(srm*step),' m'];
                    param2 = ['Tested sedimentation rate: from ',num2str(sr1),' to ',num2str(sr2),' with a step of ', num2str(srstep), ' cm/kyr'];
                    param3 = ['Number of Monte Carlo simulations ',num2str(nsim), '. Remove red noise: ',num2str(red),'. Zero padding is ',num2str(pad1)];
                    param4 = ['Data: ',num2str(data(1,1)),' to ',num2str(data(end,1)),'m. Sampling rate: ', num2str(srm),'. Number of data points: ', num2str(npts)];
                    disp('')
                    disp(' - - - - - - - - - - - - - Summary - - - - - - - - - - - ')
                    disp(data_name);
                    disp(param0);
                    disp('Seven astronomical cycles are:')
                    disp(orbit7);
                    disp(param1);
                    disp(param2);
                    disp(param3);
                    disp(param4);
                    disp(' - - - - - - - - - - - - - - End - - - - - - - - - - - - ')
                    toc
                    
                    CDac_pwd;
                    % ac.fig file name
                    acfig_name = [dat_name,'-',num2str(nsim),'sim-',num2str(slices),'slice-',num2str(window),'win-ECOCO.AC.fig'];
                    % Log name
                    log_name = [dat_name,'-',num2str(nsim),'sim-',num2str(slices),'slice-',num2str(window),'win-ECOCO-log',ext];
                    
                    if exist([pwd,handles.slash_v,acfig_name]) || exist([pwd,handles.slash_v,log_name])
                        for i = 1:100
                            acfig_name = [dat_name,'-',num2str(nsim),'sim-',num2str(slices),'slice-',num2str(window),'win-ECOCO-',num2str(i),'.AC.fig'];
                            log_name   = [dat_name,'-',num2str(nsim),'sim-',num2str(slices),'slice-',num2str(window),'win-ECOCO-',num2str(i),'.log',ext];
                            if exist([pwd,handles.slash_v,acfig_name]) || exist([pwd,handles.slash_v,log_name])
                            else
                                break
                            end
                        end
                    end

                    % open and write log into log_name file
                    fileID = fopen(fullfile(dat_dir,log_name),'w+');
                    fprintf(fileID,'%s\n',' - - - - - - - - - - - - - Summary - - - - - - - - - - -');
                    fprintf(fileID,'%s\n',datestr(datetime('now')));
                    fprintf(fileID,'%s\n',log_name);
                    fprintf(fileID,'%s\n',param0);
                    fprintf(fileID,'%s\n','Seven astronomical cycles are:');
                    fprintf(fileID,'%s\n\n',mat2str(orbit7));
                    fprintf(fileID,'%s\n',param1);
                    fprintf(fileID,'%s\n',param2);
                    fprintf(fileID,'%s\n',param3);
                    fprintf(fileID,'%s\n',param4);
                    fprintf(fileID,'%s\n',' - - - - - - - - - - - - - - End - - - - - - - - - - - -');
                    fclose(fileID);
                    
                    handles.t1 = t1/1000;
                    %handles.t2 = t2/1000;
                    handles.f1 = f1;
                    handles.f2 = f2;
                    handles.window = window;
                    handles.sr1 = sr1;
                    handles.sr2 = sr2;
                    handles.srm = srm;
                    handles.step = step;
                    handles.srstep = srstep;
                    handles.nsim = nsim;
                    handles.red = red;
                    handles.adjust = adjust;
                    handles.slices = slices;
                    handles.prt_sr = prt_sr;
                    handles.out_depth = out_depth;
                    handles.out_ecc = out_ecc;
                    handles.out_ep = out_ep;
                    handles.out_eci = out_eci;
                    handles.out_ecoco = out_ecoco;
                    handles.out_ecocorb = out_ecocorb;
                    handles.out_norbit = out_norbit;
                    handles.target = target;
                    %
                    assignin('base','prt_sr',prt_sr)
                    assignin('base','out_depth',out_depth)
                    assignin('base','out_ecc',out_ecc)
                    assignin('base','out_ep',out_ep)
                    assignin('base','out_eci',out_eci)
                    assignin('base','out_ecoco',out_ecoco)
                    assignin('base','out_ecocorb',out_ecocorb)
                    assignin('base','out_norbit',out_norbit)
                    
                    d = dir; %get files
                    set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                    refreshcolor;
                    
                    saveacfigyes = 1;
                    set(handles.menu_etrack,'Enable','On')
                    set(handles.menu_ecocoplot,'Enable','On')
                    figure(handles.acfig)
%                     handles.acfig = gcf;
%                     savefig(handles.acfig,acfig_name) % save ac.fig automatically
                    cd(pre_dirML);
                    
                    disp('>>  *ECOCO.AC.fig file:')
                    disp(acfig_name)
                    disp('>>  *.ECOCO-log file:')
                    disp(log_name)
                end
            end
        end
        end
end

guidata(hObject, handles);

if saveacfigyes == 1
    CDac_pwd;
    savefig(gcf,acfig_name)
    d = dir; %get files
    set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
    refreshcolor;
    cd(pre_dirML);
end


% --- Executes during object creation, after setting all properties.
function menu_laskar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function menu_laskar_Callback(hObject, eventdata, handles)
% hObject    handle to menu_laskar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
basicseries(handles);


% --- Executes during object creation, after setting all properties.
function menu_LR04_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function menu_LR04_Callback(hObject, eventdata, handles)
% hObject    handle to menu_LR04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Start Age in k.a. (>= 0):',...
                'End Age in k.a. (<= 5320):'};
dlg_title = 'LR04 stack: Plio-Pleistocene \delta^{18}O(ben)';
num_lines = 1;
defaultans = {'0','5320'};
options.Resize='on';
answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
if ~isempty(answer)
    t1 = str2double(answer{1});
    t2 = str2double(answer{2});
    LR04stack = load('LR04stack5320ka.txt');
    LR04stack_s = select_interval(LR04stack,t1,t2);
    figure;
    plot(LR04stack_s(:,1),LR04stack_s(:,2),'LineWidth',1);
    xlabel('Time (kyr)')
    ylabel('Global Benthic \delta^{18}O')
    title(['LR04 Stack: ',num2str(t1),'-',num2str(t2),' ka'])
    set(gca,'XMinorTick','on','YMinorTick','on')
    filename = ['LR04_Stack_',num2str(t1),'_',num2str(t2),'ka.txt'];
    % cd ac_pwd dir
    CDac_pwd
    dlmwrite(filename, LR04stack_s, 'delimiter', ',', 'precision', 9);
    d = dir; %get files
    set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
    refreshcolor;
    cd(pre_dirML); % return to matlab view folder
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_plotn_Callback(hObject, eventdata, handles)
% hObject    handle to menu_plotn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = handles.index_selected;  % read selection in listbox 1
nplot = length(plot_selected);   % length
% check
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        if isdir(plot_filter_s)
            return
        else
            [~,~,ext] = fileparts(plot_filter_s);
            if sum(strcmp(ext,handles.filetype)) > 0
                check = 1; % selection can be executed 
            else
                return
            end
        end
    else
        return
    end
end

if check == 1;
    figure;
    hold on;
    for i = 1:nplot
        plot_no = plot_selected(i);
            plot_filter_s = char(contents(plot_no));
            GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
    try
        fid = fopen(plot_filter_s);
        data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
        fclose(fid);
        if iscell(data_ft)
            dat = cell2mat(data_ft);
        end
    catch
        dat = load(plot_filter_s);
    end
            
            
            dat = dat(~any(isnan(dat),2),:);
            dat(:,2) = (dat(:,2)-mean(dat(:,2)))/std(dat(:,2));
            plot(dat(:,1),dat(:,2),'LineWidth',1);
    end
    set(gca,'XMinorTick','on','YMinorTick','on')
    hold off
    title(contents(plot_selected))
    if handles.unit_type == 0;
        xlabel(['Unit (',handles.unit,')'])
    elseif handles.unit_type == 1;
        xlabel(['Depth (',handles.unit,')'])
    else
        xlabel(['Time (',handles.unit,')'])
    end
end
guidata(hObject,handles)

% --------------------------------------------------------------------
function menu_plotn2_Callback(hObject, eventdata, handles)
% hObject    handle to menu_plotn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = handles.index_selected;  % read selection in listbox 1
nplot = length(plot_selected);   % length
% check
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        if isdir(plot_filter_s)
            return
        else
            [~,~,ext] = fileparts(plot_filter_s);
            if sum(strcmp(ext,handles.filetype)) > 0
                check = 1; % selection can be executed 
            else
                return
            end
        end
    else
        return
    end
end

if check == 1;
    xlimit = zeros(nplot,2);
    figure;
    hold on;
    for i = 1:nplot
        plot_no = plot_selected(i);
            plot_filter_s = char(contents(plot_no));
            GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
     try
        fid = fopen(plot_filter_s);
        data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
        fclose(fid);
        if iscell(data_ft)
            dat = cell2mat(data_ft);
        end
    catch
        dat = load(plot_filter_s);
    end 
            
            dat = dat(~any(isnan(dat),2),:);
            dat(:,2) = (dat(:,2)-mean(dat(:,2)))/std(dat(:,2));
            plot(dat(:,1),2*(i-1)+dat(:,2),'LineWidth',1);
            xlimit(i,:) = [dat(1,1) dat(length(dat(:,1)),1)];
    end
    set(gca,'XMinorTick','on','YMinorTick','on')
    hold off
    title(contents(plot_selected))
    xlim([min(xlimit(:,1)) max(xlimit(:,2))])
    if handles.unit_type == 0;
        xlabel(['Unit (',handles.unit,')'])
    elseif handles.unit_type == 1;
        xlabel(['Depth (',handles.unit,')'])
    else
        xlabel(['Time (',handles.unit,')'])
    end

end
guidata(hObject,handles)

% --------------------------------------------------------------------
function menu_rename_Callback(hObject, eventdata, handles)
% hObject    handle to menu_rename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = handles.index_selected;  % read selection in listbox 1
nplot = length(plot_selected);   % length
% check
if nplot == 1
    if plot_selected > 2
        CDac_pwd;
        plot_filter_s = char(contents(plot_selected));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        prompt = {'Enter new file name:'};
        dlg_title = 'Rename                           ';
        num_lines = 1;
        defaultans = {plot_filter_s};
        options.Resize='on';
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
        newname = char(answer);
        if ~isempty(newname)
            try
                movefile(plot_filter_s,newname)
            catch
                disp('Error: Cannot copy or move a file or directory onto itself.')
            end
            d = dir; %get files
            set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
            refreshcolor;
            cd(pre_dirML);
        end
    end
end

% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_import_Callback(hObject, eventdata, handles)
% hObject    handle to menu_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.txt;*.csv','Files (*.txt;*.csv)'},...
    'Import data (*.csv,*.txt)');
if filename == 0
    open_data = 'Tips: open 2 colume data';
    h = helpdlg(open_data,'Tips: Close');
    uiwait(h); 
else
    aaa = [pathname,filename];
    data=load(aaa);
    
    CDac_pwd % cd ac_pwd dir
    %csvwrite(handles.foldname,data)
    dlmwrite(handles.foldname, data, 'delimiter', ',', 'precision', 9); 
    d = dir; %get files
    set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
    refreshcolor;
    cd(pre_dirML); % return to matlab view folder
    handles.current_data = data;
    guidata(hObject,handles)
end

% --------------------------------------------------------------------
function menu_savefig_Callback(hObject, eventdata, handles)
% hObject    handle to menu_savefig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Name of ACYCLE figure:'};
        dlg_title = 'Filename';
        num_lines = 1;
        defaultans = {'.AC.fig'};
        options.Resize='on';
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
        newname = char(answer);
        if ~isempty(newname)
            CDac_pwd % cd ac_pwd dir
            savefig(newname)
            refreshcolor;
            cd(pre_dirML); % return to matlab view folder
        end


% --------------------------------------------------------------------
function menu_depeaks_Callback(hObject, eventdata, handles)
% hObject    handle to menu_depeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
        [~,dat_name,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0
            
            data = load(data_name);
            time = data(:,1);
            value = data(:,2);
            npts = length(time);

            prompt = {'Enter Mininum value:','Enter Maximum value:'};
            dlg_title = 'Input MIN and MAX value';
            num_lines = 1;
            defaultans = {num2str(min(value)),num2str(max(value))};
            options.Resize='on';
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
            if ~isempty(answer)
            ymin_cut = str2double(answer{1});
            ymax_cut = str2double(answer{2});
            [current_data]=depeaks(data,ymin_cut,ymax_cut); 

            name1 = [dat_name,'-dpks',num2str(ymin_cut),'-',num2str(ymax_cut),ext];  % New name
            %csvwrite(name1,current_data)    
            % cd ac_pwd dir
                CDac_pwd
            dlmwrite(name1, current_data, 'delimiter', ',', 'precision', 9); 
            d = dir; %get files
            set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
            refreshcolor;
            cd(pre_dirML); % return to matlab view folder
            end
        end
        end
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menuac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function menuac_Callback(hObject, eventdata, handles)
% hObject    handle to menuac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function menu_prewhiten_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function menu_prewhiten_Callback(hObject, eventdata, handles)
% hObject    handle to menu_prewhiten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,~,ext] = fileparts(data_name);
            if sum(strcmp(ext,handles.filetype)) > 0

                current_data = load(data_name);
                handles.current_data = current_data;
                handles.data_name = data_name;
                guidata(hObject, handles);
                prewhiten(handles);
            end
        end
end
guidata(hObject, handles);



% --------------------------------------------------------------------
function menu_etrack_Callback(hObject, eventdata, handles)
% hObject    handle to menu_etrack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'How many peaks within each window?',...
    'Threshold H0 significant level',...
    'Threshold correlation coefficient',...
    'Threshold number of orbital parameters',...
    'Threshold sedimentation rate searching radius',...
    'How many intervals to cut the series?',...
    'Plot? 1 = Yes, 0 = No',...
    'Optional: sedimentation rate ranges from',...
    'Optional: sedimentation rate ranges to'};
dlg_title = 'Track sedimentation rates';
num_lines = 1;
defaultans = {'3','5','0.3','4','2','3','1',num2str(handles.sr1),num2str(handles.sr2)};
options.Resize='on';
answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
if ~isempty(answer)
    n = str2double(answer{1});
    ci = str2double(answer{2});
    corrcf = str2double(answer{3});
    sh_norb = str2double(answer{4});
    srsh = str2double(answer{5});
    srslice = str2double(answer{6});
    plotn = str2double(answer{7});
    sr1 = str2double(answer{8});
    sr2 = str2double(answer{9});

    %
    ecc = handles.out_ecc;  % matrix
    eci = handles.out_eci;  % matrix
    norbit = handles.out_norbit; % matrix
    ecoco = handles.out_ecoco;
    % cut using given sedimentation range
    srstep = handles.srstep;
    if or(sr1 ~= handles.sr1, sr2~= handles.sr2)
        %srshrange = round((sr1:srsh:sr2)/srstep);
        srsh_1 = round((sr1-handles.sr1)/srstep); % start number of selected sed. rate
        if srsh_1 == 0; srsh_1 = 1; end
        srsh_n = round(abs(sr2-sr1)/srstep); % end number of selected sed. rate
        ecc = ecc(srsh_1:srsh_n,:); % selected data
        eci = eci(srsh_1:srsh_n,:); % selected data
        norbit = norbit(srsh_1:srsh_n,:); % selected data
        ecoco = ecoco(srsh_1:srsh_n,:); % selected data
    end
    %[Y] = ebrief(handles.out_ecocorb,2,-2); % brief ecocorb
    %[Y] = ebrief(handles.out_ecoco,2,-2); % brief ecoco
    [Y] = ebrief(ecc,2,-2); % brief ecoco
%     size(Y)
%     size(ecc)
    %[Ypcc,locatcc] = eccpeaks(Y,handles.out_ecc,handles.out_eci,n,ci,corrcf,1,NaN);
    [Ypcc,locatcc] = eccpeaks(Y,ecc,eci,norbit,corrcf,ci,sh_norb,n,1,NaN); % get peaks
    
%     [srslice_range,srn_all,srn_best,eccout_all] = ecocotrack(locatcc,ecc,eci,ecoco,...
%     norbit,handles.out_depth,handles.sr1,handles.sr2,srstep,...
%     srsh,srslice,corrcf,ci,plotn,sh_norb);

    [~,~,srn_best,~] = ecocotrack(locatcc,ecc,eci,ecoco,...
    norbit,handles.out_depth,sr1,sr2,srstep,...
    srsh,srslice,corrcf,ci,plotn,sh_norb);

    assignin('base','Y',Y)
    assignin('base','Ypcc',Ypcc)
    %assignin('base','handles.out_ecoco',handles.out_ecoco)
    
    name0 = [handles.dat_name,'-',num2str(n),'pk-',num2str(ci),'%H0SL',...
        num2str(corrcf),'co-',num2str(srslice),'sl','-SR'];  % New name
    name1 = [name0,handles.ext];  % name for sedrate file
    if exist([pwd,handles.slash_v,name1])
        for i = 1:100
            name1 = [name0,num2str(i),handles.ext];
            if exist([pwd,handles.slash_v,name1])
            else
                break
            end
        end
    end
    %srn_map(:,2) = (handles.sr1+handles.srstep*(srn_best(1,:)-1))';
    srn_map(:,2) = (sr1+handles.srstep*(srn_best(1,:)-1))';
    srn_map(:,1) = handles.out_depth;
    % cd ac_pwd dir
    CDac_pwd
    dlmwrite(name1, srn_map, 'delimiter', ',', 'precision', 9);
    disp(['>> Sedimentation rate file: ',name1])
    % Log name
    log_name = [name0,'-log',handles.ext]; 
    if exist([pwd,handles.slash_v,log_name])
        for i = 1:100
            log_name = [name0,'-log',num2str(i),'.txt'];
            if exist([pwd,handles.slash_v,log_name])
            else
                break
            end
        end
    end
    disp(['>> Log file: ',log_name])
    % open and write log into log_name file
    fileID = fopen(fullfile(pwd,handles.slash_v,log_name),'w+');
    fprintf(fileID,'%s\n',' - - - - - - - - - - - - - Summary - - - - - - - - - - -');
    fprintf(fileID,'%s\n\n',datestr(datetime('now')));
    fprintf(fileID,'%s\n\n',log_name);
    fprintf(fileID,'%s\n','How many peaks each window?');
    fprintf(fileID,'%s\n',num2str(n));
    fprintf(fileID,'%s\n','Threshold H0 significant level');
    fprintf(fileID,'%s\n',num2str(ci));
    fprintf(fileID,'%s\n','Threshold correlation coefficient');
    fprintf(fileID,'%s\n',num2str(corrcf));
    fprintf(fileID,'%s\n','Threshold number of orbital parameters?');
    fprintf(fileID,'%s\n',num2str(sh_norb));
    fprintf(fileID,'%s\n','Threshold sedimentation rate');
    fprintf(fileID,'%s\n',num2str(srsh));
    fprintf(fileID,'%s\n','How many intervals to cut the series?');
    fprintf(fileID,'%s\n',num2str(srslice));
    fprintf(fileID,'%s\n','Optional: sedimentation rate ranges from');
    fprintf(fileID,'%s\n',num2str(sr1));
    fprintf(fileID,'%s\n','Optional: sedimentation rate ranges to');
    fprintf(fileID,'%s\n',num2str(sr2));
    fprintf(fileID,'%s\n',' - - - - - - - - - - - - - - End - - - - - - - - - - - -');
    fclose(fileID);
    
    d = dir; %get files
    set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
    refreshcolor;
    cd(pre_dirML); % return to matlab view folder
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_ecocoplot_Callback(hObject, eventdata, handles)
% hObject    handle to menu_ecocoplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Plot: 1 = 1 fig; 2 = multi-figs; 3 = 3D figs; reverse Y-axis = (-1,-2,or -3)'};
dlg_title = 'Plot ecoco results';
num_lines = 1;
defaultans = {'1'};
options.Resize='on';
answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
if ~isempty(answer)
    plotn = str2double(answer{1});
    [~] = ecocoplot(handles.prt_sr,handles.out_depth,...
    handles.out_ecc,handles.out_ep,handles.out_eci,handles.out_ecoco,handles.out_ecocorb,handles.out_norbit,plotn);
end


% --------------------------------------------------------------------
function menu_agebuild_Callback(hObject, eventdata, handles)
% hObject    handle to menu_agebuild (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
        [~,dat_name,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0
            
            data = load(data_name);

            prompt = {'Enter period (kyr):','Use 1 = peak; 0 = trough:'};
            dlg_title = 'Input period';
            num_lines = 1;
            defaultans = {'41','1'};
            options.Resize='on';
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
            if ~isempty(answer)
            period = str2double(answer{1});
            pkstrough = str2double(answer{2});
            if pkstrough == 1
                [datapks,~] = getpks(data);
                plot_filter_s ='max';
            else
                data(:,2) = -1*data(:,2);
                [datapks,~] = getpks(data);
                plot_filter_s ='min';
            end
            [nrow, ~] = size(datapks);
            datapksperiod = 1:nrow;
            datapksperiod = datapksperiod*period;
            datapksperiod = datapksperiod';
            handles.datapks_tie = [datapks(:,1),datapksperiod];
            %csvwrite([dat_name,'-agemod-',num2str(period),'-',plot_filter_s,ext],handles.datapks_tie)
            name1 = [dat_name,'-agemod-',num2str(period),'-',plot_filter_s,ext];
            % cd ac_pwd dir
            CDac_pwd
            dlmwrite(name1, handles.datapks_tie, 'delimiter', ',', 'precision', 9);
            d = dir; %get files
            set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
            refreshcolor;
            cd(pre_dirML); % return to matlab view folder
            end
        end
        end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_function_Callback(hObject, eventdata, handles)
% hObject    handle to menu_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
        [~,dat_name,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0
            
            data = load(data_name);

            prompt = {'a for the 1st column: x(i) = a * x(i) + b',...
                'b for the 1st column: x(i) = a * x(i) + b',...
                'c for the 2nd column: y(i) = c * y(i) + d',...
                'd for the 2nd column: y(i) = c * y(i) + d'};
            dlg_title = 'Input parameters';
            num_lines = 1;
            defaultans = {'1','0','1','0'};
            options.Resize='on';
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
            if ~isempty(answer)
            a = str2double(answer{1});
            b = str2double(answer{2});
            c = str2double(answer{3});
            d = str2double(answer{4});

            data(:,1) = a * data(:,1) + b;
            data(:,2) = c * data(:,2) + d;
            if and(and(a == 1, b==0), and(c==1, d==0))
            else
            %csvwrite([dat_name,'-new',ext],data)
            % cd ac_pwd dir
            CDac_pwd
            dlmwrite([dat_name,'-new',ext], data, 'delimiter', ',', 'precision', 9);
            d = dir; %get files
            set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
            refreshcolor;
            cd(pre_dirML); % return to matlab view folder
            end
            end
        end
        end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_maxmin_Callback(hObject, eventdata, handles)
% hObject    handle to menu_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0

        try
            fid = fopen(data_name);
            data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
            fclose(fid);
            if iscell(data_ft)
                data = cell2mat(data_ft);
            end
        catch
            data = load(data_name);
        end 
        
            x = data(:,1);
            dlg_title = 'Find Max/Min value and indice';
            prompt = {'Interval start','Interval end','Max or Min (1 = max, else = min)','Tested column'};
            num_lines = 1;
            defaultans = {num2str(min(x)),num2str(max(x)),'1','2'};
            options.Resize='on';
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
            if ~isempty(answer)
                t1 = str2double(answer{1});
                t2 = str2double(answer{2});
                maxmin = str2double(answer{3});
                ind = str2double(answer{4});
                % 
                [dat] = select_interval(data,t1,t2);
                y = dat(:,ind);
                % max
                if maxmin == 1  
                    [m,i] = max(y);
                else
                    [m,i] = min(y);
                end
                disp(dat(i,:))
            end
        end
        end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_cpt_Callback(hObject, eventdata, handles)
% hObject    handle to menu_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Function of Bayesian changepoint technique

contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0

        try
            fid = fopen(data_name);
            data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
            fclose(fid);
            if iscell(data_ft)
                data = cell2mat(data_ft);
            end
        catch
            data = load(data_name);
        end 
        
            x = data(:,1);
            dlg_title = 'Ruggieri (2013) Bayesian Changepoint';
            prompt = {...
                'k_max, max no. of change points allowed',...
                'd_min, min distance between consecutive change points',...
                'k_0, variance scaling hyperparameter',...
                'v_0,  pseudo data point',...
                'sig_0, pseudo data variance (maybe halved)',...
                'n, number of sampled solutions',...
                'Save data? (1 = yes, 0 = no)'};
            num_lines = 1;
            sig_0 = var(data(:,2));
            k_0 = ceil( abs(x(end)-x(1))/44 ); % default value, 1/sub-interval*25%
            defaultans = {'10','1','0.01',num2str(k_0),num2str(sig_0),'500','1'};
            options.Resize='on';
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
            if ~isempty(answer)
                if length(x)> 500
                    warndlg('Large dataset, wait...')
                end
                k_max = str2double(answer{1}); % default is 10
                d_min = str2double(answer{2}); % at least twice as many data points as free parameters
                    % in the regression model. Ensure enough data is
                    % available to estimate the parameters of the model
                    % accurately
                k_0 = str2double(answer{3}); % set k0 to be small, yielding a wide prior distribution
                    % on the regression coefficients
                v_0 = str2double(answer{4}); % may be <25% of the size of the minimum allowed sub-interval
                sig_0 = str2double(answer{5}); %  this will not be larger than the overall variance of the
                    % data set, one option is to conservatively set the
                    % prior variance sig_0^2, equal to the variance of the
                    % data set being used
                num_samp = str2double(answer{6});
                savedata = str2double(answer{7});
                % 
                [mod,cpt,R_2] = bayes_cpt(data,k_max,d_min,k_0,v_0,sig_0,num_samp);
                if savedata == 1
                    CDac_pwd
                    dlmwrite([dat_name,'-BayesRegModel',ext], mod, 'delimiter', ',', 'precision', 9);
                    dlmwrite([dat_name,'-BayesChangepoint',ext], cpt, 'delimiter', ',', 'precision', 9);
                    disp(['>> ',dat_name,ext,' Bayesian change points output saved. R_2 is ',num2str(R_2)])
                    
                    d = dir; %get files
                    set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                    refreshcolor;
                    cd(pre_dirML); % return to matlab view folder
                end
            end
        end
        end
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_imshow_Callback(hObject, eventdata, handles)
% hObject    handle to menu_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
            
        else
            [~,dat_name,ext] = fileparts(data_name);
            if sum(strcmp(ext,{'.jpg','.jpeg','.JPG','.JPEG','.png','.PNG','.tif','.TIF'})) > 0
                im_name = imread(data_name);
                figure;
                imshow(im_name)
                set(gcf,'Name',[dat_name,ext])
            end
        end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_rgb2gray_Callback(hObject, eventdata, handles)
% hObject    handle to menu_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
            
        else
            [~,dat_name,ext] = fileparts(data_name);
            if sum(strcmp(ext,{'.jpg','.jpeg','.JPG','.JPEG','.png','.PNG','.tif','.TIF'})) > 0
                im_name = imread(data_name);
                
                try I = rgb2gray(im_name);
                figure
                imshow(I)
                dat_name = [dat_name,'-gray',ext];
                set(gcf,'Name',dat_name)
                CDac_pwd;
                imwrite(I,dat_name)
                d = dir; %get files
                set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                refreshcolor;
                cd(pre_dirML); % return to matlab view folder
                catch
                    warndlg('This is not a RGB image')
                end
            end
        end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_improfile_Callback(hObject, eventdata, handles)
% hObject    handle to menu_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
            if sum(strcmp(ext,{'.jpg','.jpeg','.JPG','.JPEG','.png','.PNG','.tif','.TIF'})) > 0
                I = imread(data_name);
                fig = figure;
                imshow(I);
                set(gcf,'Name',[dat_name,ext,': Press "ALT" & select cursors now'])
                
                choice = questdlg('Press "ALT" key and click to select 2 cursors, then press "Enter"', ...
                    'Select', 'Got you','Cancel','Got you');
                
                switch choice
                    case 'Got you'
                        figure(fig)
                        dcm_obj = datacursormode(fig);
                        %set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off')
                        Sure = input('>>  Press "Enter"');
                        c_info = getCursorInfo(dcm_obj);
                        m=length(c_info);
                        CursorInfo_value = zeros(m,2);
                        if m>=1
                            for i=1:m
                               CursorInfo_value(i,1)=c_info(i).Position(:,1);
                               CursorInfo_value(i,2)=c_info(i).Position(:,2);
                            end
                        end
                        %disp(CursorInfo_value)
                        if m >= 2
                            if m>2
                                warndlg('More than 2 cursors are selected!')
                            end
                            [cx,cy,c,xi,yi] = improfile(I,CursorInfo_value(:,1),CursorInfo_value(:,2));
                            cx = sort(cx - min(cx));
                            cy = sort(cy - min(cy));
                            cz = sqrt(cx.^2 + cy.^2);

                            try data = [cz,c];
                            catch
                                warndlg('This is not a grayscale image!')
                                try c = reshape(c,[],3);
                                    %warndlg('Looks like a RGB image?')
                                catch
                                    warndlg('Looks like a cymk image, right?')
                                    c = reshape(c,[],4);
                                end
                                data = [cz,c];
                            end
                            name = [dat_name,'-profile.txt'];
                            name1= [dat_name,'-controlpoints.txt'];
                            data1 = [xi,yi];
                            
                            CDac_pwd
                            dlmwrite(name , data, 'delimiter', ',', 'precision', 9);
                            dlmwrite(name1, data1, 'delimiter', ',', 'precision', 9);
                            disp(['>>  save profile data as   ',name1])
                            disp(['>>  save control points as ',name1])
                            d = dir; %get files
                            set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                            refreshcolor;
                            cd(pre_dirML); % return to matlab view folder
                            
                            figure;plot(cz,c);title(name); xlabel('Pixels'); 
                            if m == 2
                                ylabel('Grayscale')
                            else
                                ylabel('Value')
                            end
                        end
                    case 'Cancel'
                end
            end
        end
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menu_cut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_refresh

% --------------------------------------------------------------------
function menu_cut_Callback(hObject, eventdata, handles)
% hObject    handle to menu_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
CDac_pwd;
handles.nplot = nplot;
if  min(plot_selected) > 2
    handles.data_name = {};
    handles.file = {};
    for i = 1 : nplot
       filename = char(contents(plot_selected(i)));
       handles.data_name{i} = strrep2(filename, '<HTML><FONT color="blue">', '</FONT></HTML>');
       handles.file{i} = [ac_pwd,handles.slash_v,handles.data_name{i}];
    end
end
handles.copycut = 'cut';
cd(pre_dirML);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menu_copy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to menu_copy

% --------------------------------------------------------------------
function menu_copy_Callback(hObject, eventdata, handles)
% hObject    handle to menu_copy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
CDac_pwd;
handles.nplot = nplot;
if  min(plot_selected) > 2
    handles.data_name = {};
    handles.file = {};
    for i = 1 : nplot
       filename = char(contents(plot_selected(i)));
       handles.data_name{i} = strrep2(filename, '<HTML><FONT color="blue">', '</FONT></HTML>');
       handles.file{i} = [ac_pwd,handles.slash_v,handles.data_name{i}];
    end
end
handles.copycut = 'copy';
cd(pre_dirML);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function menu_paste_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to menu_copy

% --------------------------------------------------------------------
function menu_paste_Callback(hObject, eventdata, handles)
% hObject    handle to menu_paste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CDac_pwd;
copycut = handles.copycut; % cut of copy
nplot = handles.nplot; % number of selected files
if nplot == 0
    return
end
for i = 1:nplot
    if strcmp(copycut,'cut')
        new_name = handles.data_name{i};
        new_name_w_dir = [ac_pwd,handles.slash_v,new_name];
        if exist(new_name_w_dir)
            answer = questdlg(['Cover existed file ',new_name,'?'],...
                'Warning',...
                'Yes','No','Yes');
            % Handle response
            switch answer
                case 'Yes'
                    movefile(handles.file{i}, ac_pwd)
                case 'No'
            end
        else
            movefile(handles.file{i}, ac_pwd)
        end
    elseif strcmp(copycut,'copy')
        % paste copied files
        new_name = handles.data_name{i};
        new_name_w_dir = [ac_pwd,handles.slash_v,new_name];
        if exist(new_name_w_dir)
            %disp('exist files')
            [~,dat_name,ext] = fileparts(new_name);
            for i = 1:100
                new_name = [dat_name,'_copy',num2str(i),ext];
                if exist([ac_pwd,handles.slash_v,new_name])
                else
                    break
                end
            end
        end
        new_file = [ac_pwd,handles.slash_v,new_name];
        file_list = handles.file;
        copyfile(file_list{1}, new_file)
    end
end
d = dir; %get files
set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
refreshcolor;
if isdir(pre_dirML)
cd(pre_dirML);
end


% --------------------------------------------------------------------
function menu_delete_Callback(hObject, eventdata, handles)
% hObject    handle to menu_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
deletefile = 0;

choice = questdlg('You are going to DELETE the selected file(s)', ...
	'Warning', 'Yes','No','No');
% Handle response
switch choice
    case 'No'
        deletefile = 0;
    case 'Yes'
        %disp([choice ' coming right up.'])
        deletefile = 1;
end

if deletefile == 1
    list_content = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
    selected = handles.index_selected;  % read selection in listbox 1; minus 2 for listbox
    nplot = length(selected);   % length
    CDac_pwd; % cd working dir
    % handles.listnumber = handles.listnumber - nplot;
    if selected > 2
        
        for i = 1:nplot
            plot_no = selected(i);
            % delete selected data
            plot_filter_selection = char(list_content(plot_no));
            
            if plot_no > 2
                file_type = exist(plot_filter_selection);
                    if file_type == 0
                        plot_filter_selection = strrep2(plot_filter_selection, '<HTML><FONT color="blue">', '</FONT></HTML>');
                    end
                if isdir(plot_filter_selection)
                    choice = questdlg('DELETE selected folder and files within it', ...
                        'Warning', 'Yes','No','No');
                    % Handle response
                    switch choice
                        case 'No'
                        case 'Yes'
                            status = rmdir(plot_filter_selection,'s');
                    end
                else
                    delete(plot_filter_selection);
                end
            end
        end
        d = dir; %get files
        set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
        refreshcolor;
        cd(pre_dirML);
    end
    guidata(hObject,handles)
end

% --------------------------------------------------------------------
function menu_noise_Callback(hObject, eventdata, handles)
% hObject    handle to menu_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Start time (t1)',...
        'End time (t2, and t2 > t1)',...
        'Sample rates',...
        'Standard deviation','Type: 0 = random; 1 = normal distribution'};
dlg_title = 'White noise series';
num_lines = 1;
defaultans = {'1','1000','1','1','0'};
options.Resize='on';
answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
if ~isempty(answer)
t1 = str2double(answer{1});
t2 = str2double(answer{2});
sr = str2double(answer{3});
amp = str2double(answer{4});
type = str2double(answer{5});

t = t1:sr:t2;
data(:,1) = t';
if type == 1
    data(:,2) = amp * randn(length(t),1);
    dat_name = 'rand-n';
else
    data(:,2) = amp * rand(length(t),1);
    dat_name = 'rand';
end
% cd ac_pwd dir
CDac_pwd
dlmwrite([dat_name,'-noise.txt'], data, 'delimiter', ',', 'precision', 9);
end
d = dir; %get files
set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
refreshcolor;
cd(pre_dirML); % return to matlab view folder


% --- Executes during object creation, after setting all properties.
function menu_red_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function menu_red_Callback(hObject, eventdata, handles)
% hObject    handle to menu_red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Start time (t1)',...
        'End time (t2, and t2 > t1)',...
        'Sample rates',...
        'Standard deviation',...
        'RHO-1 (from 0 to 1)'};
dlg_title = 'Red noise series';
num_lines = 1;
defaultans = {'1','1000','1','1','0.5'};
options.Resize='on';
answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
if ~isempty(answer)
t1 = str2double(answer{1});
t2 = str2double(answer{2});
sr = str2double(answer{3});
amp = str2double(answer{4});
rho1 = str2double(answer{5});

t = t1:sr:t2;
data(:,1) = t';
data(:,2) = amp * zscore(redmark(rho1,length(t)));
% cd ac_pwd dir
CDac_pwd
dlmwrite(['rednoise',num2str(rho1),'.txt'], data, 'delimiter', ',', 'precision', 9);

d = dir; %get files
set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
refreshcolor;
cd(pre_dirML); % return to matlab view folder
end


% --------------------------------------------------------------------
function menu_add_Callback(hObject, eventdata, handles)
% hObject    handle to menu_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = handles.index_selected;  % read selection in listbox 1
nplot = length(plot_selected);   % length
% check
check = 0;
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        if isdir(plot_filter_s)
            return
        else
            [~,~,ext] = fileparts(plot_filter_s);
            if sum(strcmp(ext,handles.filetype)) > 0
                if nplot >1
                check = 1; % selection can be executed 
                end
            else
                return
            end
        end
    else
        return
    end
end

if check == 1;
    plot_filter_s2 = char(contents(plot_selected(1)));
    GETac_pwd; plot_filter_s2 = fullfile(ac_pwd,plot_filter_s2);
    dat_new = load(plot_filter_s2);
    if i > 1
        for i = 2:nplot
            plot_no = plot_selected(i);
            plot_filter_s = char(contents(plot_no));
            data_filterout = load(fullfile(ac_pwd,plot_filter_s));
            dat_new = [dat_new; data_filterout];
            dat_merge = sortrows(dat_new);
        end
    else
    end
    dat_merge = findduplicate(dat_merge);
    % cd ac_pwd dir
    CDac_pwd
    dlmwrite('mergedseries.txt', dat_merge, 'delimiter', ',', 'precision', 9);
    d = dir; %get files
set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
refreshcolor;
cd(pre_dirML); % return to matlab view folder
end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function menu_sort_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function menu_sort_Callback(hObject, eventdata, handles)
% hObject    handle to menu_sort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
disp(['Select ',num2str(nplot),' data'])
%if and ((min(plot_selected) > 2), (nplot == 1))
for nploti = 1:nplot
if plot_selected > 2
    prompt = {'Sort data in ascending order?','Unique values in data?','Remove empty row?','Apply to ALL'};
        dlg_title = 'Sort, Unique & Remove empty (1 = yes)';
        num_lines = 1;
        defaultans = {num2str(handles.math_sort),num2str(handles.math_unique),num2str(handles.math_deleteempty),'0'};
        options.Resize='on';
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
        if ~isempty(answer)
            datasort = str2double(answer{1});
            dataunique = str2double(answer{2});
            dataempty = str2double(answer{3});
            dataApply2ALL = str2double(answer{4});
            
            if dataApply2ALL == 1
                for nploti = 1:nplot
                % Apply settings to all data
                    data_name_all = (contents(plot_selected));
                    data_name = char(data_name_all{nploti});
                    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
                    disp(['>>  Processing ', data_name]);
                    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
                    data_error = 0;
                    if isdir(data_name) == 1
                    else
                        [~,dat_name,ext] = fileparts(data_name);
                        if sum(strcmp(ext,handles.filetype)) > 0
                            try
                                fid = fopen(data_name);
                                data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
                                fclose(fid);
                                if iscell(data_ft)
                                    try
                                        data = cell2mat(data_ft);
                                    catch
                                        fid = fopen(data_name,'at');
                                        fprintf(fid,'%d\n',[]);
                                        fclose(fid);
                                        fid = fopen(data_name);
                                        data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', Inf);
                                        fclose(fid);
                                        try
                                            data = cell2mat(data_ft);
                                        catch
                                            warndlg(['Check data file: ', dat_name],'Data Error!')
                                            disp(['      Error! Skipped. Check the data file:', dat_name]);
                                            data_error = 1;
                                        end
                                    end
                                end
                            catch
                                data = load(data_name);
                            end
                            if data_error ==1
                            else
                                data = data(~any(isnan(data),2),:); % remove NaN values
                                if datasort == 1
                                    data = sortrows(data);
                                    name1 = [dat_name,'-so'];
                                end
                                if dataunique == 1
                                    data=findduplicate(data);
                                    name1 = [dat_name,'-u'];  % New name
                                end
                                if (datasort + dataunique) == 2
                                    name1 = [dat_name,'-su'];  % New name
                                end
                                if dataempty == 1
                                    data(any(isinf(data),2),:) = [];
                                    if (datasort + dataunique) > 0
                                        name1 = [name1,'e'];  % New name
                                    else
                                        name1 = [dat_name,'-e'];  % New name
                                    end
                                end
                                if (datasort + dataunique + dataempty) > 0
                                    name2 = [name1,ext];
                                else
                                    name2 = [dat_name,ext];
                                end
                                % remember settings
                                handles.math_sort = datasort;
                                handles.math_unique = dataunique;
                                handles.math_deleteempty = dataempty;

                                % cd ac_pwd dir
                                CDac_pwd
                                dlmwrite(name2, data, 'delimiter', ',', 'precision', 9);
                            end
                        end
                    end
                end
                d = dir; %get files
                set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                refreshcolor;
                cd(pre_dirML); % return to matlab view folder
                return
            else
                data_name_all = (contents(plot_selected));
                data_name = char(data_name_all{nploti});
                data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
                disp(['>>  Processing ', data_name]);
                GETac_pwd; data_name = fullfile(ac_pwd,data_name);
                data_error = 0;
                if isdir(data_name) == 1
                else
                    [~,dat_name,ext] = fileparts(data_name);
                    if sum(strcmp(ext,handles.filetype)) > 0
                        try
                            fid = fopen(data_name);
                            data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
                            fclose(fid);
                            if iscell(data_ft)
                                try
                                    data = cell2mat(data_ft);
                                catch
                                    fid = fopen(data_name,'at');
                                    fprintf(fid,'%d\n',[]);
                                    fclose(fid);
                                    fid = fopen(data_name);
                                    data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', Inf);
                                    fclose(fid);
                                    try
                                        data = cell2mat(data_ft);
                                    catch
                                        % length of 2 columns are not equal
                                        lengthmin = min(length(data_ft{1,1}), length(data_ft{1,2}));
                                        data_ft1 = data_ft{1,1};
                                        data_ft2 = data_ft{1,2};
                                        data_ft_new{1,1} = data_ft1(1:lengthmin);
                                        data_ft_new{1,2} = data_ft2(1:lengthmin);
                                        try 
                                            data = cell2mat(data_ft_new);
                                        catch
                                            warndlg(['Check data file: ', dat_name],'Data Error!')
                                            disp(['      Error! Check the data file:', dat_name]);
                                            data_error = 1;
                                        end
                                    end
                                end
                            end
                        catch
                            data = load(data_name);
                        end
                        if data_error == 1
                        else
                            data = data(~any(isnan(data),2),:); % remove NaN values
                            if datasort == 1
                                data = sortrows(data);
                                name1 = [dat_name,'-so'];
                            end
                            if dataunique == 1
                                data=findduplicate(data);
                                name1 = [dat_name,'-u'];  % New name
                            end
                            if (datasort + dataunique) == 2
                                name1 = [dat_name,'-su'];  % New name
                            end
                            if dataempty == 1
                                data(any(isinf(data),2),:) = [];
                                if (datasort + dataunique) > 0
                                    name1 = [name1,'e'];  % New name
                                else
                                    name1 = [dat_name,'-e'];  % New name
                                end
                            end
                            if (datasort + dataunique + dataempty) > 0
                                name2 = [name1,ext];
                            else
                                name2 = [dat_name,ext];
                            end
                            % remember settings
                            handles.math_sort = datasort;
                            handles.math_unique = dataunique;
                            handles.math_deleteempty = dataempty;

                            % cd ac_pwd dir
                            CDac_pwd
                            dlmwrite(name2, data, 'delimiter', ',', 'precision', 9);
                            d = dir; %get files
                            set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                            refreshcolor;
                            cd(pre_dirML); % return to matlab view folder
                        end
                    end
                end
            end
        end
end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_sr2age_Callback(hObject, eventdata, handles)
% hObject    handle to menu_sr2age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
        [~,dat_name,ext] = fileparts(data_name);
        if sum(strcmp(ext,handles.filetype)) > 0
            
            data = load(data_name);
            data = data(~any(isnan(data),2),:);
            data = sortrows(data);
            
            time = data(:,1);
            value = data(:,2);
            npts = length(time);
            agemodel = zeros(npts,2);
            agemodel(:,1) = time;
            for i = 2:npts
                agemodel(i,2) = 100*(time(i)-time(i-1))/value(i-1)+agemodel(i-1,2);
            end
            name1 = [dat_name,'-agemod',ext];  % New name
            % cd ac_pwd dir
                CDac_pwd
            dlmwrite(name1, agemodel, 'delimiter', ',', 'precision', 9);
            d = dir; %get files
            set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
            refreshcolor;
            cd(pre_dirML); % return to matlab view folder
        end
        end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function munu_plot_stairs_Callback(hObject, eventdata, handles)
% hObject    handle to munu_plot_stairs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
% check
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        if isdir(plot_filter_s)
            return
        else
            [~,~,ext] = fileparts(plot_filter_s);
            check = 0;
            if sum(strcmp(ext,handles.filetype)) > 0
                check = 1; % selection can be executed 
            end
        end
    else
        return
    end
end

if check == 1
%     prompt = {'Interpolation sample rate for stairs'};
%     dlg_title = 'Input sample rate (1 = yes)';
%     num_lines = 1;
%     defaultans = {'0.1'};
%     options.Resize='on';
%     answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
%     if ~isempty(answer)
%         dt = str2double(answer{1});
        
        figure;
        hold on;
        for j = 1: nplot
            plot_no = plot_selected(j);
            plot_filter_s = char(contents(plot_no));
            GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
%            data = load(plot_filter_s);
     try
        fid = fopen(plot_filter_s);
        data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
        fclose(fid);
        if iscell(data_ft)
            data = cell2mat(data_ft);
        end
    catch
        data = load(plot_filter_s);
    end 

            data = data(~any(isnan(data),2),:);
            stairs(data(:,1),data(:,2),'LineWidth',1,'Color','k');
        end
        set(gca,'XMinorTick','on','YMinorTick','on')
        if handles.unit_type == 0;
            xlabel(['Unit (',handles.unit,')'])
        elseif handles.unit_type == 1;
            xlabel(['Depth (',handles.unit,')'])
        else
            xlabel(['Time (',handles.unit,')'])
        end
        title(plot_filter_s)
%     end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function menu_plotplus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to menu_plotplus

% --------------------------------------------------------------------
function menu_plotplus_Callback(hObject, eventdata, handles)
% hObject    handle to menu_plotplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length

% check
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        if isdir(plot_filter_s)
            return
        else
            [~,~,ext] = fileparts(plot_filter_s);
            check = 0;
            if sum(strcmp(ext,handles.filetype)) > 0
                check = 1; % selection can be executed 
            elseif sum(strcmp(ext,{'.jpg','.jpeg','.JPG','.JPEG','.png','.PNG','.tif','.TIF'})) > 0
                try 
                    im_name = imread(plot_filter_s);
                    figure;
                    imshow(im_name)
                    set(gcf,'Name',[dat_name,ext])
                    set(gcf,'color','w');
                catch
                end
            end
        end
    else
        return
    end
end
if check == 1
    GETac_pwd; %plot_filter_s = fullfile(ac_pwd,plot_filter_s);
    for i = 1: nplot
        plot_no = plot_selected(i);
        handles.plot_s{i} = fullfile(ac_pwd,char(contents(plot_no)));
    end
    handles.nplot = nplot;
    guidata(hObject, handles);
    PlotAdv(handles);
end


% --------------------------------------------------------------------
function menu_rho_Callback(hObject, eventdata, handles)
% hObject    handle to menu_rho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nsim_yes = 0;

choice = questdlg('Single run or Monte Carlo Simulation', ...
	'Select', 'Single','Monte Carlo','Cancel','Single');
% Handle response
switch choice
    case 'Single'
        nsim_yes = 0;
    case 'Monte Carlo'
        %disp([choice ' coming right up.'])
        nsim_yes = 1;
    case 'Cancel'
        nsim_yes = 2;
end
if nsim_yes < 2
    contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
    plot_selected = get(handles.listbox_acmain,'Value');
    nplot = length(plot_selected);   % length
if nplot > 1
    warndlg('Select 1 data','Error');
end
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
            if sum(strcmp(ext,handles.filetype)) > 0
                data = load(data_name);
                samplerate = diff(data(:,1));
                ndata = length(data(:,1));
                datalength = data(length(data(:,1)),1)-data(1,1);
                samp1 = min(samplerate);
                samp2 = max(samplerate);
                sampmedian = median(samplerate);

                if nsim_yes == 0
                    prompt = {'Window',...
                    'Sample rate (Default = median)'};
                    dlg_title = 'Evolutionary RHO in AR(1)';
                    num_lines = 1;
                    defaultans = {num2str(.3 * datalength),num2str(sampmedian)};
                    options.Resize='on';
                    answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
                    if ~isempty(answer)
                        window = str2double(answer{1});
                        interpolate_rate= str2double(answer{2});
                        [data_even] = interpolate(data,interpolate_rate);
                        [rhox] = erhoAR1(data_even,window);

                        figure; plot(rhox(:,1),rhox(:,2),'LineWidth',1)
                            if handles.unit_type == 0;
                                xlabel(['Unit (',handles.unit,')'])
                            elseif handles.unit_type == 1;
                                xlabel(['Depth (',handles.unit,')'])
                            else
                                xlabel(['Time (',handles.unit,')'])
                            end
                        set(gca,'XMinorTick','on','YMinorTick','on')
                        ylabel('RHO in AR(1)')
                        title(['Window = ',num2str(window),'. Sample rate = ',num2str(interpolate_rate)])

                        name1 = [dat_name,'-rho1.txt'];
                        CDac_pwd
                        if exist([pwd,handles.slash_v,name1])
                            for i = 1:100
                                name1 = [dat_name,'-rho1-',num2str(i),'.txt'];
                                if exist([pwd,handles.slash_v,name1])
                                else
                                     break
                                end
                            end
                        end
                        dlmwrite(name1, rhox, 'delimiter', ',', 'precision', 9); 
                        disp(['>>  Save rho1    : ',name1])   
                        cd(pre_dirML); % return to matlab view folder
                    end
                else
                    prompt = {'Monte Carlo simulations',...
                    'Window ranges from',...
                    'Window ranges to',...
                    'Sample rate from',...
                    'Sample rate to',...
                    'Plot: interpolation',...
                    'Plot: shift grids (Default = 15; no shift = 1)'};
                dlg_title = 'Monte Carlo Simulation of eRHO in AR(1)';
                num_lines = 1;
                if ndata > 1000;
                    interpn = 1000;
                else
                    interpn = ndata;
                end
                defaultans = {'1000',num2str(.3 * datalength),num2str(.4 * datalength),...
                    num2str(samp1),num2str(samp2),num2str(interpn),'15'};
                options.Resize='on';
                answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
                if ~isempty(answer)
                    nsim = str2double(answer{1});
                    window1 = str2double(answer{2});
                    window2 = str2double(answer{3});
                    samprate1 = str2double(answer{4});
                    samprate2 = str2double(answer{5});
                    nout = str2double(answer{6});
                    shiftwin = str2double(answer{7});

                    % Waitbar
                    hwaitbar = waitbar(0,'Noise estimation - rho1: Monte Carlo processing ...',...    
                       'WindowStyle','modal');
                    hwaitbar_find = findobj(hwaitbar,'Type','Patch');
                    set(hwaitbar_find,'EdgeColor',[0 0.9 0],'FaceColor',[0 0.9 0]) % changes the color to blue
                    steps = 100;
                    % step estimation for waitbar
                    nmc_n = round(nsim/steps);
                    waitbarstep = 1;
                    waitbar(waitbarstep / steps)
                    %
                  if nsim >= 50
                    samplez = samprate1+(samprate2-samprate1)*rand(1,nsim);
                    window_sim = window1 + (window2-window1) * rand(1,nsim);
                    y_grid = linspace(data(1,1),data(length(data(:,1)),1),nout);
                    y_grid = y_grid';
                    powy = zeros(nout,nsim);
                    if shiftwin > 1
                        for i=1:nsim
                            window = window_sim(i);
                            interpolate_rate= samplez(i);
                            [data_even] = interpolate(data,interpolate_rate);
                            [rhox] = erhoAR1(data_even,window);
                            y_grid_rand = -1*window/2 + window * rand(1);
                            % interpolation
                            powy(:,i)=interp1((rhox(:,1)+y_grid_rand),rhox(:,2),y_grid);
                            disp(['Simulation step = ',num2str(i),' / ',num2str(nsim)]);
                            
                            if rem(i,nmc_n) == 0
                                waitbarstep = waitbarstep+1; 
                                if waitbarstep > steps; waitbarstep = steps; end
                                pause(0.001);%
                                waitbar(waitbarstep / steps)
                            end
                        end
                    elseif shiftwin == 1
                        for i=1:nsim
                            window = window_sim(i);
                            interpolate_rate= samplez(i);
                            [data_even] = interpolate(data,interpolate_rate);
                            [rhox] = erhoAR1(data_even,window);
                            % interpolation
                            powy(:,i)=interp1(rhox(:,1),rhox(:,2),y_grid);
                            disp(['Simulation step = ',num2str(i),' / ',num2str(nsim)]);
                            if rem(i,nmc_n) == 0
                                waitbarstep = waitbarstep+1; 
                                if waitbarstep > steps; waitbarstep = steps; end
                                pause(0.001);%
                                waitbar(waitbarstep / steps)
                            end
                        end
                    end  
                    
                    if ishandle(hwaitbar); 
                        close(hwaitbar);
                    end
                    
                    percent =[2.5,5,10,15.865,25,50,75,84.135,90,95,97.5];
                    npercent  = length(percent);
                    npercent2 = (length(percent)-1)/2;
                    powyp = prctile(powy, percent,2);

                    for i = 1: npercent
                        powyadjustp1=powyp(:,i);
                        powyad_p_nan(:,i) = powyadjustp1(~isnan(powyadjustp1));
                    end
                    y_grid_nan = y_grid(~isnan(powyp(:,1)));

                    figure;hold all
                    colorcode = [221/255,234/255,224/255; ...
                    201/255,227/255,209/255; ...
                    176/255,219/255,188/255;...
                    126/255,201/255,146/255;...
                    67/255,180/255,100/255];
                    for i = 1:npercent2
                        fill([y_grid_nan; (fliplr(y_grid_nan'))'],[powyad_p_nan(:,npercent+1-i);...
                        (fliplr(powyad_p_nan(:,i)'))'],colorcode(i,:),'LineStyle','none');
                    end
                    plot(y_grid,powyp(:,npercent2+1),'Color',[0,120/255,0],'LineWidth',1.5,'LineStyle','--')
                    hold off
                    if handles.unit_type == 0;
                        xlabel(['Unit (',handles.unit,')'])
                    elseif handles.unit_type == 1;
                        xlabel(['Depth (',handles.unit,')'])
                    else
                        xlabel(['Time (',handles.unit,')'])
                    end
                    set(gca,'XMinorTick','on','YMinorTick','on')
                    ylabel('RHO in AR(1)')
                    legend('2.5% - 97.5%', '5% - 95%', '10% - 90%','15.87% - 84.14%', '25% - 75%', 'Median')
                    title(['Window: ',num2str(window1),'-',num2str(window2),...
                        '. Sample rate: ',num2str(samprate1),'-',num2str(samprate2)])

                    name1 = [dat_name,'-rho1-median.txt'];
                    data1 = [y_grid_nan,powyad_p_nan(:,npercent2+1)];
                    name2 = [dat_name,'-rho1-percentile.txt'];
                    data2 = [y_grid_nan,powyad_p_nan];
                    CDac_pwd
                    if exist([pwd,handles.slash_v,name1]) || exist([pwd,handles.slash_v,name2])
                        for i = 1:100
                            name1 = [dat_name,'-rho1-median-',num2str(i),'.txt'];
                            name1 = [dat_name,'-rho1-percentile-',num2str(i),'.txt'];
                            if exist([pwd,handles.slash_v,name1]) || exist([pwd,handles.slash_v,name2])
                            else
                                 break
                            end
                        end
                    end
                    dlmwrite(name1, data1, 'delimiter', ',', 'precision', 9); 
                    dlmwrite(name2, data2, 'delimiter', ',', 'precision', 9); 
                    disp(['>>  Save rho1 median    : ',name1])   
                    disp(['>>  Save rho1 percentile: ',name2])  
                    %cd(pre_dirML); % return to matlab view folder
                    
                    d = dir; %get files
                    set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                    refreshcolor;
                    cd(pre_dirML);
                else
                    errordlg('Number simulations is too few, try 1000','Error');
                end
                end
                end
            end
        end
end
guidata(hObject, handles);
end

% --------------------------------------------------------------------
function menu_folder_Callback(hObject, eventdata, handles)
% hObject    handle to menu_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Type name of the folder'};
dlg_title = 'Create a Folder in the working directory';
num_lines = 1;
defaultans = {'newfolder'};
options.Resize='on';
answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
if ~isempty(answer)
    foldername = (answer{1});
    
    CDac_pwd;   
    mkdir([ac_pwd,handles.slash_v,foldername]);
    addpath(genpath([ac_pwd,handles.slash_v,foldername]));
    cd(ac_pwd);
    refreshcolor;
    cd(pre_dirML);
end


% --------------------------------------------------------------------
function sinewave_Callback(hObject, eventdata, handles)
% hObject    handle to sinewave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Start time (t1)',...
        'End time (t2, and t2 > t1)',...
        'Sampling rates (<< t2-t1)',...
        'Amplitude',...
        'Period (T)',...
        'Phase (pi, 0.25*pi, etc.)',...
        'Signal bias'};
dlg_title = 'Sine wave: Y=A*sin(2*pi/T*X+Ph)+bias';
num_lines = 1;
defaultans = {'1','1000','1','1','100','0','0'};
options.Resize='on';
answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
if ~isempty(answer)
    
t1 = str2double(answer{1});
t2 = str2double(answer{2});
sr = str2double(answer{3});
A = str2double(answer{4});
T = str2double(answer{5});
Ph = str2double(answer{6});
B = str2double(answer{7});

x = t1:sr:t2;
x = x';
y = A * sin(2*pi/T*x + Ph) + B;
data(:,1) = x;
data(:,2) = y;

CDac_pwd  % cd ac_pwd dir
dlmwrite(['sineA',num2str(A),'T',num2str(T),'Ph',num2str(Ph),'B',num2str(B),'.txt'],...
    data, 'delimiter', ',', 'precision', 9);
end
d = dir; %get files
set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
refreshcolor;
cd(pre_dirML); % return to matlab view folder


% --------------------------------------------------------------------
function menu_email_Callback(hObject, eventdata, handles)
% hObject    handle to menu_email (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
email


% --------------------------------------------------------------------
function menu_samplerate_Callback(hObject, eventdata, handles)
% hObject    handle to menu_samplerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = handles.index_selected;  % read selection in listbox 1
nplot = length(plot_selected);   % length
% check
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        if isdir(plot_filter_s)
            return
        else
            [~,dat_name,ext] = fileparts(plot_filter_s);
            check = 0;
            if sum(strcmp(ext,handles.filetype)) > 0
                check = 1; % selection can be executed 
            end
        end
    else
        return
    end
end

if check == 1;
    for i = 1:nplot
        plot_no = plot_selected(i);
            plot_filter_s = char(contents(plot_no));
            GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
            
     try
        fid = fopen(plot_filter_s);
        data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
        fclose(fid);
        if iscell(data_ft)
            data_filterout = cell2mat(data_ft);
        end
    catch
        data_filterout = load(plot_filter_s);
    end 
            
            t = data_filterout(:,1);
            dt = diff(t);
            len_t = length(t);
            figure;
            datasamp = [t(1:len_t-1),dt];
            datasamp = datasamp(~any(isnan(datasamp),2),:);
            %[dat] = n2stair(datasamp,min(dt)/10);
            %plot(dat(:,1),dat(:,2),'k','LineWidth',1);
            stairs(datasamp(:,1),datasamp(:,2),'LineWidth',1,'Color','k');
            set(gca,'XMinorTick','on','YMinorTick','on')
            set(gcf,'Color', 'white')
            set(0,'Units','normalized') % set units as normalized
            set(gcf,'units','norm') % set location
            set(gcf,'position',[0.1,0.5,0.45,0.45]) % set position
            set(gcf,'Name', 'Sampling rate (original domain)')
            %plot(data_filterout(1:(len_t-1),1),dt);
            if handles.unit_type == 0;
                xlabel(['Unit (',handles.unit,')'])
                ylabel('Unit')
            elseif handles.unit_type == 1;
                xlabel(['Depth (',handles.unit,')'])
                ylabel(handles.unit)
            else
                xlabel(['Time (',handles.unit,')'])
                ylabel(handles.unit)
            end
            
            title([[dat_name,ext],': sampling rate'])
            xlim([min(datasamp(:,1)),max(datasamp(:,1))])
            ylim([0.9*min(dt) max(dt)*1.1])
            
            figure;
            histfit(dt,[],'kernel')
            set(gcf,'Color', 'white')
            set(0,'Units','normalized') % set units as normalized
            set(gcf,'units','norm') % set location
            set(gcf,'position',[0.55,0.5,0.45,0.45]) % set position
            title([[dat_name,ext],': kernel fit of sampling rates'])
            set(gcf,'Name', 'Sampling rate: distribution')
            if handles.unit_type == 0;
                xlabel(['Sampling rate (',handles.unit,')'])
            elseif handles.unit_type == 1;
                xlabel(['Sampling rate (',handles.unit,')'])
            else
                xlabel(['Sampling rate (',handles.unit,')'])
            end
            ylabel('Number')
            note = ['max: ',num2str(max(dt)),'; mean: ',num2str(mean(dt)),...
                '; median: ',num2str(median(dt)),'; min: ',num2str(min(dt))];
            legend(note)
            %text(mean(dt),len_t/10,note);
    end
end
guidata(hObject,handles)

% --------------------------------------------------------------------
function menu_datadistri_Callback(hObject, eventdata, handles)
% hObject    handle to menu_datadistri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = handles.index_selected;  % read selection in listbox 1
nplot = length(plot_selected);   % length
% check
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        if isdir(plot_filter_s)
            return
        else
            [~,dat_name,ext] = fileparts(plot_filter_s);
            check = 0;
            if sum(strcmp(ext,handles.filetype)) > 0
                check = 1; % selection can be executed 
            end
        end
    else
        return
    end
end

if check == 1;
    for i = 1:nplot
        plot_no = plot_selected(i);
            plot_filter_s = char(contents(plot_no));
            GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
     %       data_filterout = load(plot_filter_s); % load data
    try
        fid = fopen(plot_filter_s);
        data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', NaN);
        fclose(fid);
        if iscell(data_ft)
            data_filterout = cell2mat(data_ft);
        end
    catch
        data_filterout = load(plot_filter_s);
    end 

            datax = data_filterout(:,2);
            figure;
            histfit(datax,[],'kernel')
            set(gcf,'Name', 'Data Distribution')
            title([[dat_name,ext],': kernel fit of the data'])
            xlabel('Data')
            note = ['max: ',num2str(max(datax)),'; mean: ',num2str(mean(datax)),...
                '; median: ',num2str(median(datax)),'; min: ',num2str(min(datax))];
            %text(mean(datax),length(datax)/10,note);
            legend(note)
    end
end
guidata(hObject,handles)


% --------------------------------------------------------------------
function menu_addPath_Callback(hObject, eventdata, handles)
% hObject    handle to menu_addPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = handles.index_selected;  % read selection in listbox 1
nplot = length(plot_selected);   % length
% check
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        %GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        if isdir(plot_filter_s)
            addpath(genpath(plot_filter_s));
        end
    else
        return
    end
end


% --------------------------------------------------------------------
function menu_pda_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = handles.index_selected;  % read selection in listbox 1
nplot = length(plot_selected);   % length
% check
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        if isdir(plot_filter_s)
            return
        else
            [~,~,ext] = fileparts(plot_filter_s);
            check = 0;
            if sum(strcmp(ext,handles.filetype)) > 0
                check = 1; % selection can be executed 
            else
                errordlg('Error: Selected file must be a supported type (*.txt,*.csv).');
            end
        end
    else
        return
    end
end

if check == 1;
    prompt = {'Paired frequency bands (space delimited):',...
        'Window (kyr):',...
        'Time-bandwidth product, nw:',...
        'Lower cutoff frequency (>= 0)',...
        'Upper cutoff frequency (<= nyquist)',...
        'Step of calculations:',...
        'Zero-padding number:',...
        'Save Results (1 = Yes; 0 = No):'};
    dlg_title = 'Power Decomposition analysis';
    num_lines = 1;
    defaultans = {'1/45 1/25','500','2',num2str(handles.f1),num2str(handles.f2),'1','5000','0'};
    options.Resize='on';
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
    if ~isempty(answer)
        f3 = str2num(answer{1});
        %f3 = sort(f3);
        window = str2double(answer{2});
        nw = str2double(answer{3});
        ftmin = str2double(answer{4});
        fterm = str2double(answer{5});
        step = str2double(answer{6});
        pad = str2double(answer{7});
        savedata = str2double(answer{8});
        for i = 1:nplot
            
            figure;
            plot_no = plot_selected(i);
            plot_filter_s = char(contents(plot_no));
            plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
            GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
            [~,dat_name,ext] = fileparts(plot_filter_s);
            data = load(plot_filter_s);
            data = data(~any(isnan(data),2),:);
            
            disp1 = ['Data: ',plot_filter_s, 'Window = ',num2str(window),' kyr; NW =',num2str(nw)];
            disp2 = ['    cutoff freqency:',num2str(ftmin),'-',num2str(fterm),'; Step =',num2str(step),'; Pad = ',num2str(pad)];
            disp3 = ['    pairs of frequency bands:'];
            disp(disp1)
            disp(disp2)
            disp(disp3)
            disp(f3)
            disp('Wait ... ...')
            [pow]=pdan(data,f3,window,nw,ftmin,fterm,step,pad);
            plot(pow(:,1),pow(:,2),'k','LineWidth',1);
            set(gca,'XMinorTick','on','YMinorTick','on')
            xlabel('Time (kyr)')
            ylabel('Power ratio')
            title(plot_filter_s)
            if savedata == 1
                name1 = [dat_name,'-win',num2str(window),'-pda',ext];
                CDac_pwd  % cd ac_pwd dir
                dlmwrite(name1, pow, 'delimiter', ',', 'precision', 9); 
                refreshcolor;
                cd(pre_dirML); % return to matlab view folder
            end
            
        end
        disp('Done')
    end
end
%end
guidata(hObject,handles)


% --------------------------------------------------------------------
function menu_desection_Callback(hObject, eventdata, handles)
% hObject    handle to menu_desection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
            if sum(strcmp(ext,handles.filetype)) > 0
                
                dat = load(data_name);
                dat = sortrows(dat);
                xmin = dat(1);
                xmax = dat(length(dat(:,1)));
                
                prompt = {'Start and End point(s) of section(s):'};
                    dlg_title = 'Remove Section(s)';
                    num_lines = 1;
                    defaultans = {''};
                    options.Resize='on';
                    answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
                    if ~isempty(answer)
                        answer = answer{1};
                        answer1 = textscan(answer,'%f','Delimiter',{';','*',',','\t','\b',' '},'Delimiter',',');
                        sec = answer1{1};
                        n_sec = length(sec);
                        if mod(n_sec,2) == 1
                            errordlg('Error: must be 2x points')
                        else
                            
                            [data0] = select_interval(dat,xmin,sec(1));
                            data_mer = data0;
                            d_accum = 0;
                            for i = 1: n_sec/2
                                d = sec(2*i) - sec(2*i-1);
                                d_accum = d + d_accum;
                                if i == n_sec/2
                                    [data1] = select_interval(dat,sec(2*i),xmax);
                                    data1(:,1) = data1(:,1) - d_accum;
                                    data_mer = [data_mer;data1];
                                else
                                    [data2] = select_interval(dat,sec(2*i),sec(2*i+1));
                                    data2(:,1) = data2(:,1) - d_accum;
                                    data_mer = [data_mer;data2];
                                end    
                            end
                            name1 = [dat_name,'-desec',ext];
                            disp(['>> Removed sections are ',answer])
                            CDac_pwd  % cd ac_pwd dir
                            dlmwrite(name1, data_mer, 'delimiter', ',', 'precision', 9); 
                            refreshcolor;
                            cd(pre_dirML); % return to matlab view folder
                        end
                    end
            end
        end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_gap_Callback(hObject, eventdata, handles)
% hObject    handle to menu_gap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
if and ((min(plot_selected) > 2), (nplot == 1))
    data_name = char(contents(plot_selected));
    data_name = strrep2(data_name, '<HTML><FONT color="blue">', '</FONT></HTML>');
    GETac_pwd; data_name = fullfile(ac_pwd,data_name);
        if isdir(data_name) == 1
        else
            [~,dat_name,ext] = fileparts(data_name);
            if sum(strcmp(ext,handles.filetype)) > 0
                
                dat = load(data_name);
                dat = sortrows(dat);
                xmin = dat(1);
                xmax = dat(length(dat(:,1)));
                
                prompt = {'Location and duration of the gap(s): (comma-separated)'};
                    dlg_title = 'Add Gap(s)';
                    num_lines = 1;
                    defaultans = {''};
                    options.Resize='on';
                    answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
                    if ~isempty(answer)
                        answer = answer{1};
                        answer1 = textscan(answer,'%f','Delimiter',{';','*',',','\t','\b',' '},'Delimiter',',');
                        sec = answer1{1};
                        n_sec = length(sec);
                        if mod(n_sec,2) == 1
                            errordlg('Error: 1 location must have 1 duration')
                        else
                            [data0] = select_interval(dat,xmin,sec(1));
                            data_mer = data0;
                            d_accum = 0;
                            for i = 1: n_sec/2
                                d = sec(2*i);
                                d_accum = d + d_accum;
                                if i == n_sec/2
                                    [data1] = select_interval(dat,sec(2*i-1),xmax);
                                    data1(:,1) = data1(:,1) + d_accum;
                                    data_mer = [data_mer;data1];
                                else
                                    [data2] = select_interval(dat,sec(2*i-1),sec(2*i+1));
                                    data2(:,1) = data2(:,1) + d_accum;
                                    data_mer = [data_mer;data2];
                                end    
                            end
                            name1 = [dat_name,'-wgap',ext];
                            disp(['>> Gap location and duration are ',answer])
                            CDac_pwd  % cd ac_pwd dir
                            dlmwrite(name1, data_mer, 'delimiter', ',', 'precision', 9); 
                            refreshcolor;
                            cd(pre_dirML); % return to matlab view folder
                        end
                    end
            end
        end
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menu_insol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to menu_copy
% --------------------------------------------------------------------
function menu_insol_Callback(hObject, eventdata, handles)
% hObject    handle to menu_insol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
Insolation(handles);
%Insolation;


% --------------------------------------------------------------------
function Official_Callback(hObject, eventdata, handles)
% hObject    handle to Official (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function github_Callback(hObject, eventdata, handles)
% hObject    handle to github (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function menu_newtxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to menu_copy

% --------------------------------------------------------------------
function menu_newtxt_Callback(hObject, eventdata, handles)
% hObject    handle to menu_newtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Name of the new text file'};
dlg_title = 'New text file';
num_lines = 1;
defaultans = {'untitled.txt'};
options.Resize='on';
answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
if ~isempty(answer)
    
    CDac_pwd;
    filename = answer{1};
    if length(filename) < 4
        filename = [filename,'.txt'];
    else
        if strcmp(filename(end-3:end),'.txt')
        else
            filename = [filename,'.txt'];
        end
    end
    
    if exist([ac_pwd,handles.slash_v,filename])
        warndlg('File name exists. An alternative name used','File Name Warning')
        
        for i = 1:100
            filename = [filename(1:end-4),'-',num2str(i),'.txt'];
            if exist([ac_pwd,handles.slash_v,filename])
            else
                break
            end
        end
    end
    
    disp(['>>  Create a new data file entitled: ',filename])
    fid = fopen([ac_pwd,handles.slash_v,filename], 'wt' );
    fclose(fid);
    cd(ac_pwd);
    refreshcolor;
    cd(pre_dirML);
end


% --------------------------------------------------------------------
function menu_open_Callback(hObject, eventdata, handles)
% hObject    handle to menu_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.fig','Files (*.fig)'},...
    'Open *.fig file');
if filename == 0
%     open_data = 'Tips: open 2 colume data';
%     h = helpdlg(open_data,'Tips: Close');
%     uiwait(h); 
else
    aaa = [pathname,filename];
    openfig(aaa)
end


% --- Executes on mouse press over axes background.
function axes_up_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
CDac_pwd; % cd working dir
cd ..;
refreshcolor;
cd(pre_dirML); % return view dir
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function axes_refresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_refresh


% --- Executes on mouse press over axes background.
function axes_refresh_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
CDac_pwd; % cd working dir
refreshcolor;
cd(pre_dirML); % return view dir

% --- Executes during object creation, after setting all properties.
function menu_refreshlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_refresh
% --- Executes on mouse press over axes background.
function menu_refreshlist_Callback(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
CDac_pwd; % cd working dir
refreshcolor;
cd(pre_dirML); % return view dir

% --- Executes during object creation, after setting all properties.
function menu_opendir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function menu_opendir_Callback(hObject, eventdata, handles)
% hObject    handle to menu_opendir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CDac_pwd; % cd working dir
if ismac
    system(['open ',ac_pwd]);
elseif ispc
    winopen(ac_pwd);
end
cd(pre_dirML); % return view dir


% --- Executes on mouse press over axes background.
function axes_plot_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length

% check
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        if isdir(plot_filter_s)
            return
        else
            [~,~,ext] = fileparts(plot_filter_s);
            check = 0;
            if sum(strcmp(ext,handles.filetype)) > 0
                check = 1; % selection can be executed 
            elseif sum(strcmp(ext,{'.jpg','.jpeg','.JPG','.JPEG','.png','.PNG','.tif','.TIF'})) > 0
                try 
                    im_name = imread(plot_filter_s);
                    figure;
                    imshow(im_name)
                    set(gcf,'Name',[dat_name,ext])
                catch
                end
            end
        end
    else
        return
    end
end

if check == 1
    for i = 1: nplot
        plot_no = plot_selected(i);
        handles.plot_s{i} = fullfile(ac_pwd,char(contents(plot_no)));
    end
    handles.nplot = nplot;
    guidata(hObject, handles);
    PlotAdv(handles);
end


% --- Executes on mouse press over axes background.
function axes_folder_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fileID = fopen('ac_pwd.txt','r');
formatSpec = '%s';
ac_pwd = fscanf(fileID,formatSpec);   % AC window folder dir
fclose(fileID);
if ismac
    system(['open ',ac_pwd]);
elseif ispc
    winopen(ac_pwd);
end


% --- Executes on mouse press over axes background.
function axes_openfolder_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%acfigmain = gcf;
handles = guidata(hObject);
pre_dirML = pwd;
fileID = fopen('ac_pwd.txt','r');
formatSpec = '%s';
ac_pwd = fscanf(fileID,formatSpec);   % AC window folder dir
fclose(fileID);
selpath = uigetdir(ac_pwd);
if selpath == 0
else
    if isdir(selpath)
        disp(['>>  Change working folder to ',selpath])
        cd(selpath)
        refreshcolor;
        cd(pre_dirML); % return view dir
    end
end


% --- Executes on mouse press over axes background.
function axes_populate_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_populate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% refresh add color in the list box
handles = guidata(hObject);

% FULL VERSION
% Cannot use CDac_pwd here!!!
pre  = '<HTML><FONT color="blue">';
post = '</FONT></HTML>';
fileID = fopen('ac_pwd.txt','r');
formatSpec = '%s';
ac_pwd = fscanf(fileID,formatSpec);
fclose(fileID);
pre_dirML = pwd;

% get what is inside the folder
Infolder = dir(ac_pwd);
% Initialize the cell of string that will be update in the list box
MyListOfFiles = [];
% EXPEND SELECTED FOLDER

contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
%plot_selected = handles.index_selected;  % read selection in listbox 1
nplot = length(plot_selected);   % length

for i = 1:length(Infolder)
    if i > 2
        for m = 1:nplot
            plot_no = plot_selected(m);
            if plot_no > 2
                if isdir([ac_pwd,handles.slash_v,Infolder(plot_no).name])
                    cd(ac_pwd);
                    if i == plot_selected(m)
                        MyListOfFiles{end+1,1} = [pre Infolder(i).name post];
                        Infolder_i = dir([ac_pwd,handles.slash_v,Infolder(i).name]);
                        for j = 3:length(Infolder_i);  % don't pick the first two elements
                            if Infolder_i(j).isdir == 1
                                MyListOfFiles{end+1,1} = [pre '> ', Infolder_i(j).name post];
                                Infolder_j = dir([ac_pwd,handles.slash_v,Infolder(i).name,handles.slash_v,Infolder_i(j).name]);
                                for k = 3:length(Infolder_j)
                                    if Infolder_j(k).isdir == 1
                                        MyListOfFiles{end+1,1} = [pre '> > ', Infolder_j(k).name post];
                                    else
                                        MyListOfFiles{end+1,1} = ['----- ', Infolder_j(k).name];
                                    end
                                end
                            else
                                MyListOfFiles{end+1,1} = ['-- ',Infolder_i(j).name];
                            end
                        end
                    elseif Infolder(i).isdir == 1
                        if m == 1; MyListOfFiles{end+1,1} = [pre Infolder(i).name post]; end
                    else
                        MyListOfFiles{end+1,1} = Infolder(i).name;
                    end
                else
                    return
                end
            end
        end
    else
         MyListOfFiles{end+1,1} = Infolder(i).name;
    end
end
if and(nplot > 0, plot_selected(max(nplot))>2)
  set(handles.listbox_acmain,'String',MyListOfFiles,'Value',1) %set string   
end
cd(pre_dirML); % cd view dir


% --------------------------------------------------------------------
function menu_extract_Callback(hObject, eventdata, handles)
% hObject    handle to menu_extract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = handles.index_selected;  % read selection in listbox 1
nplot = length(plot_selected);   % length
% check
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        if isdir(plot_filter_s)
            return
        else
            [~,~,ext] = fileparts(plot_filter_s);
            check = 0;
            if sum(strcmp(ext,handles.filetype)) > 0
                check = 1; % selection can be executed 
            else
                errordlg('Error: unsupported file type')
            end
        end
    else
        return
    end
end

if check == 1;
    for i = 1:nplot
        plot_no = plot_selected(i);
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        [~,dat_name,ext] = fileparts(plot_filter_s);
        
        prompt = {'Original data: column #',...
            '1st column:',...
            '2nd column:'};
        dlg_title = 'Extract data';
        num_lines = 1;
        defaultans = {'2','1','2'};
        options.Resize='on';
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
        if ~isempty(answer)
            c0 = str2double(answer{1});
            c1 = str2double(answer{2});
            c2 = str2double(answer{3});
            if or(c1> c0, c2> c0)
                errordlg('Error: column is too large')
            elseif or(c1<1, c2<1)
                errordlg('Error: column is no less than 1')
            else
                try
                    data = load(plot_filter_s);
                catch       
                    fid = fopen(plot_filter_s);
                    data_ft = textscan(fid,'%f',c0,'Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', Inf);
                    %size(data_ft)
                    fclose(fid);
                    if iscell(data_ft)
                        data = cell2mat(data_ft);
                    end
                end
                [~, ncol] = size(data);

                data = data(~any(isnan(data),2),:);

                data_new(:,1) = data(:,c1);
                data_new(:,2) = data(:,c2);
                CDac_pwd  % cd ac_pwd dir
                % save data
                name1 = [dat_name,'-c',num2str(c1),'-c',num2str(c2),ext];  % New name
                %csvwrite(name1,current_data)
                dlmwrite(name1, data_new, 'delimiter', ',', 'precision', 9);
                disp(['Extract data from columns ',num2str(c1),' & ',num2str(c2),' : ',dat_name,ext])
                d = dir; %get files
                set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                refreshcolor;
                cd(pre_dirML); % return to matlab view folder
            end
        end
    end
end

guidata(hObject,handles)



% --- Executes on mouse press over axes background.
function axes_robot_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
unit = handles.unit;
unit_type = handles.unit_type;
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = get(handles.listbox_acmain,'Value');
nplot = length(plot_selected);   % length
check = 0;
% check
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        if isdir(plot_filter_s)
            %return
        else
            [~,dat_name,ext] = fileparts(plot_filter_s);
            %check = 0;
            if sum(strcmp(ext,handles.filetype)) > 0
                check = 1; % selection can be executed 
            end
        end
    else
        %return
    end
end

if check == 1
    for i = 1:nplot
        plot_no = plot_selected(i);
        plot_filter_s1 = char(contents(plot_no));
        GETac_pwd; 
        plot_filter_s = fullfile(ac_pwd,plot_filter_s1);
        try
            data_filterout = load(plot_filter_s);
        catch       
            fid = fopen(plot_filter_s);
            data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', Inf);
            fclose(fid);
            if iscell(data_ft)
                try
                    data_filterout = cell2mat(data_ft);
                catch
                    fid = fopen(plot_filter_s,'at');
                    fprintf(fid,'%d\n',[]);
                    fclose(fid);
                    fid = fopen(plot_filter_s);
                    data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', Inf);
                    disp(['>>  Read data: ', dat_name, '. Okay!'])
                    fclose(fid);
                    try
                        data_filterout = cell2mat(data_ft);
                    catch
                        warndlg(['Check selected data: ',dat_name],'Data Error!')
                    end
                end
            end
        end

        ddd = data_filterout; ddd = ddd(:,1); window = 0.25 * (max(ddd)-min(ddd));

        dlg_title = 'Acycle: Robot';
        prompt = {...
            'Preparation check: NaN, Sort, Unique, Remove-empty'; ...
            'Interpolation: mean, median, max, min, value';...
            'Detrend: lowess/rlowess/loess/rloess/linear/no, window';...
            'Power Spectrum & robustAR(1) noise';...
            'Evolutionary FFT: window or 0 (skip)';...
            'Wavelet transform';...
            'Save results';...
            'Pause (second)'};
        num_lines = 1;
        defaultans = {...
            '1, 1, 1, 1',...
            'median',...
            'lowess, 0.25',...
            '1',...
            num2str(window),...
            '1',...
            '1',...
            '0.5'};
        options.Resize='on';
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);

        if ~isempty(answer)

            answer1 = textscan(answer{1},'%f%f%f%f','Delimiter',',');
            check_nan = answer1{1};
            check_sort = answer1{2};
            check_unique = answer1{3};
            check_empty = answer1{4};

            answer11  = textscan(answer{2},'%s');
            robot_sr = answer11{1};

            answer2 = textscan(answer{3},'%s%f','Delimiter',{';','*',',','\t','\b',' '});
            answer2 = answer2{1};
            robot_detrend = answer2{1};
            robot_detrendwin = str2double(answer2{2});

            robot_power  = str2double(answer{4});
            robot_evofft  = str2double(answer{5});
            robot_wavelet  = str2double(answer{6});
            robot_savedata  = str2double(answer{7});
            robot_pause  = str2double(answer{8});
            disp('>>  ==================================================')
            disp('>>  ==================================================')
            disp('>>  Hi, this is ~  acycle robot ')
            disp('>>      by Mingsong Li')
            disp('>>  It was born on Dec. 25, 2018 at Penn State')
            disp('>>  MatXmas ... ')
            disp('>>')
            disp(['>>  ==========   ',dat_name])
            disp('>>')
            disp('>>  ==========      starting ...')
            disp('>>')
            disp('>>  ==========    Step 1: check data    ==========')
            disp('>>')
            if unit_type == 0
                warndlg(['Waning: Unit is "',unit,'".'])
            end

            name1 = dat_name;
            dat = data_filterout(~any(isnan(data_filterout),2),:);

            % check NaN
            datx = dat(:,1); 
            daty = dat(:,2);
            if check_nan == 1
                if length(data_filterout(:,1)) > length(datx)
                    warndlg('Data: NaN numbers removed.')
                    disp('>>  ==========        removing NaNs')
                    name1 = [name1,'NaN'];  % New name
                end
            end

            % check empty
            if check_empty == 1
                dat(any(isinf(dat),2),:) = [];
                if length(dat(:,1)) < length(datx)
                    warndlg('Data: Empty numbers removed.')
                    disp('>>  ==========        removing Empty numbers')
                    name1 = [name1,'e'];  % New name
                end
            end

            % check order
            diffx = diff(dat(:,1));
            if check_sort == 1
                if any(diffx(:) < 0)
                     warndlg('Data: Not sorted. Now sorting ... ')
                     disp('>>  ==========        sorting')
                     dat = sortrows(dat);
                     name1 = [name1,'s'];  % New name
                end
            end
            % duplicate
            diffx = diff(dat(:,1));
            if check_unique == 1
                if any(diffx(:) == 0)
                     warndlg('Data: duplicated x. Now replace duplicate numbers with their mean')
                     disp('>>  ==========        duplicate numbers are replaced by mean')
                     name1 = [name1,'u'];  % New name
                     dat=findduplicate(dat);
                end
            end

            % save data
            if robot_savedata == 1
                CDac_pwd
                dlmwrite([name1,ext], dat, 'delimiter', ',', 'precision', 9);
                disp(['>>  Saving data. See main window: ', name1,ext])
                d = dir; %get files
                set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                refreshcolor;
                cd(pre_dirML); % return to matlab view folder
            end

            % plot data
            figf = figure;
            disp('>>  Plot data')
            subplot(3,1,1)
            try plot(dat(:,1),dat(:,2:end),'LineWidth',1,'Color','k')
                plotsucess = 1;
                set(gca,'XMinorTick','on','YMinorTick','on')
                if unit_type == 0;
                    xlabel(['Unit (',unit,')'])
                elseif unit_type == 1;
                    xlabel(['Depth (',unit,')'])
                else
                    xlabel(['Time (',unit,')'])
                end
                title(['Data:', name1])
                xlim([min(dat(:,1)),max(dat(:,1))])
            catch
                plotsucess = 0;
                errordlg([name1,': data error.'],'Data Error')
                if plotsucess > 0
                else
                    close(figf)
                    continue
                end   
            end

            % Sampling rate
            datx = dat(:,1);
            daty = dat(:,2);
            diffx = diff(datx);
            len_x = length(datx);
            datasamp = [datx(1:len_x-1),diffx];
            datasamp = datasamp(~any(isnan(datasamp),2),:);
            % Plot sampling rate
            subplot(3,1,2)
            stairs(datasamp(:,1),datasamp(:,2),'LineWidth',1,'Color','k');
            set(gca,'XMinorTick','on','YMinorTick','on')
            if handles.unit_type == 0;
                xlabel(['Unit (',handles.unit,')'])
                ylabel('Unit')
            elseif handles.unit_type == 1;
                xlabel(['Depth (',handles.unit,')'])
                ylabel(handles.unit)
            else
                xlabel(['Time (',handles.unit,')'])
                ylabel(handles.unit)
            end
            title([name1,': sampling rate'])
            xlim([min(datasamp(:,1)),max(datasamp(:,1))])
            ylim([0.9*min(diffx) max(diffx)*1.1])

            subplot(3,1,3)
            histfit(diffx,[],'kernel')
            title([name1,': kernel fit of the sampling rate'])
            if handles.unit_type == 0;
                xlabel(['Sampling rate (',handles.unit,')'])
            elseif handles.unit_type == 1;
                xlabel(['Sampling rate (',handles.unit,')'])
            else
                xlabel(['Sampling rate (',handles.unit,')'])
            end
            ylabel('Number')
            note = ['max: ',num2str(max(diffx)),'; mean: ',num2str(mean(diffx)),...
                '; median: ',num2str(median(diffx)),'; min: ',num2str(min(diffx))];
            text(mean(diffx),len_x/10,note);
            % pause
            pause(robot_pause);
            % interpolation
            if nanmax(diffx) - nanmin(diffx) > eps('single')
                warndlg('Warning: Data may not be evenly spaced. Interpolation ...')
                disp('>>')
                disp('>>  ==========    Step 2: Interpolation    ==========')
                disp('>>')
                disp('>>  ==========        Sampling rates are not even')
                if strcmp(robot_sr,'mean')
                    interpolate_rate = nanmean(diffx);
                    name1 = [name1,'-rsp',num2str(interpolate_rate)];
                    dati = interpolate(dat,interpolate_rate);
                elseif strcmp(robot_sr,'median')
                    interpolate_rate = nanmedian(diffx);
                    name1 = [name1,'-rsp',num2str(interpolate_rate)];
                    dati = interpolate(dat,interpolate_rate);
                elseif strcmp(robot_sr,'max')
                    interpolate_rate = nanmax(diffx);
                    name1 = [name1,'-rsp',num2str(interpolate_rate)];
                    dati = interpolate(dat,interpolate_rate);
                elseif strcmp(robot_sr,'min')
                    interpolate_rate = nanmin(diffx);
                    name1 = [name1,'-rsp',num2str(interpolate_rate)];
                    dati = interpolate(dat,interpolate_rate);
                else
                    try str2double(robot_sr)
                        if isnumeric(str2double(robot_sr))
                            interpolate_rate = str2double(robot_sr);
                            name1 = [name1,'-rsp',num2str(num2str(interpolate_rate))];
                            dati = interpolate(dat,interpolate_rate);
                        end
                    end
                end
                clear dat; dat = dati;
                disp(['>>  ==========        interpolating using ', num2str(interpolate_rate),' sampling rate'])
                % save data
                if robot_savedata == 1
                    CDac_pwd
                    dlmwrite([name1,ext], dati, 'delimiter', ',', 'precision', 9);
                    disp(['>>  Saving data. See main window: ', name1,ext])
                    d = dir; %get files
                    set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                    refreshcolor;
                    cd(pre_dirML); % return to matlab view folder

                end

            else
            end

            % detrend
            % pause
            pause(robot_pause);
            datx = dat(:,1);
            daty = dat(:,2);
            if strcmp(robot_detrend,'no')
                dats = dat;
            elseif strcmp(robot_detrend,'linear')
                disp('>>')
                disp('>>  ==========    Step 3: Detrend    ==========')
                disp('>>')
                name1 = [name1,'-',robot_detrend];
                sdat=polyfit(datx,daty,1);
                datalinear = datx * sdat(1) + sdat(2);
                dats = [datx,daty-datalinear];
            else
                disp('>>')
                disp('>>  ==========    Step 3: Detrend    ==========')
                disp('>>')
                name1 = [name1,'-',num2str(robot_detrendwin),robot_detrend];
                datxsmth = smooth(datx,daty, robot_detrendwin,robot_detrend);
                dats = [datx,daty-datxsmth];
            end
            % plot
            figure; 
            plot(dat(:,1),dat(:,2));hold on;
            plot(dats(:,1),dats(:,2));
            %legend('Raw data','detrended data')
            if strcmp(robot_detrend,'no')
            else
                plot(dats(:,1),daty-dats(:,2));
                legend('Raw data','detrended data',[num2str(robot_detrendwin*100),'% ',robot_detrend,' trend'])
            end

            clear dat;
            dat = dats;
            datx = dat(:,1);
            daty = dat(:,2);
            dt = median(diff(datx));

            % save data
            if robot_savedata == 1
                CDac_pwd
                dlmwrite([name1,ext], dat, 'delimiter', ',', 'precision', 9);
                disp(['>>  Saving data. See main window: ', name1,ext])
                d = dir; %get files
                set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                refreshcolor;
                cd(pre_dirML); % return to matlab view folder
            end
            % pause
            pause(robot_pause);
            % power spectrum
            if robot_power == 1
                disp('>>')
                disp('>>  ==========    Step 4: Power spctra & robustAR(1) noise   ==========')
                disp('>>')

                [rhoM, s0M,redconfAR1,redconfML96]=redconfML(dat(:,2),dt,2);
                % save data
                if robot_savedata == 1

                    name11 = [name1,'-',num2str(2),'piMTM-RobustAR1',ext];
                    data11 = redconfML96;
                    name2 = [name1,'-',num2str(2),'piMTM-ConvenAR1',ext];
                    data2 = redconfAR1;

                    CDac_pwd
                    dlmwrite(name11, data11, 'delimiter', ',', 'precision', 9);
                    dlmwrite(name2, data2, 'delimiter', ',', 'precision', 9);
                    disp(['>>  Saving data. See main window: ', name11,ext])
                    disp(['>>  Saving data. See main window: ', name2,ext])
                    d = dir; %get files
                    set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
                    refreshcolor;
                    cd(pre_dirML); % return to matlab view folder
                end
            end
            % pause
            pause(robot_pause);
            % evofft
            if robot_evofft > 0
                disp('>>')
                disp('>>  ==========    Step 5: Evolutionary FFT   ==========')
                disp('>>')

                fn = 1/(2*dt);
                npts = length(dat(:,1));
                if npts < 300
                    step = dt;
                else
                    step = round(npts/300)*dt;
                end
                [s,x_grid,y_grid] = evofft(dat,robot_evofft,step,dt,0,fn,1);
                % plot

                figure
                subplot(2,1,1)
                whitebg('white');
                plot(dat(:,1),dat(:,2));
                ylim([0.9* min(dat(:,2)), 1.1*max(dat(:,2))])
                xlim([min(dat(:,1)),max(dat(:,1))])
                ylabel('Value')
                if handles.unit_type == 0;
                    xlabel(['Unit (',handles.unit,')'])
                elseif handles.unit_type == 1;
                    xlabel(['Depth (',handles.unit,')'])
                else
                    xlabel(['Time (',handles.unit,')'])
                end

                subplot(2,1,2)
                whitebg('white');
                %try pcolor(x_grid,y_grid,s)
                try pcolor(y_grid,x_grid,s')
                colormap(jet)
                shading interp
                title(['EvoFFT. Window',' = ',num2str(robot_evofft),' ',unit,'; step = ',num2str(step),' ', unit])
                ylabel(['Frequency ( cycles per ',unit,' )'])
                if handles.unit_type == 0;
                    xlabel(['Unit (',handles.unit,')'])
                elseif handles.unit_type == 1;
                    xlabel(['Depth (',handles.unit,')'])
                else
                    xlabel(['Time (',handles.unit,')'])
                end
                set(gcf,'Name',[num2str(name1),': Running Periodogram'])
                set(gca, 'YScale', 'log')
                ylim([0 fn])
                xlim([min(dat(:,1)),max(dat(:,1))])
                catch
                    errordlg('EvoFFT: Sampling rate or something else is incorrect.')
                end
            end
            % pause
            pause(robot_pause);
            % wavelet
            if robot_wavelet ==1
                disp('>>')
                disp('>>  ==========    Step 6: Wavelet transform   ==========')
                disp('>>')
                figwave = figure;
                try [~,~,~]= waveletML(daty,datx,1,0.1,2*dt,datx(end)-datx(1));
                catch
                    try [~,~,~]= waveletML(daty,datx,1,0.1,2*dt,1/2*(datx(end)-datx(1)));
                    catch
                        errordlg('Error. Please try with other parameters')
                        disp('>>  ==========    Error in wavelet transform')
                    end
                end
            end
            disp('')
            disp('>>  ==========    Done   ==========')
            disp('>>  ==================================================')
        end
    end
else
    warndlg({'No selected data';'';...
        'Please first select at leaset one *.txt data file.';...
        '';'FORMAT:';'';'<No header>';'';...
        '1st column: depth or time';'';'2nd column: value';''})
end
% --------------------------------------------------------------------
function menu_pca_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox_acmain,'String')); % read contents of listbox 1 
plot_selected = handles.index_selected;  % read selection in listbox 1
nplot = length(plot_selected);   % length
% check
for i = 1:nplot
    plot_no = plot_selected(i);
    if plot_no > 2
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = strrep2(plot_filter_s, '<HTML><FONT color="blue">', '</FONT></HTML>');
        GETac_pwd; plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        if isdir(plot_filter_s)
            return
        else
            [~,~,ext] = fileparts(plot_filter_s);
            check = 0;
            if sum(strcmp(ext,handles.filetype)) > 0
                check = 1; % selection can be executed 
            end
        end
    else
        return
    end
end

if check == 1;
    data_new = [];
    nrow = [];
    data_pca = [];
    disp('>>  Principal component analysis of ')
    for i = 1:nplot
        plot_no = plot_selected(i);
        plot_filter_s = char(contents(plot_no));
        plot_filter_s = fullfile(ac_pwd,plot_filter_s);
        % read data
        try
            data_filterout = load(plot_filter_s);
        catch       
            fid = fopen(plot_filter_s);
            data_ft = textscan(fid,'%f%f','Delimiter',{';','*',',','\t','\b',' '},'EmptyValue', Inf);
            fclose(fid);
            if iscell(data_ft)
                data_filterout = cell2mat(data_ft);
            end
        end
        data_filterout = data_filterout(~any(isnan(data_filterout),2),:); %remove empty
        
        if nplot == 1
            data_new = data_filterout;
        else
            if i == 1
                data_new(:,i) = data_filterout(:,2);
                data_pca = data_filterout(:,1);
                disp(['>>   ',plot_filter_s]);
            else
                [nrow(i-1),~] = size(data_new);
                if nrow(i-1) ~= length(data_filterout(:,2))
                    errordlg('Error: number of rows of series must be the same')
                else
                    data_new(:,i) = data_filterout(:,2);
                    data_pca = data_filterout(:,1);
                    disp(['>>   ',plot_filter_s]);
                end
            end
        end
    end
    disp('>>  Principal component analysis: Done')
    % pca
    [coeff, pc] = pca(data_new); 
    [~,dat_name,ext] = fileparts(char(contents(plot_selected(1))));% first file name
    if nplot == 1
        name1 = [dat_name,'-PCA',ext];
        name2 = [dat_name,'-PCA-coeff',ext];
    else
        name1 = [dat_name,'-w-others-PCA',ext];  % New name
        name2 = [dat_name,'-w-others-PCA-coeff',ext];
    end

    CDac_pwd; % cd ac_pwd dir
    dlmwrite(name1, [data_pca,pc], 'delimiter', ',', 'precision', 9);
    dlmwrite(name2, coeff, 'delimiter', ',', 'precision', 9);
    d = dir; %get files
    set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
    refreshcolor;
    cd(pre_dirML); % return to matlab view folder
end
guidata(hObject,handles)



% --------------------------------------------------------------------
function menu_smooth1_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_utilities_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_image_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_menu_utilities_Callback(hObject, eventdata, handles)
% hObject    handle to menu_utilities (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_whiten_Callback(hObject, eventdata, handles)
% hObject    handle to menu_utilities (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_sednoise_Callback(hObject, eventdata, handles)
% hObject    handle to menu_utilities (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
