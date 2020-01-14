library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity lab_8 is
port(     clk : in std_logic;
          rx_in : in std_logic;
          reset : in std_logic;
--          idle : in std_logic;   
          led : out std_logic_vector(7 downto 0) := "00000000");
          
--          seg : out std_logic_vector(6 downto 0);
--          an : out std_logic_vector(3 downto 0) := "1110");
              
end lab_8;

architecture Behavioral of lab_8 is
        signal rx_reg : std_logic_vector(7 downto 0);  
        signal rx_clk : std_logic := '0'; 
        TYPE state_type IS (Idle, start, si); 
        signal state : state_type := Idle; 
        signal count : Integer := 0;
        signal i : Integer := 0;     -- counter for index of bits of rx_reg
        signal temp : Integer := 0;  --  temp is used as a counter for converting  
                                     --  input clock to Clock with baud rate = 9600, 8 bits
               
    begin
    
      --for Converting Input Clock
      -- to Clock with baud rate = 9600, 8 bits
            process(clk)
            begin
                if(clk = '1' and clk'EVENT) then
                    temp <= temp + 1;       --  (10^8 when divided by 960
                    if(temp = 325) then   --    0*16, gives approixmately 326) 
                        rx_clk <= not rx_clk;
                        temp<=0;
                    end if;
                end if;
                                
            
            end process;
    
    
    
        -- This is the receiver code and simulataneously giving output to LEDs
        
            process(rx_clk, rx_in, state, reset) 
                begin
                
               --With every cycle of input clock, we check for the state   
                    if(rx_clk='1' and rx_clk'event) then
                        
  --                When state is Idle, 
                        if(state = Idle) then
                            if(rx_in = '0') then
                                count<=0;
                                state <= start;
                          
                            end if;
                            
  --                When state is start,                                                
                        elsif(state = start) then
                            count <= count+1;
                            if(rx_in = '1') then
                                state <= Idle;
                            else
                                if(count<6) then
                                    state <= start;
                                else 
                                    i<=0;
                                    state <= si;
                                    count<=0;
                                end if;
                            end if;

  --                When state is si,                                    
                        elsif(state = si) then
                            count <= count+1;
                            if(count <15) then
                                state <= si;
                            else 
                                rx_reg(i) <= rx_in; 
                                count<=0;
                                if(i<8) then
--                 increase the counter by 1
                                    i <= i+1;
                                else
                                    state <= Idle;
    --          Assign the value of rx_reg to the output led
                                    led <= rx_reg; 
                                end if;
                            end if;
                            
                                
                        end if;    
                    end if;
               
--          When reset push button is pressed, all leds are set to 0
               if(reset ='1') then
                    led<="00000000";
               end if;
                        
            end process;
            
            
                
  

                              
 
end architecture Behavioral;