function varargout = comb_gui(varargin)
% COMB_GUI MATLAB code for comb_gui.fig
%      COMB_GUI, by itself, creates a new COMB_GUI or raises the existing
%      singleton*.
%
%      H = COMB_GUI returns the handle to a new COMB_GUI or the handle to
%      the existing singleton*.
%
%      COMB_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMB_GUI.M with the given input arguments.
%
%      COMB_GUI('Property','Value',...) creates a new COMB_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before comb_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to comb_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help comb_gui

% Last Modified by GUIDE v2.5 02-Jul-2014 13:09:56

% Begin initialization code - DO NOT EDIT

clc;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @comb_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @comb_gui_OutputFcn, ...
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

% --- Executes just before comb_gui is made visible.
function comb_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to comb_gui (see VARARGIN)

% Choose default command line output for comb_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using comb_gui.
if strcmp(get(hObject,'Visible'),'off')
    
end



% UIWAIT makes comb_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = comb_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global detune_s;
global detune_e;
global modes_number;
global pump_freq;
global fsr;
global d2;
global d3;
global pump_power;
global linewidth;
global coupling;
global refr_index;
global nonlin_index;
global mode_volume; 
global filename;
global progress;
global snapshot;
global reslist;
global sweep_speed;
global pump_profile;

% if validate(handles)==true 
%     change_edits_background();
    progress=hObject;
    set(hObject,'Enable','off');
    set(handles.slider3,'Enable','off');
    pause(.1);
    
    filename=strcat('coupledeq',datestr(fix(clock),'yyyymmddHHMMSS'));
    snapshot=detune_s+(detune_e-detune_s)/2;
    % adjust slider to snapshot
    min_slider=get(handles.slider3,'Min');
    max_slider=get(handles.slider3,'Max');
    slider_value=(snapshot-detune_s)/(detune_e-detune_s)*(max_slider-min_slider)+min_slider;
    
    detune_s 
    detune_e
    pump_power 
    %simulate
    combsim(...
        reslist, ...% list of resonance frequencies
        sweep_speed, ... % detuning sweep speed in units of 1/linewidth
        0,... % initial conditions for field amplitutdes
        [detune_s detune_e], ... % detuning range in un. of linewidth
        [pump_power pump_power], ... % power range in W (usually the single value)
        linewidth, ... % linewidth in Hz
        coupling, ... % coupling
        refr_index, ... % ref. index
        nonlin_index, ... % nonlin. index in m^2/W
        mode_volume, ... % nonlin. mode volume in m^3
        filename ... % name of the file generated in the end
        )
    
    % by tuning time we can change speed of detuning changing
    % during calculations. The more time you put in - the slower speed of tuning
    % you get [detuning = detuning0 + (t - t(0)) (detuning(end)-detuning(0))/
    % (time(end) - time(0))]
    set(hObject,'String','Solve CMEs');
    set(hObject,'Enable','on');
    % axes(handles.axes);
    % cla;
    plotcomb(filename,snapshot,'all');
    set(handles.slider3,'Enable','on');
    set(handles.slider3,'Value',slider_value);
% end

% --- Executes on button press in ssfm_btn.
function ssfm_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ssfm_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global detune_s;
global detune_e;
global modes_number;
global pump_freq;
global fsr;
global d2;
global d3;
global pump_power;
global linewidth;
global coupling;
global refr_index;
global nonlin_index;
global mode_volume; 
global filename;
global progress;
global snapshot;
global reslist;
global sweep_speed;

if validate(handles)==true 
    change_edits_background();
    progress=hObject;
    set(hObject,'Enable','off');
    set(handles.slider3,'Enable','off');
    pause(.1);
    
    filename=strcat('llessfm',datestr(fix(clock),'yyyymmddHHMMSS'));
    snapshot=detune_s+(detune_e-detune_s)/2;
    % adjust slider to snapshot
    min_slider=get(handles.slider3,'Min');
    max_slider=get(handles.slider3,'Max');
    slider_value=(snapshot-detune_s)/(detune_e-detune_s)*(max_slider-min_slider)+min_slider;
    
    % build resonance list    
    reslist = buildResList(...
        modes_number, ... % number of modes
        pump_freq, ... %approx pump freq
        fsr, ... % FSR
        d2, ... % D2/2pi
        d3 ... % D3/2pi        
        );
    %simulate
    llequation(...
        reslist, ...% list of resonance frequencies       
        pump_freq, ... %approx pump freq
        fsr, ... % FSR
        d2, ... % D2/2pi
        d3, ...
        [detune_s detune_e], ... % detuning range in un. of linewidth
        [pump_power pump_power], ... % power range in W (usually the single value)
        linewidth, ... % linewidth in Hz
        coupling, ... % coupling
        refr_index, ... % ref. index
        nonlin_index, ... % nonlin. index in m^2/W
        mode_volume, ... % nonlin. mode volume in m^3
        filename ... % name of the file generated in the end
        )
    
    % by tuning time we can change speed of detuning changing
    % during calculations. The more time you put in - the slower speed of tuning
    % you get [detuning = detuning0 + (t - t(0)) (detuning(end)-detuning(0))/
    % (time(end) - time(0))]
    set(hObject,'String','Solve LLE');
    set(hObject,'Enable','on');
    % axes(handles.axes);
    % cla;
     plotcomb(filename,snapshot,'all');
    set(handles.slider3,'Enable','on');
    set(handles.slider3,'Value',slider_value);
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,~,~] = uigetfile('*.mat');
global detune_s;
global detune_e;
global filename;
% global modes_number;
% global pump_freq;
% global fsr;
% global d2;
% global d3;
global snapshot;
global reslist;
filename=FileName;

