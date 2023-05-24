int: budget; %
set of int: N = 0..budget;
% Parameters:S
N : n;
array[1..n,1..5] of N: groceries; % Asumimos que el arreglo viene ordenado, conocemos cada producto
array[1..3,1..2] of N: requirements; % 
array[1..3,1..2] of N: offset;
 
N: variety; %

% Variables:
array[1..n] of var N: grocerylist; % grocerylist[i] Representa el número de unidades que se van a sugerir del producto i.
var N: acumprice; %

var N: protein; %
var N: carbo; %
var N: fat; %

var N: lackPro;
var N: lackCar;
var N: lackFat;
var N: excessPro;
var N: excessCar;
var N: excessFat;
var N: mnt;

% Constraints:
%Variety.
constraint forall(i in 1..n)
            (grocerylist[i] <= variety);

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

% Objective Function:
solve :: int_search([lackPro,lackCar,lackFat], occurrence,indomain_reverse_split)
minimize mnt;