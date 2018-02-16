
# Instructions

1. `git clone https://github.com/bmccary/phs-roster.git`
1. `cd phs-roster`
1. We will call this directory the root directory.
1. There are many options which are described in the file `options.mk`. You shouldn't edit that file though. Rather edit/create the file `local.mk` set the value you want there, which will override the value in `options.mk`.

# To Parse out NetID Images from CourseBook

In order for this to work, you'll need to install `poppler` (to extract data from PDFs) and `ImageMagick` (to process images).

1. Download the roster(s) in question from CourseBook and save it in root directory.
   1. It is fine to put as many in here as you want.
   1. Rosters need to be saved with names that contain no whitespace or other characters which are special to `bash` or `make`.
1. From each roster, a multitude of files in `build/` are made. But the upshot is:
   1. `build/netid/*.png` is every detected NetID.
   1. `build/stamp/*.png` is every detected NetID, but with the last name, first name, and NetID stamped on the image.
   1. `build/csv` is a CSV of `netid,last_name,first_name` collected from every roster, without duplicates.

## If NetIDs are not Detected Correctly

*This does not seem to happen any more.*

In order for this to work, you'll need to install `zenity`.

1. Suppose NetIDs are not being detected correctly from `foo.pdf`.
1. Option: you're brave/sure of the problem.
   1. Edit `build/foo.pdf/csv` and fix the problem yourself.
   1. Cross-reference the `foo.pdf` file with your eyeballs.
   1. `make`
1. Option: you're not sure where the problem is:
   1. Remove what was automatically parsed: `rm -rf build/foo.pdf`
   1. Do one of the following.
      1. `make YESNO=YESNO_ZENITY` which turns on the yet/no asking for this run.
      1. Edit/create `local.mk` and add the line `YESNO := YESNO_ZENITY` which will permanently turn on this feature.
   1. You'll be asked individually for each picture.
   1. If you click *No* then the make will crash at that spot, identifying the location of the problem for you.
   1. Now be brave and do the previous option.

# To Make an XLSX Roster from a CSV Grid

In order for this to work, you'll need to install the python library for dealing with XLSX:

```
pip install --user openpyxl
```

If you want to turn off this feature then do one of the following

1. `make MAKE_XLSX=` which sets the `MAKE_XLSX` variable to empty for this run.
1. Edit/create `local.mk` and add the line `MAKE_XLSX :=` which sets the `MAKE_XLSX` variable to empty permanently.

Then

1. Create `foo.csv` in the root directory, containing a grid of NetIDs.
1. Type `make`
1. `build/foo.xlsx` will be created.

# To Make a TeX/PDF Roster from a CSV Grid

In order for this to work, you'll need a TeX installation with `pdflatex`.
If you want to turn off this feature then do one of the following

1. `make MAKE_PDF=` which sets the `MAKE_PDF` variable to empty for this run.
1. Edit/create `local.mk` and add the line `MAKE_PDF :=` which sets the `MAKE_PDF` variable to empty permanently.

Then

1. Create `foo.csv` in the root directory, containing a grid of NetIDs.
1. Type `make`
1. `build/foo.tex` and `build/foo.pdf` will be created.

Here is an example of a grid of NetIDs.
The gaps indicate nobody sits there.

```
abc000000,abc000001,abc000002,abc000003
abc000004,,abc000005,abc000006
abc000007,abc000008,abc000009
```

# To Make an XLSX Roster from a CourseBook Roster

This is used to make a kind of drag-and-drop roster which you can modify in a spreadsheet program.
In order for this to work, you'll need the same prerequisites as *XLSX Roster from a CSV Grid*.
If you want to turn off this feature then do one of the following

1. `make MAKE_DRAG_AND_DROP=` which sets the `MAKE_DRAG_AND_DROP` variable to empty for this run.
1. Edit/create `local.mk` and add the line `MAKE_DRAG_AND_DROP :=` which sets the `MAKE_DRAG_AND_DROP` variable to empty permanently.

Then

1. Put `foo.pdf` in the root directory, a CourseBook roster.
1. Type `make`
1. `build/foo.pdf/drag-and-drop.xlsx` will be created.

