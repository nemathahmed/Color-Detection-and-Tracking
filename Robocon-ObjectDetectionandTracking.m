clc;clear all;close all;
clc; clear;
%  stop(vid);
%  flushdata(vid); 
close all; objects = imaqfind %find video input objects in memory
delete(objects) %delete a video input object from memory
obj=videoinput('winvideo',1);
%  b=getsnapshot(obj);
%  imshow(b);
a=imaqhwinfo('winvideo')
a.DeviceInfo.DeviceName
k=length(a.DeviceIDs);

for i=1:k
   a=imaqhwinfo('winvideo',i);
   if a.DeviceName(1)=='I'
       flag=1;
   end
end

if flag==0
    error('Device not found');
end
       
%f=format('MJPG_1280x720');%we are using default format
vid=videoinput('winvideo',i) %f)%,1);%f);
set(vid,'ReturnedColorspace','rgb');
set(vid,'FramesPerTrigger',Inf);

vid.FrameGrabInterval=1;
start(vid);
%while (vid.FramesAcquired<=300)
point=0;
    cen1(1)=0;
    cen1(2)=0;
    t=1:0.01:15;
for i=1:length(t)
    data=getsnapshot(vid);
    data1=0.5*data(:,:,1)+data(:,:,2)-1.5*rgb2gray(data);
    data1=medfilt2(data1,[1 1]);
    data1=im2bw(data1,0.05);
    data1=bwareaopen(data1,1000);
   
%    nnet = alexnet
%     picture = data1;              % Take a picture    
%     picture = imresize(picture,[227,227]);  % Resize the picture
% 
%     label = classify(nnet, picture);        % Classify the picture
%        
%     image(picture);     % Show the picture
%     title(char(label)); % Show the label
%     drawnow;   

    aret=bwarea(data1);
    ppm=0.1815;%property of my monotor
    er=sqrt(aret/3.14);%calculating radius in pixels
    distanceball=(330*40/(2*er))*0.264;%using focal length approximations
    bw=bwlabel(data1);
    s=regionprops(bw,'BoundingBox','Centroid');
    imshow(data)
    hold on
   
    %if aret>1.4151e+03
    for z=1:length(s)
   
       cen=s(z).Centroid;
       box=s(z).BoundingBox;

       
       plot(cen(1),cen(2),'*y');
        
        
       sp=(sqrt((abs(((cen(1)-cen1(1))*(cen(1)-cen1(1)))+((cen(2)-cen1(2))*(cen(2)-cen1(2))))))*(0.18/1000)/0.001)*distanceball/24;
       cen1(1)=cen(1);
       cen1(2)=cen(2);
        
        sp1(z)=sp;
       
       rectangle('Position',box,'EdgeColor','r','LineWidth',2),title('Robocon2018')
       a=text(cen(1),cen(2),strcat('X: ',num2str(round(cen(1))),'  Y:',num2str(round(cen(2)))));
       set(a, 'FontName','Arial','FontWeight','bold','FontSize',12,'Color','b');
       
     
       a=text(15,50,strcat('Speed(m/s): ',num2str(sp)));
       set(a, 'FontName','Arial','FontWeight','bold','FontSize',15,'Color','y')
      
       b=text(15,150,strcat('Distance(cm): ',num2str(distanceball)));
       set(b, 'FontName','Arial','FontWeight','bold','FontSize',15,'Color','y')
      point=point+1;
         xpoint(point)=cen(1);
         ypoint(point)=cen(2);
         
   
    end
    if point>0
    plot(xpoint,ypoint,'-g','LineWidth',3);
    end
    
    pause(0.001);
    end

   
    


stop(vid);
flushdata(vid); 