function J = jacobian_at_val(m,c,x)

syms xi mi ci
J_var = jacobian(exp(mi*xi + ci),[mi, ci]);
xi = transpose(x);
mi = m;
ci = c;
J = double(subs(J_var));

end

