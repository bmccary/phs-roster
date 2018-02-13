
# Instructions

1. `git clone https://github.com/bmccary/phs-roster.git`
1. `cd phs-roster`
1. Download the roster(s) in question from CourseBook and save it in `phs-roster`. 
   1. It is fine to put as many in here as you want, but you probably want to download a PDF, run `make`, download a new PDF, run `make`, et cetera.
1. `make`
1. From each roster several files/directories will be made. E.g., for a roster `foo.pdf`:
   1. `foo.txt`: The text stripped from the PDF.
   1. `foo.csv`: A conversion of `foo.txt` to CSV.
   1. `foo.ppm`: A directory full of the images found in `foo.pdf`, in the order found in the PDF bytestream.
1. From *all* PDFs, a directory called `netid` is created
   1. For each PDF, a symlink to a PPM named after student's NetID will be created.
      1. E.g., `netid/abc123456.ppm -> foo.pdf/i-023.ppm`, meaning student `abc123456` was found in `foo.pdf` in position 23.
   1. For each PPM, a PNG is created.
   1. For each PNG, you will be prompted to confirm/deny that the NetID has been properly associated with the picture.
      1. This verification step is necessary because the composition tool which UTD uses to create this PDF does not always put the images and text close to each other (in the PDF bytestream). 
      1. Every so often, this results in an off-by-one problem. E.g.  1. 1 -> 1, 2 -> 2, ..., 42 -> 42, 43 -> 44, 44 -> 45, ..., 86 -> 87, 87 -> 43.
      1. The easiest (only) fix for this is to open up the corresponding `.csv` file, fix it by hand, then re-run `make`. The process will pick back up from that place.

# Status

I'm waiting on you to confirm this process works for you.

