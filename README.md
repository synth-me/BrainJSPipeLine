```
Perl6 commands works as follows -> 
  perl6 core.p6 touch <port> <number of speakers> -- create the port
  perl6 core.p6 insert <port> <[commands]> -- insert the commands not in order
  perl6 core.p6 show <port> -- to show all the speakers 
  perl6 core.p6 run <port> -- run specific port and test
  perl6 core.p6 compile <port> -- you put this port as the main port
  perl6 core.p6 main <optinal plot> -- run the main port, if plot the speaker will be plotted

To run the Brain.js model specifically -> 

  perl6 core.p6 main 
     
     or 
  
  perl6 core.p6 run 1 

if you would like to plot the current error rate :

  perl6 core.p6 main plot 

```
