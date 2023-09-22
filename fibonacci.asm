:loop_start_value
    ldn $count_value
    sub $subtract_val
    cmp
    jmp $continue

    stp

:continue_value
    sto $count_addr
    ldn $count_value
    sto $count_addr

    ldn $n1
    sub $n2
    sto $result_addr

    ldn $n1
    sto $n2_addr
    ldn $n2
    sto $n2_addr

    ldn $result
    sto $n1_addr


    jmp $loop_start

:continue
abs $continue_value
:loop_start
abs $loop_start_value

:subtract_val
abs 0d1

:n2_addr
abs $n2
:n1_addr
abs $n1
:result_addr
abs $result

:n2
abs 0d0
:n1
abs 0d1
:result
abs 0d0

:count_addr
abs $count_value
:count_value
abs 0d-29
