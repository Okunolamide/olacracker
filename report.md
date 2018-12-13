
# CS7NS1/CS4400 Module Final Report

- Student name: Stefano Lupo
- Student number: 14334933
- Date: 13/12/18

## InfernoBall team self-evaluation

- Team number: 32
- Team members: 
  - Stefano Lupo (me)
  - Yash Pandey
  - Aron Hoffmann
  - Nicholas Blott

|             | Stefano Lupo | Yash Pandey | Aron Hoffmann | Nicholas Blott |
|-------------|--------------|-------------|---------------|----------------|
|effort       |      high    |     low     |      high     |     low        |
|effectiveness|      high    |     low     |      high     |     low        |

## What I learned (1-2 pages)

Describe what you learned from taking the module.

### Effective Use of Bash and Scripting
As I run Linux on all of my machines, I use bash pretty much every day and as such I had some basic experience working with the terminal and was pretty comfortable with it. However I was by no means _compotent_. I _almost_ got lazy and left the lecture theatre when Stephen said he was going to give a lecture on the basics of using the terminal etc, but was glad I stayed. I knew some of what was discussed but picked up the basics of using things like `awk`, `grep` and `find` which I knew existed but hadn't yet bothered to figure out!

I forced myself to stay away from manually writing Python scripts to do everything that was needed for the module. As such, I learnt a tonne about making effective use of the functionality that ships with Linux including a bunch of the basic commands, I/O redirection, piping and combining all of those into simple scripts. `awk` and `grep` proved to be particullarly useful for looking through and partitioning large password dictionaries to be used for cracking. I ended up writing a couple of reusable bash scripts for the module which can be found [here](https://github.com/stefano-lupo/password-cracking/tree/master/practical4/scripts). They were used for formatting the potfile the way submitty liked it, partitioning the given list of hashes by hash type using regex, printing out the progress I made for each hash type (e.g 299/354 DES, 305/350 MD5 etc) and printing out the passwords sorted by length and hash type to gain some insights into the passwords.

### Password Cracking & Security
I knew about some of the basics of password storage from building super insecure login systems using PHP a few years ago. However I had always wondered how password _cracking_ worked. Starting off with John The Ripper was pretty trivial as you could just throw a list of passwords at it and it knew what to do. Learning to use Hashcat was a little more tricky as you had to specify the `-m` flag, indiciating which hash algorithm to use (MD5 / SHA256 etc). One of the things that took me far longer to realise than it should have was that the salts of the passwords were stored with the password hashes themselves. However once I understood that, everything started to click.

I spent a lot of time reading the Hashcat forums and documentation to try and understand what each of the modes did. For the most part, I just threw monumental wordlists along with as much compute power I could get my hands on at the problem. However after only getting a couple of hundred hashes for practical 4 (prior to the hints that were given out), I started looking at other more complex cracking modes such as masks, combinator and wordlist/mask hybrids. I also spent some time researching the new prince mode. My uses of these modes are described in the [practical 4 section](#practical-4). I didn't make much progress using these tools as the hints were given out pretty soon after I started using them which made straight up wordlist attacks much faster again, however it was interesting playing around which prince in particular.

### Using GPUs and GPU Programming
I had used GPUs in the past for training machine learning models and neural nets but most of the GPU complexity was entirely abstracted away. The module gave me the oppurtunity to actually get my hands dirty with running compute tasks on GPUs. The lecture series on OpenCL was really interesting and some further reading gave me a good overview of the OpenCL ecosystem. I haven't taken any graphics programming modules so this module was my first real exposure to GPU programming using OpenCL.

Setting up John to use GPUs was a little tricky at the start but once I got it running on my GPU in my home machine I could repeat the process on Rosetta Hub instances pretty easily. I also learnt a small amount about the important metrics for GPUs such as the number of CUDA cores etc. 

### Using Google Cloud
Although not an intended learning outcome of the module, I ended up learning a lot about the Google Cloud infrastructure. The GPU compute power on offer through Google Cloud was monumentally higher than what was obtainable through Rosetta Hub (as p3.8 instances were disabled on Rosetta Hub). I got to know the Google Cloud SDK and was able to spin up instances which had 8 NVIDIA Tesla V100s in minutes. I learnt how to set up instance groups and use preemtable (spot) instances to keep the costs down.

## What I did (2-4 pages) 
Describe what you did during the module, i.e., how you 
solved the practicals. Include URLs for code/repos but 
not the code itself. If you have more text than fits
in 4 pages, include a link to that additional text but
do make the 4 pages self-contained (other than code).

### Practical 2 / 3
Understanding hashes / salts / formats
Getting John the Ripper up and running
For the initial two practicals, I mainly got to know Rosetta Hub, John the Ripper and the formats of the hashed passwords. 

### Practical 4

### Inferno Ball



## Module evaluation (1 page)


Say what you liked/disliked about the module and why.
There's no need to say that RosettaHub is creaky, we
know that:-)




