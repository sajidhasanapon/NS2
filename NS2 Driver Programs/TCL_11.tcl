
# ==============================================================================
# Network Parameters
# ==============================================================================
set cbr_size            64 ;	#[lindex $argv 2]; #4,8,16,32,64
set cbr_rate            11.0Mb
set grid_x_dim			500 ;	#[lindex $argv 1]
set grid_y_dim          500 ;	#[lindex $argv 1]
set time_duration       15 ;	#[lindex $argv 5] ;#50
set start_time          1
set extra_time          5
set flow_start_gap      0.0
set motion_start_gap    0.05

# ======================================
# Variables
# ======================================
set num_node            [lindex $argv 0]
set num_flow			[lindex $argv 0]
set cbr_pckt_rate       [lindex $argv 0]
set node_speed			[lindex $argv 0]
# ======================================

set cbr_interval		[expr 1.0/$cbr_pckt_rate]

set source_type			Agent/UDP
set sink_type			Agent/Null

# =====================
# source / sink options
# =====================
# UDP:		Agent/UDP					Agent/Null
# TAHOE:	Agent/TCP					Agent/TCPSink
# RENO:		Agent/TCP/Reno				Agent/TCPSink
# NEWRENO:	Agent/TCP/Newreno			Agent/TCPSink
# SACK: 	Agent/TCP/FullTcp/Sack		Agent/TCPSink/Sack1
# VEGAS:	Agent/TCP/Vegas				Agent/TCPSink
# FACK:		Agent/TCP/Fack				Agent/TCPSink
# LINUX:	Agent/TCP/Linux				Agent/TCPSink

# ==============================================================================



# ==============================================================================
# Define options
# ==============================================================================
set val(chan)		Channel/WirelessChannel  	;# channel type
set val(prop)		Propagation/TwoRayGround 	;# radio-propagation model
set val(ant)		Antenna/OmniAntenna      	;# Antenna type
set val(ll)			LL                       	;# Link layer type
set val(ifq)		Queue/DropTail/PriQueue  	;# Interface queue type
set val(ifqlen)		50                       	;# max packet in ifq
set val(netif)		Phy/WirelessPhy          	;# network interface type
set val(mac)		Mac/802_11            	;# MAC type wireless 802.11
set val(rp)			DSDV                     	;# ad-hoc routing protocol
set val(nn)			$num_node                	;# number of mobilenodes
# ==============================================================================
# ==============================================================================
# Energy Parameters
# ==============================================================================

set val(energymodel_11)         EnergyModel		;
set val(initialenergy_11)       1000            ;# Initial energy in Joules

set val(idlepower_11)			869.4e-3		;#LEAP (802.11g)
set val(rxpower_11)				1560.6e-3		;#LEAP (802.11g)
set val(txpower_11)				1679.4e-3		;#LEAP (802.11g)
set val(sleeppower_11)			37.8e-3			;#LEAP (802.11g)
set val(transitionpower_11)		176.695e-3		;#LEAP (802.11g)
set val(transitiontime_11)		2.36			;#LEAP (802.11g)



#set val(idlepower_11)			900e-3			;#Stargate (802.11b)
#set val(rxpower_11)			925e-3			;#Stargate (802.11b)
#set val(txpower_11)			1425e-3			;#Stargate (802.11b)
#set val(sleeppower_11)			300e-3			;#Stargate (802.11b)
#set val(transitionpower_11)	200e-3			;#Stargate (802.11b)
#set val(transitiontime_11)		3				;#Stargate (802.11b)

# ==============================================================================



# ==============================================================================
# Other Options
# ==============================================================================
Mac/802_11 set dataRate_ 11Mb
Mac/802_11 set syncFlag_ 1
Mac/802_11 set dutyCycle_ cbr_interval
# ==============================================================================



# ==============================================================================
# Files
# ==============================================================================
set trace_file_name		TRACE.tr
set nam_file_name		NAM.nam
set topo_file_name		TOPO.txt
set directory			""
# ==============================================================================




# ======================================================================
# Initialization
# ======================================================================

# creating an instance of the simulator
set ns_    [new Simulator]

# setup trace support by opening the trace file
set tracefd     [open $directory$trace_file_name w]
$ns_ trace-all $tracefd

# setum nam (Network Animator) support by opening the nam file
#set namtrace    [open $directory$nam_file_name w]
#$ns_ namtrace-all-wireless $namtrace $grid_x_dim $grid_y_dim


# create a topology object that keeps track of movements...
# ...of mobilenodes within the topological boundary.
set topo_file   [open $directory$topo_file_name "w"]
set topo	[new Topography]
$topo load_flatgrid $grid_x_dim $grid_y_dim
# Grid resolution can be passed to load_flatgrid as a 3rd parameter.
# Default is 1.

# create the object God
create-god $val(nn)

# GOD (General Operations Director) is the object that is used to...
# ...store global information about the state of the environment, network...
# ...or nodes that an omniscent observer would have, but that should...
# ...not be made known to any participant in the simulation.
# Currently, God object stores the total number of mobilenodes...
# ...and a table of shortest number of hops required to reach from...
# ...one node to another. The next hop information is normally loaded...
# ...into god object from movement pattern files, before simulation...
# ...begins, since calculating this on the fly during simulation runs...
# ...can be quite time consuming.
# ...However, in order to keep this example simple we avoid using movement...
# ...pattern files and thus do not provide God with next hop information.

