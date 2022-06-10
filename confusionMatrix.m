function confusionMatrix = confusionMatrix(gtruth, mask)

confusionMatrix = zeros(3,3);

for expected = 1:3 
    for predicted = 1:3     
        confusionMatrix(expected,predicted) = sum((gtruth==expected)&(mask==predicted),'all');      
    end
   
end   

end