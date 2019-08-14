charToNum = function(alpha) {
        var index = 0
        for(var i = 0, j = 1; i < j; i++, j++)  {
            if(alpha == numToChar(i))   {
                index = i;
                j = i;
            }
        }
return index;
    }

numToChar = function(number)    {
        var numeric = (number - 1) % 26;
        var letter = chr(65 + numeric);
        var number2 = parseInt((number - 1) / 26);
        if (number2 > 0) {
            return numToChar(number2) + letter;
        } else {
            return letter;
        }
    }
chr = function (codePt) {
        if (codePt > 0xFFFF) { 
            codePt -= 0x10000;
            return String.fromCharCode(0xD800 + (codePt >> 10), 0xDC00 + (codePt & 0x3FF));
        }
        return String.fromCharCode(codePt);
    }

console.log(numToChar(67799765));