file = load(FileName);
set(handles.modes_number,'String',num2str(file.a_modes_number));
c = 299792458;
set(handles.figure1,'Name',FileName);
set(handles.wavelength,'String',num2str(c/file.a_pump_freq*10^9));
set(handles.FSR,'String',num2str(file.a_fsr));
set(handles.d2,'String',num2str(file.a_d2));
set(handles.d3,'String',num2str(file.a_d3));
set(handles.pump_power,'String',num2str(file.a_pump_power));
set(handles.detune_s,'String',num2str(file.a_detune_s));
set(handles.detune_e,'String',num2str(file.a_detune_e));
set(handles.linewidth,'String',num2str(file.a_linewidth));
set(handles.refr_index,'String',num2str(file.a_refr_index));
set(handles.nonlin_index,'String',num2str(file.a_nonlin_index));
set(handles.mode_volume,'String',num2str(file.a_mode_volume));
set(handles.coupling,'String',num2str(file.a_coupling));
set(handles.sweep_speed,'String',num2str(file.a_sweep_speed));

snapshot=detune_s+(detune_e-detune_s)/2;
% adjust slider to snapshot
min_slider=get(handles.slider3,'Min');
max_slider=get(handles.slider3,'Max');
slider_value=(snapshot-detune_s)/(detune_e-detune_s)*(max_slider-min_slider)+min_slider;
plotcomb(FileName,snapshot,'all');
set(handles.slider3,'Enable','on');
set(handles.slider3,'Value',slider_value);


% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

function modes_number_Callback(hObject, eventdata, handles)
% hObject    handle to modes_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global modes_number;
modes_number=int32(str2double(get(hObject,'String')));
% Hints: get(hObject,'String') returns contents of modes_number as text
%        str2double(get(hObject,'String')) returns contents of modes_number as a double


function linewidth_Callback(hObject, eventdata, handles)
% hObject    handle to linewidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global linewidth;
linewidth=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of linewidth as text
%        str2double(get(hObject,'String')) returns contents of linewidth as a double


% --- Executes during object creation, after setting all properties.
function linewidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linewidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global linewidth;
global linewidth_handler;
linewidth_handler=hObject;
linewidth=str2double(get(hObject,'String'));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function refr_index_Callback(hObject, eventdata, handles)
% hObject    handle to refr_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global refr_index;
refr_index=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of refr_index as text
%        str2double(get(hObject,'String')) returns contents of refr_index as a double


% --- Executes during object creation, after setting all properties.
function refr_index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to refr_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global refr_index;
global refr_index_handler;
refr_index_handler=hObject;
refr_index=str2double(get(hObject,'String'));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function nonlin_index_Callback(hObject, eventdata, handles)
% hObject    handle to nonlin_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nonlin_index;
nonlin_index=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of nonlin_index as text
%        str2double(get(hObject,'String')) returns contents of nonlin_index as a double


% --- Executes during object creation, after setting all properties.
function nonlin_index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nonlin_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global nonlin_index;
global nonlin_index_handler;
nonlin_index_handler=hObject;
nonlin_index=str2double(get(hObject,'String'));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mode_volume_Callback(hObject, eventdata, handles)
% hObject    handle to mode_volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mode_volume;
mode_volume=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of mode_volume as text
%        str2double(get(hObject,'String')) returns contents of mode_volume as a double


