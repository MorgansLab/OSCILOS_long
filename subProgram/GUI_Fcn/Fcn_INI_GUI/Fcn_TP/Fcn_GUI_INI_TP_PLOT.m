%-------------------------------------------------------------------------
%
function Fcn_GUI_INI_TP_PLOT(varargin)
hObject = varargin{1};
handles = guidata(hObject);
global CI
hAxes1=handles.axes1;
pop_plot = get(handles.pop_plot,'Value');
%------------------------------------
cla(hAxes1)
axes(hAxes1)
hold on
set(hAxes1,'YColor','k','Box','on','ygrid','on','xgrid','on');
set(hAxes1,'FontName','Helvetica','FontSize',handles.FontSize(1),'LineWidth',1)
xlabel(hAxes1,'$x $ [m]','Color','k','Interpreter','LaTex','FontSize',handles.FontSize(1));
set(hAxes1,'xlim',[CI.CD.x_sample(1), CI.CD.x_sample(end)],...
    'xtick',CI.CD.x_sample(1:end),...
    'YAxisLocation','left','Color','w');
%
N = length(CI.CD.index);
x_plots(1:N-1,1) = CI.CD.x_sample(1:N-1);
x_plots(1:N-1,2) = CI.CD.x_sample(2:N);
%
switch pop_plot
    case 1  
        y_plots(1:N-1,1:2) = CI.TP.u_mean(1,1:N-1);
    case 2
        y_plots(1:N-1,1:2) = CI.TP.T_mean(1,1:N-1);
end
%
for ss = 1:N-1
    ColorUDF{ss} = 'b';         % color of the line
end
indexFlame = find(CI.CD.index == 1);
if isempty(indexFlame) == 0
    for ss = indexFlame:N-1
        ColorUDF{ss} = 'r';
    end
end
indexLiner = find(CI.CD.index == 30);
if isempty(indexLiner) == 0
   switch pop_plot
        case 1  
            y_plots(indexLiner,2) = CI.TP.u_mean(1,indexLiner+1);
        case 2
            y_plots(indexLiner,2) = CI.TP.T_mean(1,indexLiner+1);
   end
