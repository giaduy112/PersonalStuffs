def fibonacci (number)
    if number <= 1
        return number
    end
    return fibonacci(number-1) + fibonacci(number-2)
end