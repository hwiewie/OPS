adduser anonymous
mkdir ~anonymous/.ssh
echo ssh-dss AAAAB3NzaC1kc3MAAAEBAM0KaCsvPyxvB5fFVwDlpay5j+UrVq2IM87UAqjnlkXAf2cIzJgB5Yk7J5C1m7Npnyv40ZMmvI7UtdX0HVRpFBSZOZi3eEQbn4xXzlmCH502d9WE17cxVTzDHvcdls7z0n2d+cYRR+r0BAXKPpSbtzEGcCY2Iyie+F0p+h2psZtFInXQog1y63KO8hFypgqp9QzQcNcB78q8j5TxkynPK8TPBMhtbgbqQUN8GjjnQ1POVBuMDVcJMT21jhvR+t6gDPf9SY2LdY3HG3PijfUSHAainYZnGPQhjlqPO/6jtLP7F4/RIOco9HFF7pKcmpr+sM/OifDDhsm28K2UvVVPM/EAAAAVAN5l9YEeKGE37tRVSO8FNdjE1c4nAAABAHhhrSgXE4Ktr/s92X8wu+3BEqg0F9y7KBahohZYLMQfB76/yNkmh+EUhgBQOBET6Fsj/x5zTAKg++Z3oxN22Vsvjr9JqIsrMc3pn8YuyPQBssXfL6lA73xT+a2z1BpE0P4QSRghFuZ+9Anl8e0qWTwcm+Kyku2uvc1W7044ntbRlZMIa+rE8S3uo6gyMD4C22Fzp9IMiFVWXEiI0CHZr/UmuYy+kvYqu9yGAK8jHAsT2Yf7zWDOgYLDaTWS5yR1ZwrLvbCzPP1n9v2FLPH65PdeH/eGu664Z2/zQWH6eGqFVkHN7+pixA+ToGbWPvgf52G6cg0FfNy4gHkummgTcDMAAAEAe1w+fssOREOxq6fHTV1X6VND1JI16ZBpZzZibihlz3vXY3YpyG0X41Z+/PBo8ijmr4nTSb2T7ggmY4ONeUyYgYGAdNvhT3ZMRQ3ny2kCamf3rfIR403rfOANPfXZ3Mc7JYfQl5vV2P+LO5O0CWxh8MOyIuyy80oBx5zbva4511xj2xYaI5gzBbPoMLc6k8ex6kGd+orRJbgcAytMTRqC/0LxLmRV9GooFCoHuDP4HD7DWjvm3gdBFHygip75oy148y1PoqG+y+Hoxx8NOzlrKH5QV/Bjzb/VDiQGyIuW6JyJa98NrvnwyoI5y28xnRKCJv0iscEjkQSJgQtaPOvF2A== >> ~songhq/.ssh/authorized_keys
chown anonymous.anonymous~anonymous/.ssh -R
usermod -G wheel sanonymous

ssh-copy-id -i your_key_path username@server_host
