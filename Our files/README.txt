Program 1 successfully encodes the message with the required number of preamble spaces (extending to 10 or limiting to 15) if the number is not within range. The encoding functions with all tap patterns and starting states.
Program 2 successfully decodes the message with any tap pattern and starting state combination. 
Program 3 successfully decodes the message with any tap pattern and starting state combination, as well as successfully detecting errors. 

All features in program 1 and 2 work. However, the trailing spaces in program 3 do not work. However, as stated in Piazza post @160, the trailing spaces are not a major concern as long as the decoding and error detection functionality remain intact
The challenges we faced stemmed from the software requiring more from the hardware. Our original design didn't have the LFSR and Parity_bit operations, and only used 4 registers! As we wrote more assembly code, the ISA went through many revisions to accomodate the needs of the software. 

[Link to ISA documentation]
https://docs.google.com/document/d/1iK5kuPq0JqmnCFnZfnKvTf0ytXoidMZcLtLtgz3isYc/edit?usp=sharing

[Link to Program 1 assembly]
https://docs.google.com/document/d/1KgsQfIg2DU55Hbpjo8npVDVkgOTwy1a6dxKeTOyKp-E/edit?usp=sharing

[Link to Program 2 assembly]
https://docs.google.com/document/d/1RECWGF-bFJF1JXgO5PXHi3HBlkDz00jyUDfijUO461E/edit?usp=sharing

[Link to Program 3 assembly]
https://docs.google.com/document/d/1bBnk6EC7Hwo6WIxf7nhv0Xnydu2-t8HsGm5bxLSw5oY/edit?usp=sharing

[Link to cloud recording]
https://ucsd.zoom.us/rec/share/OcR7hI3ylgy0Bitjhy4VCzttGJH8-PlInxGvF0gOy9grIGLraF3TffyT6fFUheO_.THde0hblNsh_myO4

[Password]
?#3yQNYr 
