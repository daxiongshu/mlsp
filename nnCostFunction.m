function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
%J=y'*log(sigmoid(Theta2*(sigmoid(Theta1*X))))/m-(1-y)'*log(1-sigmoid(Theta2*(sigmoid(Theta1*X))))/m;%
X=[ones(m,1) X];
yx=y;
%%%% need better
% yx=zeros(m,num_labels);
% for i=1:m
%     yx(i,y(i))=1;
% end
%%%%

%m2=size(Theta1,2)
hx=sigmoid([ones(m,1) sigmoid(X*Theta1')]*Theta2');

J=-(log(hx).*yx+(1-yx).*log(1-hx))/m;
J=sum(sum(J));
xx1=size(Theta1,2);
xx2=size(Theta2,2);
J=J+lambda/m/2*(sum(sum(Theta1(:,2:xx1).^2))+sum(sum(Theta2(:,2:xx2).^2)));

% Delta1=zeros(input_layer_size+1,hidden_layer_size);
% Delta2=zeros(hidden_layer_size+1,num_labels);
% delta3=zeros(input_layer_size,num_labels);
% delta2=zeros(input_layer_size,hidden_layer_size+1);
% 
% for k=1:m
%     a1=X(k,:);
%     a2=[1 sigmoid(a1*Theta1')];
%     a3=sigmoid(a2*Theta2');
%     delta3(k,:)=a3-yx(k,:);
%     delta2(k,:)=delta3(k,:)*Theta2.*(a2.*(1-a2))
% %     temp=delta3(k,:)*Theta2.*(a2.*(1-a2));
% %     delta2(k,:)=temp(2:hidden_layer_size+1);
%     Delta2=Delta2+a2'*delta3(k,:);
%     Delta1=Delta1+a1'*delta2(k,:);
% 
% end

D1=zeros(input_layer_size+1,hidden_layer_size);
D2=zeros(hidden_layer_size+1,num_labels);
d2=zeros(hidden_layer_size,1);
d3=zeros(num_labels,1);

for i=1:m
    a1=X(i,:)';
   % a1=[1;a1];
    a2=[1;sigmoid(Theta1*a1)];
    a3=sigmoid(Theta2*a2);
    d3=a3-yx(i,:)';
    d2=Theta2'*d3.*(a2.*(1-a2));
    D2=D2+a2*d3';
    D1=D1+a1*d2(2:hidden_layer_size+1)';
end

%size(Theta1)
%size(D1)
Theta1_grad=D1'/m+lambda*Theta1/m;
Theta1_grad(:,1)=Theta1_grad(:,1)-lambda*Theta1(:,1)/m;
Theta2_grad=D2'/m+lambda*Theta2/m;
Theta2_grad(:,1)=Theta2_grad(:,1)-lambda*Theta2(:,1)/m;




% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
