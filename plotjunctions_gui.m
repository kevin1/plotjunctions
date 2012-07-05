function varargout = plotjunctions_gui(varargin)
% PLOTJUNCTIONS_GUI MATLAB code for plotjunctions_gui.fig
%      PLOTJUNCTIONS_GUI, by itself, creates a new PLOTJUNCTIONS_GUI or raises the existing
%      singleton*.
%
%      H = PLOTJUNCTIONS_GUI returns the handle to a new PLOTJUNCTIONS_GUI or the handle to
%      the existing singleton*.
%
%      PLOTJUNCTIONS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTJUNCTIONS_GUI.M with the given input arguments.
%
%      PLOTJUNCTIONS_GUI('Property','Value',...) creates a new PLOTJUNCTIONS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotjunctions_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotjunctions_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotjunctions_gui

% Last Modified by GUIDE v2.5 03-Jul-2012 15:34:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotjunctions_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @plotjunctions_gui_OutputFcn, ...
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


% --- Executes just before plotjunctions_gui is made visible.
function plotjunctions_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotjunctions_gui (see VARARGIN)

% Choose default command line output for plotjunctions_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotjunctions_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotjunctions_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Find which radio button is selected in a n-p radio button setup
function type = n_or_p(handle_n, handle_p)
% handle_n    handle for the radio button marked n-type
% handle_p    handle for the radio button marked p-type

% The Value of a radio button is 1 when selected and 0 when not. We need to
% check both radio buttons because the GUI initializes with neither radio
% selected -- the user might forget to select one.
if get(handle_n, 'Value') == 1
	type = 'n';
elseif get(handle_p, 'Value') == 1
	type = 'p';
end


% --- Executes on button press in plotbutton.
function plotbutton_Callback(hObject, eventdata, handles)
% hObject    handle to plotbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% TODO: validate user input

% Get the information from the GUI so that we can pass it into plotbands().
% str2num() is used to convert from ASCII representations of numbers to actual
% numbers.
names = [str2double(get(handles.name_edit_1, 'String')), ...
	str2double(get(handles.name_edit_2, 'String'))];

E_ea = [str2double(get(handles.ea_edit_1, 'String')), ...
	str2double(get(handles.ea_edit_2, 'String'))];

E_g = [str2double(get(handles.g_edit_1, 'String')), ...
	str2double(get(handles.g_edit_2, 'String'))];

cc = [str2double(get(handles.cc_edit_1, 'String')), ...
	str2double(get(handles.cc_edit_2, 'String'))];

effectmass = [str2double(get(handles.effectmass_edit_1, 'String')), ...
	str2double(get(handles.effectmass_edit_2, 'String'))];

dielectric = [str2double(get(handles.dielectric_edit_1, 'String')), ...
	str2double(get(handles.dielectric_edit_2, 'String'))];

% str2num() not necessary here because we actually do want an array of
% characters.
type = [n_or_p(handles.material1_radio_n, handles.material1_radio_p), ...
	n_or_p(handles.material2_radio_n, handles.material2_radio_p)];

% Make a new figure
figure()
% Put future stuff into the figure
hold on
% Make a pretty picture
plotjunctions(names, E_ea, E_g, cc, effectmass, type, dielectric)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


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



function name_edit_1_Callback(hObject, eventdata, handles)
% hObject    handle to name_edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name_edit_1 as text
%        str2double(get(hObject,'String')) returns contents of name_edit_1 as a double


% --- Executes during object creation, after setting all properties.
function name_edit_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name_edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in import_name_select.
function import_name_select_Callback(hObject, eventdata, handles)
% hObject    handle to import_name_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns import_name_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from import_name_select


% --- Executes during object creation, after setting all properties.
function import_name_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to import_name_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Look up material properties based on name and type (n or p)
function properties = get_preset(name, type)
% name    the name of the material to look up
% type    a string, 'n' or 'p', to indicate n- or p-type material

properties.name = name;
properties.type = type;

switch name
	case 'CdS'
		% From Sarah
		properties.E_ea = 4.5;
		% From Sarah
		properties.E_g = 2.4;
		
		switch type
			case 'n'
				% From Sarah
				properties.cc = 1e+1;
				% _Solid State Electronic Devices_, appendix 3
				properties.effectmass = 0.21;
			case 'p'
				% TODO
				properties.cc = 9999;
				% _Solid State Electronic Devices_, appendix 3
				properties.effectmass = 0.80;
		end
		
		% _Solid State Electronic Devices_, appendix 3
		properties.dielectric = 8.9;
		
	case 'Cu2S'
		% From Sarah
		properties.E_ea = 4.2;
		% From Sarah
		properties.E_g = 1.2;
		
		switch type
			case 'n'
				% TODO
				properties.cc = 9999;
				% TODO
				properties.effectmass = 9999;
			case 'p'
				% From Sarah
				properties.cc = 1e+20;
				% http://www.springermaterials.com/docs/info/10681727_71.html
				properties.effectmass = 1.8;
		end
		
		properties.dielectric = 9999;
		
	case 'Si'
		% From Sarah
		properties.E_ea = 3.5;
		% From Sarah
		properties.E_g = 1.1;
		% From Sarah
		properties.cc = 1e+17;
		
		switch type
			case 'n'
				% _Solid State Electronic Devices_, appendix 3
				properties.effectmass = 0.98;
			case 'p'
				% _Solid State Electronic Devices_, appendix 3
				properties.effectmass = 0.16;
		end
		
		% _Solid State Electronic Devices_, appendix 3
		properties.dielectric = 11.8;
		
end

