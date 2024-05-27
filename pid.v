module pid (
    input clk,
    input rst,
    input pid_start,
    input[15:0] data_in,
    output[15:0] data_out
);
    
    // states
    reg[2:0] state;
    localparam IDLE = 3'b000;
    localparam CALC_ERROR = 3'b001;
    localparam CALC_PID = 3'b010;
    localparam ADD_PID = 3'b011;
    localparam ADJUST_PID_VALUE = 3'b100;
    localparam OUTPUT_PID = 3'b101;

    // set point (the value PID tries to achieve)
    localparam setpoint = 54321;

    // pid constants (used for tuning)
    reg[15:0] kp = 10;
    reg[15:0] kd = 30;
    reg[15:0] ki = 1;
    
    // pid error
    reg[15:0] p = 0;
    reg[15:0] d = 0;
    reg[15:0] i = 0;

    // pid total
    reg[31:0] pid_total = 0;

    // intermediate data
    reg[15:0] inter_data = 0;

    // error and output
    reg[15:0] error = 0;
    reg[15:0] prev_error = 0;
    reg[15:0] out = 0;
    reg[15:0] prev_out = 0;

    always @ (posedge clk, posedge rst)
    begin
        if (rst)
        begin
            state = IDLE;
            p = 0;
            d = 0;
            i = 0;
        end else
        begin
            case (state)
                IDLE: 
                begin
                    inter_data <= data_in;
                    prev_error <= error;
                    prev_out <= out;

                    if (pid_start)
                        state <= CALC_ERROR;
                    else
                        state <= IDLE;
                end

                CALC_ERROR:
                begin
                    error <= setpoint - inter_data;

                    state <= CALC_PID;
                end

                CALC_PID:
                begin
                    p <= kp * error;
                    d <= kd * (error - prev_error);
                    i <= ki * (error + prev_error);

                    state <= ADD_PID;
                end

                ADD_PID:
                begin
                    pid_total <= prev_out + (p + i + d);

                    state <= ADJUST_PID_VALUE;
                end

                ADJUST_PID_VALUE:
                begin
                    if (pid_total > 65535)
                        pid_total <= 65535;
                    else if (pid_total < 1)
                        pid_total <= 1;

                    state <= OUTPUT_PID;
                end

                OUTPUT_PID:
                begin
                    out <= pid_total[15:0];

                    state <= IDLE;
                end
            endcase
        end
    end

    assign data_out = out;

endmodule
