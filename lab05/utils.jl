module Utils
    export getFunctionName

    function getFunctionName(fun) :: String
        split(string(fun), '.')[end]
    end
end
