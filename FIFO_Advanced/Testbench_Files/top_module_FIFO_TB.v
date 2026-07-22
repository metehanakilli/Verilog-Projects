`timescale 1ns / 1ps

module top_module_FIFO_TB;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 7;
    parameter SHIFT_REG = 20;
    parameter SUFFICIENT_NUMBER_OF_ONES = 12;
    parameter ONES_COUNT_BIT = 5;


    reg clk;
    reg rst_n;
    reg rbtn_in;
    reg wbtn_in;
    reg [6:0] SW;


    wire wfull;
    wire almost_wfull;
    wire rempty;
    wire almost_rempty;
    wire [DATA_WIDTH:0] wpntr;
    wire [DATA_WIDTH:0] rpntr;
    wire [DATA_WIDTH-1:0] waddr;
    wire [DATA_WIDTH-1:0] raddr;
    wire [DATA_WIDTH:0] wq2_rpntr;
    wire [DATA_WIDTH:0] rq2_wpntr;
    wire [DATA_WIDTH-1:0] rdata;
    wire [DATA_WIDTH-1:0] wdata;
    wire [6:0] led;
    wire wclk;
    wire rclk;
    wire wbtn_out;
    wire rbtn_out;
    wire rinc;
    wire winc;


    top_module_FIFO #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .SHIFT_REG(SHIFT_REG),
        .SUFFICIENT_NUMBER_OF_ONES(SUFFICIENT_NUMBER_OF_ONES),
        .ONES_COUNT_BIT(ONES_COUNT_BIT)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .rbtn_in(rbtn_in),
        .wbtn_in(wbtn_in),
        .SW(SW),
        .led(led)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // --- 4. Gercek Hayat Senaryo Task'leri (1kHz Debouncer Icin Uyarlanmis) ---
    // 1kHz = 1 ms periyot. Debouncer esigi = 12 ms (12,000,000 ns).
    // Not: Okunabilirlik icin sayilarda alt cizgi (_) kullanilmistir.
    
    task press_wbtn_bouncy_1kHz;
        begin
            $display("[%0t] YAZMA Butonuna basiliyor (Mekanik Sicrama)...", $time);
            
            // 1. BASMA TITRESIMI (PRESS BOUNCE - Toplam 5-6 ms surer)
            wbtn_in = 1; #1_500_000;   // 1.5 ms temas
            wbtn_in = 0; #800_000;     // 0.8 ms kopma
            wbtn_in = 1; #3_000_000;   // 3.0 ms temas
            wbtn_in = 0; #1_200_000;   // 1.2 ms kopma
            wbtn_in = 1; #2_000_000;   // 2.0 ms temas
            wbtn_in = 0; #700_000;     // 0.7 ms kopma
            
            // 2. KALICI TEMAS (SOLID CONTACT - 12ms esigini asmak icin 25 ms basili tutuyoruz)
            wbtn_in = 1; #10_800_000;  // 25 ms boyunca kesintisiz basili tutma
            rst_n=0; #100000; rst_n=1; #1000
            // 3. BIRAKMA TITRESIMI (RELEASE BOUNCE)
            wbtn_in = 0; #2_000_000;   // 2.0 ms kopma
            wbtn_in = 1; #1_500_000;   // 1.5 ms temas (Geri sekme)
            wbtn_in = 0; #1_000_000;   // 1.0 ms kopma
            wbtn_in = 1; #500_000;     // 0.5 ms temas
            
            // 4. TAMAMEN SERBEST (RELEASED - Iki basim arasi 20 ms dinlenme)
            wbtn_in = 0; #20_000_000;  
        end
    endtask

    task press_rbtn_bouncy_1kHz;
        begin
            $display("[%0t] OKUMA Butonuna basiliyor (Mekanik Sicrama)...", $time);
            
            // 1. BASMA TITRESIMI
            rbtn_in = 1; #1_800_000;   // 1.8 ms temas
            rbtn_in = 0; #900_000;     // 0.9 ms kopma
            rbtn_in = 1; #4_200_000;   // 4.2 ms temas
            rbtn_in = 0; #1_100_000;   // 1.1 ms kopma
            
            // 2. KALICI TEMAS
            rbtn_in = 1; #25_000_000;  // 25 ms kesintisiz basili tutma
            
            // 3. BIRAKMA TITRESIMI
            rbtn_in = 0; #1_500_000;   // 1.5 ms kopma
            rbtn_in = 1; #1_200_000;   // 1.2 ms temas
            
            // 4. TAMAMEN SERBEST
            rbtn_in = 0; #20_000_000;
       
        end
        
    endtask

    // ELEKTROMANYETIK PARAZIT (GLITCH) SENARYOSU
    task wbtn_glitch_1kHz;
        begin
            $display("[%0t] Hatta 8 milisaniyelik gurultu bindi (12ms esigini asmamali!)...", $time);
            // 12 ms'lik filtre esigini asamayan 8 ms'lik (8,000,000 ns) sahte bir sinyal
            wbtn_in = 1; #8_000_000; 
            wbtn_in = 0; #20_000_000;
        end
    endtask

    integer i;

    // --- 5. Ana Test Akisi ---
    initial begin
        // Baslangic Durumlari
        rst_n = 0;
        rbtn_in = 0;
        wbtn_in = 0;
        SW = 7'h00; 
        
        #100;
        rst_n = 1; 
        
        #5_000_000; // Modullerin stabil hale gelmesi icin 5 ms bekle

        $display("\n=======================================================");
        $display("--- SENARYO 1: TEMIZ VE IDEAL YAZMA / OKUMA ---");
        wbtn_in = 1; #25_000_000; wbtn_in = 0; #20_000_000; // 25ms bas, 20ms cek
        rbtn_in = 1; #25_000_000; rbtn_in = 0; #20_000_000;
           wbtn_in = 1; #25_000_000; wbtn_in = 0; #20_000_000; // 25ms bas, 20ms cek
        rbtn_in = 1; #25_000_000; rbtn_in = 0; #20_000_000;


 $display("\n=======================================================");
        $display("--- SENARYO 2: ASIRI GERCEKCI (BOUNCY) YAZMA / OKUMA ---");
        press_wbtn_bouncy_1kHz(); 
        press_rbtn_bouncy_1kHz(); 

        $display("\n=======================================================");
        $display("--- SENARYO 3: ELEKTROMANYETIK PARAZIT (GLITCH) TESTI ---");
        wbtn_glitch_1kHz(); 

        $display("\n=======================================================");
        $display("--- SENARYO 4: SW DURUMLARI (LED KONTROLU) ---");
        SW = 7'h01; 
        #5_000_000;
        SW = 7'h00; 
        #5_000_000;
 
        
	end

endmodule
