
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

I forced myself to stay away from manually writing Python scripts to do everything that was needed for the module. As such, I learnt a tonne about making effective use of the functionality that ships with Linux including a bunch of the basic commands, I/O redirection, piping and combining all of those into simple scripts. `awk` and `grep` proved to be particullarly useful for looking through and partitioning large password dictionaries to be used for cracking. I also made extensive use of `scp` for moving files around across machines. I ended up writing a couple of reusable bash scripts for the module which can be found [here](https://github.com/stefano-lupo/password-cracking/tree/master/practical4/scripts). They were used for formatting the potfile the way submitty liked it, partitioning the given list of hashes by hash type using regex, printing out the progress I made for each hash type (e.g 299/354 DES, 305/350 MD5 etc) and printing out the passwords sorted by length and hash type to gain some insights into the passwords.

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

### Practical 2
For the initial practical, I mainly got to know Rosetta Hub and John the Ripper. I have several machines which I frequently use over SSH so this was pretty simple. I spun up the cheapest spot instance I could find and SSHd in. The install of John the Ripper was pretty trivial also. I ran the benchmark and compared it to my laptop and old desktop and the lack of compute power on the spot instance became very evident.


### Practical 3
I started out this practical by doing some research into how people usually got about cracking passwords. I found a pretty [useful article](https://labs.mwrinfosecurity.com/blog/a-practical-guide-to-cracking-password-hashes/#fn6) which went through the basics of using hashcat to crack passwords. I continued using John the Ripper instead of switching to Hashcat and just used to article to gain some understanding. The article suggested starting with the _Battlefield 2015_ wordlist, so that's what I initially tried with my hashes. This was a pretty small wordlist which didn't take long to run through at all and got a couple of passwords. I then spent some time looking into other wordlists and discovered that _rockyou.txt_ was a hugely popular wordlist. I then set off my local machine running a wordlist attack using John the Ripper and rockyou.

At this point, JTR was just using my CPU for cracking. After about 30 minutes I had cracked ~150 passwords. I decided to stop and look into setting it up with my GPU to see how much of a performance increase I would get. I found another [useful article](https://blog.sleeplessbeastie.eu/2015/11/02/how-to-crack-password-using-nvidia-gpu/) on how to set use JTR with an NVIDIA GPU (which was what I had). This required installing some CUDA toolkits and updating my GPU drivers (which were pretty ancient, even for an 8 year old GPU!). This was suprisingly simple to set up and I could run JTR with my GPU by specifying the format to `--format <hash_format>-opencl`. The second I did this, my screen filled up with hashes ridculously quickly and I cracked all 1000 hashes in no time.

The final thing I did for this assignment was to get everything up and running on AWS. I spun up a spot of the cheapest GPU instance I could find and ran through the steps outlined in the assignment README. Everything went according to plan and I could crack the passwords even faster than on my home GPU.


### Practical 4
Practical 4 was a very challenging practical. Unfortunately, it took me this long to realize that the salts of the passwords were stored *with passwords*. Hashcat's refusal to run without specifying the hash algorithm forced me to spend some time researching how hash algorithms could be identified by their format. Fortunately, Hashcat's [example hashes page](https://hashcat.net/wiki/doku.php?id=example_hashes) made this pretty easy. It was at this point I realised that each of the salts were contained in each of the hashes which made everything make sense and I subsequently spent some time wondering what I had been thinking was happening before realising this.

Up until this point, all of the hashes we had been given were in a single format. So the first step in the practical was partitioning the hashes by hash algorithm type. As specified in the assignment README, I knew there was 6 hash types. As I wanted to improve my bash knowledge and capabilities, I spent some time writing a simple script to partition a given list of hashes using REGEX (see the `partition` function [here](https://github.com/stefano-lupo/password-cracking/blob/master/practical4/scripts/utils)). This function proved to be really useful for the remaining practicals. I ran this function and split the list of hashes into six separate files (one for each of the hash types). Comparing the partitioned hashes to the example hashes given on Hashcat's website, I noted the `-m` parameters for each of hash types.

For each of the practicals, I used a specific potfile. I version controlled these potfiles using Git/GitHub as these were essentially the deliverable for the entire assignment so if something happened to them, I would lose all of my progress. This worked quite well as I didn't come across a need to have multiple machines attempting to crack the same hashes. That is, each machine I was running was only cracking passwords for one hash type. This would have required a more _real-time_ potfile syncing mechanism. 

The next step was to determine which set of hashes to attempt first. Although my knowledge of hash algorithms was rather limited, I knew DES was simpler than MD5 and MD5 was simpler than SHA. I was unsure of where PBKDF2 / Argon would fit into things, so I ran a Hashcat benchmark for each of the hash types and determined the optimum cracking order to be: DES, MD5, SHA256, SHA512, PBKDF2, Argon. 

I then began the long process of trying to crack passwords. The first thing I tried was just running Rockyou against DES on my GPU at home. This worked quite well and didn't take long at all. It found 80/349 of the DES hashes. I had been using a simple one liner `awk -F ":" '{print $1, $2}' ~/software/hashcat-4.2.1/hashcat.potfile > hashes.broken` for reformating the potfiles, however when I went to submit the 80 hashes, Submitty didn't seem to accept them. My first guess was that there may have been hash collisions, so I removed the troublesome hashes from rockyou and the potfile and re-ran it against DES. This didn't get any more hashes but we later learnt there was a bug in the submitty checker. To get around this I wrote a simple [reformat function](https://github.com/stefano-lupo/password-cracking/blob/master/practical4/scripts/format) which would tidy up my potfile in a submitty-friendly way.

Up until this point, I had only used rockyou for each of the previous assignments. I decided to try and use some rules along with rockyou to see if that would obtain more hashes. I used the [Hob064](https://github.com/praetorian-inc/Hob0Rules/blob/master/hob064.rule) which **hugely** increased the time required to run through rockyou to 4 hours. I ran this for a few minutes and got a few hashes but ultimately abandoned the idea. In hindsight this was a terrible idea since rockyou contains modified versions of base passwords anyway.

I noticed hashcat was complaining about my (ancient) GPUs CUDA compatability of version 2.0, so I decided to switch over to Rosetta Hub. I spent some time looking into the GPU instances offered by AWS and determined that p3.x instances were the obvious choice as they contained Tesla V100s. Unfortunately, Rosetta Hub doesn't give us access to these instances, so I was stuck with g2/g3 instances which are designed for **graphic-intensive** applications. I began using a g2.8 which contains four NVIDIA GRID GPUs. I saw a speedup of ~3.5-4 times over running on my desktop at home which only really accounted for the extra GPUs the machine had.

After running some or all of rockyou against each of the hash types, I decided to examine the ~300 passwords I had cracked so far to see if there was any obvious patterns. I noticed that 5 letter lowercase and compound words (e.g. two concatenated english words) seemed to appear quite frequently and decided to go after those next.

As the compound words seemed to be english-like, I got an english dictionary wordlist and filtered it down to words of length 4. I then ran a combinator attack with both source lists pointing to this file, generating 8 character compound words. This was still quite a substantial wordlist to check but it performed quite well on the faster hash algorithms (DES, MD5).

For the five character lowercase passwords, I initially tried a brute force attack. Again this worked well enough for DES and MD5 but was not feasible for the slower hash algorithms.

At this point I had several hundred hashes based on the above process. We were then given clues for the sources of the three passwords. We determined that the three sources were Rockyou in it's entirety, the UNIX dictionary file for the 4 character words which yielded the 8 character compound words and the `pwgen` command. 

In order to attempt to solve the remaining hashes, rockyou needed to be run to completion on each of the hash algorithms. To achieve this in a somewhat reasonable time, I investigated all of the available compute instances and summarized the results in the following table: 

| Instance Type 	| GPUs          	| Rosetta Hub 	| kH/s  	| € / hour 	| kH/s / € 	|
|---------------	|---------------	|-------------	|-------	|----------	|----------	|
| p2.x          	| 1x K80        	| Y           	| 259   	| 0.3      	| 863      	|
| p3.2          	| 1x Tesla V100 	| N*          	| 2777  	| 0.75     	| 2805     	|
| p3.8          	| 4x Tesla V100 	| N           	| 11100 	| 2.61     	| 4253     	|
| g2.8          	| 4x GRID       	| Y           	| 282   	| 0.85     	| 332      	|
| g3.8          	| 2x Tela M60   	| Y           	| 1147  	| 0.72     	| 1593     	|

** _Note, at the time of writing it seems like Rosetta Hub fixed the bug where we couldn't get access p3.2 spot instances_.

As seen in the table, the p3.8 instance with 4 Tesla V100s were the optimum choice. Unfortunately, these were not available through Rosetta Hub. The best choice for password cracking on Rosetta Hub was the g3.8 which ~10x slower and was only ~2.8 times cheaper than the 4 Tesla V100s. As such, Google Cloud was used to gain access to 4x Tesla V100s.

Rockyou was run to completion on the 5 fastest hash algorithms - DES, MD5, SHA256, SHA512 and PBKDF2. However as Argon was designed to be _GPU resistant_, I attempted to crack these using several CPU optimized instances.

In order to crack the hashes generated using `pwgen`, I wrote a [function](https://github.com/stefano-lupo/password-cracking/blob/master/practical4/scripts/utils#L118-L129) which repeatedly generates lower case, pronouncable passwords of length 5. This wordlist of approximately 300000 passwords was then run through each of the hashes.

Finally in order to crack the final passwords, all of the 4 character words in the UNIX dictionary were extracted and used as both source lists for a combinator attack.


### Inferno Ball
The inferno ball practical turned out to be rather simple for all layers apart from the crackstation layer. Initially it looked like a lot of orchestration would be required as even the _"fast"_ algorithms were very slow due to the tweaked parameters (e.g. number of rounds). Some basic benchmarking was done on each of the tweaked hash algorithms in order to find the optimum cracking order of `pbkdf2`, `sha1`, `sha512`. Aron Hoffmann wrote some python scripts to handle checking the secrets and descending into inner layers. We also began writing some orchestration code. However by the time the code was taking shape, the easter eggs had been discovered and there was simply no point in spending any time trying to write orchestration code. Instead, Aron could simply run the relatively small wordlists on his GTX 1080 and we progressed through the first six layers very quickly.

Layer 7 proved to be a challenge and required some research into keyboard walks. I began generating wordlists using Hashcat's [kwprocessor](https://github.com/hashcat/kwprocessor). This was quite challenging as the algorithms were very slow and the keyboard walks could have been anything. Ultimately however I found a premade keyboard-walk wordlist online which got us through the layer.

The final challenging layer was the Crackstation layer. Crackstation is a massive wordlist and required a **collousal** amount of compute power. However as I was the only member of my team with a Google Cloud account, I solved the layer alone simply by running 4 Tesla V100s for several days and spending over €120 of my €260 free Google Cloud budget. I initially considered switching back to Rosetta Hub to burn through the teams remaining budgets, but after re-examining the performance table above, it became clear that this wasn't worth the time. As we had plenty of time remaining, I just opted to leave Google Cloud running for a few days.



## Module evaluation (1 page)
### What I Liked
I enjoyed most of the guest lecture content, especially the lectures surrounding GPUs and OpenCL. I also enjoyed Stephen's security lecture toward the end of the semester and it peaked my interest for the Security module next semester. 

The practicals were a great idea and have the potential to be great assignments! Understanding and building distributed, scalable systems is obviously extremelly important and having access to €100 worth of compute power has the potential for some really interesting projects. 

### What I Disliked
I understand that this is the first year of the module and that there was far more students taking this module than anticipated. However, in my opinion the module was very unsatisfactory.

I felt that the lecture content was extremelly lacking. I appreciate that different lectures have different styles of teaching, but in my opinion the lectures were very disorganized and unprepared. There was no source material and the lectures seemed to just be ramblings from one topic to another. 

Unfortunately the assignments ended up having absolutely nothing to do with scalability and absolutely everything to do with figuring out which password lists were used to generate the hashes. There was no benefit whatsoever in trying to build a system at all, nevermind a scalable one. 

The assesment was also very unclear until long after the assigments were completed, especially for the paper reviews. At the end of the day students have to balance their time across multiple modules and have to allocate their time based on the amount of credit on offer. 

Say what you liked/disliked about the module and why.
There's no need to say that RosettaHub is creaky, we
know that:-)




