% Parameters:
int : n;
array[1..n,1..6] of int: groceries; % Asumimos que el arreglo viene ordenado, conocemos cada producto
array[1..4,1..2] of int: requirements; % 
%int: budget; % 

% Variables:
array[1..n] of var 0..: grocerylist; % grocerylist[i] Representa el número de unidades que se van a sugerir del producto i.
var 0..: acumprice; %
var 0..: totalItems; %

%var 0..: calories; %
var 0..: protein; %
var 0..: carbo; %
var 0..: fat; %

%var 0..: minCal;
var 0..: minPro;
var 0..: minCar;
var 0..: minFat;
%var 0..: maxCal;
var 0..: maxPro;
var 0..: maxCar;
var 0..: maxFat;
var 0..: mnt;

% Constraints:

%Variety. (Review: See if its better if we reward variety.
%constraint forall(i in 1..n)
            (grocerylist[i] <= 3);

% Total.
constraint totalItems = sum(i in 1..n)
            (grocerylist[i]);

% Calories.
%constraint  calories = sum(i in 1..n)
%            (grocerylist[i] * groceries[i,1]);
% Range.
%constraint minCal = (requirements[1,1] > calories)*(requirements[1,1] - calories);
%constraint maxCal = (calories > requirements[1,2])*(calories - requirements[1,2]);

% Protein.
constraint protein = sum(i in 1..n)
            (grocerylist[i] * groceries[i,2]);
% Range.
constraint minPro = (requirements[2,1] > protein)*(requirements[2,1] - protein);
constraint maxPro = (protein > requirements[2,2])*(protein - requirements[2,2]);

% Carbohidrates.
constraint  carbo = sum(i in 1..n)
            (grocerylist[i] * groceries[i,3]);
% Range.
constraint minCar = (requirements[3,1] > carbo)*(requirements[3,1] - carbo);
constraint maxCar = (carbo > requirements[3,2])*(carbo - requirements[3,2]);

% Fat.
constraint  fat = sum(i in 1..n)
            (grocerylist[i] * groceries[i,4]);
% Range.
constraint minFat = (requirements[4,1] > fat)*(requirements[4,1] - fat);
constraint maxFat = (fat > requirements[4,2])*(fat - requirements[4,2]);
             
% Inventory.
constraint forall(i in 1..n)(grocerylist[i] <= groceries[i,5]);

% Prices and budget.
constraint acumprice = sum(i in 1..n)(grocerylist[i] * groceries[i,6]);
%constraint acumprice <= budget;

constraint mnt = minPro + minCar + minFat + maxPro + maxCar + maxFat;

% Objective Function:
solve :: int_search([minPro,minCar,minFat,maxPro,maxCar,maxFat], most_constrained,indomain_max)
minimize mnt;

% PRUEBAS:
% smallest, indomain_random