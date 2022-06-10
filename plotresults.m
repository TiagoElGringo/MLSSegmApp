function data = plotresults(data, save)

if nargin<3, save='0'; end
if nargin<2, disptype='numbers'; end

switch data.type
    
    case "nregions"
        
        [borders,indexes] = select_contours(data.c); 
        colormaphot = hot;
        colormaphot = flip(colormaphot(30:190,:),1);
        
        data.fig.segmentation=figure(8);
        movegui(data.fig.segmentation,[500,20]);
        imagesc(data.I); hold on
        colormap(gray);
        %colorarray = ['r'; 'g'; 'b'; 'y'; 'm'; 'c'; 'w'];
        colorarray = round(linspace(1,size(colormaphot,1),data.par.nlevels));
        for i=1:size(data.par.l,1)
            contour(data.phi-data.par.l(i), [0 0], 'Color', colormaphot(colorarray(i),:), 'LineWidth', .25, 'DisplayName', num2str(round(data.c(i+1),0)));
        end
        title('Segmentation contours');
        %colorarray = {'b'; 'y'; 'r'};
        %stylearray = {'--';':';':'};
        %widtharray = [1.5; 1.2; 1.2];
        %for i=1:size(borders,1)
        %    contour(data.phi-data.par.l(indexes(i)-1), [0 0], 'Color', colorarray{i}, 'LineStyle', stylearray{i}, 'LineWidth', widtharray(i), 'DisplayName', num2str(round(borders(i),0)));
        %end
        %contour(data.phi-data.par.l(end), [0 0], 'Color', colorarray{end}, 'LineStyle', stylearray{end}, 'LineWidth', widtharray(end), 'DisplayName', num2str(round(data.c(end),0)));
        %contour(data.phi-data.par.l(end-2), [0 0], 'Color', colorarray{1}, 'LineStyle', stylearray{1}, 'LineWidth', widtharray(1), 'DisplayName', num2str(round(data.c(end-2),0)));
        %contour(data.phi-data.par.l(1), [0 0], 'b--','LineWidth', 1.5, 'DisplayName', num2str(round(data.c(1+1),0)));
        %contour(data.phi-data.par.l(end-1), [0 0], 'r--', 'LineWidth', 1, 'DisplayName', num2str(round(data.c(end-1),0)));
        hold off;
        legend show;
        legend('Location', 'northwest');
        hLegend = findobj(gcf, 'Type', 'Legend');
        hLegend.ItemTokenSize = [10,10];
        hLegend.Color = [.9 .9 .9];
        hLegend.Title.String = ['Mean' newline 'int.'];
        
        
        
    
        
end

if save=='save'
    %{
    savename = ['results_' image_name '[' dest_image_param ']'];
    savepath = [dest_path savename];
    saveas(f, savepath, 'png');
    savename = ['segmented_' image_name '[' dest_image_param ']'];
    savepath = [dest_path savename];
    saveas(f10, savepath, 'png');
    %
    savename = ['mask_' image_name '[' dest_image_param ']'];
    savepath = [dest_path savename];
    imwrite(data.mask, savepath, 'png');
    savename = ['phi_' image_name '[' dest_image_param ']'];
    savepath = [dest_path savename];
    imwrite(data.phi, savepath, 'png');
    %}
end

end