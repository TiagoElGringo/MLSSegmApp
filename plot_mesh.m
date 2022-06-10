function plot_mesh(data)
figure(1);
%legend('AutoUpdate', 'Off');
mesh(data.phi);colormap('hot'), hold on;
%contour(data.phi, 10,'LineColor','r', 'LineWidth', 1.5, 'DisplayName', '\Phi = 0'), hold on;
%legend('AutoUpdate', 'On');
xlabel('x');
ylabel('y');
zlabel('\Phi');
zlim([min(data.phi,[],'all') max(data.phi,[],'all')]);
xlim([0 768]);
ylim([0 576]);
set(gca, 'YDir','reverse');
title('\Phi');
hold off;
grid minor;
box off;
view(-15,60);
%legend(a,'show');
%legend('Location', 'northeast');

end