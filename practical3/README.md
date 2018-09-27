# Practical 3

## What I Did
- Began reading [this article on password cracking](https://labs.mwrinfosecurity.com/blog/a-practical-guide-to-cracking-password-hashes/#fn6) and did some messing around
- Found a much longer dictionary list called rockyou.txt
- Began cracking passwords using rockyou.txt
- Cracked ~150 passwords in like 30 minutes of compute time
- Set up John the Ripper on my home desktop which has a GPU
- Read [this article](https://blog.sleeplessbeastie.eu/2015/11/02/how-to-crack-password-using-nvidia-gpu/) on how to configure john with a GPU
- Began cracking with my gpu MD5 OpenCL
- GPU Cracked it really fast
