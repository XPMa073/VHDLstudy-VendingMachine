library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Vending_machine is
    port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        dollar  : in  STD_LOGIC;    --????1?
        quarter : in  STD_LOGIC;    --????5?
        change  : out STD_LOGIC;    --??5?
        drink   : out STD_LOGIC     --????
    );
end entity Vending_machine;

architecture Behavioral of Vending_machine is

    type state_type is (s0,         --idle
                        s1,         --0.5
                        s2,         --1.0
                        s3,         --1.5
                        s4,         --2.0
                        s5,         --empty
                        s6,         --empty
                        s7);        --empty
    signal state, nextstate : state_type;


begin

    Resetter : process(clk, reset)
    begin                           --????????????
        if reset = '0' then
            state <= s0;
        elsif (clk'event and clk ='1') then
            state <= nextstate;
        else 
            state <= state;
        end if;
    end process Resetter;

    state_transition : process (dollar, quarter, state)
    begin                           --?????s1s2??????????
        case state is
            when s1 =>
                if dollar = '1' then
                    nextstate <= s3;
                elsif quarter = '1' then
                    nextstate <= s2;
                else
                    nextstate <= s1;
                end if;

            when s2 =>
                if dollar = '1' then
                    nextstate <= s4;
                elsif quarter = '1' then
                    nextstate <= s3;
                else
                    nextstate <= s2;
                end if;

            when others =>          --?????s0
                if dollar = '1' then
                    nextstate <= s2;
                elsif quarter = '1' then
                    nextstate <= s1;
                else
                    nextstate <= s0;
                end if;
        end case;
    end process state_transition;

    output_logic : process (state)
    begin
        case state is
            when s3 =>
                change <= '0' ;
                drink  <= '1' ;
            when s4 =>
                change <= '1' ;
                drink  <= '1' ;
            when others =>          --??s3s4???
                change <= '0' ;
                drink  <= '0' ;
        end case;
    end process;

end architecture Behavioral;