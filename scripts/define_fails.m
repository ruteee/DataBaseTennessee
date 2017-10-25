% TODO set right desription to fails
ids = [1;2;3;4;5;6;7;8;9;10;11;12];
from = ["SECURE";"SECURE";"SECURE";
        "SECURE";"SECURE";"SECURE";
        "SECURE";"SECURE";"SECURE";
        "SECURE";"SECURE";"SECURE";];
type = ["LOCK";"LOCK";"LOCK";
        "LOCK";"LOCK";"LOCK";
        "LOCK";"LOCK";"LOCK";
        "LOCK";"LOCK";"LOCK";];
fails = table(ids, from, type, 'VariableNames', {'ID', 'FROM', 'TYPE'});
clearvars ids from type