end
%
for ss = 1:N-1
plot(hAxes1,[x_plots(ss,1),x_plots(ss,2)],[y_plots(ss,1),y_plots(ss,2)]);
end

    
    
    
switch pop_plot
    case 1
        %% Begin changing by Dong Yang
        % Find the flame position. If there is no flame, f_location_num would
        % be equal to length(CI.CD.x_sample)+1
        f_location_num=1;
        while f_location_num<=length(CI.CD.x_sample) && abs(CI.CD.index(f_location_num)-1)>0
            f_location_num=f_location_num+1;
        end
        % Add one element to u_mean for plotting
        U_mean(1,:)=CI.TP.u_mean(1,:);
        U_mean(1,length(CI.CD.x_sample))=CI.TP.u_mean(1,(length(CI.CD.x_sample)-1)); 
        % Plot 
        for ss=1:length(CI.CD.x_sample)-1
            switch CI.CD.index(ss)
                case 30 % Plot the liner section
                    if ss < f_location_num % Before the flame
                        plot([CI.CD.x_sample(ss) CI.CD.x_sample(ss+1)],[U_mean(1,ss),U_mean(1,ss+1)],'color','b','linewidth',2,...
    		            'linestyle','-')
                    else
                        plot([CI.CD.x_sample(ss) CI.CD.x_sample(ss+1)],[U_mean(1,ss),U_mean(1,ss+1)],'color','r','linewidth',2,...
    		            'linestyle','-')
                    end 
                otherwise % Plot other sections
                    if ss < f_location_num % Before the flame
                       plot([CI.CD.x_sample(ss) CI.CD.x_sample(ss+1)],U_mean(1,ss).*[1 1],'color','b','linewidth',2,...
    		            'linestyle','-')
                       if ss+1==f_location_num
                           plot([CI.CD.x_sample(ss+1) CI.CD.x_sample(ss+1)],[U_mean(1,ss),U_mean(1,ss+1)],'color','r','linewidth',2,...
    		               'linestyle','--')
                       else
                           plot([CI.CD.x_sample(ss+1) CI.CD.x_sample(ss+1)],[U_mean(1,ss),U_mean(1,ss+1)],'color','b','linewidth',2,...
    		               'linestyle','--')
                       end
                    else  if ss >= f_location_num % After the flame
                           plot([CI.CD.x_sample(ss) CI.CD.x_sample(ss+1)],U_mean(1,ss).*[1 1],'color','r','linewidth',2,...
    		                    'linestyle','-')
                            if ss+1<length(CI.CD.x_sample) 
                              plot([CI.CD.x_sample(ss+1) CI.CD.x_sample(ss+1)],[U_mean(1,ss),U_mean(1,ss+1)],'color','r','linewidth',2,...
    		                    'linestyle','--')  
                            else
                                % Right side of this section is the end
                            end
                          end
                    % Not possible to happen    
                    end 
            end
        end
        %% End changing by Dong Yang
        ylabel(hAxes1,'$\bar{u}$ [m/s]','Color','k','Interpreter','LaTex','FontSize',handles.FontSize(1));
        yvalue_max=max(CI.TP.u_mean(1,:));
        yvalue_min=min(CI.TP.u_mean(1,:));
        ymax=yvalue_max+round((yvalue_max-yvalue_min).*10)./50+eps;
        ymin=yvalue_min-round((yvalue_max-yvalue_min).*10)./50-eps;
        if ymax<=ymin
            ymax = ymax+0.1*mean(CI.TP.u_mean);
            ymin = ymin-0.1*mean(CI.TP.u_mean);
        end
    case 2
        %% Begin changing by Dong Yang
        % Find the flame position. If there is no flame, f_location_num would
        % be equal to length(CI.CD.x_sample)+1
        f_location_num=1;
        while f_location_num<=length(CI.CD.x_sample) && abs(CI.CD.index(f_location_num)-1)>0
            f_location_num=f_location_num+1;
        end
        % Add one element to T_mean for plotting
        T_mean(1,:)=CI.TP.T_mean(1,:);
        T_mean(1,length(CI.CD.x_sample))=CI.TP.T_mean(1,(length(CI.CD.x_sample)-1)); 
        % Plot 
        for ss=1:length(CI.CD.x_sample)-1
            switch CI.CD.index(ss)
                case 30 % Plot the liner section
                    if ss < f_location_num % Before the flame
                        plot([CI.CD.x_sample(ss) CI.CD.x_sample(ss+1)],[T_mean(1,ss),T_mean(1,ss+1)],'color','b','linewidth',2,...
    		            'linestyle','-')
                    else
                        plot([CI.CD.x_sample(ss) CI.CD.x_sample(ss+1)],[T_mean(1,ss),T_mean(1,ss+1)],'color','r','linewidth',2,...
    		            'linestyle','-')
                    end 
                otherwise % Plot other sections
                    if ss < f_location_num % Before the flame
                       plot([CI.CD.x_sample(ss) CI.CD.x_sample(ss+1)],T_mean(1,ss).*[1 1],'color','b','linewidth',2,...
    		            'linestyle','-')
                       if ss+1==f_location_num
                           plot([CI.CD.x_sample(ss+1) CI.CD.x_sample(ss+1)],[T_mean(1,ss),T_mean(1,ss+1)],'color','r','linewidth',2,...
    		               'linestyle','--')
                       else
                           plot([CI.CD.x_sample(ss+1) CI.CD.x_sample(ss+1)],[T_mean(1,ss),T_mean(1,ss+1)],'color','b','linewidth',2,...
    		            'linestyle','--')
                       end
                    else  if ss >= f_location_num % After the flame
                           plot([CI.CD.x_sample(ss) CI.CD.x_sample(ss+1)],T_mean(1,ss).*[1 1],'color','r','linewidth',2,...
    		                    'linestyle','-')
                            if ss+1<length(CI.CD.x_sample) 
                              plot([CI.CD.x_sample(ss+1) CI.CD.x_sample(ss+1)],[T_mean(1,ss),T_mean(1,ss+1)],'color','r','linewidth',2,...
    		                    'linestyle','--')  
                            else
                                % Right side of this section is the end
                            end
                          end
                    % Not possible to happen    
                    end 
            end
        end
        %% End changing by Dong Yang
        ylabel(hAxes1,'$\bar{T}$ [K]','Color','k','Interpreter','LaTex','FontSize',handles.FontSize(1));
        yvalue_max=max(CI.TP.T_mean(1,:));
        yvalue_min=min(CI.TP.T_mean(1,:));   
        ymax=yvalue_max+round((yvalue_max-yvalue_min).*10)./50+eps;
        ymin=yvalue_min-round((yvalue_max-yvalue_min).*10)./50-eps;
        if ymax<=ymin
            ymax = ymax+10;
            ymin = ymin-10;
        end
end
        set(hAxes1,'ylim',[ymin ymax])
hold off
%--------------------------------
assignin('base','CI',CI); 
% 
% -----------------------------end-----------------------------------------