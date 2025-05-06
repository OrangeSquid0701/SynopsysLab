%Run_icc_with_correct_folder
icc_shell
import_design -format ddc -top cg_arith64 ../netlist/cg_arith64.ddc
derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS 
derive_pg_connection -power_net VDD -ground_net VSS -tie
start_gui

%floorplan_powerring_powerstrap
create_floorplan -start_first_row -left_io2core 20 -bottom_io2core 20 -right_io2core 20 -top_io2core 20
create_rectangular_rings  -nets  {VDD VSS}  -left_offset 1 -left_segment_layer M6 -left_segment_width 5 -right_offset 1 -right_segment_layer M6 -right_segment_width 5 -bottom_offset 1 -bottom_segment_layer M5 -bottom_segment_width 5 -top_offset 1 -top_segment_layer M5 -top_segment_width 5
create_power_straps -direction horizontal -start_at 55.00 -nets {VDD VSS} -layer M6 -width 5
create_power_straps -direction horizontal -start_at 105.00 -nets {VDD VSS} -layer M6 -width 5
create_power_straps -direction horizontal -start_at 155.00 -nets {VDD VSS} -layer M6 -width 5
create_power_straps -direction horizontal -start_at 205.00 -nets {VDD VSS} -layer M6 -width 5
create_power_straps -direction vertical -start_at 55.00 -nets {VDD VSS} -layer M5 -width 5
create_power_straps -direction vertical -start_at 105.00 -nets {VDD VSS} -layer M5 -width 5
create_power_straps -direction vertical -start_at 155.00 -nets {VDD VSS} -layer M5 -width 5
create_power_straps -direction vertical -start_at 205.00 -nets {VDD VSS} -layer M5 -width 5
set_pnet_options -complete {M3 M4}
derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS 
derive_pg_connection -power_net VDD -ground_net VSS -tie

%placement
create_fp_placement -timing_driven -no_hierarchy_gravity
preroute_standard_cells -remove_floating_pieces
set_separate_process_options -placement false
place_opt
derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS 
derive_pg_connection -power_net VDD -ground_net VSS -tie

%clock_tree_synthesis
remove_clock_uncertainty [all_clocks]
set_fix_hold clk
clock_opt

%route
route_opt
derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS 
derive_pg_connection -power_net VDD -ground_net VSS -tie

%verify
verify_zrt_route
verify_lvs

%Save_report
extract_rc
report_timing -delay max -path short
report_timing -delay min -path short
report_qor
save_mw_cel -as cg_arith64_routed
write -f ddc -hier -out ../netlist/cg_arith64_postlayout.ddc
write_verilog -no_physical_only_cell -no_core_filler_cells ../netlist/cg_arith64_postlayout.v
write_sdc ../netlist/cg_arith64_postlayout.sdc
write_parasitics -output ../netlist/cg_arith64_postlayout.spef

redirect -file ../reports/ICC/cg_icc_area.rpt {report_area}
redirect -file ../reports/ICC/cg_icc_timing.rpt {report_timing}
redirect -file ../reports/ICC/cg_icc_clock.rpt {report_clock}
redirect -file ../reports/ICC/cg_icc_power.rpt {report_power}
redirect -file ../reports/ICC/cg_icc_setup.rpt {report_timing -delay max}
redirect -file ../reports/ICC/cg_icc_hold.rpt {report_timing -delay min}
redirect -file -append ../reports/ICC/cg_icc_clock.rpt {report_clock -skew}

exit
