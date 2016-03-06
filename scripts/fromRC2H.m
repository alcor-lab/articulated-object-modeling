%%%%%%%%%%%% From rc to c %%%
% reduce rows and columns to a column vector
% r are the rows
% c are the column
% n is the row number
%
% Author: Marta Sanzari, sanzari@diag.uniroma1.it
function q=fromRC2H(r,c,n)

q=(n*(c-1)+r);