# ======================================================================



# ==============================================================================
# The configuration API for creating mobilenodes
# ==============================================================================
$ns_ node-config    -adhocRouting $val(rp) \
                    -llType $val(ll) \
                    -macType $val(mac)  \
                    -ifqType $val(ifq) \
                    -ifqLen $val(ifqlen) \
                    -antType $val(ant) \
                    -propType $val(prop) \
                    -phyType $val(netif) \
                    -channel  [new $val(chan)] \
                    -topoInstance $topo \
                    -agentTrace ON \
                    -routerTrace OFF \
                    -macTrace ON \
                    -movementTrace OFF \
			        -energyModel $val(energymodel_11) \
			        -idlePower $val(idlepower_11) \
			        -rxPower $val(rxpower_11) \
			        -txPower $val(txpower_11) \
          		    -sleepPower $val(sleeppower_11) \
          		    -transitionPower $val(transitionpower_11) \
			        -transitionTime $val(transitiontime_11) \
			        -initialEnergy $val(initialenergy_11)
# ==============================================================================




# ==============================================================================
# Create Nodes and Set Initial Positions
# ==============================================================================
puts "start node creation"
for {set i 0} {$i < $num_node} {incr i} {
	set node_($i) [$ns_ node]
	$node_($i) random-motion 0

	# Provide initial (X,Y, for now Z=0) co-ordinates for mobilenodes
	set x_pos [expr int($grid_x_dim*rand())] ; #random settings
	set y_pos [expr int($grid_y_dim*rand())] ; #random settings

	while {$x_pos == 0 ||
			$x_pos == $grid_x_dim} {
		set x_pos [expr int($grid_x_dim*rand())]
	}

	while {$y_pos == 0 ||
			$y_pos == $grid_y_dim} {
		set y_pos [expr int($grid_y_dim*rand())]
	}

	$node_($i) set X_ $x_pos;
	$node_($i) set Y_ $y_pos;
	$node_($i) set Z_ 0.0

	puts -nonewline $topo_file "$i x: [$node_($i) set X_] y: [$node_($i) set Y_] \n"
}

for {set i 0} {$i < $val(nn)} { incr i } {
	$ns_ initial_node_pos $node_($i) 35
    #35 = size of node in nam
}

# =====================
# random node movements
# =====================
for {set i 0} {$i < [expr $num_node] } {incr i} {
	set dest_x [expr int($grid_x_dim*rand())]
	set dest_y [expr int($grid_y_dim*rand())]

	while {$dest_x == 0 ||
			$dest_x == $grid_x_dim} {
		set dest_x [expr int($grid_x_dim*rand())]
	}

	while {$dest_y == 0 ||
			$dest_y == $grid_y_dim} {
		set dest_y [expr int($grid_y_dim*rand())]
	}
	$ns_ at $start_time "$node_($i) setdest $dest_x $dest_y  $node_speed"

	#puts "$i Destination ---> x: [$node_($i) set X_] y: [$node_($i) set Y_]"
}

puts "node creation complete"
# ==============================================================================




# ==============================================================================
# Setup Traffic Flows
# ==============================================================================
for {set i 0} {$i < $num_flow} {incr i} {
	set udp_($i) [new $source_type]
	set null_($i) [new $sink_type]
	$udp_($i) set fid_ $i
	$ns_ color $i Blue
	if { [expr $i%2] == 0} {
		$ns_ color $i Blue
	} else {
		$ns_ color $i Red
	}
}


for {set i 0} {$i < $num_flow} {incr i} {
	set source_number [expr int($num_node*rand())]
	set sink_number [expr int($num_node*rand())]
	while {$sink_number==$source_number} {
		set sink_number [expr int($num_node*rand())]
	}
	$ns_ attach-agent $node_($source_number) $udp_($i)
  	$ns_ attach-agent $node_($sink_number) $null_($i)
	puts -nonewline $topo_file "RANDOM:  Src: $source_number Dest: $sink_number\n"
}


for {set i 0} {$i < $num_flow } {incr i} {
	set cbr_($i) [new Application/Traffic/CBR]
	$cbr_($i) set packetSize_ $cbr_size
	$cbr_($i) set rate_ $cbr_rate
	$cbr_($i) set interval_ $cbr_interval
	$cbr_($i) attach-agent $udp_($i)
	$ns_ at $start_time "$cbr_($i) start"
}

# Connecting udp_node & null_node
for {set i 0} {$i < $num_flow } {incr i} {
     $ns_ connect $udp_($i) $null_($i)
}
puts "flow creation complete"
# ==============================================================================


# ==============================================================================
# Ending the simulation
# ==============================================================================

for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at [expr $start_time+$time_duration] "$node_($i) reset";
}

$ns_ at [expr $start_time+$time_duration +$extra_time] "finish"
$ns_ at [expr $start_time+$time_duration +$extra_time] "$ns_ nam-end-wireless [$ns_ now]; puts \"NS Exiting...\"; $ns_ halt"

proc finish {} {
    puts "finishing"
    global ns_ tracefd namtrace topo_file nam_file_name
    $ns_ flush-trace
    close $tracefd
	close $topo_file
    #close $namtrace
    #exec nam $nam_file_name &
    exit 0
}

puts "Starting Simulation..."
$ns_ run