% --- Import the currently selected preset into a material form
function import_preset(material_num)
% material_num    number of the material to put data in. 1 or 2.

% Get all GUI handles for the current figure
handles = guihandles();

% Grab the handle of the object with tag 'import_name_select'
h_name = handles.import_name_select;
% Get a matrix of the choices for the popup menu.
contents = cellstr(get(h_name,'String'));
% Find the currently selected choice in the popup menu.
name = contents{get(h_name, 'Value')};

% Grab the handle of the object with tag 'np_select_import'
h_type = handles.import_radio_n;

% Find which type is selected in the radio buttons.
type = n_or_p(handles.import_radio_n, handles.import_radio_p);

% Look up data for the selected preset.
properties = get_preset(name, type);

% Throw the data into the appropriate form.

eval(sprintf('set(handles.name_edit_%d, ''String'', properties.name)', material_num))
eval(sprintf('set(handles.ea_edit_%d, ''String'', properties.E_ea)', material_num))
eval(sprintf('set(handles.g_edit_%d, ''String'', properties.E_g)', material_num))
eval(sprintf('set(handles.cc_edit_%d, ''String'', properties.cc)', material_num))
eval(sprintf('set(handles.effectmass_edit_%d, ''String'', properties.effectmass)', material_num))
eval(sprintf('set(handles.dielectric_edit_%d, ''String'', properties.dielectric)', material_num))
% Clear the radio buttons
eval(sprintf('set(handles.material%d_radio_n, ''Value'', 0)', material_num))
eval(sprintf('set(handles.material%d_radio_p, ''Value'', 0)', material_num))
% Set the appropriate radio button.
eval(sprintf('set(handles.material%d_radio_%c, ''Value'', 1)', material_num, properties.type))


% --- Executes on button press in button_import1.
function button_import1_Callback(hObject, eventdata, handles)
% hObject    handle to button_import1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
import_preset(1)


% --- Executes on button press in button_import2.
function button_import2_Callback(hObject, eventdata, handles)
% hObject    handle to button_import2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
import_preset(2)


function ea_edit_1_Callback(hObject, eventdata, handles)
% hObject    handle to ea_edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ea_edit_1 as text
%        str2double(get(hObject,'String')) returns contents of ea_edit_1 as a double


% --- Executes during object creation, after setting all properties.
function ea_edit_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ea_edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g_edit_1_Callback(hObject, eventdata, handles)
% hObject    handle to g_edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g_edit_1 as text
%        str2double(get(hObject,'String')) returns contents of g_edit_1 as a double


% --- Executes during object creation, after setting all properties.
function g_edit_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g_edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cc_edit_1_Callback(hObject, eventdata, handles)
% hObject    handle to cc_edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cc_edit_1 as text
%        str2double(get(hObject,'String')) returns contents of cc_edit_1 as a double


% --- Executes during object creation, after setting all properties.
function cc_edit_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cc_edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function effectmass_edit_1_Callback(hObject, eventdata, handles)
% hObject    handle to effectmass_edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of effectmass_edit_1 as text
%        str2double(get(hObject,'String')) returns contents of effectmass_edit_1 as a double


% --- Executes during object creation, after setting all properties.
function effectmass_edit_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to effectmass_edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in import_radio_p.
function import_radio_p_Callback(hObject, eventdata, handles)
% hObject    handle to import_radio_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of import_radio_p


% --- Executes on button press in import_radio_n.
function import_radio_n_Callback(hObject, eventdata, handles)
% hObject    handle to import_radio_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of import_radio_n


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1



function name_edit_2_Callback(hObject, eventdata, handles)
% hObject    handle to name_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name_edit_2 as text
%        str2double(get(hObject,'String')) returns contents of name_edit_2 as a double


% --- Executes during object creation, after setting all properties.
function name_edit_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ea_edit_2_Callback(hObject, eventdata, handles)
% hObject    handle to ea_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ea_edit_2 as text
%        str2double(get(hObject,'String')) returns contents of ea_edit_2 as a double


% --- Executes during object creation, after setting all properties.
function ea_edit_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ea_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g_edit_2_Callback(hObject, eventdata, handles)
% hObject    handle to g_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g_edit_2 as text
%        str2double(get(hObject,'String')) returns contents of g_edit_2 as a double


% --- Executes during object creation, after setting all properties.
function g_edit_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cc_edit_2_Callback(hObject, eventdata, handles)
% hObject    handle to cc_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cc_edit_2 as text
%        str2double(get(hObject,'String')) returns contents of cc_edit_2 as a double


% --- Executes during object creation, after setting all properties.
function cc_edit_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cc_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function effectmass_edit_2_Callback(hObject, eventdata, handles)
% hObject    handle to effectmass_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of effectmass_edit_2 as text
%        str2double(get(hObject,'String')) returns contents of effectmass_edit_2 as a double


% --- Executes during object creation, after setting all properties.
function effectmass_edit_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to effectmass_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dielectric_edit_2_Callback(hObject, eventdata, handles)
% hObject    handle to dielectric_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dielectric_edit_2 as text
%        str2double(get(hObject,'String')) returns contents of dielectric_edit_2 as a double


% --- Executes during object creation, after setting all properties.
function dielectric_edit_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dielectric_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dielectric_edit_1_Callback(hObject, eventdata, handles)
% hObject    handle to dielectric_edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dielectric_edit_1 as text
%        str2double(get(hObject,'String')) returns contents of dielectric_edit_1 as a double


% --- Executes during object creation, after setting all properties.
function dielectric_edit_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dielectric_edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
