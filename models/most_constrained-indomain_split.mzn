% Parameters:
int : n;
int : maxTotal = 5000;
array[1..n,1..6] of int: groceries; % Asumimos que el arreglo viene ordenado, conocemos cada producto
array[1..4,1..2] of int: requirements; % 
int: budget; % 

% Variables:
array[1..n] of var 0..: grocerylist; % grocerylist[i] Representa el número de unidades que se van a sugerir del producto i.
var 0..: acumprice; %
var 0..: totalItems; %

%var 0..: calories; %
var 0..: protein; %
var 0..: carbo; %
var 0..: fat; %

%var 0..: lackCal;
var 0..: lackPro;
var 0..: lackCar;
var 0..: lackFat;
%var 0..: excessCal;
var 0..: excessPro;
var 0..: excessCar;
var 0..: excessFat;
var 0..: mnt;

% Constraints:

%Variety. (Review: See if its better if we reward variety.
constraint forall(i in 1..n)
            (grocerylist[i] <= 3);

% Total.
constraint totalItems = sum(i in 1..n)
            (grocerylist[i]);

% Calories.
%constraint  calories = sum(i in 1..n)
%            (grocerylist[i] * groceries[i,1]);
% Range.
%constraint lackCal = (requirements[1,1] > calories)*(requirements[1,1] - calories);
%constraint excessCal = (calories > requirements[1,2])*(calories - requirements[1,2]);

% Protein.
constraint protein = sum(i in 1..n)
            (grocerylist[i] * groceries[i,2]);
% Range.
constraint lackPro = (requirements[2,1] > protein)*(requirements[2,1] - protein);
constraint excessPro = (protein > requirements[2,2])*(protein - requirements[2,2]);

% Carbohidrates.
constraint carbo = sum(i in 1..n)
            (grocerylist[i] * groceries[i,3]);
% Range.
constraint lackCar = (requirements[3,1] > carbo)*(requirements[3,1] - carbo);
constraint excessCar = (carbo > requirements[3,2])*(carbo - requirements[3,2]);

% Fat.
constraint  fat = sum(i in 1..n)
            (grocerylist[i] * groceries[i,4]);
% Range.
constraint lackFat = (requirements[4,1] > fat)*(requirements[4,1] - fat);
constraint excessFat = (fat > requirements[4,2])*(fat - requirements[4,2]);
             
% Inventory.
constraint forall(i in 1..n)(grocerylist[i] <= groceries[i,5]);

% Prices and budget.
constraint acumprice = sum(i in 1..n)(grocerylist[i] * groceries[i,6]);

constraint mnt = (lackPro*100 div maxTotal + lackCar*100 div maxTotal + lackFat*100 div maxTotal + excessPro*100 div maxTotal + excessCar*100 div maxTotal + excessFat*100 div maxTotal)*90 + 10*(6*acumprice*100 div budget);

% Objective Function:
solve :: int_search([lackPro,lackCar,lackFat], most_constrained,indomain_split)
minimize mnt;