%% non linear least square using lm

%% generating random data for non linear fitting of the curve
m = 0.3;
c = 0.1;
x = [0:0.05:5];
y = exp(m*x + c);
noise = 0.2*randn(size(x));
y_obs = y + noise;
data = [transpose(x), transpose(y_obs)];

plot(x,y,x,y_obs,'*')
hold off;
%% initialization of variables
m_init = 0.0;
c_init = 0.0;
f_new = transpose(y_obs) - exp(m_init*transpose(x) + c_init);
max_iter = 20;
delta = [0;0];
lambda = 5;
lambda_list = [lambda];
i_list = [1];

%% loop for LM
m_new = m_init;
c_new = c_init;
for i = 2:max_iter
    J = jacobian_at_val(m_new,c_new,x);
    f_next = f_new + J*[delta(1,1);delta(2,1)]
    next_delta = -(pinv((transpose(J)*J + lambda*eye(2))))*(transpose(J))*(f_new);
    m_new = m_new - next_delta(1,1);
    c_new = c_new - next_delta(2,1);
    delta = next_delta;
    f_prev = f_new;
    f_new = transpose(y_obs) - exp(m_new*transpose(x) + c_new);
    
     if(sum(f_prev.^2) > sum(f_new.^2))
         % accept the iterate
         lambda = 0.8*lambda;
     else
         % dont accept the iterate and bring back the old values of m and c
         m_new = m_new + next_delta(1,1);
         c_new = c_new + next_delta(2,1);
         f_new = f_prev
         lambda = 2*lambda;
     end
     
     lambda_list = [lambda_list, lambda];
     i_list = [i_list, i];
    i
    subplot(2,1,1)
    plot(x,y,'k-.'); hold on;
    scatter(x,y_obs,10, 'filled'); hold on;
    x = [0:0.05:5];
    y_new = exp(m_new*x + c_new);
    plot(x,y_new,'r');
    xlabel('X')
    ylabel('Function Value - Y')
    legend('True Function', 'Random Value','Fitted Function');
    title('Simulation');
    drawnow
    hold off;
    
    subplot(2,1,2)
    plot(i_list,lambda_list, 'b--o')
    xlabel('Number of Iteration')
    ylabel('Value of Lambda')
    title('Value of lambda versus each iteration');
    
    pause
    saveas(gcf, ['exp_function_fit/', num2str(i,'%04.f'), '.png']);
    hold off;
    
end
