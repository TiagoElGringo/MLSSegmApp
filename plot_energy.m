function data = plot_energy(data)

e=data.energy;
steps=flip(data.it.stepsvec);
kvec = [3;2;1;0];
pos=1;

data.fig.energy = figure(30);
for i=1:4
    subplot(2,2,i), hold on;
    title(['energy k=' num2str(kvec(i))]);
    plot(pos:pos+steps(i)-1, e.total(pos:pos+steps(i)-1)), 
    %plot(pos:pos+steps(i)-1, e.length(pos:pos+steps(i)-1));
    %plot(pos:pos+steps(i)-1, e.area(pos:pos+steps(i)-1));
    %plot(pos:pos+steps(i)-1, e.gradinnerlayer(pos:pos+steps(i)-1)), 
    hold off;
    %legend("total", "length", "area", "grad");
    pos=pos+steps(i);
end
end