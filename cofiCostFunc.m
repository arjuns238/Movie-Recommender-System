function [J, grad] = cofiCostFunc(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
%COFICOSTFUNC Collaborative filtering cost function
%   [J, grad] = COFICOSTFUNC(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.
%

% Unfold the U and W matrices from params
X = reshape(params(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);

            
% Initializing the variable we need to return
J = 0;
X_grad = zeros(size(X));
Theta_grad = zeros(size(Theta));

% ======================  CODE  ======================
% Notes: X - num_movies  x num_features matrix of movie features
%        Theta - num_users  x num_features matrix of user features
%        Y - num_movies x num_users matrix of user ratings of movies
%        R - num_movies x num_users matrix, where R(i, j) = 1 if the 
%            i-th movie was rated by the j-th user
%%
%        X_grad - num_movies x num_features matrix, containing the 
%                 partial derivatives w.r.t. to each element of X
%        Theta_grad - num_users x num_features matrix, containing the 
%                     partial derivatives w.r.t. to each element of Theta
%
hyp = X*Theta';
hyp = hyp.*R;
Y1 = Y.*R;
J = (1/2) * sum(sum((hyp-Y1).^2)) + ((lambda/2)*(sum(sum((Theta.^2)))))...
+ ((lambda/2)*(sum(sum(X.^2))));
[m,n] = size(X);
for i = 1:m
  idx = find(R(i,:)==1);
  % idx is the number of users that have rated movie i
  Theta_temp = Theta(idx,:);
  Y_temp = Y(i,idx);
  X_grad(i,:) = ((X(i,:)*Theta_temp' - Y_temp)*Theta_temp) + (lambda * X(i,:));
 endfor
[m2, n2] = size(Theta);
for i = 1:m2
  idx = find(R(:,i)==1);
  % idx is the number of movies that user i has rated
  Theta_temp = Theta(i,:);
  X_temp = X(idx,:);
  Y_temp = Y(idx,i);
  Theta_grad(i,:) = ((X(idx,:)*Theta_temp' - Y_temp)'*X_temp) + (lambda * Theta(i,:));
endfor














% =============================================================

grad = [X_grad(:); Theta_grad(:)];

end
