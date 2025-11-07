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
   6.3 Create Files (`touch`, `cat >`, `nano`, `echo >`/`>>`)  
   6.4 Making Files and Folders Exercise (Questions Only)
7. Nano Editor
   7.1 Open Files and Modes  
   7.2 Interface Overview  
   7.3 Common Shortcuts  
   7.4 Editing and Saving  
   7.5 Open at Specific Line / Read-only  
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
