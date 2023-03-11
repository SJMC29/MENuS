% Parameters:
int : n;
array[1..n,1..6] of int: groceries; % Asumimos que el arreglo viene ordenado, conocemos cada producto
array[1..4,1..2] of int: requirements; % 
%int: budget; % 

% Variables:
array[1..n] of var 0..100000: grocerylist; % grocerylist[i] Representa el número de unidades que se van a sugerir del producto i.
var 0..100000: acumprice; %
var 0..100000: totalItems; %

%var 0..100000: calories; %
var 0..100000: protein; %
var 0..100000: carbo; %
var 0..100000: fat; %

%var 0..100000: minCal;
var 0..100000: minPro;
var 0..100000: minCar;
var 0..100000: minFat;
%var 0..100000: maxCal;
var 0..100000: maxPro;
var 0..100000: maxCar;
var 0..100000: maxFat;
var 0..100000: mnt;

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
solve :: int_search([minPro,minCar,minFat,maxPro,maxCar,maxFat], smallest,indomain_middle)
minimize mnt;

% PRUEBAS:
% smallest, indomain_random