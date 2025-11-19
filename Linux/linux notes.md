# linux_report

A clean, structured Markdown conversion of the original `linux notes.txt`.  
Style: mixed documentation, no emojis, commands in fenced code blocks, exercises contain **questions only**.

---

## Table of Contents

1. Installation and Setup
   1.1 VirtualBox on Windows  
   1.2 Ubuntu ISO Preparation  
   1.3 Create a New VM  
   1.4 VM Settings  
   1.5 Ubuntu Installation

2. Linux Basics
   2.1 UNIX → Linux History  
   2.2 What Is Linux  
   2.3 Where Linux Is Used  
   2.4 How We Use Linux (GUI vs CLI)  
   2.5 Architecture Overview  
   2.6 Terminal vs Shell vs Kernel  
   2.7 Practical Command Flow Example

3. Command Structure and Manuals
   3.1 Command Syntax  
   3.2 `man` Pages Overview  
   3.3 Manual Sections (1–9)  
   3.4 Useful `man` Navigation Keys

4. Types of Commands and Identification
   4.1 Internal (Built-in) Commands  
   4.2 External Commands  
   4.3 Shell Scripts  
   4.4 Aliases  
   4.5 Functions  
   4.6 Identify With `type`

5. Navigation Commands
   5.1 `pwd`  
   5.2 `ls`  
   5.3 `cd`  
   5.4 `tree` (optional)  
   5.5 Path Concepts (absolute, relative, home, parent, current)  
   5.6 Navigation Exercise (Questions Only)

6. Creating Files and Folders
   6.1 `mkdir`  
   6.2 `file`  
   6.3 Creating Files (`touch`, `cat >`, `nano`, `echo >`, `echo >>`)  
   6.4 Making Files and Folders Exercise (Questions Only)

7. Nano Editor
   7.1 Open Files and Modes  
   7.2 Interface Overview  
   7.3 Common Shortcuts  
   7.4 Editing and Saving  
   7.5 Open at Specific Line / Read-only Mode  
   7.6 Nano Exercise (Questions Only)

8. Delete / Move / Copy
   8.1 `rm`  
   8.2 `mv`  
   8.3 `cp`  
   8.4 Deleting, Moving & Copying Exercise (Questions Only)

9. Useful Terminal Shortcuts

10. Working With Files
    10.1 `cat`  
    10.2 `less`  
    10.3 `tac`  
    10.4 `rev`  
    10.5 `head`  
    10.6 `tail`  
    10.7 `wc`  
    10.8 `sort`  
    10.9 Working With Files Exercise (Questions Only)

11. Standard Streams and Redirection
    11.1 Standard Streams (stdin, stdout, stderr)  
    11.2 Redirection Operators (`>`, `>>`, `2>`, `&>`, `<`)  
    11.3 Practical Examples  
    11.4 Redirection Exercise (Questions Only)

12. Piping
    12.1 What and Why  
    12.2 How It Works  
    12.3 Common Pipelines and Examples

13. `tr` Command  
14. `tee` Command  
15. Piping Exercise (Questions Only)

