
DNS-Stalker
========

ALPHA CODE!!! Ya'll be warned... it is rough..
Forked from dnstwist. creates a scheduler to watch domain registries for changes
and alerts the admins



cred to elceef for building dnstwist




See what sort of trouble users can get in trying to type your domain name.
Find similar-looking domains that adversaries can use to attack you. Can detect
typosquatters, phishing attacks, fraud and corporate espionage. Useful as an
additional source of targeted threat intelligence.

![Demo](/docs/dnstwist_demo.gif)

The idea is quite straightforward: `dnstwist` takes in your domain name as a
seed, generates a list of potential phishing domains and then checks to see if
they are registered.
Additionally it can test if the mail server from MX record can be used to
intercept misdirected corporate e-mails and it can generate fuzzy hashes of the
web pages to see if they are live phishing sites.


Key features
------------

- A wide range of efficient domain fuzzing algorithms
- Unicode domain names (IDN)
- Multithreaded job distribution
- Queries A, AAAA, NS and MX records
- Evaluates web page similarity with fuzzy hashes to find live phishing sites
- Tests if MX host (mail server) can be used to intercept misdirected e-mails
- Additional domain variants using dictionary files
- GeoIP location information
- Grabs HTTP and SMTP service banners
- WHOIS lookups for creation and modification date
- Output in CSV and JSON format


Requirements (Needs Updating)
------------

**Ubuntu 16.04.06**

DNS-Stalker
Built on Ubuntu 18.04.06 Desktop
1. sudo apt update
2. sudo apt upgrade
3. sudo apt install mailutils
4. sudo apt install git
5. sudo apt install vim (optional, but we know VIM is the best)
6.  cd /home/user/Downloads
7. git clone https://github.com/elceef/dnstwist
8. cd /home/user/Downloads/dnstwist/
9. vim comparer.sh
File 1 -- location
File 2 -- Location
mail  -t <to sender>
mail -a From:Admin
inspection of outfile.txt
10. vim scheduler.sh
line 15,17,19,20
11. create master.txt
(cd "/home/ossec/Downloads/dnstwist/" && ./dnstwist.py --registered $URL > master.txt)

<#Linux is the primary development platform. If running Debian/Ubuntu, you can
install all dependencies with just single command:

```
$ sudo apt-get install python3-dnspython python3-geoip python3-whois \
python3-requests python3-ssdeep
```

Alternately, you can use Python tooling. This can be done within a virtual
environment to avoid conflicts with other installations. However, you will
still need a couple of libraries installed at the system level.

```
$ sudo apt-get install libgeoip-dev libffi-dev
$ BUILD_LIB=1 pip install -r requirements.txt
```
#>

How to use (Needs Updating)
----------

To start, it's a good idea to enter only the domain name as an argument. The
tool will run it through its fuzzing algorithms and generate a list of
potential phishing domains with the following DNS records: A, AAAA, NS and MX.

```
$ dnstwist.py domain.name
```

The tool generates hundreds and thousands of domain names - especially for
longer ones. In such cases, it may be practical to display only registered
(resolvable) ones using `--registered` argument. The bad guys usually do the
opposite ;)

```
$ dnstwist.py --registered domain.name
```

Manually checking each domain name in terms of serving a phishing site might be
time consuming. To address this, `dnstwist` makes use of so called fuzzy hashes
(context triggered piecewise hashes). Fuzzy hashing is a concept which involves
the ability to compare two inputs (in this case HTML code) and determine a
fundamental level of similarity. This unique feature of `dnstwist` can be
enabled with `--ssdeep` argument. For each generated domain, `dnstwist` will
fetch content from responding HTTP server (following possible redirects) and
compare its fuzzy hash with the one for the original (initial) domain. The
level of similarity will be expressed as a percentage.

Please keep in mind it's rather unlikely to get 100% match for a dynamically
generated web page. However each notification should be inspected carefully
regardless of the score.

```
$ dnstwist.py --ssdeep domain.name
```

