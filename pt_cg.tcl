read_verilog ../netlist/cg_arith64_postlayout.v
link_design arith64
current_design
report_units

create_clock -period 12 [get_ports clk]
set_input_delay 1 -clock clk -network_latency_included [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 1 -clock clk -network_latency_included [all_outputs]
set_load 0.2 [all_outputs]
set_driving_cell -lib_cell NBUFFX4_HVT [remove_from_collection [all_inputs] [get_ports clk]]
set_operating_conditions -analysis_type on_chip_variation ss0p95v125c

set power_enable_analysis true

read_parasitic ../netlist/cg_arith64_postlayout.spef

redirect -file ../reports/PT/pt_cg_clock.rpt {report_clock}
redirect -file ../reports/PT/pt_cg_timing.rpt {report_timing}
redirect -file ../reports/PT/pt_cg_timing_delay_min.rpt {report_timing -delay min}
redirect -file ../reports/PT/pt_cg_power.rpt {report_power}
redirect -file ../reports/PT/pt_cg_qor.rpt {report_qor}

exit
