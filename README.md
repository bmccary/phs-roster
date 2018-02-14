
# Instructions

1. `git clone https://github.com/bmccary/phs-roster.git`
1. `cd phs-roster`
1. Download the roster(s) in question from CourseBook and save it in `phs-roster`. 
   1. It is fine to put as many in here as you want, but you probably want to download a PDF, run `make`, download a new PDF, run `make`, et cetera.
   1. Rosters need to be saved with names that contain no whitespace or other characters which are special to `bash` or `make`.
1. `make`
1. From each roster several files/directories will be made. E.g., for a roster `foo.pdf`:
   1. `build/foo.pdf/txt`: The text stripped from the PDF.
   1. `build/foo.pdf/csv`: A conversion of `build/foo.pdf/txt` to CSV.
   1. `build/foo.pdf/ppm`: A directory full of the images found in `foo.pdf`, in the order found in the PDF bytestream.
1. From *all* PDFs, a directory called `build/netid` is created
   1. For each image, you will be prompted to confirm/deny that the NetID has been properly associated with the picture.
      1. This verification step is necessary because the composition tool which UTD uses to create this PDF does not always put the images and text close to each other (in the PDF bytestream). 
      1. Every so often, this results in an off-by-one problem. E.g.  1. 1 -> 1, 2 -> 2, ..., 42 -> 42, 43 -> 44, 44 -> 45, ..., 86 -> 87, 87 -> 43.
      1. The easiest (only) fix for this is to open up the corresponding `.csv` file, fix it by hand, then re-run `make`. The process will pick back up from that place.
      1. **But this out-of-order problem may have been fixed by simply sorting the students found in the text file, time will tell.**
1. The `build/netid` will be populated with files of the form `abc123456.png` 

# Status

I'm waiting on you to confirm this process works for you. Once you've got this working, I'll hack together `spreadsheet-of-text-NetIDs-to-spreadsheet-of-images-and-whatnot` script.

