# Genetic-Algorithm-Sheffield-University

1. Copy the toolbox folder to the toolbox directory on the local computer, with the path being matlabroot/toolbox. Where matlabroot is the installation directory of Matlab

2. Add the folder where the toolbox is located to the search path in MATLAB, which can be added by calling the addpath command.

```
% Obtain the full path to the toolbox    
str = [matlabroot, '/toolbox/gatbx'];  
% Add it to the MATLAB search path  
addpath(str) 
```

3. You can use the function ver to view the name, release version, etc. of the Gatbx toolbox

```
v = ver('gatbx')
```
