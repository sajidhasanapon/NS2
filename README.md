# NS2 Project : Level 3, Term 2

#### "ns-allinone-2.35/ns-2.35(MAIN)" contains the original code.
#### "ns-allinone-2.35/ns-2.35(MODIFIED)" contains the modified code.
____

### Before running ns2, one of these directories must be renamed to "ns-2.35"
___

###### The details of the modification can be found in the "NS2 Report.pdf" file.

# How to Install Network Simulator 2 (NS2)

#### 1. Download ns2
https://kent.dl.sourceforge.net/project/nsnam/allinone/ns-allinone-2.35/ns-allinone-2.35.tar.gz


#### 2. Extract the .tar.gz file in your home directory.


#### 3. Terminal : 
`sudo apt-get install build-essential autoconf automake libxmu-dev`

`nano ~/ns-allinone-2.35/ns-2.35/linkstate/ls.h`

 #### On line 137, change **erase(baseMap...)** to **this->erase(baseMap...)** and save the file.

`cd ~/ns-allinone-2.35`

`./install`	(might require sudo privilege)


`sudo nano ~/.bashrc`

#### At the end of the file, add the following lines: 

            # LD_LIBRARY_PATH
            OTCL_LIB=/home/USERNAME/ns-allinone-2.35/otcl-1.14
            NS2_LIB=/home/USERNAME/ns-allinone-2.35/lib
            X11_LIB=/usr/X11R6/lib
            USR_LOCAL_LIB=/usr/local/lib
            export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$OTCL_LIB:$NS2_LIB:$X11_LIB:$USR_LOCAL_LIB
            # TCL_LIBRARY
            TCL_LIB=/home/USERNAME/ns-allinone-2.35/tcl8.5.10/library
            USR_LIB=/usr/lib
            export TCL_LIBRARY=$TCL_LIB:$USR_LIB
            # PATH
            XGRAPH=/home/USERNAME/ns-allinone-2.35/bin:/home/USERNAME/ns-allinone-2.35/tcl8.5.10/unix:/home/USERNAME/ns-allinone-2.35/tk8.5.10/unix
            #the above two lines beginning from xgraph and ending with unix should come on the same line
            NS=/home/USERNAME/ns-allinone-2.35/ns-2.35/ 
            NAM=/home/USERNAME/ns-allinone-2.35/nam-1.15/ 
            PATH=$PATH:$XGRAPH:$NS:$NAM

#### Then save the file.


#### IMPORTANT: Replace **USERNAME** with your own (unix) username.


### 4. reboot
---

# Getting Started: Youtube
[![](https://i.ibb.co/KsGrcCB/ns2-Copy.png)](http://www.youtube.com/watch?v=YPDP1uOygtk "Getting Started")




