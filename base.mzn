% Parameters:
int : n;
int : maxTotal = 5000;
array[1..n,1..5] of int: groceries; % Asumimos que el arreglo viene ordenado, conocemos cada producto
array[1..3,1..2] of int: requirements; % 
array[1..3,1..2] of int: offset;
int: budget; % 
int: variety; %

% Variables:
array[1..n] of var 0..: grocerylist; % grocerylist[i] Representa el número de unidades que se van a sugerir del producto i.
var 0..: acumprice; %
%var 0..: totalItems; %

var 0..: protein; %
var 0..: carbo; %
var 0..: fat; %

var 0..: lackPro;
var 0..: lackCar;
var 0..: lackFat;
var 0..: excessPro;
var 0..: excessCar;
var 0..: excessFat;
var 0..: mnt;

% Constraints:
%Variety. (Review: See if its better if we reward variety.
constraint forall(i in 1..n)
            (grocerylist[i] <= variety);

% Total (Display).
%constraint totalItems = sum(i in 1..n)
%            (grocerylist[i]);

% Protein.
constraint protein = sum(i in 1..n)
            (grocerylist[i] * groceries[i,1]);
% Range.
constraint lackPro = (requirements[1,1] > protein)*(requirements[1,1] - protein);
constraint lackPro <= offset[1,1];
constraint excessPro = (protein > requirements[1,2])*(protein - requirements[1,2]);
constraint excessPro <= offset[1,2];

% Carbohidrates.
constraint carbo = sum(i in 1..n)
            (grocerylist[i] * groceries[i,2]);
% Range.
constraint lackCar = (requirements[2,1] > carbo)*(requirements[2,1] - carbo);
constraint lackCar <= offset[2,1];
constraint excessCar = (carbo > requirements[2,2])*(carbo - requirements[2,2]);
constraint excessCar <= offset[2,2];

% Fat.
constraint  fat = sum(i in 1..n)
            (grocerylist[i] * groceries[i,3]);
% Range.
constraint lackFat = (requirements[3,1] > fat)*(requirements[3,1] - fat);
constraint lackFat <= offset[3,1];
constraint excessFat = (fat > requirements[3,2])*(fat - requirements[3,2]);
constraint excessFat <= offset[3,2];
             
% Inventory.
constraint forall(i in 1..n)(grocerylist[i] <= groceries[i,4]);

% Prices and budget.
constraint acumprice = sum(i in 1..n)(grocerylist[i] * groceries[i,5]);

% New
constraint mnt = ((((lackPro*100) div offset[1,1])+((lackCar*100) div offset[2,1])+((lackFat*100) div offset[3,1])) div 3)*65 +
                 ((((excessPro*100) div offset[1,2])+((excessCar*100) div offset[2,2])+((excessFat*100) div offset[3,2])) div 3)*25 +      
                 (acumprice*100 div budget)*10;

% Old
%constraint mnt = (((4*lackPro+4*lackCar+9*lackFat)*100) div offset[1])*65+(((4*excessPro+4*excessCar+9*excessFat)*100) div offset[2])*25 + (acumprice*100 div budget)*10;
% Older
%constraint mnt = (lackPro*100 div maxTotal + lackCar*100 div maxTotal + lackFat*100 div maxTotal + excessPro*100 div maxTotal + excessCar*100 div maxTotal + excessFat*100 div maxTotal)*82 + 18*(3*acumprice*100 div budget);

% Objective Function:
solve :: int_search([lackPro,lackCar,lackFat], first_fail, indomain_split)

minimize mnt;