% --- Executes during object creation, after setting all properties.
function mode_volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mode_volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global mode_volume;
global mode_volume_handler;
mode_volume_handler=hObject;
mode_volume=str2double(get(hObject,'String'));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function coupling_Callback(hObject, eventdata, handles)
% hObject    handle to coupling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global coupling;
coupling=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of coupling as text
%        str2double(get(hObject,'String')) returns contents of coupling as a double


% --- Executes during object creation, after setting all properties.
function coupling_CreateFcn(hObject, eventdata, handles)
% hObject    handle to coupling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global coupling_handler;
coupling_handler=hObject;
global coupling;
coupling=str2double(get(hObject,'String'));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function sweep_speed_Callback(hObject, eventdata, handles)
% hObject    handle to sweep_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sweep_speed;
sweep_speed=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of sweep_speed as text
%        str2double(get(hObject,'String')) returns contents of sweep_speed as a double


% --- Executes during object creation, after setting all properties.
function sweep_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sweep_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global sweep_speed_handler;
sweep_speed_handler=hObject;
global sweep_speed;
sweep_speed=str2double(get(hObject,'String'));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global detune_s;
global detune_e;
global filename;
global snapshot;

min_slider=get(hObject,'Min');
max_slider=get(hObject,'Max');
value_slider=get(hObject,'Value');
snapshot=detune_s+(detune_e-detune_s)*(value_slider-min_slider)/(max_slider-min_slider);
plotcomb(filename,snapshot,'all')
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Enable','off');
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in total_fld_btn.
function total_fld_btn_Callback(hObject, eventdata, handles)
% hObject    handle to total_fld_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global snapshot;
global filename;
plotcomb(filename,snapshot,'total_field');

% --- Executes on button press in amp_button.
function amp_button_Callback(hObject, eventdata, handles)
% hObject    handle to amp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global snapshot;
global filename;
plotcomb(filename,snapshot,'amps');


% --- Executes on button press in spectrum_button.
function spectrum_button_Callback(hObject, eventdata, handles)
% hObject    handle to spectrum_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global snapshot;
global filename;
plotcomb(filename,snapshot,'spectrum');

% --- Executes on button press in waveform_btn.
function waveform_btn_Callback(hObject, eventdata, handles)
% hObject    handle to waveform_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global snapshot;
global filename;
plotcomb(filename,snapshot,'waveform');

% --- Executes on button press in edit_modes.
function edit_modes_Callback(hObject, eventdata, handles)
% hObject    handle to edit_modes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global modes_number;
global pump_freq;
global fsr;
global d2;
global d3;
global nms_a;
global nms_b;
global linewidth;
global reslist;

prompt={'Modes number',...
    'Wavelength (nm)',...
    'FSR (Hz)', ...
    'D2 (Hz)', ...
    'D3 (Hz)' ...
    'Distortion, a' ...
    'Distortion, b'
    };
defaultanswer={'201','1553','35e9','1e4','0','0','0'};
options.Resize='on';
options.WindowStyle='normal';
answer=inputdlg(prompt,'Dispersion',1,defaultanswer,options);
modes_number=int32(str2double(answer{1}));
c = 299792458;
lambda=str2double(answer{2})*10^-9; % in nm
pump_freq=c/lambda;
fsr=str2double(answer{3});
d2=str2double(answer{4});
d3=str2double(answer{5});
nms_a=str2double(answer{6});
nms_b=str2double(answer{7});
% TODO: linewidth must be set prior eigenmodes calculation
reslist = buildResList(modes_number, pump_freq, fsr, d2, d3, nms_a,nms_b,linewidth);

% --- Executes on button press in import_eigenmodes.
function import_eigenmodes_Callback(hObject, eventdata, handles)
% hObject    handle to import_eigenmodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global modes_number;
global reslist;
global pump_freq;
[FileName,~,~] = uigetfile('*.*');
reslist = csvread(FileName);
modes_number = length(reslist);
pump_freq=reslist(ceil(modes_number/2));


% --- Executes on button press in pump_edit.
function pump_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pump_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pump_import.
function pump_import_Callback(hObject, eventdata, handles)
% hObject    handle to pump_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pump_profile;
[FileName,~,~] = uigetfile('*.*');
pump_profile = csvread(FileName);


% --- Executes on button press in edit_detuning.
function edit_detuning_Callback(hObject, eventdata, handles)
% hObject    handle to edit_detuning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in import_detuning.
function import_detuning_Callback(hObject, eventdata, handles)
% hObject    handle to import_detuning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in seeding_edit.
function seeding_edit_Callback(hObject, eventdata, handles)
% hObject    handle to seeding_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in seeding_import.
function seeding_import_Callback(hObject, eventdata, handles)
% hObject    handle to seeding_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
