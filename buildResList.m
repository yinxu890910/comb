function reslist = buildResList(NumberOfModes, CenterFreq, FSR, D2over2pi, D3over2pi)
%returns resonance frequencies in units of Hz according to FSR, D2, D3
global nms_a;
global nms_b;
global linewidth;
list = zeros(NumberOfModes,1);
for k=1:size(list,1)
    list(k) = CenterFreq ...
        + (k-round(size(list,1)/2))*FSR ...
        + (k-round(size(list,1)/2))^2 * D2over2pi ...
        + (k-round(size(list,1)/2))^3 * D3over2pi/3 ...
        + nms_a*linewidth/4/(k-round(size(list,1)/2)-nms_b-0.5);
end

reslist = list;

end