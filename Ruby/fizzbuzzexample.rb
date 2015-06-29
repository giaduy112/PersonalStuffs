denominators = { 3 => "fizz", 5 => "buzz"}

def divisibleOrNot (number, denominators)
    resultStr = ""
    denominators.keys.each do |x|
    if (number % x) == 0
        resultStr << denominators[x]
    end 
    return (resultStr.length > 0) ? resultStr : number
end

puts divisibleOrNot(1, denominators)