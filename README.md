# PID Controller in FPGA

Proportional - Integral - Derivative (PID) controller is a control structure used in control systems and other applications that require continuous modulated control such as robots. They are widely used in different areas (a lot in industrial applications) because of their robustness and efficiency along with being able to be applied to various different applications. PID controllers are usually implemented in hardware using analog components or in software. 

This project aims to implement a PID controller on FPGA. This provides many advantages: programmable bit widths, speed, power efficiency. Because of the reprogrammability of FPGA, it has lots of advantages over Application Specific Standard Product (ASSP) such as flexibility, performance and customizability. This means an PID controller designed for a specific FPGA to be used in a specific application can be modified to operate differently if we need to use that specific FPGA for other applications.
