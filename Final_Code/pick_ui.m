function [total_picks, shape_color_list] = pick_ui
    global ui;
    ui.start = false;
    ui.shapesPicked = [];
    ui.colorsPicked = [];
    ui.totalPicks = 10;
    
    ui.fig = uifigure('Position', [100 100 500 300], 'CloseRequestFcn', @onDone);
    uititle = uilabel(ui.fig, 'Position', [100, 220, 400, 50]);
    uititle.Text = "Select colours, shapes & total picks";
    uititle.FontSize = 20;
    uilistbox(ui.fig, 'Position',[30 120 100 78],...
    'Items',["Red","Blue","Green"],...
    'Multiselect', 'on', ...
    'ValueChangedFcn', @onColorChange);

    ui.numSelect = uieditfield(ui.fig,'numeric',...
    'Position',[260 120 60 30],...
    'ValueChangedFcn', @onPickChange, 'Value', ui.totalPicks);    
    
    uilistbox(ui.fig, 'Position',[150 120 100 78],...
    'Items',["Triangle","Square","Circle","Pentagon"],...
    'Multiselect', 'on', ...
    'ValueChangedFcn', @onShapeChange);

    uibutton(ui.fig, 'Position',[230 10 100 30],...
    'Text', 'Done', ...
    'ButtonPushedFcn', @onDone);

    while ~ui.start
        pause(0.1);
    end
    
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
    for i=1:length(ui.shapesPicked)
        shape_color_list(i) = ShapeColourEnum.(ui.shapesPicked(i));
    end
    for i=1:length(ui.colorsPicked)
        shape_color_list(length(ui.shapesPicked) + i) = ShapeColourEnum.(ui.colorsPicked(i));
    end
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

function onDone(~, ~)
    global ui;
    disp("Done");
    ui.start = true;
    delete(ui.fig);
end