In some cases phishing sites are served from a specific URL. If you provide a
full or partial URL address as an argument, `dnstwist` will parse it and apply
for each generated domain name variant. This ability is obviously useful only
in conjunction with the fuzzy hashing feature.

```
$ dnstwist.py --ssdeep https://domain.name/owa/
$ dnstwist.py --ssdeep domain.name/crm/login
```

Very often attackers set up e-mail honey pots on phishing domains and wait for
mistyped e-mails to arrive. In this scenario, attackers would configure their
server to vacuum up all e-mail addressed to that domain, regardless of the user
it was sent towards. Another `dnstwist` feature allows to perform a simple test
on each mail server (advertised through DNS MX record) in order to check which
one can be used for such hostile intent. Suspicious servers will be marked with
*SPYING-MX* string.

Please be aware of possible false positives. Some mail servers only pretend to
accept incorrectly addressed e-mails but then discard those messages. This
technique is used to prevent "directory harvesting attack".

```
$ dnstwist.py --mxcheck domain.name
```

Not always domain names generated by the fuzzing algorithms are sufficient. To
generate even more domain name variants please feed `dnstwist` with a
dictionary file. Some dictionary samples with a list of the most common words
used in targeted phishing campaigns are included. Feel free to adapt it to your
needs.

```
$ dnstwist.py --dictionary dictionaries/english.dict domain.name
``` 

If you need to check whether domains with different TLDs exist, you can use the 
'--tld' option. You'll need to supply the TLDs list in a text file. A sample file
is provided ('./dictionaries/common_tlds.dict'). Feel free to adapt it to your
needs.

```
$ dnstwist.py --tld dictionaries/common_tlds.dict example.com
``` 

Apart from the default nice and colorful text terminal output, the tool
provides two well known and easy to parse output formats: CSV and JSON. Use it
for convenient data interchange.

```
$ dnstwist.py --format csv domain.name > out.csv
$ dnstwist.py --format json domain.name > out.json
```

In case you want to chain `dnstwist` with other tools and you need only domain
variants without performing any DNS lookups, you can use `--format idle`:

```
$ dnstwist.py --format idle domain.name | tr '\n' ','
```

The tool is shipped with built-in GeoIP database. Use `--geoip` argument to
display geographical location (country name) of IPv4 address.

```
$ dnstwist.py --geoip domain.name
```

Of course all of the features offered by `dnstwist` together with brief
descriptions are always available at your fingertips:

```
$ dnstwist.py --help
```

Good luck!


Scanning top-level domains (TLD)
-------------------------------

This utility is shipped with simple shell script `tools/full_tld_scan.sh` which
allows to run `dnstwist` against the top-level domains (TLD). Optionally it can
scan only the country code top-level domains (ccTLD) or the generic top-level
domains (gTLD). For each TLD a distinct CSV file will be created in the current
directory. Note that due to the large number of existing TLD this process is
time consuming.

```
$ ./full_tld_scan.sh domain cctld
```

Coverage
--------

Along with the length of the domain, the number of variants generated by the
algorithms increases considerably and therefore the number of DNS queries
needed to verify them. For example, to check all variants for google.com, you
would have to send over 300k queries. For the domain facebook.com the number
increases to over 5 million. How easy it is to guess it takes a lot of
resources and most importantly even more time. For longer domains checking all
is simply not feasible.
For this reason, this tool generates and checks domains very close to the
original one. Theoretically, these are the most attractive domains from the
attacker's point of view. However, be aware that the imagination of the
aggressors is unlimited.


Contact
-------
[vdalabs.com]

To send questions, comments or a chocolate, just drop an e-mail at
[mwilds@vdalabs.com](mailto:mwilds@vdalabs.com)

You can also reach the author via:

- Twitter: [@mattwilds](https://twitter.com/mattwilds)
- LinkedIn: [Matthew Wilds](https://www.linkedin.com/in/matthew-wilds-41085a8b/)

Any feedback is appreciated. If you were able to run the tool and you are happy
with the results just let me know. If you have found some confirmed phishing
domains with this tool and are comfortable with sharing them, also please send
me a message. Thank you.
