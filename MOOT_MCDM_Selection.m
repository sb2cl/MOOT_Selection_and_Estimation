%% Drawing a LevelDiagram for MCDM Parameter Selection
clear all
close all
%Load the solutions obtained from the optimization
load('OUT_Opti_IE_ifac_wc.mat')

% Create variables related with the concept: 
% concept1 and concept1_data
conceptCreate(OUT.PFront,OUT.PSet,'concept1')

% Bounds for Pareto front normalization
% bounds =[upperbounds; lowerbounds]
bounds=[concept1.maxpf;concept1.minpf];
    
% Calculate the value of the norm (2-norm) for y-axis synchronization
% and create the associated variable concept1_ld1
basicNorm('ld1','concept1',bounds,2);

%Change the x-axis of all the plots to be the second objective 
concept1_ld1 = OUT.PFront(:,2)

% Draw the Level Diagram ld1 with a unique concept1
ldDraw('ld1','concept1')


%% Customization of the diagrams
%% The marker shape can be selected between 's','o','^', etc.
ldChangeMarker(ld1,'o','concept1')

% Creating an array with sizes for each point
s=(20:5:20+5*(concept1.nind-1))';

% Ordering sizes according to the values of J1
[~,idx]=sort(concept1_data(:,1));
s2(idx,1)=s;
ldChangeSize(ld1,s2,'concept1')

%% Clustering
%Constructiong the Data matrix with Objectives and Desicion Variables
pf = OUT.PFront;
PS = OUT.PSet;
Points = size(PS,1);
PSn = [];
for m=1:Points
     PSn=[PSn; PS(m,:)./max(PS)];
end
PFn = [];
for m=1:Points
     PFn=[PFn; pf(m,:)./max(pf)];
end
Data =[PSn PFn];
%Calculation of the distance and clustering tree
eucD = pdist(Data,   'euclidean'); %
clustTreeEuc = linkage(eucD,'ward'); %
cophenet(clustTreeEuc,eucD);

% Number of desired clusters
Desired_Clusters = 3;
Clusters_out = cluster(clustTreeEuc,'maxclust',Desired_Clusters);

% Using Clusters to set the colors of the points 
maxC = max(Clusters_out);
Color_Map = make_color_map(maxC);

% Seting the color of each point
Color_Clusters = zeros(length(Clusters_out),3);
for i=1:maxC
    Color_Clusters(Clusters_out==i,:) = ones(size( Color_Clusters(Clusters_out==i,:),1),1)*Color_Map(i,:);
end
Variation = [0.7 1 1.3 0.6 0.8 1 1.2 0.5 0.6 0.8 1 1.2]';
Color_Clusters = Color_Clusters.*Variation;

%Change the color of the points in the plots
ldChangeColor(ld1,Color_Clusters,'concept1');



% Color map function
function Color_Map = make_color_map(maxC)
 if maxC==2
     Color_Map = [253,219,199;...
44,123,182]/255;

 elseif maxC==3
     Color_Map = [253,219,199;...
209,225,245;...
44,123,182]/255;
Color_Map = [ 215,25,28;...
171,221,164;...
43,131,186]/255;

  %  Color_Map = [202,0,32;...
%244,165,130;...
%146,197,222 ]/255;
 elseif maxC==4
    Color_Map = [ 202,0,32;...
244,165,130;...
146,197,222;...
5,113,176]/255;
 elseif maxC==5
     Color_Map = [ 215,25,28;...
253,174,97;...
255*0.8,255*0.8,191*0.8;...
171,221,164;...
43,131,186]/255;
% Color_Map = [ 215,25,28;...
% 253,174,97;...
% 255,255,191;...
% 171,217,233;...
% 44,123,182]/255;
 elseif maxC==6
Color_Map = [ 178,24,43;...
    239,138,98;...
    253,219,199;...
    209,229,240;...
    103,169,207;...
    33,102,172]/255;
 elseif maxC==7
Color_Map = [ 215,48,39;...
252,141,89;...
254,224,144;...
255,255,191;...
224,243,248;...
145,191,219;...
69,117,180]/255;
 elseif maxC==8
Color_Map = [ 215,48,39;...
244,109,67;...
253,174,97;...
254,224,144;...
224,243,248;...
171,217,233;...
116,173,209;...
69,117,180]/255;
 end
 
end
