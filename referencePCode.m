function [reference] = referencePCode(satID,day)

 switch satID
    case 1
        switch day
            case 1
                reference_P1_1 =  ('924110552BD74E7FC62D21CD7F83B3F9A4CC77E4C4A5DF081E90B013D5D49F81');
                reference = reference_P1_1;
            case 2
                reference_P1_2 =  ('6FBA7C64D4EE0839FF5EB0B376D8B5A1BCBDDDCF191940183BFE36A24FE6DE4B');
                reference = reference_P1_2;
            case 4
                reference_P1_4 =  ('DEAB62046E05324EAD7498317CA46457BE5F06BC689EA4207AD66250BA3A9F35');
                reference = reference_P1_4;
            otherwise
                disp('Нет верификационного материала для данных условий')
        end
        

    case 2
        switch day
            case 1
                reference_P2_1 =  ('800D9D1EB5EF85CA7B25290C95BF1C92131D6DB1793B8630F4D8D69D8D1C481B');
                reference = reference_P2_1;
            otherwise
                disp('Нет верификационного материала для данных условий');
        end
        
    case 25
        switch day
            case 6
                reference_P25_6 = ('2735B1757E9494E7183A6A6C9B335824A2B9EBE2E4947C07C21EBD9CDB7A5E18');
                reference = reference_P25_6;
            otherwise
                disp('Нет верификационного материала для данных условий');      
        end
     otherwise
        disp('Нет верификационного материала для данных условий');  
 end
end

