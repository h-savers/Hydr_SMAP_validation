function [cols, rows] = resolution_to_grid(resolution)
if resolution == 3.125
        cols=11104;
        rows=4672;
    elseif resolution == 6.25
        cols=5552;
        rows=2336;
    elseif resolution == 9
        cols=3856;
        rows=1624;
    elseif resolution == 12.5
        cols=2776;
        rows=1168;
    elseif resolution == 25
        cols=1388;
        rows=584;
    elseif resolution == 36
        cols=964;
        rows=406;
    else
        cols=-1;
        rows=-1;
    end
end