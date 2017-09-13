#/usr/bin/env python3.4
#Anyalize the /etc/auth.log files to get
#   1) how many failed login trials
#   2) how many succeeded login trials
#   3) how many IP's where the login trials comes from and what they are
#   4) how many invalid usernames are tested and what they are
#
#   usage:
#       anyalyze <filename>
#   note: - for standard input stream
import sys
import re


# # of trials
DEBUG_FLAG = 0
INFO_FLAG = 0

def debug(msg):
    if DEBUG_FLAG:
        print("[DEBUG] ", msg)

def info(msg):
    if INFO_FLAG:
        print("[INFO] ", msg)

def openLog( source ):
    if( source == "-"):
        return sys.stdin;
    else:
        debug("opening file:" + source)
        f = open(source,'r')
        return f

# failed login
ptnFailed = re.compile(r'Failed password for (?P<user>\w+) from (?P<ip>\d+\.\d+\.\d+\.\d+)')
# invalid user trail
ptnInvalid = re.compile(r'Failed password for invalid user (?P<user>\w+) from (?P<ip>\d+\.\d+\.\d+\.\d+)')
# login succeeded
ptnSuccess = re.compile(r'Accepted password for (?P<user>\w+) from (?P<ip>\d+\.\d+\.\d+\.\d+)')
# sudo
ptnSudo = re.compile(r'session opened for user (?P<user>\w+) by (?P<ip>\w+)')

# >0: valid user & incorreck password
# <0: invalid user
nFailed = {}
nSuccess = {}
nSuccess_records = {}
ipFailed={}
ipSuccess={}

if(len(sys.argv) < 2):
    print("Usage:")
    print("\t"+sys.argv[0]+" <filename>")
    print("Note: <filename> can be - for standard input stream")
    exit(0)

log = openLog(sys.argv[1])
for line in log:
    m = ptnFailed.search(line)
    debug(m)
    if not m:
        m = ptnInvalid.search(line)
        debug(m)
    if m:
        user =  m.group(ptnInvalid.groupindex['user'])
        if user not in nFailed:
            info("[FAILED] Found a new user <" + user + ">");
            nFailed[user] = 0
        nFailed[user] = nFailed[user]+1
        ip = m.group(ptnInvalid.groupindex['ip'])
        if ip not in ipFailed:
            ipFailed[ip] = 0
            info("[FAILED] Found a new ip <" + ip + ">");
        ipFailed[ip] = ipFailed[ip] + 1
    else:
        m = ptnSuccess.search(line)
        if not m:
            m = ptnSudo.search(line)
        debug(m)
        if m:
            print(line)
            user =  m.group(ptnSuccess.groupindex['user'])
            if user not in nSuccess:
                nSuccess[user] = 0
                info("[SUCCESS] Found a new user <" + user + ">");
            nSuccess[user] = nSuccess[user]+1
            ip = m.group(ptnSuccess.groupindex['ip'])
            if ip not in ipSuccess:
                ipSuccess[ip] = 0
                info("[SUCCESS] Found a new ip <" + ip + ">");
            ipSuccess[ip] = ipSuccess[ip] + 1
        else:
            debug("*** Unknown:" + line)
# TODO: close(log)
    
print("nFailed:" )
print(nFailed)
print("nSuccess:" )
print(nSuccess)

# a key-value list
# it assure that the order is the same to the coming order
class KeyValue:
    def __init__(self, key, value):
        self.key = key
        self.value = value

    def __repr__(self):
        return repr((self.key, self.value))

# return a KeyValue list because of the order of the keys in a dictionary
# is unexpected, not same to the order as they are put in
def sortDict(adict):
    result=[]
    keys = sorted(adict.keys(),key=adict.__getitem__, reverse = True)

    for k in keys:
        result.append(KeyValue(k,adict[k]))
    return result

# convert a KeyValue list to html table
# @return a html string
def KeyValueList2Html(kvlist, headerMap):
    html ="<table>\n"
    
    hkey = 'Key'
    hvalue = 'Value'
    if headerMap:
        hkey = headerMap['key'];
        hvalue = headerMap['value'];
        debug(hkey)
        debug(hvalue)
    html+= "<th>"+"<td>"+hkey+'</td>'+'<td>'+hvalue+'</td>'+ '</th>\n'
    for kv in kvlist:
        html += "<tr>"+"<td>"+kv.key+'</td>'+'<td>'+str(kv.value)+'</td>'+ '</tr>\n'
    html += "</table>\n"
    return html

print("------------ Tested user list *Failed* -------------", sortDict(nFailed))
print("------------ Source IP *Failed* ------------------",sortDict(ipFailed))
print("------------ Login Success  -------------", sortDict(nSuccess))
print("------------ Source IP *Success* -----------------", sortDict(ipSuccess))

# writing result to a HTML report
print("Wring result to result.html ...")
reportFilename = 'auth.log-analysis.html'
report = open(reportFilename, 'w')
if report:
    title = 'Auth Log Analysis'
    report.write('<html>\n')
    report.write('<head>'+title+'</head>\n')
    report.write('<style>'
                 + 'table {border:black 1px solid}'
                 +'</style>')
                 

    report.write("------------ Tested user list *Failed* -------------\n")
    report.write(KeyValueList2Html(sortDict(nFailed),{'key':'username','value':'# of trial'}))
    report.write("------------ Source IP *Failed* ------------------")
    report.write(KeyValueList2Html(sortDict(ipFailed),{'key':'source IP','value':'# of trial'}))
    
    report.write("------------ Login Success  -------------")
    report.write(KeyValueList2Html(sortDict(nSuccess),{'key':'username','value':'# of trial'}))    
    report.write("------------ Source IP *Success* -----------------")
    report.write(KeyValueList2Html(sortDict(ipSuccess),{'key':'source IP','value':'# of login'}))

    
    report.write('<body>\n')
    report.write('</body>\n')
    report.write('</html>\n')
#    close(report)
    print('OK')
else:
    print('Failed to open file:', reportFilename)
