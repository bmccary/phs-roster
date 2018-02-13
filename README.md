
# Instructions

1. `git clone https://github.com/bmccary/phs-roster.git`
1. `cd phs-roster`
1. Download the roster(s) in question from CourseBook and save it in `phs-roster`.
1. `make`
1. When any new rosters are added, their images will be extracted.
   1. You will be prompted to confirm/deny that the NetID has been properly associated with the picture.
      1. This verification step is necessary because the composition tool which UTD uses to create this PDF does not always put the images and text close to each other (in the PDF bytestream). 
      1. Every so often, this results in an off-by-one problem. E.g.  1. 1 -> 1, 2 -> 2, ..., 42 -> 42, 43 -> 44, 44 -> 45, ..., 86 -> 87, 87 -> 43.
      1. The easiest (only) fix for this is to open up the corresponding `.csv` file, fix it by hand, then re-run `make`.

# Status

I'm waiting on you to confirm this process works for you.

