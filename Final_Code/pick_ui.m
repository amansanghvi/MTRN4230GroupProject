function [shape_color_list,total_picks,ipaddress] = pick_ui
    global ui;
    if(isempty(ui))
        [shape_color_list,total_picks,ipaddress] = intialise_ui;
    else 
        [shape_color_list,total_picks,ipaddress] = AskForNewSelection;
    end
    
end
function [shape_color_list,total_picks,ipaddress] = intialise_ui()
    global ui;
    ui.start = false;
    ui.shapesPicked = ["Triangle"];
    ui.colorsPicked = ["Red"];
    ui.totalPicks = 10;
    ui.ipaddress = '10.10.14.73';
    
    ui.fig = uifigure('Position', [100 100 500 300]);
    ui.title = uilabel(ui.fig, 'Position', [100, 220, 400, 50]);
    ui.title.Text = "Select Colours, Shapes & Total Picks";
    ui.title.FontSize = 20;
       
    colourList = uilistbox(ui.fig, 'Position',[30 120 100 78],...
    'Items',["Red","Blue","Green"],...
    'Multiselect', 'on', ...
    'ValueChangedFcn', @onColorChange);

    ui.numSelect = uieditfield(ui.fig,'numeric',...
    'Position',[260 120 60 30],...
    'ValueChangedFcn', @onPickChange, 'Value', ui.totalPicks);    
    
    shapeList = uilistbox(ui.fig, 'Position',[150 120 100 78],...
    'Items',["Triangle","Square","Circle","Pentagon"],...
    'Multiselect', 'on', ...
    'ValueChangedFcn', @onShapeChange);
    
    uilabel(ui.fig, 'Position', [50, 80, 100, 30],'Text','ROS IP Address:');
    ipArea = uitextarea(ui.fig, 'Position',[150 80 100 30],...
     'Value', ui.ipaddress, ...
    'ValueChangedFcn', @onIPChange);
    
    startButton = uibutton(ui.fig, 'Position',[230 10 100 30],...
    'Text', 'Start', ...
    'ButtonPushedFcn', @onDone);
    ui.pickscompleted = uilabel(ui.fig, 'Position', [260, 140, 400, 50]);
    ui.pickscompleted.Text = "Picks Completed: " + 0;
    ui.ui_elements = [colourList shapeList startButton ipArea  ui.numSelect];
    while ~ui.start
        pause(0.1);
    end
    
    set(ui.ui_elements, 'Enable', 'off');
    
    disp("Picking " + string(ui.totalPicks) + " total of any of the following shapes:");
    all_combinations = string(zeros(length(ui.shapesPicked), length(ui.colorsPicked)));
    for i=1:length(ui.shapesPicked)
        for j=1:length(ui.colorsPicked)
            all_combinations(i,j) = ui.colorsPicked(j) + " " + ui.shapesPicked(i);
        end
    end
    disp(all_combinations);
    % TODO: FIX THIS
    total_picks = ui.totalPicks;
    shape_color_list = ShapeColourEnum.(ui.shapesPicked(1));
    ipaddress = ui.ipaddress;
    for i=1:length(ui.shapesPicked)
        shape_color_list(i) = ShapeColourEnum.(ui.shapesPicked(i));
    end
    for i=1:length(ui.colorsPicked)
        shape_color_list(length(ui.shapesPicked) + i) = ShapeColourEnum.(ui.colorsPicked(i));
    end
    ui.title.Text = "Picking Selected Colours and Objects";
end
function [shape_color_list,total_picks,ipaddress] = AskForNewSelection()
    global ui;
    ui.start = false;
    set(ui.ui_elements(1:end-1), 'Enable', 'on'); %don't renable the IP and Pick Count
    ui.title.Text = {'Please Reselect Colours and Shapes';'for Remaining Picks'};
    while ~ui.start
        pause(0.1);
    end
    
    set(ui.ui_elements, 'Enable', 'off');
    
    disp("Picking remaing of any of the following shapes:");
    all_combinations = string(zeros(length(ui.shapesPicked), length(ui.colorsPicked)));
    for i=1:length(ui.shapesPicked)
        for j=1:length(ui.colorsPicked)
            all_combinations(i,j) = ui.colorsPicked(j) + " " + ui.shapesPicked(i);
        end
    end
    disp(all_combinations);
    % TODO: FIX THIS
    total_picks = ui.totalPicks;
    shape_color_list = ShapeColourEnum.(ui.shapesPicked(1));
    ipaddress = ui.ipaddress;
    for i=1:length(ui.shapesPicked)
        shape_color_list(i) = ShapeColourEnum.(ui.shapesPicked(i));
    end
    for i=1:length(ui.colorsPicked)
        shape_color_list(length(ui.shapesPicked) + i) = ShapeColourEnum.(ui.colorsPicked(i));
    end
    ui.title.Text = "Picking Selected Colours and Objects";
end

function onPickChange(src, ~)
    global ui;
    if src.Value < 10 || src.Value > 100 
        ui.numSelect.Value = ui.totalPicks;
    end
    ui.totalPicks = src.Value;
end

function onColorChange(src, ~)
    global ui;
    ui.colorsPicked = string(src.Value);
end

function onShapeChange(src, ~)
    global ui;
    ui.shapesPicked = string(src.Value);
end

function onIPChange(src, ~)
    global ui;
    ui.ipaddress = string(src.Value);
end

function onDone(~, ~)
    global ui;
    disp("Done");
    ui.start = true;
end


