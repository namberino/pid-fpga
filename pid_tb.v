module pid_tb();

    initial begin
        $dumpfile("pid_tb.vcd");
        $dumpvars(0, pid_tb);
    end

    integer i;
    reg clk = 0;
    initial begin
        for (i = 0; i < 80; i++)
            #1 clk = ~clk;
    end

    reg pid_start;
    reg[15:0] data_in;
    wire[15:0] data_out;
    pid uut(
        .clk(clk),
        .rst(rst),
        .pid_start(pid_start),
        .data_in(data_in),
        .data_out(data_out)
    );

    reg rst;
    initial begin
        pid_start = 0;
        data_in = 0;

        // pulse reset signal
        rst = 1;
        #1
        rst = 0;

        #5
        
        // test 1 (no error)
        data_in = 16'd54321;
        #1
        pid_start = 1'b1;
        #2
        pid_start = 1'b0;

        #15

        // test 2 (negative error)
        data_in = 16'd55000;
        #1
        pid_start = 1'b1;
        #2
        pid_start = 1'b0;

        #15

        // test 3 (positive error)
        data_in = 16'd51000;
        #1
        pid_start = 1'b1;
        #2
        pid_start = 1'b0;

        #15

        rst = 1;
    end

endmodule
