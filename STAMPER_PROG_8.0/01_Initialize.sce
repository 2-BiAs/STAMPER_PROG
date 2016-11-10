clear
clc

printf('\nBegin Initialization\n');

printf('\nBuilding Libraries\n');

exec('bin\BuildLibs.sci');
BuildLibs();

printf('\nLoading Libraries\n');

exec('bin\LoadLibs.sci');
LoadLibs();

printf('\nInitialization Complete\n');
