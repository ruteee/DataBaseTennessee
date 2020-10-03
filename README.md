# Database Tennessee
The Tennessee database is a simulation that uses Matlab's Simulink, [original source here](http://depts.washington.edu/control/LARRY/TE/download.html "Tennessee Eastman Archive"). This simulation corresponds to the Tennessee Eastman 
Process (TEP), which is a simulator based on a real industrial chemical process. The process consists of five main units, 
namely the reactor, the product condenser, a vapor-liquid separator, a recycling compressor and the pickling.

In addition, the TEP has 12 manipulated variables and 41 measurement variables available for monitoring or control 
purposes. Of these 41 process variables provided for monitoring, 22 are continuous process variables and 19 are 
discrete process variables.

For the purpose of fault simulation and evaluation of control methods and failure detection, the TEP also has 20
 disturbances that can be applied during the simulations.

### Run DataBaseTennessee
To run the Tennessee database on Matlab, you need the following commands:

1. Call the settings:
```
$ setup
```
2. With the `tennessee_setup` function, enter the simulation settings:
- Model
- Start time
- End time
- Disturb
- Start time of disturbance
- End time of disturbance
```
$ var = tennessee_setup('MultiLoop_mode1',
                        'sim_start',0,
                        'sim_end', 100, 
                        'dist_id',[1,2],
                        'dist_start',[10,50],
                        'dist_end',[30,70])
```
In the example above, a simulation will be created using the `MultiLoop_mode1` model, lasting 100 hours, starting at time 
0 (zero). The disturbances used were 1 and 2, disturbance 1 corresponds to IDV1 which is activated at the time corresponding 
to 10 hours and deactivated at the time corresponding to 30 hours; disturbance 2 corresponds to IDV2, being activated at hour 
50 and deactivated at hour 70.

3. Run simulation:
```
$ process_data_gen(var,'name','name.csv')
```
At the end of the simulation, a `name.csv` file was generated with the TEP process variables.

### Reference
Downs, J. J., & Vogel, E. F. (1993). A plant-wide industrial process control problem. Computers & Chemical Engineering, 
17(3), 245–255. https://doi.org/10.1016/0098-1354(93)80018-I
