function [C_A,C, label, J] = kmeans(I, k)
[m, n, p] = size(I);
X = reshape(double(I), m*n, p);
rng('default');
C = X(randperm(m*n, k), :);
C_A = X(randperm(m*n, k), :);
J_prev = inf; iter = 0; J = []; tol = 1e-2;
while true
    iter = iter + 1;
    dist = sum(X.^2, 2)*ones(1, k) + (sum(C.^2, 2)*ones(1, m*n))' - 2*X*C';
    [~, label] = min(dist, [], 2) ;%����ά��Ϊ2����СԪ�أ����Ƿ��ذ���ÿһ�е���Сֵ���������൱�ڸ�ÿһ�����ݶ������˱�ǩ
    for i = 1:k
       C(i, :) = mean(X(label == i , :));
    end
    J_cur = sum(sum((X - C(label, :)).^2, 2));
    J = [J, J_cur];
    %display(sprintf('#iteration: %03d, objective fcn: %f', iter, J_cur));
    if norm(J_cur-J_prev, 'fro') < tol,
        break;
    end
    J_prev = J_cur;
end
