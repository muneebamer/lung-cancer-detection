function varargout = LCD(varargin)
clc;

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LCD_OpeningFcn, ...
                   'gui_OutputFcn',  @LCD_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before LCD is made visible.
function LCD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for LCD
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LCD wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = LCD_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
    clc
    % browse files %
    srcPath = uigetdir();
    srcFile = dir(strcat(srcPath,'\*.dcm'));
    %Loop through dicom images of patient
    for i=1:length(srcFile)
        fileName = strcat(srcPath,'\',srcFile(i).name)
        I = dicomread(fileName);
        info = dicominfo(fileName) 
    end
    %Display in axes1
    axes(handles.axes1)
    imshow(I,[]);
    
    handles.I=I;
    
    guidata(hObject, handles);
    
% --- Executes on button press in processing_button.
function processing_button_Callback(hObject, eventdata, handles)
    I = handles.I;
    % loop to read info of each file and save parameters info %
    [img_threshold, hist_eq, sob_fil] = preProcessing(I);
    
    global thresh;
    thresh = img_threshold;
    %Thresholded image Display in axes2
    axes(handles.axes2)
    imshow(img_threshold,[]);
    
    %Equalized image Display in axes3
    axes(handles.axes3)
    imshow(hist_eq,[]);
    
    %Filtered image Display in axes4
    axes(handles.axes4)
    imshow(sob_fil,[]);
    
 % --- Executes on button press in segmentation_button.
 
function segmentation_button_Callback(hObject, eventdata, handles)
    I = handles.I;

    [dilated, edge_det] = Segmentation(I);
    global dilatedImg;
    dilatedImg = dilated;
    
    global edge_detImg;
    edge_detImg = edge_det;
    
    %Dilated image Display in axes5
    axes(handles.axes5)
    imshow(dilated,[]);
    
    %Edge Detected image Display in axes6
    axes(handles.axes6)
    imshow(edge_det,[]);
    
 % --- Executes on button press in feature_button.
 
function feature_button_Callback(hObject, eventdata, handles)
    %global thresh;
    %global dilatedImg;
    global edge_detImg;
    % Feature Extraction %
    [mean, entr, ener, cont, homo] = featureExtraction(edge_detImg);
    
    %Mean display in mean axes
    set(handles.mean,'string',num2str(mean));
    %Entropy display in entropy axes
    set(handles.entropy,'string',num2str(entr));
    %Energy display in energy axes
    set(handles.energy,'string',num2str(ener));
    %Contrast display in contr axes
    set(handles.contrast,'string',num2str(cont));
    %Homogeneity display in homo axes
    set(handles.homogeneity,'string',num2str(homo));
    
  % --- Executes on button press in classification_button.
function classification_button_Callback(hObject, eventdata, handles)
    
    mean = str2double(get(handles.mean, 'String'));
    entr = str2double(get(handles.entropy, 'String'));
    ener = str2double(get(handles.energy, 'String'));
    cont = str2double(get(handles.contrast, 'String'));
    homo = str2double(get(handles.homogeneity, 'String'));
    
    if (isnan(mean))
        set(handles.result,'string','FIRST EXTRACT FEATURES');
        set(handles.result,'ForegroundColor',[0.93,0.69,0.13]);
        return
    else    
        label = classify(mean,entr,ener,cont,homo);
    end
    
    if (label == 2)
        set(handles.result,'string','CANCER NOT DETECTED');
        set(handles.result,'ForegroundColor',[0.10,0.47,0.18]);
    else
        set(handles.result,'string','CANCER DETECTED');
        set(handles.result,'ForegroundColor','red');
    end
    

% --- Executes on button press in exit_button.
function exit_button_Callback(hObject, eventdata, handles)
    close
    
% --- Executes on button press in clear_button.
function clear_button_Callback(hObject, eventdata, handles)
empty=[];

set(handles.mean,'string',empty)

set(handles.entropy,'string',empty)

set(handles.energy,'string',empty)

set(handles.contrast,'string',empty)

set(handles.homogeneity,'string',empty)

set(handles.result,'string',empty)

axes(handles.axes1);cla

axes(handles.axes2);cla

axes(handles.axes3);cla

axes(handles.axes4);cla

axes(handles.axes5);cla

axes(handles.axes6);cla

    
function result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mean_Callback(hObject, eventdata, handles)
% hObject    handle to mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mean as text
%        str2double(get(hObject,'String')) returns contents of mean as a double


% --- Executes during object creation, after setting all properties.
function mean_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function entropy_Callback(hObject, eventdata, handles)
% hObject    handle to entropy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of entropy as text
%        str2double(get(hObject,'String')) returns contents of entropy as a double


% --- Executes during object creation, after setting all properties.
function entropy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to entropy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function energy_Callback(hObject, eventdata, handles)
% hObject    handle to energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of energy as text
%        str2double(get(hObject,'String')) returns contents of energy as a double


% --- Executes during object creation, after setting all properties.
function energy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function contrast_Callback(hObject, eventdata, handles)
% hObject    handle to contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of contrast as text
%        str2double(get(hObject,'String')) returns contents of contrast as a double


% --- Executes during object creation, after setting all properties.
function contrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function homogeneity_Callback(hObject, eventdata, handles)
% hObject    handle to homogeneity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of homogeneity as text
%        str2double(get(hObject,'String')) returns contents of homogeneity as a double


% --- Executes during object creation, after setting all properties.
function homogeneity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to homogeneity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function result_Callback(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of result as text
%        str2double(get(hObject,'String')) returns contents of result as a double


% --- Executes during object creation, after setting all properties.
