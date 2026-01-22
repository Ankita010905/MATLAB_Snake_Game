function varargout = gamesgui(varargin)
% GAMESGUI MATLAB GUIDE-based Snake Game
% Fully corrected and safe for MATLAB 2024+
% Features: restart, end, pause, wall toggle, high score, red food, boundary, soft sound

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gamesgui_OpeningFcn, ...
                   'gui_OutputFcn',  @gamesgui_OutputFcn, ...
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

%% ---------------- Opening Function ----------------
function gamesgui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% Initialize axes
axes(handles.axes1);
axis(handles.axes1,'off'); 
set(handles.axes1,'Color','k');

% Initialize globals
global mat_r mat_g mat_b direction points move_status food_x food_y ...
       game_running snake_img;

mat_r = zeros(100,100);
mat_g = zeros(100,100);
mat_b = zeros(100,100);
direction = 3; points = 0; move_status = 0; game_running = true;

% Fixed image object for safe rendering
snake_img = image(handles.axes1, zeros(100,100,3,'uint8')); % RGB image
set(handles.axes1,'XTick',[],'YTick',[]);

% Load high score if exists
if exist('highscore.mat','file')
    S = load('highscore.mat');
    handles.highscore = S.highscore;
else
    handles.highscore = 0;
end
set(handles.highscore_text,'String',['High Score: ',num2str(handles.highscore)]);

% --- Menu bar ---
uimenu(handles.figure1,'Label','⭐ Star','Callback',@menu_star_Callback);
uimenu(handles.figure1,'Label','Instructions','Callback',@menu_instr_Callback);
uimenu(handles.figure1,'Label','Exit','Separator','on','Callback',@menu_exit_Callback);

guidata(hObject,handles);

%% ---------------- Menu Callbacks ----------------
function menu_star_Callback(hObject, eventdata)
    msgbox('Thanks for playing! Please ⭐ the repo on GitHub.');

function menu_instr_Callback(hObject, eventdata)
    msgbox(['Use Arrow Keys or Buttons to move the snake. ' ...
            'Eat red food to grow. Avoid walls if enabled. ' ...
            'Pause and Restart are available.']);

function menu_exit_Callback(hObject, eventdata)
    close(gcbf);  % safely close current figure

%% ---------------- Output Function ----------------
function varargout = gamesgui_OutputFcn(hObject, eventdata, handles)
if isstruct(handles) && isfield(handles,'output')
    varargout{1} = handles.output;
else
    varargout{1} = [];
end

%% ---------------- Start Game Callback ----------------
function startgame_Callback(hObject, eventdata, handles)
global mat_r mat_g mat_b direction points move_status ...
       food_x food_y game_running snake_img;

% Initialize snake
locx = [50 50 50 50 50]; 
locy = [60 61 62 63 64]; 
direction = 3; move_status = 1; points = 0; t = 0.1; 
game_running = true;

% Generate first food
[food_x, food_y] = GenerateFood(locx,locy);

% Draw boundary rectangle once
rectangle('Parent',handles.axes1,'Position',[0.5 0.5 100 100],'EdgeColor','w','LineWidth',2);

while game_running
    % Check if figure exists
    if ~ishandle(handles.figure1)
        break;
    end

    % Clear board
    mat_r(:)=0; mat_g(:)=0; mat_b(:)=0;

    % Draw red food
    mat_r(food_x,food_y) = 255; mat_g(food_x,food_y) = 0; mat_b(food_x,food_y) = 0;

    % Move snake
    if move_status
        len = length(locx);
        locx(2:len) = locx(1:len-1);
        locy(2:len) = locy(1:len-1);

        switch direction
            case 1, locy(1)=locy(1)+1;
            case 2, locx(1)=locx(1)-1;
            case 3, locy(1)=locy(1)-1;
            case 4, locx(1)=locx(1)+1;
        end

        % Wall collision toggle
        if isfield(handles,'wall_toggle') && ishandle(handles.wall_toggle) && get(handles.wall_toggle,'Value')
            if locx(1)<1 || locx(1)>100 || locy(1)<1 || locy(1)>100
                NotificationSound(400,0.2); msgbox('Game Over'); break;
            end
        else
            locx(1) = mod(locx(1)-1,100)+1;
            locy(1) = mod(locy(1)-1,100)+1;
        end

        % Eat food
        if locx(1)==food_x && locy(1)==food_y
            locx=[locx locx(end)]; locy=[locy locy(end)];
            points = points+1; 
            if ishandle(handles.points)
                set(handles.points,'String',num2str(points));
            end
            NotificationSound(800,0.1);
            [food_x, food_y] = GenerateFood(locx,locy);
        end

        % Self collision
        if any(locx(2:end)==locx(1) & locy(2:end)==locy(1))
            NotificationSound(400,0.2); msgbox('Game Over'); break;
        end
    end

    % Draw snake
    mat_r(locx(1),locy(1))=255; mat_g(locx(1),locy(1))=255; % head
    mat_g(locx(2:end),locy(2:end))=255; % body

    % Update image safely
    if ishandle(snake_img)
        set(snake_img,'CData',uint8(cat(3,mat_r,mat_g,mat_b)));
    end
    drawnow;

    % Adjust speed by points
    if points<5, t=0.1; elseif points<10, t=0.08; elseif points<15, t=0.05; else t=0.03; end
    pause(t);
end

% Update high score safely
if ishandle(handles.figure1)
    if points > handles.highscore
        handles.highscore = points;
        save('highscore.mat','highscore');
        for i=1:3
            set(handles.highscore_text,'ForegroundColor','r'); pause(0.3);
            set(handles.highscore_text,'ForegroundColor','w'); pause(0.3);
        end
    end
    guidata(handles.figure1,handles);
end

%% ---------------- Helper Functions ----------------
function [fx, fy] = GenerateFood(sx,sy)
while true
    fx = randi(100); fy = randi(100);
    if ~any(sx==fx & sy==fy), break; end
end

function NotificationSound(freq,duration)
Fs=8000; t=0:1/Fs:duration; y=0.05*sin(2*pi*freq*t); sound(y,Fs);

%% ---------------- Direction Callbacks ----------------
function up_Callback(hObject, eventdata, handles)
global direction move_status; if direction~=4, direction=2; move_status=1; end
function down_Callback(hObject, eventdata, handles)
global direction move_status; if direction~=2, direction=4; move_status=1; end
function left_Callback(hObject, eventdata, handles)
global direction move_status; if direction~=1, direction=3; move_status=1; end
function right_Callback(hObject, eventdata, handles)
global direction move_status; if direction~=3, direction=1; move_status=1; end

function pause_Callback(hObject, eventdata, handles)
global move_status; move_status=0;

function endgame_Callback(hObject, eventdata, handles)
global game_running; game_running=false; 
if ishandle(handles.figure1), close(handles.figure1); end

function restartgame_Callback(hObject, eventdata, handles)
global game_running; game_running=false; 
if ishandle(handles.figure1), close(handles.figure1); end
gamesgui;

%% ---------------- Key Press ----------------
function figure1_KeyPressFcn(hObject, eventdata, handles)
global direction move_status;
switch eventdata.Key
    case 'uparrow', if direction~=4, direction=2; move_status=1; end
    case 'downarrow', if direction~=2, direction=4; move_status=1; end
    case 'leftarrow', if direction~=1, direction=3; move_status=1; end
    case 'rightarrow', if direction~=3, direction=1; move_status=1; end
end