16. Linux Expansions
    16.1 Pathname Expansion (`*`, `?`, `[]`)  
    16.2 Tilde Expansion (`~`)  
    16.3 Brace Expansion (`{}`)  
    16.4 Arithmetic Expansion (`$(( ))`)  
    16.5 Command Substitution (`$( )`)  
    16.6 Variable & Parameter Expansion (`$VAR`, `${}` forms`)  
    16.7 Quote Removal  
    16.8 Real-world Expansion Examples

17. Finding Things in Linux
    17.1 `locate` Command  
    17.2 `find` Command  
    17.3 Find by Timestamps  
    17.4 Find Using Logical Operators  
    17.5 Find with `-exec` and `-ok`  
    17.6 `xargs` Command  
    17.7 Practical Find + Grep + Xargs Workflows

18. Grep Command
    18.1 What Is grep  
    18.2 Why grep Is Used  
    18.3 How grep Works  
    18.4 Basic Usage Examples  
    18.5 Searching Multiple Files  
    18.6 Regular Expressions with grep  
    18.7 Common grep Options  
    18.8 Advanced grep Usage  
    18.9 Exit Status Codes  
    18.10 Real-world grep Examples  
    18.11 Summary & Quick Reference

19. Permissions Basics
    19.1 Multi-User System Concept  
    19.2 File Owners and Groups  
    19.3 File Types (`-`, `d`, `l`, etc.)  
    19.4 Permission Bits (r, w, x)  
    19.5 Read/Write/Execute on Files  
    19.6 Read/Write/Execute on Directories  
    19.7 Real-World Permission Scenarios

20. Altering Permissions in Linux
    20.1 `chmod` (Symbolic Mode)  
    20.2 `chmod` (Octal Mode)  
    20.3 `su` Command  
    20.4 Root User  
    20.5 `sudo` Command  
    20.6 `chown`  
    20.7 Working with Groups (groupadd, adduser, gpasswd, etc.)  
    20.8 Summary Table

21. The Environment in Linux
    21.1 Local vs Environment Variables  
    21.2 Parameter Expansion (Advanced forms)  
    21.3 Defining and Exporting Variables  
    21.4 Shell Startup Files (`.bashrc`, `.profile`, etc.)  
    21.5 PS1 Prompt Customization  
    21.6 Aliases  
    21.7 `.bash_aliases` File  
    21.8 Useful Alias Examples

22. Writing Our Own Commands (Shell Scripting Basics)
    22.1 Introduction to Scripting  
    22.2 Writing the First Script  
    22.3 PATH Variable and How Commands Are Found  
    22.4 Adding Custom Scripts to PATH  
    22.5 Making Scripts Executable  
    22.6 Shebang (`#!`) Importance  
    22.7 Scripting Summary Table

23. Writing Our Own Command — Weather Script Using Case
    23.1 Installing curl  
    23.2 Testing wttr.in  
    23.3 Creating the Weather Script  
    23.4 Making It Executable  
    23.5 Script Options (`-h`, `-3`, `-l`)  
    23.6 Short Output Examples  
    23.7 Weather Script Summary

24. Automation in Linux — Cron Jobs
    24.1 What Is Cron  
    24.2 Cron Syntax Explained  
    24.3 First Cron Job  
    24.4 Handling Errors in Cron  
    24.5 More Cron Syntax (Ranges, Lists, Steps)  
    24.6 Advanced Cron Expressions

25. TAR Command in Linux
    25.1 What Is tar  
    25.2 Creating Archives  
    25.3 Extracting Archives  
    25.4 Compressed Tar Formats (`.tar.gz`, `.tar.bz2`, `.tar.xz`)  
    25.5 Listing, Appending, Deleting in tar  
    25.6 Practical tar Examples  
    25.7 Summary Table

---

# 1. Installation and Setup

## 1.1 VirtualBox on Windows

- Download VirtualBox from its official site and run the installer.
- To install the Extension Pack: double-click the `.vbox-extpack` or use `VirtualBox → File → Preferences → Extensions`.

## 1.2 Ubuntu ISO Preparation

- Download an Ubuntu Desktop LTS ISO (e.g., 24.04 LTS) from ubuntu.com. Save it to an accessible location.

## 1.3 Create a New VM

```
VirtualBox → New
Name: Ubuntu
ISO image: select your Ubuntu ISO (ensure the file is in "VirtualBox VMs" or accessible)
Memory: 4096 MB recommended (use 2048 MB if host has 8 GB total)
Hard disk: Create a virtual hard disk now → VDI → Dynamically allocated → 30 GB (min 25 GB)
```

## 1.4 VM Settings

```
CPU: assign 2 vCPUs (or half of cores; leave at least 2 for host)
```

## 1.5 Ubuntu Installation

```
Start VM → it boots from ISO
Choose: Install Ubuntu
Select language and keyboard layout
Choose: Normal installation
Storage: Erase disk and install Ubuntu (applies only to the VM virtual disk)
Set timezone, username, password
Wait for installation, then reboot when prompted
```

---

# 2. Linux Basics

## 2.1 UNIX → Linux History

- UNIX was developed at Bell Labs in the 1960s–1970s.
- In 1991, Linus Torvalds created the Linux kernel, inspired by UNIX, free and open-source.

## 2.2 What Is Linux

Linux is an operating system that manages:

- Hardware (CPU, RAM, storage)
- Programs (applications)
- User interaction (keyboard, mouse, display)

Key difference: Linux is open-source; Windows and macOS are closed-source.

## 2.3 Where Linux Is Used

- Cloud servers
- Supercomputers
- Android OS
- Websites, apps, databases
- DevOps and CI/CD tooling
- Cybersecurity and Ethical Hacking
- IoT devices

## 2.4 How We Use Linux (GUI vs CLI)

- GUI interface (e.g., Ubuntu Desktop)
- Command Line / Terminal (primary focus for development and operations)

## 2.5 Architecture Overview

```
User
  ↓
Shell (interpreter; e.g., Bash)
  ↓
Kernel (core of OS; manages resources and hardware)
  ↓
Hardware
```

## 2.6 Terminal vs Shell vs Kernel

| Part     | Role                                                               |
| -------- | ------------------------------------------------------------------ |
| Terminal | The window/screen where commands are entered and output is shown   |
| Shell    | Interpreter that parses commands (Bash is default on many systems) |
| Kernel   | Core engine that performs the requested operations                 |

## 2.7 Practical Command Flow Example

```
$ ls
Documents  Downloads  Pictures
```

Flow:

- Terminal: the visible window
- Shell (Bash): reads `ls`, passes to kernel
- Kernel: lists the directory entries
- Terminal: prints the output

---

# 3. Command Structure and Manuals

## 3.1 Command Syntax

```
command -options arguments
```

Example:

```
echo "Hello"
```

## 3.2 `man` Pages Overview

`man` displays documentation for commands, programs, system functions.

Typical sections you may see inside a man page:

- NAME
- SYNOPSIS
- DESCRIPTION
- OPTIONS
- EXAMPLES
- FILES
- SEE ALSO
- AUTHOR / BUGS

## 3.3 Manual Sections (1–9)

| Section | Description                            |
| ------- | -------------------------------------- |
| 1       | User commands                          |
| 2       | System calls                           |
| 3       | Library functions                      |
| 4       | Special files/devices (`/dev`)         |
| 5       | File formats & configuration           |
| 6       | Games                                  |
| 7       | Miscellaneous (conventions, protocols) |
| 8       | System administration commands         |
| 9       | Kernel routines (Linux-specific)       |

## 3.4 Useful `man` Navigation Keys

| Key       | Action      |
| --------- | ----------- |
| Space     | Page down   |
| b         | Page up     |
| q         | Quit        |
| `/word`   | Search      |
| n         | Next match  |
| Shift + g | Go to end   |
| 1 + g     | Go to start |

---

# 4. Types of Commands and Identification

## 4.1 Internal (Built-in) Commands

Examples: `cd`, `echo`, `pwd`, `exit`, `history`

## 4.2 External Commands

Stored in system directories (e.g., `/bin`, `/usr/bin`).  
Examples: `ls`, `cp`, `mv`, `grep`, `cat`

## 4.3 Shell Scripts

Files containing a series of commands, e.g., `./backup.sh` or `bash script.sh`.

## 4.4 Aliases

Shortcuts to commands, e.g.:

```
alias ll='ls -l'
```

## 4.5 Functions

User-defined functions in shell:

```
myfunc() { echo "Hello $1"; }
```

## 4.6 Identify With `type`

```
type cd       # cd is a shell builtin
type ls       # ls is aliased to 'ls --color=auto' (example)
type echo     # echo is a shell builtin
```

---

# 5. Navigation Commands

## 5.1 `pwd` — Print Working Directory

```
pwd
```

## 5.2 `ls` — List Directory Contents

```
ls              # List Current Directory Contents
ls -l           # Long listing (details like permissions, size, owner, date)
ls -a           # Show hidden files (that start with .)
ls -la          # Long listing + hidden files
ls /path        # List contents of another directory
```

## 5.3 `cd` — Change Directory

```
cd foldername
cd ..
cd ../..
cd ~        # home
cd /        # root
cd /path/to/folder
cd -        # previous directory
```

## 5.4 `tree` — Directory Structure (optional utility)

```
tree /home/user/
		  /home/jaswanth/
    	  ├── Documents
    	  │     └── Projects
    	  └── Downloads
```

## 5.5 Path Concepts

| Type             | Symbol | Meaning                        |
| ---------------- | ------ | ------------------------------ |
| Absolute Path    | —      | Full path from root `/`        |
| Relative Path    | —      | From current working directory |
| Home Directory   | `~`    | `/home/<username>`             |
| Parent Directory | `..`   | One level up                   |
| Current Dir      | `.`    | Current directory              |

## Navigation Exercise

Download the above file, **unzip it**, and drag the resulting **`Farm`** folder to your **Desktop**. The Farm folder contains the following subdirectories:

```bash
Farm/
	Coop/
		Chickens/
		Geese/
	Stable/
		Horses/
```

**From this point forward, ONLY use the terminal to accomplish the following:**

1. Open a new terminal window. Navigate to the `Farm` folder.

```
cd Farm
```

2. List the contents of the `Farm` directory.

```
ls
```

3. "Move" into the `Coop` folder.

```
cd Coop
```

4. List the contents of the `Coop` folder.

```
ls
--> Chickens,Geese
```

5. "Move" into the `Chickens` folder.

```
cd Chickens
```

6. List out the chickens in the `Chickens` folder. How many are there?

```
ls
-->6
```

7. One of the chickens is very very old, which one is it? (which file in the `Chickens` folder has the oldest modification time?) Use a command to figure it out!

```
ls --sort=time -la
-->Elvis , feb 14
```

8. In a **single** command, move from the `Chickens` directory to the `Geese` directory. Consult the folder structure written out above if needed.

```
cd ~/Farm/Coop/Grees
cd /home/jaswanth/Farm/Coop/Grees
```

9. How many geese (files) are in the `Geese` directory?

```
ls
-->4
```

10. One of the geese is sitting on a golden egg! It's larger than the other geese. Which one is it?  
    (which file in the `Geese` folder is the largest?). Use a command to figure it out!

```
ls -l --sort=size
-->Muffin
```

11. Navigate to the `Horses` directory. Consult the folder structure written out above, if needed.

```
cd ../../Stable/Horese
```

12. How many horses are in the `Horses` directory?

```
ls
-->4
```

13. Wait! There is a hidden horse in the `Horses` directory! What is it's name??

```
ls -la
-->Tory
```

---

# 6. Creating Files and Folders

## 6.1 `mkdir` — Make Directories

    	mkdir [OPTION]... Directory...

Create the directory(ies), if they do not already exist.

```
mkdir folder_name               # creating single folder
mkdir folder1 folder2           # creating multiple folders
mkdir -p parent/child1/child2   # Creates nested folders (also creates parent folder if it doesn't exist).
```

## 6.2 `file` — Determine File Type

file prints the type of that file

```
example::
	file colors.txt
		-->colors.txt: ASCII text
	file Farm
		-->Farm: directory
```

## 6.3 Creating Files

### There are multiple ways to create a file:

TOUCH

touch [OPTIONS]..FILE
update the access and modification times of each file to the current time.

A file argument that does not exits is created empty, unlwss -c or -h is supplied

used to create a new file from the command line. touch filename.ext
if we try to se touch with a file that already exits,it will simply update the access and modification dates to current time.

```
touch filename        #Creates an empty file or updates timestamp if file exists.
cat > filename        # Create a file and write content. (Press Ctrl + D to save and exit).
nano filename         # Opens a text editor to write content.
echo "text" > file    # Creates a file with text (overwrites if exists).
echo "text" >> file   # Adds text to the end of a file (append mode).
```

```
Examples::
    touch notes.txt
    touch app.js index.html style.css		# creating multiple files at a time
    cat > todo.txt         		           	# Type text, then press Ctrl + D to save
    nano report.txt       					# Write, then press Ctrl + O (save) and Ctrl + X (exit)
    echo "Hello Linux" > file1.txt
    echo "More content" >> file1.txt
```

## Making Files And Folders Exercise

    1.Create a new folder called my-app
    	--> mkdir my-app
    2.Navigate to my-app and inside create two new empty files called README.md and package.json
    	--> cd my-app
    	--> touch README.md package.json
    3.Still inside of my-app create a new folder called public. Without cd-ing into public, create an index.html file inside of it.
    	--> mkdir public
    	--> touch public/index.html
    4.Create a new folder called src inside of my-app.  Navigate inside of it.
    	--> mkdir src
    	--> cd src
    5.Using a single line, create the following four files inside of src: App.css, App.js, index.css, and index.js
    	--> touch App.css App.js index.css index.js
    Your folder structure should now look like this:
    	my-app/
    	  README.md
    	  package.json
    	  public/
    	    index.html
    	  src/
    	    App.css
    	    App.js
    	    index.css
    	    index.js
    BONUS:Using a single command, create a new directory inside of `src` called `components`,
    and inside of that new `components` directory create a new directory called `Navbar`.
    Do this using a single command, without first creating the `components` directory.
    	--> mkdir -p components/Navbar

---

# 7. Nano Editor

nano is a simple text editor that we can access right from the terminal.
its far more accessible thean other papular command-line editiors like vim and emacs.

nano includes all basic text editing functionality
you would expect: search, spellcheck, syntax highlighting, etc.

## 7.1 Open Files and Modes

```
nano filename      #Open Nano with a new/existing file
nano -v filename   # view/read-only
```

```
example::
		nano notes.txt
		--> If the file doesn’t exist, Nano will create it once you save.
```

## 7.2 Interface Overview

- Title bar shows file and version.
- Common shortcuts displayed at the bottom (`^` means Ctrl).

```

		GNU nano 6.2                         notes.txt
		---------------------------------------------
		| Here is your file content...              |
		|                                           |
		---------------------------------------------
		^G Help  ^O Write Out  ^W Where Is  ^K Cut  ^U Paste  ^X Exit
		(Shortcuts are shown at bottom)

		^ means Ctrl key (Example: ^X = Ctrl + X)
```

## 7.3 Common Shortcuts

| Action         | Shortcut               |
| -------------- | ---------------------- |
| Save file      | Ctrl + O (then Enter)  |
| Exit           | Ctrl + X               |
| Save & exit    | Ctrl + X → Y → Enter   |
| Cut line       | Ctrl + K               |
| Paste line     | Ctrl + U               |
| Undo           | Alt + U                |
| Redo           | Alt + E                |
| Search         | Ctrl + W               |
| Replace        | Ctrl + \               |
| Go to line     | Ctrl + \_              |
| Justify text   | Ctrl + J               |
| Mark/select    | Ctrl + Shift + 6       |
| Copy selection | Alt + 6                |
| Delete char    | Backspace or Ctrl + D  |
| Spell check    | Ctrl + O then Ctrl + S |

## 7.4 Editing and Saving

    ✏️ To write content:
    	Just start typing.
    💾 To Save:
    	Press Ctrl + O
    	Press Enter to confirm filename
    🚪 To Exit:
    	Ctrl + X
    	If there are unsaved changes, it asks:
    		--------------------------------------------------------------
    		| Save modified buffer? (Answering "No" will DISCARD changes) |
    		| Y Yes   N No   ^C Cancel			              |
    		---------------------------------------------------------------

## 7.5 Open at Specific Line / Read-only

```
nano +10 example.txt    # This opens example.txt at line number 10
nano -v filename        # You can view the file but not edit.
```

## Nano Exercise

    [NanoExercise.zip](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/cc6ee08f-2e6f-4fe9-b8f4-98ba8d963c6b/NanoExercise.zip)

    Download the above zip file.  Unzip it and then navigate to the resulting directory using the command line.

### Part 1

    1. Open up the `recipe.txt` file using `nano`
    	--> cd NanoExercise
    	nano recipe.txt
    2. On line 3, add your own name after `Author:` so that it says `Author: Stevie Wonder` or whatever your name is
    	--> jaswanth kumar
    3. Whoever wrote this recipe didn't know how to spell "parmesan", so instead they wrote "parm".
       Please update the two instances of "Parm" to "Parmesan".
       You can do this manually or by using nano's replace feature.
    	--> Ctrl+\ --> parm -- enter --parmesan  --> y
    4. Write out your changes! Close the file.
    	--> ctrl+O
    	--> enter for file name
    	--> ctrl+x

### Part 2

    1. Open up the `website.html` file with `nano`
    	--> nano website.html
    2. This html file contains a simple website for a fictional restaurant called "Ristorante Colt".
       You recently purchased the restaurant and have decided to change its name!
       Please replace all instance of "Ristorante Colt" with your new restaurant'sname.
       Do this using a nano shortcut, rather than manually replacing each one.

    	--> Ctrl+\ --> Ristorante Colt -- enter -- jaswanth jas  --> a
    	--> total 4 occurrences

    3. Save your changes and close the file!
    	ctrl+O
    	enter for file name
    	ctrl+x

### Part 3

    1. The `country-data.json` file contains a large country dataset, with over 39,000 lines of json!
    	--> nano +15399 country-data.json
    2. Unfortunately, there is a typo on line **15399**.  It says "Hondras" but it should say "Honduras".
       Please fix this!  Rather than scrolling for a decade, use a nano shortcut to jump to line **15399**.
    	--> Ctrl+\ --> Hondras -- enter -- jaswanth jas  --> a
    3. **Bonus:** Figure out how to tell `nano` to open the file at exactly **15399**.
    	nano +15399 country-data.json

### Bonus

    1. The `review.txt` file contains a text review of the Cacio E Pepe recipe from `recipe.txt`

    2. Open up the `recipe.txt` file using `nano` and scroll to the bottom.

    3. Using a nano shortcut we have not covered, insert the contents of `review.txt` at the bottom of `recipe.txt`.

---

# 8. Delete / Move / Copy

## 8.1 `rm` — Remove Files or Directories

```
rm file                 # single file
rm file1 file2          # multiple files
rm -d emptydir          # remove empty directory
rm -r folder            # Delete Folder + All Its Contents (Recursive)
rm -rf folder           # Delete everything inside the folder without asking confirmation
rm -i file.txt          # for interactive safe delete files
--> Safe Delete Mode (Ask before deletion)
rm -ri folder           # for interactive safe delete folder
--> Safe Delete Mode (Ask before deletion every file and folder)
```

## 8.2 `mv` — Move/Rename

```
mv file1 /path/to/dir/
mv file1 file2 folder/
mv oldname.txt newname.txt
mv oldfolder newfolder
```

## 8.3 `cp` — Copy Files/Directories

```
cp file1.txt file2.txt
cp file.txt /path/to/folder/
cp file1 file2 folder/
cp -r folder1 folder2
```

## 8.4 Deleting, Moving & Copying Exercise (Questions Only)

Create the `Bootcamp` structure. Then complete these tasks:

1. Delete `Edgar.txt` in `FallCohort`.
2. Move `Netta.txt` from `Waitlist` to `FallCohort`.
3. Delete `Waitlist` folder and its contents.
4. Rename `Sara.txt` to `Sarah.txt`.
5. Move `Italo.txt` from `FallCohort` to `WinterCohort`.
6. Copy `WinterCohort` to `SpringCohort`.
7. Rename `WinterCohort` to `WinterCohortCANCELLED`.
8. Delete entire `Bootcamp` directory.

---

# 9. Useful Terminal Shortcuts

General:
| Shortcut | Action |
|------------------|-----------------------------------------|
| Ctrl + L | Clear screen |
| Ctrl + A | Move cursor to start |
| Ctrl + E | Move cursor to end |
| Ctrl + F / B | Move forward/back one char |
| Ctrl + T | Swap last two characters |
| Alt + T | Swap last two words |
| Ctrl + K / U | Cut to end / start of line |
| Ctrl + W | Delete one word backward |
| Alt + D | Delete one word forward |
| Ctrl + H | Delete one char backward |
| Ctrl + Y | Paste text removed by Ctrl+U/W/K |
| Ctrl + C | Cancel current command |
| Ctrl + Z | Suspend process (background) |
| Ctrl + D | Logout/exit terminal |
| Tab | Autocomplete |

Navigation & History:
| Shortcut | Action |
|--------------|-------------------------------------------|
| Alt + B / F | Move back/forward one word |
| Ctrl + P / N | Previous/next command |
| Up/Down | Browse history |
| Ctrl + R | Reverse search history |
| Ctrl + G | Exit history search |

Terminal Tabs/Windows:
| Shortcut | Action |
|---------------------|---------------------------|
| Ctrl + Shift + C/V | Copy/Paste in terminal |
| Ctrl + Shift + T/N | New tab / new window |
| Ctrl + Shift + W | Close current tab |

Process Control:
| Command | Action |
|---------|---------------------------------------------|
| fg | Bring a suspended job to foreground |
| bg | Run a suspended job in background |
| jobs | List background/suspended processes |

---

# 10. Working With Files

## 10.1 `cat` — Concatenate and View

```
cat filename.txt
cat > notes.txt    # create then Ctrl+D
cat >> notes.txt   # append
cat -n filename.txt
cat part1.txt part2.txt > final.txt
```

## 10.2 `less` — Pager for Large Files

```
less filename.txt
```

Navigation keys (subset):

- Up/Down: line scroll
- Space: page down
- b: page up
- G: end of file
- g: start of file
- `/keyword`: search forward
- `?keyword`: search backward
- `n`/`N`: next/previous match
- `q`: quit

## 10.3 `tac` — Reverse Lines

```
tac logfile.txt
```

## 10.4 `rev` — Reverse Characters Per Line

```
echo "Linux" | rev
```

## 10.5 `head` — Top Lines

```
head file.txt
head -n 20 file.txt
```

## 10.6 `tail` — Bottom Lines

```
tail file.txt
tail -n 15 file.txt
```

## 10.7 `wc` — Counts

```
wc sample.txt
wc -l file
wc -w file
wc -c file
wc -m file
```

## 10.8 `sort` — Sorting

```
sort names.txt
sort -r names.txt
sort -u names.txt
```

## 10.9 Working With Files Exercise (Questions Only)

1. Print entire contents of `poem.txt` with line numbers.
2. Read `poem.txt` in `less` and navigate; search for the term "Dog".
3. Open `poem.txt` in `less` with line numbers by default.
4. Jump to exactly 50% of the file in `less`.
5. Count the number of words in `poem.txt`.
6. Print the first 4 lines of `poem.txt`.
7. Print the last 8 lines of `poem.txt`.
8. Print `purchases.txt` lines in reverse order.
9. Sort `purchases.txt` alphabetically.
10. Count the number of lines in `purchases.txt`.
11. Sort `purchases.txt` by the final numeric column in reverse order.

---

# 11. Standard Streams and Redirection

## 11.1 Standard Streams

| Stream | Abbrev | FD  | Purpose               |
| ------ | ------ | --- | --------------------- |
| stdin  | 0      | 0   | Program input         |
| stdout | 1      | 1   | Normal program output |
| stderr | 2      | 2   | Error messages        |

## 11.2 Redirection Operators

| Operator | Meaning                     |
| -------- | --------------------------- |
| `>`      | Redirect stdout (overwrite) |
| `>>`     | Redirect stdout (append)    |
| `2>`     | Redirect stderr             |
| `&>`     | Redirect stdout + stderr    |
| `<`      | Redirect stdin from file    |

Examples:

```
ls > output.txt
ls >> output.txt
ls nofile 2> error.txt
command > file 2>&1
command &> file
command < notes.txt
```

Pipes:

```
command1 | command2
ls | grep "test"
grep "apple" *.txt 2>/dev/null | wc -l
```

## 11.3 Practical Examples

```
sort names.txt > sorted.txt
grep "error" app.log 2> errors.log
grep "dog" animals.txt > result.txt 2> errors.txt
grep "dog" animals.txt &> all.log
```

## 11.4 Redirection Exercise (Questions Only)

1. Create `all-species.txt` that combines `angela-survey.txt`, `nico-survey.txt`, and `juan-survey.txt`.
2. Sort unique lines in `all-species.txt` into `sorted-animals.txt`.
3. Append the current date and the text `Green Anaconda` to `sorted-animals.txt`.
4. Run a non-existent command and append its error messages to `sorted-animals.txt`.

---

# 12. Piping

## 12.1 What and Why

Pipes send the stdout of one command directly to the stdin of another:

```
command1 | command2
```

## 12.2 How It Works

- stdout of the left command is connected to stdin of the right command.
- Chains of multiple pipes create processing pipelines.

## 12.3 Common Pipelines and Examples

```
ls | grep ".txt"
ls | grep ".txt" | wc -l
cat /etc/passwd | cut -d ':' -f1
ls -lh | sort -k5 -n | tail -5
grep "ERROR" app.log | tail -10 | sort
echo "HELLO" | tr A-Z a-z
```

---

# 13. `tr` Command

Purpose: translate, delete, or squeeze characters.  
Syntax:

```
tr [OPTION] SET1 [SET2]
```

Examples:

```
echo "linux" | tr a-z A-Z
echo "HELLO" | tr A-Z a-z
echo "Linux OS" | tr ' ' '_'
echo "abc123" | tr -d 0-9
echo "aaabbccdd" | tr -s a-z
echo "hello world" | tr -d "aeiou"
echo "jaswanth.uppu@gmail.com" | tr -d '[:alpha:]'
echo "uppu jaswanth kumar" | tr -d '[:blank:]'
```

---

# 14. `tee` Command

Reads from stdin, writes to stdout and files simultaneously.

Syntax:

```
command | tee filename
```

Examples:

```
ls | tee list.txt
ls | tee -a history.txt
echo "Log Entry" | tee log1.txt log2.txt
grep "error" app.log | tee errors.txt
ls | wc -l | tee count.txt
```

---

# 15. Piping Exercise (Questions Only)

1. Count the number of files in `PokeDex/`.
2. Create `all-pokemon.txt` in `PokemonExercise/` with lowercased names from `PokeDex/`, sorted numerically.
3. Print lines 16–18 from `all-pokemon.txt`.
4. Output the first 151 lines of `all-pokemon.txt`, remove digits, sort alphabetically, and store as `original-151.txt`.

---

## Notes and Cautions

- Commands are case-sensitive (e.g., `date` ≠ `Date`).
- Use `rm -rf` with extreme caution; never run it on `/`.
- Some typos in the original practice answers were left out of exercises here by design (exercises are questions only).
# 16. Linux Expansions

Linux shells (especially Bash) perform several automatic transformations
*before* executing your command. These transformations are called **expansions**.

Understanding expansions is one of the most important skills in Linux because
almost every command you type goes through this expansion phase.  
Bash reads your line → expands variables, patterns, ranges, arithmetic →
and only then runs the final executed command.

---

## 16.1 What Are Expansions?

Expansion is a preprocessing step in which the shell scans your command for
patterns such as:

- Variables (`$HOME`, `$USER`)
- Wildcards (`*`, `?`, `[abc]`)
- Braces (`{1..10}`, `{a,b,c}`)
- Arithmetic (`$((5+3))`)
- Command substitution (`$(date)`)
- Tilde (`~`)
- Parameter operations (`${var^^}`)

The shell then **replaces** them with their actual values *before*
executing the command.

Example:

```
echo My home is $HOME
```

The shell expands `$HOME`:

```
My home is /home/jaswanth
```

Only after expansion does the `echo` command receive its final arguments.

---

## 16.2 Why Are Expansions Used?

Expansions allow:

- **Dynamic commands**  
  Use variables, system information, date, etc.

- **Automation**  
  Create hundreds of files or directories with one line:
  ```
  touch file{1..100}.txt
  ```

- **Shorter commands**  
  Globbing avoids typing long filenames manually.

- **Pattern matching**  
  Work with groups of files (`*.log`, `a*.py`, `file?.txt`)

- **Script flexibility**  
  Write scripts that adapt to user, environment, or system state.

- **Advanced string manipulation**  
  Convert case, extract substrings, replace text using parameter expansion.

Expansions make Linux **powerful**, **concise**, and **extremely efficient**.

---

## 16.3 How Expansion Works Internally

When you type a command, Bash processes it in this order:

1. **Brace expansion** (`{1..5}`, `{a,b}`)
2. **Tilde expansion** (`~`, `~user`)
3. **Parameter & variable expansion** (`$HOME`, `${name}`)
4. **Arithmetic expansion** (`$((5+3))`)
5. **Command substitution** (`$(ls)`)
6. **Word splitting** (splits text into separate command arguments)
7. **Pathname expansion (globbing)** (`*`, `?`, `[abc]`)
8. **Quote removal**

Each stage modifies the command before execution.

This is why:

```
echo $(ls *.txt)
```

first expands `*.txt` → list of files  
then runs `ls` → output becomes a string  
then `echo` prints it.

---

## 16.4 Types of Expansions

Below are all commonly used expansions with detailed examples.

---

## 16.4.1 Pathname Expansion (Globbing)

Globbing automatically matches filenames based on wildcard patterns.

### Wildcard Symbols

| Symbol | Meaning |
|--------|---------|
| `*` | Matches zero or more characters |
| `?` | Matches exactly one character |
| `[abc]` | Matches any one from the set |
| `[^abc]` | Matches anything *except* a, b, or c |
| `[0-9]` | Range |

### Examples

```
ls *.txt
```
→ Matches: report.txt, notes.txt

```
ls file?.txt
```
→ Matches: file1.txt, fileA.txt  
✗ Does NOT match: file10.txt

```
ls [ab]*
```
→ Matches files starting with 'a' or 'b'

```
grep "[^0-9]" file.txt
```
→ Matches lines containing anything except digits.

---

## 16.4.2 Tilde Expansion

`~` expands to the user's home directory.

Examples:

```
echo ~
```
Output:
```
/home/jaswanth
```

```
cd ~
```
→ Takes you to your home folder.

```
ls ~root
```
→ Expands to root’s home directory: `/root`

Tilde saves time and avoids needing to memorize full absolute paths.

---

## 16.4.3 Brace Expansion

Brace expansion **generates strings** before execution.
It is NOT related to filenames (unlike globbing).

### Simple List

```
echo {red,green,blue}
```

Output:
```
red green blue
```

### Generate File Names

```
touch file{1,2,3}.txt
```

Creates:
- file1.txt
- file2.txt
- file3.txt

### Numeric Sequence

```
echo {1..5}
```

Output:
```
1 2 3 4 5
```

### Numeric Sequence with Step

```
echo {0..20..5}
```

Output:
```
0 5 10 15 20
```

### Reverse Alphabet with Step

```
echo {Z..A..2}
```

Output:
```
Z X V T R P N L J H F D B
```

### Nested Braces

```
echo {a,b{1..3},c}
```

Output:
```
a b1 b2 b3 c
```

Brace expansion is extremely powerful for mass-file creation:

```
mkdir Year/{Winter,Spring,Summer,Fall}/{House,Yard}
```

Creates a full directory structure in one command.

---

## 16.4.4 Arithmetic Expansion

Arithmetic expansion evaluates integer expressions.

```
echo $((5 + 3))
```

Output:
```
8
```

Variables work too:

```
a=10; b=4
echo $((a * b))
```
Output:
```
40
```

You can use:

- `+ - * /`
- `%` (modulo)
- `**` (power)
- `<<`, `>>` (bitwise shift)
- Comparisons (`> < == !=`)
- Logical operators (`&& || !`)

---

## 16.4.5 Quote Removal

After expansion, Bash removes certain quotes (when safe).

Example:

```
echo "My home is $HOME"
```

→ Quotes are removed in output, giving:

```
My home is /home/jaswanth
```

But quotes **protect whitespace**:

```
echo "A   B"
```

Whitespace is preserved.

---

## 16.4.6 Command Substitution

Runs a command and replaces the expression with its output.

```
echo "Today is $(date)"
```

Output:
```
Today is Fri Nov 7 10:43:00 IST 2025
```

Another example:

```
files=$(ls)
echo "My files: $files"
```

Command substitution is essential for scripting.

---

## 16.4.7 Variable Expansion

Variables store values and expanding them allows dynamic content.

```
name="Jaswanth"
echo "Hello $name"
```

```
echo $HOME
```

Expands to:

```
/home/jaswanth
```

You can embed variables inside strings:

```
echo "I am $USER working in $PWD"
```

---

## 16.4.8 Parameter Expansion (Advanced)

Parameter expansion allows **string manipulation** using variables.

### Uppercase

```
name="linux"
echo ${name^^}
```
Output:
```
LINUX
```

### Substring Extraction

```
echo ${name:0:3}
```
Output:
```
lin
```

### Replacement

```
echo ${name/l/L}
```
Output:
```
Linux
```

Parameter expansion is extremely useful in scripting for data processing.

---

## 16.5 Combining Multiple Expansions

You can combine expansions to build powerful single-line commands.

Example:

```
echo "Files: $(ls *.txt), Today: $(date +%A)"
```

Output:
```
Files: notes.txt report.txt, Today: Friday
```

Another example using brace + command substitution:

```
touch file_{$(date +%d),backup}.txt
```

Creates files like:

- file_07.txt
- file_backup.txt

---

## 16.6 Real-World Usage of Expansions

### 1. Automation in file creation

```
touch {morning,afternoon}-day-{1..30}.txt
```

Creates 60 files in seconds.

### 2. Date-based logs

```
touch todo-$(date +"%m-%d-%Y").txt
```

### 3. Bulk directory structure creation

```
mkdir -p Year/{Winter/{Yard,House},Summer/{Yard,House}}
```

### 4. Filtering with globbing

```
ls *9
ls *1?
ls afternoon*7
```

### 5. Moving grouped files

```
mkdir Mornings
mv morning* Mornings/
```

### 6. Massive directory-tree creation

```
mkdir -p Year/{Winter/{Yard,House},Spring/{Yard,House},Summer/{Yard,House},Fall/{Yard,House}}
```

### 7. Create files inside the structure

```
touch Year/*/{Yard,House}/{todos,done}.txt
```

---
# 17. Finding Things in Linux

Searching for files, directories, and content is one of the most essential
skills in Linux. Whether you are troubleshooting, automating tasks, or
managing large systems, you must know how to find files efficiently.

Linux offers powerful tools like **locate**, **find**, **grep**, and **xargs**.
Each tool is designed for a different purpose—some are extremely fast,
others are extremely flexible.

This chapter teaches you how these tools work and how to use them in real
world scenarios.

---

## 17.1 The `locate` Command

The `locate` command is used for *very fast* file searches.  
It does not scan the filesystem in real time. Instead, it uses a
pre-generated database of file paths.

### How It Works (Deep Explanation)

- Linux maintains a database (usually `/var/lib/mlocate/mlocate.db`)
  containing *every* file path on the system.
- The `locate` command searches this database instantly.
- Since it does not walk through directory trees, it is **much faster**
  than `find`.
- The database is updated by the command:
  ```
  sudo updatedb
  ```
- If you create or delete files, the database might not reflect changes
  until you update it.

### Basic Usage

```
locate notes.txt
```

Finds all files named "notes.txt".

```
locate -i report.pdf
```

Case-insensitive search.

```
locate -c txt
```

Count how many matches were found.

```
locate Downloads/ exercise -il10
```

Case-insensitive search, limit to 10 results.

### Important Option: `-e`

The `-e` flag ensures returned results **actually exist** at the moment
of search.

Without `-e`, `locate` might show deleted files because the database can
be outdated.

```
locate -e backup.tar.gz
```

### Updating the Database

```
sudo updatedb
```

Use this whenever you create new files and `locate` does not find them.

### Common `locate` Options

| Option | Description |
|--------|-------------|
| `-e` | Show only currently existing files |
| `-i` | Case-insensitive search |
| `-n N` | Limit results to N |
| `-c` | Show only count |
| `-r regex` | Search using regular expressions |

### When to Use `locate`

Use `locate` when you want speed:

- Searching by filename
- Searching large systems
- Finding file locations instantly
- Quickly jumping to config files

---

## 17.2 The `find` Command

`find` is the most powerful and flexible search tool in Linux.
Unlike `locate`, it performs **real-time** searches by scanning the
actual filesystem directory tree.

### How `find` Works (Deep Explanation)

- It starts at a given path (`/home`, `.` , `/var/log`, etc.).
- Walks the directory structure recursively.
- Checks each file/directory against search conditions:
  - name
  - size
  - type
  - permissions
  - modification time
  - ownership
  - patterns
  - and more
- It can perform **actions** such as:
  - deleting results
  - copying results
  - printing results
  - executing commands (`-exec`)

This makes `find` suitable for system administration, automation,
cleanup, and advanced scripting.

### Basic Syntax

```
find [path] [options] [expression]
```

Example:

```
find . -name "notes.txt"
```

### Case-Insensitive Search

```
find . -iname "*.txt"
```

### Search Directories

```
find /var/log -type d -name "apache*"
```

### Search Files Only

```
find . -type f -name "*.log"
```

---

## 17.3 Important `find` Options (Deep Breakdown)

Below is a structured list of useful `find` options.

### Search by Name

```
find . -name "file.txt"
find . -iname "file.txt"
```

### Search by Type

| Type | Meaning |
|------|---------|
| f | File |
| d | Directory |
| l | Symlink |

Example:

```
find . -type d -name "backup"
```

### Search by Size

```
find . -size +10M
```
Files larger than 10MB.

```
find . -size -100k
```
Files smaller than 100KB.

### Search by Time (mtime, atime, ctime)

| Flag | Meaning |
|------|---------|
| mtime | Content modified |
| atime | Last accessed |
| ctime | Metadata changed |

Examples:

```
find . -mtime -1
```
Modified within 1 day.

```
find . -mmin -60
```
Modified within last 60 minutes.

```
find . -ctime +7
```
Metadata changed more than 7 days ago.

### Search Empty Files/Directories

```
find . -empty
```

### Search By Permissions

```
find . -perm 644
find . -perm -111   # executable
```

### Search by Owner

```
find . -user jaswanth
find . -group staff
```

### Limit Depth

```
find . -maxdepth 2 -name "*.txt"
```

---

## 17.4 Combining Logical Operators With `find`

### OR

```
find . -name "*.sh" -or -name "*.py"
```

### NOT

```
find . ! -name "*.txt"
```

### AND (default)

```
find . -type f -name "*.log" ! -size 0
```

### Grouping With Parentheses

```
find /home -type f \( -name "*.txt" -or -name "*.pdf" \)
```

Parentheses must be escaped to avoid shell interpretation.

---

## 17.5 Executing Commands With `-exec`

`find` can run a command on every file it matches.

### Delete All `.log` Files

```
find . -name "*.log" -exec rm {} \;
```

### Copy All JPG Files

```
find . -name "*.jpg" -exec cp {} /backup/images/ \;
```

### List All Found Files With Details

```
find . -type f -exec ls -lh {} \;
```

### Ask for Confirmation Before Running

```
find . -name "*.tmp" -ok rm {} \;
```

---

## 17.6 The `xargs` Command

`xargs` builds and executes commands using standard input.  
It is extremely efficient when dealing with large file lists.

### Why Use `xargs`?

- Faster than using `-exec` for hundreds of files
- Can batch operations for performance
- Lets you process piped input

### Basic Syntax

```
find ... | xargs command
```

### Example: Delete All `.txt` Files

```
find . -name "*.txt" | xargs rm
```

### Copy Files Using Placeholder

```
find . -name "*.jpg" | xargs -I {} cp {} /backup/images/
```

### Safe With Filenames Containing Spaces

```
find . -name "*.mp3" -print0 | xargs -0 cp -t /music/
```

### xargs With ls

```
ls | xargs -n 1 echo
```

---

## 17.7 Using Timestamps in Real Scenarios

### Files Accessed in Last 24 Hours

```
find . -type f -atime -1
```

### Files Modified More Than 7 Days Ago

```
find . -type f -mtime +7
```

### Metadata Changed Recently

```
find . -type f -ctime -2
```

---

## 17.8 Real-World Examples

### Count How Many Files Match Pattern

```
find -type f -name "*closed*" | wc -l
```

### Case-Insensitive Match

```
find -type f -iname "*closed*" | wc -l
```

### Find Empty Files

```
find -empty
```

### Search by Size and Name Together

```
find . -type f -size +150k -name "*closed.txt"
```

### Find Files Newer Than a Given File

```
find . -newer reference.txt
```

---

## 17.9 Summary — locate vs find vs grep vs xargs

| Tool | Purpose |
|------|---------|
| **locate** | Extremely fast name-based search using a database |
| **find** | Real-time search with powerful filtering options |
| **grep** | Search text *inside* files |
| **xargs** | Execute commands on results, often used with `find` |

### Key Points

- `locate` → fast, but may show outdated results  
- `find` → accurate, but slower  
- `grep` → text searching inside files  
- `xargs` → extends `find` by letting you execute commands on results

---

# 18. Grep Command in Linux

The `grep` command is one of the most important tools in Linux.  
It is used to search for **text patterns inside files or command output**.
System administrators, developers, analysts, and support engineers rely on it
daily to filter logs, extract information, and analyze text data.

`grep` supports simple text searches as well as complex **regular expressions**,
making it extremely powerful for real-world usage.

---

## 18.1 What Is `grep`?

`grep` stands for **Global Regular Expression Print**.

It reads input (files or piped output), **matches lines** that fit a pattern,
and **prints only those lines**.

In simple words:

> 🔍 *`grep` searches inside files and shows only what you want to find.*

Example:

```
grep "error" logfile.txt
```

This prints every line containing the word “error”.

### How `grep` Works Internally (Deep Explanation)

1. It reads the file **line by line**.
2. For each line, it compares the text against the given search pattern.
3. If the pattern matches:
   - The matching line is printed.
   - Depending on options, extra info (line numbers, colored output, filenames) may be shown.
4. If no match is found, it prints nothing (exit code will indicate result).

This makes `grep` ideal for analyzing large log files efficiently.

---

## 18.2 Why Is `grep` Used?

`grep` is used because:

- It is **fast** — optimized for text searching.
- It is **powerful** — uses regex for advanced patterns.
- It handles **multiple files**, entire directories, or piped input.
- It is essential for **log analysis**, debugging, auditing, monitoring.
- It integrates beautifully with other commands using **pipes**.

### Common Use Cases

- Find error lines in logs  
- Search code for functions or variables  
- Check configuration files  
- Filter system messages  
- Extract numbers, IPs, emails  
- Combine with cron, scripts, and automation

---

## 18.3 Basic Syntax

```
grep [OPTIONS] PATTERN [FILE...]
```

Examples:

```
grep "root" /etc/passwd
grep -i "error" *.log
dmesg | grep usb
```

---

## 18.4 Basic Usage Examples (With Explanations)

### 1. Simple Search

```
grep "error" system.log
```

Prints all lines containing the string “error”.

### 2. Case-Insensitive Search

```
grep -i "error" system.log
```

Matches “error”, “Error”, “ERROR”, etc.

### 3. Show Line Numbers

```
grep -n "error" system.log
```

Example output:

```
42:error: failed to start daemon
```

### 4. Match Whole Word Only

```
grep -w "root" /etc/passwd
```

Matches `root`  
Does NOT match `rooted` or `fireroot`.

### 5. Count Matching Lines

```
grep -c "error" system.log
```

Output:

```
5
```

### 6. Invert Match (Show lines NOT containing pattern)

```
grep -v "success" result.log
```

### 7. Highlight Matches

```
grep --color=auto "fail" test.log
```

Colors help identify matched text easily.

---

## 18.5 Searching Multiple Files

### Search in All `.py` Files

```
grep "import" *.py
```

### Search in Specified Files

```
grep "main" file1.c file2.c
```

### Always Display Filename With Match

```
grep -H "root" /etc/*
```

### Recursive Search in Directories

```
grep -r "Linux" /home/user/docs
```

Recursive + case-insensitive:

```
grep -ri "error" /var/log
```

---

## 18.6 Regular Expressions in `grep`

By default, `grep` supports basic regex.  
Extended regex is available using:

```
grep -E "pattern"
```
or
```
egrep "pattern"
```

### 1. Lines Starting With a Word

```
grep "^Error" logfile.txt
```

Matches:

```
Error: cannot read file
```

### 2. Lines Ending With a Word

```
grep "failed$" logfile.txt
```

Matches lines ending with `failed`.

### 3. OR Condition

```
grep -E "error|fail|critical" logfile.txt
```

Matches any of the three patterns.

### 4. Search For Digits

```
grep "[0-9]" file.txt
```

### 5. Match Repeated Characters

```
grep "lo\{2\}" words.txt
```

Matches:

```
hello
balloon
```

### 6. Match Any Single Character

```
grep "h.t" file.txt
```

Matches:

- hat  
- hit  
- hot  
- h?t  

### 7. Escape Special Characters

```
grep "2\.0" version.txt
```

Matches literal “2.0”, not “2-anything-0”.

---

## 18.7 Common Options Table

| Option | Description |
|--------|-------------|
| `-i` | Ignore case |
| `-n` | Show line numbers |
| `-c` | Count matches |
| `-v` | Invert match |
| `-w` | Match whole word |
| `-x` | Match entire line |
| `-r` | Recursive search |
| `-H` | Always show filename |
| `-h` | Hide filename in multi-file results |
| `-l` | Show filenames with matches |
| `-L` | Show filenames WITHOUT matches |
| `-o` | Show only matched part |
| `-q` | Quiet mode (no output) |
| `--color=auto` | Highlight matches |
| `-E` | Extended regex |
| `-F` | Fixed string search (faster) |
| `-A N` | Print N lines after match |
| `-B N` | Print N lines before match |
| `-C N` | Print context (before + after) |

---

## 18.8 Advanced Usage Examples

### 1. Search Command Output

```
ps aux | grep firefox
```

Finds running Firefox processes.

### 2. Search Inside Compressed Files

```
zgrep "error" logfile.gz
```

### 3. Show Context (Useful in Logs)

```
grep -C 2 "failed" server.log
```

### 4. Show Only Matched Part (Extracting Numbers)

```
grep -o "[0-9]\+" file.txt
```

### 5. Suppress Permission Errors

```
grep "config" /etc/* 2>/dev/null
```

### 6. Combine `grep` With `find`

```
find /var/log -type f -name "*.log" -exec grep -i "error" {} \;
```

### 7. Combine `grep` With `xargs`

```
find . -name "*.py" | xargs grep "import"
```

---

## 18.9 Exit Status Codes (Very Important for Scripting)

`grep` returns codes instead of printed output when needed.

| Code | Meaning |
|------|----------|
| `0` | Match found |
| `1` | No match found |
| `2` | Error occurred |

Example:

```
grep "hello" file.txt && echo "Found" || echo "Not found"
```

---

## 18.10 Real-World Use Cases

### 1. Search Logs for Errors

```
grep -i "error" /var/log/syslog
```

### 2. Check Config Values

```
grep "^Listen" /etc/httpd/conf/httpd.conf
```

### 3. Detect Failed SSH Attempts

```
grep "Failed password" /var/log/auth.log
```

### 4. Search for Functions in Code

```
grep -rn "def " /home/user/project
```

### 5. Monitor Logs in Real-Time

```
tail -f /var/log/syslog | grep "network"
```

### 6. Extract IPv4 Addresses

```
grep -oE "[0-9]{1,3}(\.[0-9]{1,3}){3}" logfile.txt
```

### 7. Find Email Addresses

```
grep -oE "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}" users.txt
```

---

## 18.11 Summary Table

| Feature | Description |
|---------|-------------|
| **Purpose** | Search for text patterns inside files |
| **Pattern Types** | Plain text or regex |
| **Extended Mode** | `grep -E` / `egrep` |
| **Fixed Strings** | `grep -F` / `fgrep` |
| **Recursive Search** | `grep -r` |
| **Highlighting** | `--color=auto` |
| **Exit Codes** | 0, 1, 2 for scripting automation |
| **Best For** | Log analysis, filtering, debugging, text extraction |

---

## 18.12 Quick Reference

| Task | Command |
|-------|----------|
| Simple Search | `grep "pattern" file.txt` |
| Recursive Search | `grep -r "pattern" /path` |
| Ignore Case | `grep -i "pattern" file.txt` |
| Count Matches | `grep -c "pattern" file.txt` |
| Match Word | `grep -w "pattern"` |
| Exclude Pattern | `grep -v "pattern"` |
| Show Filenames | `grep -l "pattern" *.txt` |
| OR Search | `grep -E "error|fail"` |
| Show Line Numbers | `grep -n "pattern"` |
| Show Context | `grep -C 2 "pattern"` |

---
---

# 19. Permissions Basics in Linux

Linux is a **multi-user operating system**, meaning multiple people (or
processes) can work on the same system at the same time.  
Because of this, Linux has a powerful **permission system** that protects
files, directories, and system resources.

Understanding permissions is essential for:

- Security  
- Collaboration  
- System administration  
- File access control  
- Script execution  
- Application deployment  

This chapter explains users, groups, file ownership, and how permissions
work at a deeper level.

---

## 19.1 Multi-User Architecture (Why Permissions Exist)

Linux was designed from the beginning as a **multi-user system**, where:

- Many users can log in simultaneously
- Processes from different users must not interfere
- Files must be protected from unauthorized access
- System files must be safe from regular users
- Services run as different users/groups for security

Without proper permissions:

- A normal user could delete system files  
- An application could overwrite another user’s data  
- Malicious processes could access sensitive information  

Linux solves this by assigning **ownership and permissions** to every file
and directory.

---

## 19.2 File Owners and Group Owners

Every file or directory has two owners:

1. **User owner (u)**  
   The user who created the file. Responsible for the file.

2. **Group owner (g)**  
   A group of users who may share access to resources.

There is also:

3. **Others (o)**  
   Everyone else on the system.

When you run:

```
ls -l file.txt
```

Example output:

```
-rw-r--r-- 1 jaswanth devteam 1200 Nov 7 09:30 file.txt
```

Breakdown:

- `jaswanth` → User owner  
- `devteam` → Group owner  

### Changing Ownership

```
chown user file
```

```
chgrp group file
```

```
chown user:group file
```

Ownership is critical for deciding who can read, write, or execute files.

---

## 19.3 File Type Indicators

The first character in a permission string indicates the **type of file**:

Example:

```
-rw-r--r--
```

The first `-` means **regular file**.

### File Type Summary

| Symbol | Meaning |
|--------|----------|
| `-` | Regular file |
| `d` | Directory |
| `l` | Symbolic link |
| `c` | Character device (keyboard, terminal) |
| `b` | Block device (hard disks) |
| `p` | Named pipe |
| `s` | Socket |

Examples:

```
drwxr-xr-x    → Directory
-rw-r--r--    → Text file
lrwxrwxrwx    → Symbolic link
```

---

## 19.4 Permission Structure (Deep Explanation)

Each file/directory has a permission string of **10 characters**:

```
-rwxr-xr--
```

Breakdown:

1st character → File type  
Next 9 characters → Permissions

```
[1] [2 3 4] [5 6 7] [8 9 10]
  |    |       |        |
type owner    group     others
```

### Permission Letters

| Symbol | Meaning |
|---------|----------|
| `r` | read |
| `w` | write |
| `x` | execute |
| `-` | no permission |

### Example Breakdown

```
-rwxr-xr--
```

| Section | Meaning |
|---------|-----------|
| `-` | Regular file |
| `rwx` | Owner can read, write, execute |
| `r-x` | Group can read, execute |
| `r--` | Others can read |

Permissions are evaluated **from left to right**.

---

## 19.5 Read Permissions

### Read on Files

`r` lets you **view** the contents of a file:

```
cat file.txt
less file.txt
```

Without read permission:

```
cat: Permission denied
```

### Read on Directories

`r` allows listing directory contents:

```
ls dirname/
```

Without read permission:

```
ls: cannot open directory ‘dirname’: Permission denied
```

> Remember:  
> A directory is a file that contains *filenames*, not file data.

---

## 19.6 Write Permissions

### Write on Files

`w` lets you:

- Modify file contents
- Append text
- Delete content

Examples:

```
echo "hello" >> file.txt
```

Without write permission:

```
bash: file.txt: Permission denied
```

### Write on Directories

Write permission on a directory allows:

- Creating files → `touch new.txt`
- Renaming files
- Removing files

Important:
> A user can delete a file inside a directory **if the directory has write permission**, even if the user does NOT own the file.

This surprises many new users.

---

## 19.7 Execute Permissions

### Execute on Files

`x` lets you **run the file as a program or script**.

```
./script.sh
```

If missing:

```
bash: ./script.sh: Permission denied
```

Give execute permission:

```
chmod +x script.sh
```

### Execute on Directories

`x` allows **entering** the directory:

```
cd dirname/
```

Without execute permission:

```
cd: dirname: Permission denied
```

### Summary of Directory Permissions

| Permission | Effect |
|------------|---------|
| `r` | list directory contents |
| `w` | create/delete/modify files |
| `x` | enter/traverse directory |

To fully access a directory, you usually need `rx`.

---

## 19.8 Understanding Permission Combinations

### Read + Write (`rw-`)

User can:

- Read file
- Modify it

### Read + Execute (`r-x`)

User can:

- Enter directory
- List files
- Execute program

### Write + Execute (`-wx`)

User can:

- Modify contents
- Execute program
- But cannot view contents directly

### Full Permissions (`rwx`)

User can do everything.

---

## 19.9 Numeric (Octal) Permission Values

Permissions can be converted to numbers:

| Symbol | Value |
|---------|--------|
| `r` | 4 |
| `w` | 2 |
| `x` | 1 |

Add them:

- `rwx` → 7  
- `rw-` → 6  
- `r-x` → 5  
- `r--` → 4  

So permission like:

```
-rwxr-xr--
```

Becomes:

```
750
```

Common numeric permissions:

| Number | Meaning |
|---------|-----------|
| 777 | Everyone full access |
| 755 | Owner full access, others read/execute |
| 700 | Owner only |
| 644 | Owner read/write, others read |
| 600 | Private file |

---

## 19.10 Real-World Permission Examples

### 1. Give execute permission to owner

```
chmod u+x script.sh
```

### 2. Remove write permission from group

```
chmod g-w file.txt
```

### 3. Give read to everyone

```
chmod a+r notes.txt
```

### 4. Remove all permissions for others

```
chmod o-rwx secret.txt
```

### 5. Set exact permissions

```
chmod u=rw, g=r, o= file.txt
```

### View Permissions

```
ls -l file.txt
```

---

## 19.11 Special Ownership Terms (Preview)

You will learn them in next chapter:

- **setuid**
- **setgid**
- **sticky bit**

These add extra behaviors to files and directories.


---

# 20. Altering Permissions in Linux

Now that you understand *what* permissions are, it’s time to learn *how*
to change them.  
Linux provides dedicated commands to modify:

- File permissions (`chmod`)  
- Ownership (`chown`)  
- Group ownership (`chgrp`)  

Learning these commands is essential for system security, scripting,
automation, and administering multi-user environments.

This chapter goes deep into symbolic and numeric modes, advanced examples,
and common real-world scenarios.

---

## 20.1 The `chmod` Command (Change Permissions)

`chmod` changes file or directory permissions.

General syntax:

```
chmod [options] mode file
```

Modes can be:

- **Symbolic** (human readable: `u+r`, `g-wx`, `o=r`)  
- **Numeric** (octal mode: `755`, `644`, `700`)  

We will explore both in detail.

---

## 20.2 Symbolic Mode (Human-Friendly)

Symbolic permissions modify specific parts of the permission string using:

- **u** = user (owner)  
- **g** = group  
- **o** = others  
- **a** = all (ugo)

Operators:

| Operator | Meaning |
|----------|----------|
| `+` | Add permission |
| `-` | Remove permission |
| `=` | Set exact permissions |

### Examples (With Explanations)

#### Add execute for user:

```
chmod u+x script.sh
```

Owner can now run `script.sh`.

#### Remove write from group:

```
chmod g-w file.txt
```

Group can no longer modify the file.

#### Add read permission for all users:

```
chmod a+r report.txt
```

#### Remove all permissions for others:

```
chmod o-rwx secrets/
```

This prevents external access to a folder.

#### Set exact permission values:

```
chmod u=rw,g=r,o= file.txt
```

Meaning:

- User: read + write  
- Group: read  
- Others: nothing  

Symbolic mode is ideal when you want fine control over individual
permissions.

---

### 20.2.1 Multiple Operations at Once

You can change multiple permissions in one command:

```
chmod u+rwx,g+rx,o-rw file.sh
```

You can also combine targets:

```
chmod ug+w file.txt
```

Grant write permission to both user and group.

---

### 20.2.2 Changing Directories vs Files

Directories require **execute** permission to enter.

Example:

```
chmod a+x scripts/
```

Without `x`, you cannot:

```
cd scripts/
```

`chmod` works the same way for files and directories, but **execute**
means different things:

- For files → Run the file  
- For directories → Enter/Traverse the directory

---

## 20.3 Numeric (Octal) Mode

Numeric permissions use **three-digit octal numbers**, each digit representing:

- User  
- Group  
- Others  

Each digit is the sum of:

| Permission | Value |
|------------|--------|
| `r` | 4 |
| `w` | 2 |
| `x` | 1 |

So:

- `7` → `rwx`  
- `6` → `rw-`  
- `5` → `r-x`  
- `4` → `r--`  
- `0` → `---`  

### Common Numeric Values

| Octal | Meaning |
|--------|----------|
| `777` | Everyone full access |
| `755` | Owner full, others read + execute |
| `700` | Only owner has access |
| `644` | Owner read/write, others read |
| `600` | Private file |

### Examples (with deep explanations)

#### Make script executable by everyone:

```
chmod 755 script.sh
```

Breakdown:

```
7 → rwx (owner)
5 → r-x (group)
5 → r-x (others)
```

#### Make a private file:

```
chmod 600 notes.txt
```

Owner: read + write  
Others: no access

#### Secure SSH keys:

```
chmod 600 ~/.ssh/id_rsa
```

SSH will reject insecure key permissions.

---

## 20.4 Changing Ownership (`chown`)

`chown` changes the **user** and/or **group** owner of a file.

### Syntax

```
chown user file
chown user:group file
```

### Examples

#### Change owner:

```
sudo chown jaswanth file.txt
```

#### Change group:

```
sudo chown :devteam file.txt
```

#### Change both user and group:

```
sudo chown jaswanth:devteam project/
```

### Change recursively:

```
sudo chown -R www-data:www-data /var/www
```

Useful when configuring servers.

---

## 20.5 Changing Group Ownership (`chgrp`)

Changes group only:

```
sudo chgrp devteam report.txt
```

Recursive:

```
sudo chgrp -R developers src/
```

---

## 20.6 Managing Groups (Deep Explanation)

Groups allow shared access to files.

### Create a group:

```
sudo groupadd devteam
```

### Add user to group:

```
sudo usermod -aG devteam jaswanth
```

### Check user groups:

```
groups jaswanth
```

### Change group of file:

```
sudo chgrp devteam file.txt
```

### Remove group:

```
sudo groupdel devteam
```

Groups are essential for collaborating on shared projects.

---

## 20.7 Special Permissions (Preview)

Three advanced permission types:

### 1. **setuid (`s`)**

- Applied to files  
- Allows executed program to run with file owner's permissions  

Example: `/usr/bin/passwd`

### 2. **setgid (`s`)**

- For files → program runs with group permissions  
- For directories → files created inside inherit group

### 3. **Sticky Bit (`t`)**

- For directories  
- Only file owner can delete their own files  
- Used in `/tmp`

These are advanced topics and will be covered in a separate chapter.

---

## 20.8 Recursive Permission Changes

Use `-R` for recursive modifications.

### Recursive chmod:

```
chmod -R 755 /var/www
```

### Recursive remove all permissions for others:

```
chmod -R o-rwx private/
```

### Recursive ownership changes:

```
chown -R user:group /data
```

Be careful — recursive operations can enable or break entire systems if misused.

---

## 20.9 Real-World Permission Scenarios

### 1. Fix “Permission Denied” on Script

```
chmod +x run.sh
```

### 2. Secure Website Directory

```
chmod -R 755 /var/www
chown -R www-data:www-data /var/www
```

### 3. Make a Shared Project Folder

```
mkdir project
chgrp devteam project
chmod 2775 project
```

The `2` makes setgid apply → all new files inherit group.

### 4. Share Read-Only Folder

```
chmod 755 shared/
```

### 5. Make Private Folder

```
chmod 700 private/
```

### 6. Enable Collaborative Editing

```
chmod g+w file.txt
```

### 7. Restrict Others Completely

```
chmod o-rwx secrets/
```

---

## 20.10 Understanding Why Permission Changes Matter

Changing permissions protects:

- System stability  
- User data  
- Application files  
- Sensitive configuration  
- Shared folders  
- Temporary files  

Incorrect permissions can cause:

- Security vulnerabilities  
- Services not starting  
- Applications not running  
- SSH keys failing  
- “Permission denied” errors  

# 21. The Environment in Linux

Every time you open a terminal, Linux loads a set of variables and configuration files that define **how your shell behaves**, what commands are available, and what settings each program inherits.

These settings are collectively called **the environment**.

Understanding the Linux environment is essential for:

- Shell scripting  
- Running applications  
- Debugging issues  
- Setting up PATH for custom commands  
- Automating workflows  
- Professional system administration  

This chapter explains everything you must know about how Linux variables work, how to customize them, and how shell startup files load.

---

## 21.1 What Is an Environment?

An **environment** is a collection of key–value pairs that define:

- User information  
- System settings  
- Command search paths  
- Language, region, timezone  
- Program behavior  
- Default editors and tools  

Example:

```
echo $HOME
```

Output might be:

```
/home/jaswanth
```

Every process inherits the environment of its parent — this is crucial for scripting.

---

## 21.2 Types of Variables

There are two major categories:

### **1. Local Variables**
- Exist only inside the current shell.
- Not passed to child processes.

Example:

```
name="linux"
```

```
bash
echo $name
→ (empty)
```

### **2. Environment Variables**
- Inherited by child processes.
- Used by programs, shells, and scripts.

Example:

```
export name="linux"
```

```
bash
echo $name
→ linux
```

This is why **export** is important.

---

## 21.3 Common Environment Variables (Explained)

| Variable | Purpose |
|----------|---------|
| **PATH** | Directories where Linux looks for commands |
| **HOME** | User’s home directory |
| **USER** | Current username |
| **SHELL** | Path of active shell (bash, zsh, etc.) |
| **PWD** | Present working directory |
| **LOGNAME** | Login username |
| **LANG** | Language/locale settings |
| **EDITOR** | Default editor (nano/vim etc.) |
| **MAIL** | Mail inbox path |
| **TERM** | Type of terminal being used |

Example:

```
echo $PATH
```

Output:

```
/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:...
```

This tells Linux **where to search for commands**.

---

## 21.4 Viewing Variables

### View all environment variables:

```
printenv
```

```
env
```

### View ALL variables (local + environment):

```
set
```

### View single variable:

```
echo $PATH
echo $HOME
echo $USER
```

### View exported variables:

```
export -p
```

---

## 21.5 Creating Variables

### Create a local variable:

```
myvar="hello"
```

### Create + export an environment variable:

```
export myvar="hello"
```

### Export an already created variable:

```
myvar=hello
export myvar
```

### Remove a variable:

```
unset myvar
```

### Check if exported:

```
printenv | grep myvar
```

---

## 21.6 Parameter Expansion (Detailed)

Parameter expansion lets you manipulate variable values.

### Basic usage:

```
${variable}
```

### Provide default value if variable not set:

```
${name:-"Guest"}
```

### Assign default value if variable not set:

```
${username:=user123}
```

### Alternate value if variable IS set:

```
${foo:+YES}
```

### Throw error if variable not set:

```
${MUST_SET:?Variable missing}
```

### Substring:

```
text="LinuxMaster"
echo ${text:0:5}      # Linux
```

### Replace:

```
name="jaswanth"
echo ${name/j/J}      # Jaswanth
```

---

## 21.7 Shell Startup Files (Very Important)

When you log in or open a terminal, Bash automatically loads several configuration files.

### System-wide files:

| File | Purpose |
|-------|---------|
| `/etc/profile` | General system environment settings |
| `/etc/bash.bashrc` | System-wide bashrc for all users |

### User-specific files:

| File | Loaded When |
|-------|-------------|
| **~/.bash_profile** | Login shell |
| **~/.bash_login** | If `.bash_profile` missing |
| **~/.profile** | Fallback |
| **~/.bashrc** | Non-login shells (normal terminals) |
| **~/.bash_logout** | When session ends |

---

### IMPORTANT WORKFLOW (Easy to Remember)

#### **When you log in:**
1. `/etc/profile`
2. `~/.bash_profile`
3. `~/.bashrc` (if sourced)

#### **When you open a new terminal:**
1. `~/.bashrc`

### Apply changes to bashrc:

```
source ~/.bashrc
```

---

## 21.8 Customizing the Shell Prompt (PS1)

Your terminal prompt is controlled by **PS1**.

Example:

```
PS1='\u@\h:\w\$ '
```

### Meaning:

- `\u` → username  
- `\h` → hostname  
- `\w` → current directory  
- `\$` → `$` for normal user, `#` for root  

Example with colors:

```
PS1='\[\e[32m\]\u@\h \[\e[34m\]\w \$\[\e[0m\] '
```

To make permanent:

```
nano ~/.bashrc
```

Add your PS1 line.

Reload:

```
source ~/.bashrc
```

---

## 21.9 Aliases (Command Shortcuts)

Aliases make long commands shorter.

### Create an alias:

```
alias ll='ls -l'
```

### Useful Examples:

```
alias gs='git status'
alias rm='rm -i'     # safer delete
alias c='clear'
alias update='sudo apt update && sudo apt upgrade'
```

### Delete an alias:

```
unalias ll
```

### View all aliases:

```
alias
```

---

## 21.10 The `.bash_aliases` File

On Ubuntu, `.bashrc` automatically loads `.bash_aliases` if it exists.

Check inside `~/.bashrc`:

```
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```

### Create it:

```
nano ~/.bash_aliases
```

Example contents:

```
alias ll='ls -lh'
alias py='python3'
alias ..='cd ..'
alias ...='cd ../..'
```

Apply changes:

```
source ~/.bash_aliases
```

---

## 21.11 PATH Variable (Very Important)

PATH determines where Linux searches for commands.

```
echo $PATH
```

### Add a folder to PATH temporarily:

```
export PATH=$PATH:~/bin
```

### Make it permanent:

Add this to your `.bashrc`:

```
export PATH=$PATH:~/bin
```

Reload:

```
source ~/.bashrc
```

### Why PATH is needed?

If a script is not in your PATH, you must run:

```
./script.sh
```

If it is in PATH, you simply type:

```
script.sh
```

---

## 21.12 Real-World Examples of Environment Usage

### 1. Set JAVA_HOME:

```
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
```

### 2. Change default editor:

```
export EDITOR=nano
```

### 3. Set Python virtual environment:

```
export PATH=~/myenv/bin:$PATH
```

### 4. Customizing PATH for scripts:

```
mkdir ~/scripts
mv myscript ~/scripts
export PATH=$PATH:~/scripts
```

### 5. Add aliases for productivity:

```
alias gs='git status'
alias activate='source venv/bin/activate'
```

---

## 21.13 Summary Table — Environment Commands

| Command | Purpose | Example |
|---------|----------|----------|
| `printenv` | Show environment variables | `printenv PATH` |
| `export` | Create/make env variables | `export NAME=Linux` |
| `set` | Show all variables | `set | less` |
| `unset` | Remove variable | `unset NAME` |
| `source` | Reload shell config | `source ~/.bashrc` |
| `alias` | Create shortcut commands | `alias ll='ls -l'` |
| `unalias` | Remove alias | `unalias ll` |

---




# 22. Writing Our Own Commands (Shell Scripting)

Linux gives you the power to create your **own commands**, automate tasks, and write scripts that behave just like real system utilities.  
This chapter teaches you how shell scripts work, how to make them executable, how to add them to PATH, and how to write commands the professional way.

---

## 22.1 What Is Shell Scripting?

A **shell script** is a text file containing a sequence of commands that the Linux shell executes line-by-line.

You can use shell scripts to:

- Automate repetitive tasks  
- Perform system monitoring  
- Process files and logs  
- Create custom Linux commands  
- Build menu-driven and interactive tools  
- Run backups and cron jobs  
- Simplify command sequences  

### Why Shell Scripting Matters?

- It is the **foundation** of DevOps, cloud, CI/CD, and server automation.  
- Every Linux administrator uses scripts daily.  
- Shell scripts run on any Linux machine without installing extra software.  
- They are lightweight and extremely fast.  

---

## 22.2 Structure of a Shell Script

Every script follows this structure:

```
#!/bin/bash       ← Shebang (interpreter)
# This is a comment
command1
command2
command3
```

### Explanation

- **Shebang (`#!`)** tells Linux which interpreter should run the file.  
  Example options:  
  - `/bin/bash`
  - `/bin/sh`
  - `/usr/bin/python3`
  - `/usr/bin/env node`

- **Commands** run exactly like they do in the terminal.

---

## 22.3 Creating Your First Script

### Step 1: Create a script file

```
nano hi
```

### Step 2: Add content

```
#!/bin/bash
echo "Hello, $USER!"
echo "Today is: $(date)"
echo "Current directory: $(pwd)"
echo "Last ran hi at $(date)" >> hi.log
```

### Step 3: Save and Exit  
Ctrl + O → Enter → Ctrl + X

### Step 4: Run the script (method 1)

```
bash hi
```

### Step 5: Make it executable (so it becomes a command)

```
chmod +x hi
```

### Step 6: Run it directly

```
./hi
```

---

## 22.4 Making Scripts Behave Like Real Commands

To run your script **from anywhere**, you must:

1. Give it execute permission  
2. Move it to a folder included in your PATH  
3. Or add your own folder to PATH  

---

## 22.5 Understanding the PATH Variable

`PATH` tells Linux **where to search for commands**.

```
echo $PATH
```

Example output:

```
/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/games
```

When you type `ls`, Linux checks these folders **in order** until it finds the executable.

### Add your own folder to PATH

#### Step 1: Create a folder for personal commands

```
mkdir -p ~/bin
```

#### Step 2: Move your script

```
mv hi ~/bin/
```

#### Step 3: Add folder to PATH temporarily

```
export PATH=$PATH:~/bin
```

#### Step 4: Make it permanent

Edit `.bashrc`:

```
nano ~/.bashrc
```

Add:

```
export PATH=$PATH:~/bin
```

Reload:

```
source ~/.bashrc
```

Now your script works like a real command:

```
hi
```

---

## 22.6 The Importance of the Shebang (#!)

The shebang determines the interpreter.

```
#!/bin/bash
```

Meaning:

- Linux opens `/bin/bash`
- Executes each line using Bash
- The script behaves consistently on every system

### Alternative Shebang Examples

| Language | Shebang |
|----------|---------|
| Bash | `#!/bin/bash` |
| Sh (POSIX shell) | `#!/bin/sh` |
| Python | `#!/usr/bin/python3` |
| Node.js | `#!/usr/bin/env node` |
| Perl | `#!/usr/bin/perl` |

### Without a shebang

You must manually specify interpreter:

```
bash hi
```

With shebang:

```
./hi
```

---

## 22.7 Making Scripts Executable

Linux needs the `x` permission to treat files as programs.

### Check permissions

```
ls -l hi
```

Output example:

```
-rw-r--r-- 1 user user 120 Nov 11 09:25 hi
```

### Add execute permission

```
chmod +x hi
```

Now:

```
-rwxr-xr-x 1 user user 120 Nov 11 09:25 hi
```

### Execute:

```
./hi
```

If the folder is in PATH:

```
hi
```

---

## 22.8 Passing Arguments to Scripts

Use `$1`, `$2`, `$3`, ... for positional arguments.

Example:

```
#!/bin/bash
echo "First argument: $1"
echo "Second argument: $2"
```

Run:

```
./myscript apple banana
```

Output:

```
First argument: apple
Second argument: banana
```

---

## 22.9 Read User Input

```
#!/bin/bash
echo "Enter your name:"
read name
echo "Hello, $name!"
```

---

## 22.10 Conditional Logic (`if`)

```
#!/bin/bash
if [ $1 -gt 10 ]; then
    echo "Greater than 10"
else
    echo "Less or equal to 10"
fi
```

---

## 22.11 Loops (`for`, `while`)

### For Loop

```
for i in 1 2 3 4 5
do
    echo "Value: $i"
done
```

### While Loop

```
count=1
while [ $count -le 5 ]
do
    echo "Count: $count"
    count=$((count+1))
done
```

---

## 22.12 Writing Modular Scripts (Functions)

```
#!/bin/bash

greet() {
    echo "Hello, $1!"
}

greet Jaswanth
```

---

## 22.13 Logging Output

```
echo "Script ran at $(date)" >> /var/log/my_script.log
```

---

## 22.14 Making a Script Available System-Wide

Move to a global bin directory:

```
sudo mv myscript /usr/local/bin/
```

All users can now run:

```
myscript
```

---

## 22.15 Example — Simple Backup Command

```
#!/bin/bash

src=$1
dest=$2

if [ ! -d "$src" ]; then
    echo "Source directory missing!"
    exit 1
fi

cp -r "$src" "$dest"
echo "Backup complete!"
```

Run:

```
backup ~/project ~/backup
```

---

## 22.16 Real-World Use Cases of Scripting

- Automatic backups  
- System resource monitoring  
- Log analysis  
- Cleanup tasks  
- Software deployment steps  
- Downloading and processing data  
- Creating custom shortcuts  
- Automating cron jobs  

---

## 22.17 Summary Table — Scripting Essentials

| Concept | Description | Example |
|---------|-------------|---------|
| Shebang | Defines interpreter | `#!/bin/bash` |
| chmod +x | Make script executable | `chmod +x hi` |
| PATH | Stores command locations | `export PATH=$PATH:~/bin` |
| Variables | Store values | `name="Jaswanth"` |
| Arguments | Script inputs | `$1 $2 $3` |
| Loops | Repeating actions | `for i in ...` |
| Functions | Reusable blocks | `greet()` |
| Logging | Store script output | `>> logfile.txt` |

---

# 23. Weather Script Using Case (Creating a Real Command)

In this chapter, we build a **real Linux command** named `weather` that fetches live weather information using *wttr.in* and `curl`.  
This introduces a practical combination of:

- Shell scripting  
- Case statements  
- Arguments (`$1`, `$2`)  
- Executable commands  
- PATH usage  
- Real-world command design  

This chapter makes your Linux skills **practical and professional**.

---

## 23.1 Introduction to the Project

We will create a command that:

- Shows default weather
- Shows next 3-day forecast
- Shows weather for a specific city
- Provides a help message
- Handles invalid input automatically

### Why this project is important?

Because it teaches:

✔ Command creation  
✔ Argument handling  
✔ Conditions using `case`  
✔ Script organization  
✔ Real-world command behaviour  
✔ Integration with an external API  
✔ Making a script “feel” like a native Linux command  

---

## 23.2 Understanding `curl` (The Core Tool)

`curl` is used to **fetch data from URLs**.

We will use it to fetch weather info from:

```
wttr.in
```

### Basic Examples

```
curl wttr.in
```

→ Shows weather for your current location.

```
curl wttr.in/hyderabad
```

→ Shows weather for Hyderabad.

```
curl wttr.in?m1
```

→ Shows a minimal version (best for scripts).

---

## 23.3 Installing curl (if not installed)

```
sudo apt install curl -y
```

---

## 23.4 Testing wttr.in in Terminal

Check default weather:

```
curl wttr.in
```

Check weather for a city:

```
curl wttr.in/delhi
```

Check next 3 days:

```
curl wttr.in?format=3
```

---

## 23.5 Creating the Weather Script

Now we build our *first real command*.

### Step 1 — Create a script file

```
nano weather
```

### Step 2 — Add the script content

```
#!/bin/bash

case $1 in
    -h | --help)
        echo "======================"
        echo " WEATHER COMMAND HELP "
        echo "======================"
        echo "Usage:"
        echo "  weather           → Show default weather"
        echo "  weather -3        → Show 3-day forecast"
        echo "  weather -l CITY   → Show weather for a specific city"
        echo "Examples:"
        echo "  weather -l hyderabad"
        echo "  weather -3"
        ;;
        
    -3)
        echo "Fetching 3-day forecast..."
        curl "wttr.in?m&format=v2"
        ;;
        
    -l | --location)
        if [[ -z "$2" ]]; then
            echo "Error: No city provided!"
            echo "Usage: weather -l <city>"
            exit 1
        fi
        echo "Weather for: $2"
        curl "wttr.in/$2?m1"
        ;;
        
    *)
        curl "wttr.in?m1"
        ;;
esac
```

### What does this script do?

- `$1` = first argument  
- `$2` = second argument  
- `case` = switches behaviour depending on user choice  
- `curl` prints weather information  

---

## 23.6 Detailed Explanation of the `case` Structure

### Structure

```
case variable in
    pattern1) command ;;
    pattern2) command ;;
    *) default command ;;
esac
```

### Why use case over if-else?

- Cleaner  
- More readable  
- Better for command-style options  
- Used in most professional scripts  

Example breakdown from our script:

| Input | Behavior |
|--------|----------|
| `weather -h` | Print help menu |
| `weather -l cityname` | Show weather for that city |
| `weather -3` | Show next 3 days |
| `weather` | Show default summary |

---

## 23.7 Make the Script Executable

```
chmod +x weather
```

Check:

```
ls -l weather
```

Expected:

```
-rwxr-xr-x 1 jaswanth jaswanth  120 Nov 11 11:45 weather
```

---

## 23.8 Running the Script (Local)

### Default

```
./weather
```

### Help

```
./weather -h
```

### 3-day forecast

```
./weather -3
```

### Specific city

```
./weather -l delhi
```

---

## 23.9 Installing the Command System-Wide

There are 2 ways.

---

### ✔ Method 1 — Add to ~/bin (recommended for user commands)

```
mkdir -p ~/bin
mv weather ~/bin/
export PATH=$PATH:~/bin
```

To make permanent:

```
echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
source ~/.bashrc
```

Now run:

```
weather
```

---

### ✔ Method 2 — Install globally (for all users)

```
sudo mv weather /usr/local/bin/
```

Now any user can run:

```
weather
```

---

## 23.10 Real Output Examples

### Default Output

```
🌞 +31°C   Clear sky
```

### Weather for Delhi

```
Delhi: 🌤️ +32°C
```

### 3-Day Forecast

```
Day 1: ☀️ +33°C
Day 2: 🌦️ +29°C
Day 3: ☁️ +30°C
```

---

## 23.11 Understanding API Query Parameters in wttr.in

| Parameter | Purpose |
|-----------|----------|
| `?m` | Metric system |
| `?m1` | Minimal output |
| `?format=v2` | Compact 3-day format |
| `/cityname` | City-based weather |

Examples:

```
curl wttr.in/mumbai?m
curl wttr.in/hyderabad?format=3
curl wttr.in/delhi?m1
```

---

## 23.12 Improving the Weather Script (Optional Enhancements)

You can upgrade your script:

### Add color:

```
echo -e "\e[32mWeather Script\e[0m"
```

### Add units:

```
curl "wttr.in/$2?format=%l:+%t°C,+%h"
```

### Add error handling:

```
if ! curl -s "wttr.in" > /dev/null; then
    echo "Error: No internet connection!"
fi
```

### Add more options:

- `-t` → temperature only  
- `-c` → cloud report  
- `-w` → wind details  
- `--raw` → raw API mode  

---

## 23.13 Summary Table — Weather Command

| Feature | Command | Description |
|---------|----------|-------------|
| Default weather | `weather` | Shows minimal weather summary |
| Help menu | `weather -h` | Shows all options |
| 3-day forecast | `weather -3` | Displays upcoming 3 days |
| City-based weather | `weather -l hyderabad` | Weather for a specific city |
| Make executable | `chmod +x weather` | Required to run script |
| Install globally | `sudo mv weather /usr/local/bin/` | System-wide usage |
| Add to PATH | `export PATH=$PATH:~/bin` | User-only commands |

---


# 24. Automation in Linux — Cron Jobs

Automation is one of the strongest features of Linux.  
The **cron daemon** allows you to schedule commands, tasks, and scripts to run automatically at specific times or intervals.

This is essential for:

- backups  
- log cleanup  
- system monitoring  
- sending reports  
- updating services  
- syncing data  
- running custom scripts  

Cron is at the heart of Linux system automation.

---

## 24.1 What Is Cron?

**Cron** is a background service (daemon) that wakes up every minute and checks if any scheduled job needs to run.

A **cron job** is one line in a user's **crontab** file that defines:

- what to run  
- when to run it  

The **crontab** is where users store their scheduled tasks.

---

## 24.2 Why Cron Is Important

Cron is extremely valuable because it provides:

✔ Hands-free automation  
✔ Precise control (minutes, hours, days, months)  
✔ Low resource usage  
✔ Reliability (runs even when no user is logged in)  
✔ Flexibility (scripts, commands, programs)  
✔ System-wide or user-specific automation  

Cron works silently and consistently — perfect for server environments.

---

## 24.3 Types of Cron

| Type | Description |
|------|-------------|
| **System cron** | `/etc/crontab` and `/etc/cron.*` directories |
| **User cron** | Per-user cron tables (`crontab -e`) |

Most of your automation work will happen in **user cron jobs**.

---

## 24.4 Checking Cron Service

Check if cron is running:

```
systemctl status cron
```

Start cron:

```
sudo systemctl start cron
```

Enable on boot:

```
sudo systemctl enable cron
```

Cron must be active for jobs to execute.

---

## 24.5 Viewing, Editing, and Removing Crontab

### View your cron jobs:

```
crontab -l
```

### Edit your crontab:

```
crontab -e
```

This opens your crontab in the default editor (usually nano or vim).

### Remove all your cron jobs:

```
crontab -r
```

⚠️ This deletes everything — no undo.

---

## 24.6 Cron Log File

To check if cron ran a job:

```
cat /var/log/syslog | grep CRON
```

or live monitoring:

```
tail -f /var/log/syslog | grep CRON
```

This is essential for debugging.

---

## 24.7 Understanding Cron Syntax

Cron syntax always follows **five time fields + the command**:

```
*   *   *   *   *   command
│   │   │   │   │
│   │   │   │   └── Day of week (0–6, Sun=0)
│   │   │   └────── Month (1–12)
│   │   └────────── Day of month (1–31)
│   └────────────── Hour (0–23)
└────────────────── Minute (0–59)
```

This looks confusing at first, but becomes easy with examples.

---

## 24.8 Meaning of Symbols in Cron

### `*` → every value

```
* * * * *  run every minute
* * * * 1  run every Monday
```

### `,` → list of values

```
1,15  * * * *   run at minute 1 and 15
```

### `-` → range

```
1-7 * * * *   run minutes 1 to 7
```

### `/` → step values (intervals)

```
*/5 * * * *   run every 5 minutes
0 */3 * * *   run every 3 hours
```

---

## 24.9 Special Cron Keywords

| Keyword | Meaning |
|---------|---------|
| @reboot | Run once on system boot |
| @yearly | Yearly, Jan 1 at midnight |
| @monthly | Monthly, day 1 at midnight |
| @weekly | Weekly on Sunday |
| @daily | Daily at midnight |
| @hourly | Every hour |

Examples:

```
@reboot   bash ~/startup.sh
@daily    bash ~/backup.sh
```

---

## 24.10 Creating Your First Cron Job

### Step 1: Edit your crontab

```
crontab -e
```

### Step 2: Add a job

```
1 * * * * echo "Another minute: $(date)" >> ~/time.log
```

Meaning:

- Runs at **minute 1** of **every hour**  
- Appends timestamp to `time.log`

### Step 3: Check if job is saved:

```
crontab -l
```

### Step 4: Verify logs:

```
cat ~/time.log
```

---

## 24.11 Handling Cron Job Errors

### 1. Logging output and errors separately

```
*/5 * * * * ~/bin/greet.sh >> ~/cron_success.log 2>> ~/cron_error.log
```

- `>>`  → append output  
- `2>>` → append errors  

### 2. Cron uses a minimal PATH

Always use **absolute paths** inside scripts.

Bad:

```
echo "Done"
```

Good:

```
/bin/echo "Done"
```

### 3. Script must be executable

```
chmod +x ~/bin/greet.sh
```

### 4. Test your script manually first

```
bash greet.sh
```

---

## 24.12 Cron Timing: Ranges, Lists, Steps

### Ranges

```
0 8 1-21 * *   run at 8 AM on days 1–21
```

### Lists

```
0 9 * * 1,3,5   run Mon/Wed/Fri at 9 AM
```

### Steps

```
*/5 * * * *   run every 5 minutes
```

### Combined

```
30 7 1-21/3 * *   every 3rd day between 1–21 at 7:30 AM
```

---

## 24.13 Practical Real-World Cron Examples

### Backup a project daily

```
0 1 * * * cp -r ~/project ~/project_backup
```

### Delete log files older than 7 days

```
0 0 * * * find /var/log/app -mtime +7 -delete
```

### Restart a service every Monday

```
0 3 * * 1 sudo systemctl restart apache2
```

### Check if a website is up

```
*/10 * * * * curl -Is https://google.com | head -1 >> ~/site_status.log
```

### Sync folders

```
0 */6 * * * rsync -av ~/data/ ~/backup/
```

---

## 24.14 Cron with Scripts

Example script: `/home/user/bin/backup.sh`

```
#!/bin/bash
tar -czf ~/backup/home_$(date +\%F).tar.gz /home/user
```

Make executable:

```
chmod +x ~/bin/backup.sh
```

Cron job:

```
0 2 * * * /home/user/bin/backup.sh
```

---

## 24.15 Debugging Cron Jobs

### 1. Check logs:

```
grep CRON /var/log/syslog
```

### 2. Add debugging info inside script:

```
echo "Script started" >> /tmp/debug.log
```

### 3. Force cron to send mail:

Add at top of crontab:

```
MAILTO="your@email.com"
```

### 4. Run with full path:

```
/usr/bin/python3
/usr/bin/curl
/bin/bash
```

---

## 24.16 Summary Table — Cron Syntax

| Field | Allowed Values | Meaning |
|-------|----------------|---------|
| Minute | 0–59 | When in the minute |
| Hour | 0–23 | When in the hour |
| Day | 1–31 | When in the month |
| Month | 1–12 | Which month |
| Day of week | 0–6 | Sunday=0 |

---

## 24.17 Summary

Cron is a powerful, lightweight, reliable automation tool used on every Linux system.

You learned:

- What cron and crontab are  
- Cron syntax and symbols  
- How to schedule tasks  
- How to debug cron issues  
- How to automate scripts  
- Real-world scheduling examples  
- Logging and error handling  
- Special keywords like @reboot  

Automation is a major part of Linux administration, and cron is your foundational tool.

---

# 25. Tar Command in Linux

The `tar` command is one of the most powerful and frequently used utilities in Linux for **archiving**, **packaging**, **compressing**, and **extracting** files.  
It is essential for backups, project packaging, file transfers, and system administration.

This chapter explains **what tar is**, **how it works**, **compression types**, **real-world usage**, **advanced tricks**, and a complete command reference.

---

## 25.1 What Is Tar?

`tar` stands for **Tape Archive**.  
Originally created for writing data onto tape drives, it is now widely used to **combine multiple files into a single archive file**, known as a **tarball**.

Tar archives:

- Preserve directory structure
- Preserve permissions and ownership
- Store metadata (timestamps, links)
- Can be compressed or uncompressed
- Are fast and efficient for packaging

---

## 25.2 Why Tar Is Used

Tar is mainly used because:

### ✔ It creates a single file from many files  
Useful for backups, transfers, sending projects, packaging logs, etc.

### ✔ It compresses data with gzip, bzip2, xz  
Examples:
- `.tar.gz`
- `.tar.bz2`
- `.tar.xz`

### ✔ It preserves important file metadata  
Ideal for sysadmins and DevOps engineers.

### ✔ It works recursively by default  
No need for extra flags to include subfolders.

### ✔ It integrates easily with backup scripts and cron jobs.

---

## 25.3 Tar File Extensions Explained

Tar itself only *archives* files — it does not compress them unless a compression option is used.

| Extension | Meaning | Compression? | Created Using |
|----------|----------|--------------|----------------|
| `.tar` | Archive only | ❌ No | `tar -cvf` |
| `.tar.gz` or `.tgz` | Gzip compression | ✔ Yes | `tar -czvf` |
| `.tar.bz2` | bzip2 compression | ✔ Yes | `tar -cjvf` |
| `.tar.xz` | xz compression | ✔ Yes | `tar -cJvf` |

---

## 25.4 Basic Tar Syntax

```
tar [options] [archive-file] [file/directory]
```

Examples:

```
tar -cvf backup.tar /home/user
tar -xvf backup.tar
tar -tvf backup.tar
```

---

## 25.5 Most Important Tar Options

| Flag | Meaning |
|------|----------|
| `-c` | Create a new tar archive |
| `-x` | Extract from a tar archive |
| `-v` | Verbose (show files being processed) |
| `-f` | File name (archive file) |
| `-t` | List files inside archive |
| `-z` | Use gzip compression |
| `-j` | Use bzip2 compression |
| `-J` | Use xz compression |
| `-C` | Extract to specific directory |
| `-r` | Append files to existing archive |
| `--delete` | Delete files from archive |

---

## 25.6 Creating Tar Archives

### 1. Create a tar archive (no compression)

```
tar -cvf project.tar project_folder/
```

Explanation:

- `c` → create  
- `v` → verbose  
- `f project.tar` → name of archive  

---

### 2. Create gzip-compressed archive (.tar.gz / .tgz)

```
tar -czvf project.tar.gz project_folder/
```

Gzip is fast and widely used.

---

### 3. Create bzip2-compressed archive (.tar.bz2)

```
tar -cjvf project.tar.bz2 project_folder/
```

bzip2 = better compression but slower.

---

### 4. Create xz-compressed archive (.tar.xz)

```
tar -cJvf project.tar.xz project_folder/
```

xz = very high compression (best for large backups).

---

## 25.7 Extracting Archives

### 1. Extract .tar

```
tar -xvf project.tar
```

### 2. Extract .tar.gz

```
tar -xzvf project.tar.gz
```

### 3. Extract .tar.bz2

```
tar -xjvf project.tar.bz2
```

### 4. Extract .tar.xz

```
tar -xJvf project.tar.xz
```

---

## 25.8 Extract to a Specific Directory

```
tar -xvf project.tar -C /home/user/Desktop/
```

This is useful when:

- restoring backups  
- extracting inside containers  
- organizing output  

**Note:** target directory must exist.

---

## 25.9 Listing Files Inside an Archive (Without Extracting)

```
tar -tvf project.tar
```

Useful for previewing:

- structure  
- file names  
- extracted size  

---

## 25.10 Appending a File to Existing Tar Archive

```
tar -rvf project.tar newfile.txt
```

### Important:

- You can append only to **uncompressed** `.tar` archives  
- Cannot append to `.tar.gz`, `.tar.xz`, etc.

---

## 25.11 Deleting a File from a Tar Archive

```
tar --delete -f project.tar oldfile.txt
```

### Note:

Not supported for compressed archives.

---

## 25.12 Verifying Tar Archives

### Test if tar is valid

```
tar -tvf archive.tar > /dev/null
```

If no error appears → archive is good.

---

## 25.13 Combining Tar with Other Commands

### 1. Using find to select files and tar them

```
find . -name "*.log" | tar -cvf logs.tar -T -
```

`-T -` means “read list from stdin”.

---

### 2. Tar + gzip + progress bar

```
tar -czvf - project/ | pv > project.tar.gz
```

---

### 3. Create incremental backups

```
tar --listed-incremental=backup.snar -cvf backup.tar /home/user
```

---

## 25.14 Real-World Use Cases

### ✔ Backing up home directory

```
tar -czvf home_backup.tar.gz /home/user
```

### ✔ Archiving logs

```
tar -czvf logs_$(date +%F).tar.gz /var/log
```

### ✔ Packing a project for deployment

```
tar -czvf app.tar.gz app/
```

### ✔ Compressing website files

```
tar -czvf site_backup.tar.gz /var/www/html
```

### ✔ Extracting backups on a server

```
tar -xzvf site_backup.tar.gz -C /var/www/html
```

---

## 25.15 Tar with Permissions & Ownership

Tar preserves:

- File permissions (rwx)
- Ownership (user:group)
- Timestamps
- Symlinks
- Device files
- Directory structure

This makes tar ideal for:

- system snapshots  
- server migrations  
- container packaging  

---

## 25.16 Choosing the Right Compression

| Format | Speed | Compression | Best Use |
|--------|--------|--------------|-----------|
| `.tar` | Fastest | None | Safe archives, scripts |
| `.tar.gz` | Fast | Good | General backups |
| `.tar.bz2` | Medium | Better | Logs, text-heavy files |
| `.tar.xz` | Slowest | Best | Very large backups |

---

## 25.17 Summary Table — Tar Commands

| Task | Command |
|------|---------|
| Create .tar | `tar -cvf file.tar dir/` |
| Create .tar.gz | `tar -czvf file.tar.gz dir/` |
| Create .tar.bz2 | `tar -cjvf file.tar.bz2 dir/` |
| Create .tar.xz | `tar -cJvf file.tar.xz dir/` |
| Extract .tar | `tar -xvf file.tar` |
| Extract .tar.gz | `tar -xzvf file.tar.gz` |
| Extract to directory | `tar -xvf file.tar -C /path/` |
| List contents | `tar -tvf file.tar` |
| Append file | `tar -rvf file.tar file.txt` |
| Delete file | `tar --delete -f file.tar file.txt` |
| Verify archive | `tar -tvf file.tar > /dev/null` |
| Tar with find | `find . -name "*.log" | tar -cvf logs.tar -T -` |

---

## 25.18 Summary

You learned:

- What tar is and why it is used  
- All tar compression types  
- Syntax breakdown  
- Creating, extracting, listing archives  
- Appending and deleting  
- Real-world examples  
- Advanced usage with `find`, compression, and backups  
- How tar preserves metadata  
- Best practices for compression formats  

Tar is essential for system administrators, developers, DevOps engineers, and anyone managing files in Linux.

---

