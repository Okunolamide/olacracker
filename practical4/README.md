# Practical 4

### First Session (~2/3 Hours)
- Ran barebones and default john against the hashes on local machine in background while doing some research
- Brute force crack got 0 after like 30 mins (obviously), restarted with rockyou.txt
- John / rockyou got nowhere.. Started with noodling with hashcat on my GPU at home
- Hashcat does NOT like just dumping a file at it without knowing the hash algorithm
- Sorted the list of hashes so I could get a better sense of what hashes we had
  - I noticed the shortest had only 13 characters
  - Looked up hashcats [list of example hashes](https://hashcat.net/wiki/doku.php?id=example_hashes) and noticed it looked a lot like old school UNIX DES
  - Grabbed all of the 13 char length hashes with `awk 'length($0) == 13 { print} ' lupos.hashes > DES.hashes`
  - Ran hashcat against that specifying DES and using a dictionary attack with ROCKYOU.TXT
  - `hashcat -m 1500 -a 0 DES.hashes ../dictionaries/rockyou.txt`
  - This immediately started finding hashes 
  - There was a total of 349 unique hashes to find
  - Finished but only found like 80
  - A handy reformat `awk -F ":" '{print $1, $2}' ~/software/hashcat-4.2.1/hashcat.potfile > des.broken`
  - Submitted (the potfile) but submitty didnt like _some_ of my hashes, so I ran again 
    - Theres still some that submitty doesnt like - I wonder are these collisions or are some of these 13 char ones just not DES?
  - I still missed a bunch of them with rockyou, so I tried adding a rulefile called [hob064](https://github.com/praetorian-inc/Hob0Rules). This gave DES an ETA of 4 hours :z
  - I reduced the number of rules to the first ~30 which brought it down to like 2 hours
    - This found 6 more within a few minutes so probably worth running


- Next I looked at all the `$1$` which is indicative of md5crypt usually
  - I dumped all the 34 length hashes into a file and ran hashcat with the same dictionary file 
  - hashcat gave me a warning saying that the kernel i was using was unoptimized
    - This allows for cracking of passwords of up to 256 chars in length
    - I ran it in optimized mode which supports passwords from 0 to 15 chars long
    - `hashcat -a 0 -m 500 -O md5crypt.hashes ../dictionaries/rockyou.txt`
    - This had an eta of 4 hours on my GPU at home.. eek
    - This could be a sneaky salt of $1$ and some other alg..
    - We got one!!!
    - Going to run this for 4 hours and see how we go.

- Next I noticed all the `$5$` which is apparently indicative of sha256
  - I grabbed all of those using `awk '/\$5\$/' lupos.hashes`
  - I detatched from the md5crypt terminal using TMUX, I was onyl using 200MB (out of 1GB) of GPU memory at this point
  - ~This is probably not the limiting metric (just cause I have the memory I probably shouldn't parallelizer thge algorithms), but this was still experimental so I just ran them together~
    - Yeah you cant do that..
  - Again using rockyou.txt `hashcat -a 0 -m 7400 -O sha256.hashes ../dictionaries/rockyou.txt`
  - This is apparently going to take 3 days with rockyou... lol
  - Got one after like 15 minutes..
  - Going to try a smaller dictionary: phpbb.txt
    - This should only take 1 hour to run..


- Next I notcied all the `$6$` which is apparently sha512 --> eeeeeeek

- `$argon2i$v=19$m=102400,t=2,p=8$07oXIkRISck5B6D0vtdayw$MInXABfJH6m/LabKeUO/4w`
  - These are argon2 hashes with some parameter info??


### 2nd Session
- I notcied that Hashcat was complaining that my GPU was realtively ancient so I'm going to try run stuff on AWS to see what the projected ETAs will be
- Yeah this is considerably faster: 1h 9 mins for DES with full hob064 ruleset..
- Still getting warning that the hardware has outdated CUDA compute capatability 
  - This GPU has 3.0 but my GPU and 2.0 --> target is 5.0
	- Also seeing: Device 5 not a native open cl runtime and to expect massive speed loss - this probably isnty a GPU
- SHA256 with rockyou is looking like 1 day. This is better than 3 days with my GPU but still not great
- OVerall performance seems around 3 times better on this GPU
- Trying md5cript hashes: 
  - ETA of 37 minutes (vs 4 hours on my GPU) using the optimized one (passwords of up to 15 chars)
	- Cracking fairly well --> definitely worth running


Pretty sure I lost a bunch of notes but oh well..
Looking at pasword distributions..
- 5 char all lowercase alphabet seems to be a common password
- Going to also try 4 to 9 length numerics only..
```john --pot=practical4.potfile --incremental=4_9_numbers --format=descrypt-opencl hashes/DES.hashes```
``` john --pot=practical4.potfile --incremental=8_char_numbers --format=sha256crypt_opencl --fork=4 --devices=0,1,2,3 --session=sha_8_digits hashes/SHA256.hashes```