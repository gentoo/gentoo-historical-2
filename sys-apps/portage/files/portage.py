#!/usr/bin/env python
#
# Gentoo Linux Dependency Checking Code
# Copyright 1998-2000 Daniel Robbins, Gentoo Technologies, Inc.
# Distributed under the GNU Public License
# Version 1.0 7/31/2000
#
# Version comparison: Functionality
#
# Exactly what version numbers and letters does this versioning code
# recognize, and which tags are considered later versions than others?
# Take a look at these version number examples:
#
# 4.5 >  4.0		(you knew this one!)
# 4.0 == 4		(probably knew this one too)
# 4.0.1 < 4.0.2
# 4.0.0.1 < 4.0.2
#
# Build (revision) Numbers:
#
# Build (or revision) numbers can be specified along with the last digit
# in a version string, for example:
#
# 4.5b			(Revision b of version 4.5, *not* 4.5 beta)
# 4.5c > 4.5b
# 1.2.3a > 1.2.3
# 9.8.0z > 9.8
# 9a.5b *ILLEGAL* --- Build numbers can only immediately follow the *last*
#                     digit in a version, so the "9a" is illegal
#
# Alpha, Beta, and Pre
#
# Functionality has been added to support alpha, beta and pre prefixes.
# They are specified by placing an underscore "_" immediately after the last
# digit, and then specifying "alpha","beta",or "pre".  They are always branched
# off the last digit in a version.  In addition, an optional build (revision) number
# can immediately follow an "alpha", "beta" or "pre"
#
# More examples:
#
# 4.5_pre6 > 4.5_beta6 > 4.5_alpha6      ( pre is closer to release than a beta )
# 4.5_pre < 4.5pre1 < 4.5pre2            ( without a build number, a "0 build" is assumed )
# 2.9_alpha > 2.8
# 3.4beta *ILLEGAL* (no "_" betweeen last digit and "beta")
# 3.4.beta *ILLEGAL* ("beta" must immediately follow a digit and a "_")
# 3.4_beta 		(Correct)
#
# The versioning functionality will provide adequate support for a variety of
# numbering schemes, and will allow them to interoperate together.  Of course,
# we cannot support every wacky versioning scheme.  Our versioning supports
# the vast majority of packages, however.

import string,os
from commands import *
import md5
from stat import *

# parsever:
# This function accepts an 'inter-period chunk' such as
# "3","4","3_beta5", or "2b" and returns an array of three
# integers. "3_beta5" returns [ 3, -2, 5 ]
# These values are used to determine which package is
# newer.

# master category list.  Any new categories should be added to this list to ensure that they all categories are read
# when we check the portage directory for available ebuilds.

categories=("app-admin", "app-arch", "app-cdr", "app-doc", "app-editors", "app-emulation", "app-games", "app-misc", 
			"app-office", "app-shells", "app-text", "dev-db", "dev-java", "dev-lang", "dev-libs", "dev-perl", 
			"dev-python", "dev-util", "gnome-apps", "gnome-base", "gnome-libs", 
			"gnome-office","kde-apps", "kde-base", "kde-libs", "media-gfx", "media-libs", "media-sound", "media-video", 
			"net-analyzer", "net-dialup", "net-fs", "net-ftp", "net-irc", "net-libs", "net-mail", "net-misc", "net-nds", 
			"net-print", "net-www", "packages", "sys-apps", "sys-devel", "sys-kernel", "sys-libs", "x11-base", "x11-libs", 
			"x11-terms", "x11-wm")

def isfifo(x):
	mymode=os.stat(x)[ST_MODE]
	return S_ISFIFO(mymode)

def movefile(src,dest):
    if os.path.exists(dest):
	os.unlink(dest)
    mystat=os.stat(src)
    mymode=mystat[ST_MODE]
    myperms=S_IMODE(mymode)
    if S_ISCHR(mymode):
	mydev=getstatusoutput("/bin/ls -l "+src)[1][34:42]
	mymajor=mydev[:3]
	myminor=mydev[4:]
	myout=getstatusoutput("/bin/mknod "+dest+" c "+mymajor+" "+myminor)
	#character device
    elif S_ISBLK(mymode):
	mydev=getstatusoutput("/bin/ls -l "+src)[1][34:42]
	mymajor=mydev[:3]
	myminor=mydev[4:]
	myout=getstatusoutput("/bin/mknod "+dest+" b "+mymajor+" "+myminor)
	#block device
    elif S_ISLNK(mymode):
	pointsto=os.readlink(src)
	os.symlink(pointsto,dest)
	#symbolic link
    elif S_ISREG(mymode):
	mybuffer=""
	myin=open(src,"r")
	myout=open(dest,"w")
	while (1):
        	#do 256K reads for enhanced performance
        	mybuffer=myin.read(262144)
        	if mybuffer=="":
            		break
		myout.write(mybuffer)
    	myin.close()
	myout.close()
 	#regular file
    elif S_ISFIFO(mymode): 
	os.mkfifo(dest)
	#fifo
    #set permissions/ownership
    os.chmod(dest,myperms)
    os.chown(dest,mystat[ST_UID],mystat[ST_GID])
    #unlink src
    return 1

def md5digest(x):
    hexmap=["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]
    m=md5.new()
    mydata=""
    myfile=open(x)
    while (1):
        #do 256K reads for enhanced performance
        mydata=myfile.read(262144)
        if mydata=="":
            break
        m.update(mydata)
    myfile.close()
    asciidigest=""
    for mydigit in m.digest():
        asciidigest=asciidigest+hexmap[((ord(mydigit) & 0xf0) >> 4)]+hexmap[(ord(mydigit) & 0xf)]
    return asciidigest

def getmtime(x):
	 return `os.lstat(x)[-2]`

def prepare_db(myroot,mycategory,mypackage):
    if not os.path.isdir(myroot+"var/db"):
	os.mkdir(myroot+"var/db",0755)
    if not os.path.isdir(myroot+"var/db/pkg"):
	os.mkdir(myroot+"var/db/pkg",0755)
    if not os.path.isdir(myroot+"var/db/pkg/"+mycategory):
	os.mkdir(myroot+"var/db/pkg/"+mycategory,0755)
    if not os.path.isdir(myroot+"var/db/pkg/"+mycategory+"/"+mypackage):
	os.mkdir(myroot+"var/db/pkg/"+mycategory+"/"+mypackage,0755)

def pathstrip(x,myroot,mystart):
    cpref=os.path.commonprefix([x,mystart])
    return [myroot+x[len(cpref)+1:],x[len(cpref):]]


def mergefiles(outfile,myroot,mystart):
	mycurpath=os.getcwd()
	myfiles=os.listdir(mycurpath)
	for x in myfiles:
		floc=pathstrip(os.path.normpath(mycurpath+"/"+x),myroot,mystart)
		if os.path.islink(x):
			myto=os.readlink(x)
			if os.path.exists(floc[0]):
				if os.path.isdir(floc[0]):
					print "!!!",floc[0],"->",myto
				else:
					os.unlink(floc[0])
			try:
				os.symlink(myto,floc[0])
				print "<<<",floc[0],"->",myto
				outfile.write("sym "+floc[1]+" -> "+myto+" "+getmtime(floc[0])+"\n")
			except:
				print "!!!",floc[0],"->",myto
		elif os.path.isdir(x):
			mystat=os.stat(x)
			if not os.path.exists(floc[0]):
				os.mkdir(floc[0])
				os.chmod(floc[0],mystat[0])
				os.chown(floc[0],mystat[4],mystat[5])
				print "<<<",floc[0]+"/"
			else:
				print "---",floc[0]+"/"
			#mtime doesn't mean much for directories -- we don't store it
			outfile.write("dir "+floc[1]+"\n")
			mywd=os.getcwd()
			os.chdir(x)
			mergefiles(outfile,myroot,mystart)
			os.chdir(mywd)
		elif os.path.isfile(x):
			mymd5=md5digest(mycurpath+"/"+x)
			if movefile(x,pathstrip(mycurpath,myroot,mystart)[0]+"/"+x):
				zing="<<<"
			else:
				zing="!!!"
	
			print zing+" "+floc[0]
			print "md5",mymd5
			outfile.write("obj "+floc[1]+" "+mymd5+" "+getmtime(floc[0])+"\n")
		elif isfifo(x):
			zing="!!!"
			if not os.path.exists(pathstrip(mycurpath,myroot,mystart)[0]+"/"+x):	
				if movefile(x,pathstrip(mycurpath,myroot,mystart)[0]+"/"+x):
					zing="<<<"
			elif isfifo(pathstrip(mycurpath,myroot,mystart)[0]+"/"+x):
				os.unlink(pathstrip(mycurpath,myroot,mystart)[0]+"/"+x)
				if movefile(x,pathstrip(mycurpath,myroot,mystart)[0]+"/"+x):
					zing="<<<"
			print zing+" "+floc[0]
			outfile.write("fif "+floc[1]+"\n")
		else:
			if movefile(x,pathstrip(mycurpath,myroot,mystart)[0]+"/"+x):
				zing="<<<"
			else:
				zing="!!!"
			print zing+" "+floc[0]
			outfile.write("dev "+floc[1]+"\n")

def merge(myroot,mycategory,mypackage,mystart):
	mystart=os.path.normpath(mystart)
	os.chdir(mystart)
	print 
	print ">>> Merging contents of",mystart,"to "+myroot
	print ">>> Logging merge to "+myroot+"var/db/pkg/"+mycategory+"/"+mypackage+"/CONTENTS"
	prepare_db(myroot,mycategory,mypackage)
	outfile=open(myroot+"var/db/pkg/"+mycategory+"/"+mypackage+"/CONTENTS","w")
	mergefiles(outfile,myroot,mystart)
	outfile.close()
	print
	print ">>>",mypackage,"merged."
	print

def getsetting(mykey,recdepth=0):
	"""perform bash-like basic variable expansion, recognizing ${foo} and $bar"""
	if recdepth>10:
		return ""
		#avoid infinite recursion
	global configdefaults, cdcached
	global configsettings, cscached
	if os.environ.has_key(mykey):
		mystring=os.environ[mykey]
	elif configsettings.has_key(mykey):
		mystring=configsettings[mykey]
	elif configdefaults.has_key(mykey):
		mystring=configdefaults[mykey]
	else:
		return ""
	if (len(mystring)==0):
		return ""
	if mystring[0]=="'":
		#single-quoted, no expansion
		return mystring[1:-1]
	newstring=""
	pos=0
	while (pos<len(mystring)):
		if mystring[pos]=='\\':
			if (pos+1)>=len(mystring):
				#we're at the end of the string
				return "" #error
			a=mystring[pos+1]
			pos=pos+2
			if a=='a':
				newstring=newstring+chr(007)
			elif a=='b':
				newstring=newstring+chr(010)
			elif a=='e':
				newstring=newstring+chr(033)
			elif a=='f':
				newstring=newstring+chr(012)
			elif a=='r':
				newstring=newstring+chr(015)
			elif a=='t':
				newstring=newstring+chr(011)
			elif a=='v':
				newstring=newstring+chr(013)
			elif a=="'":
				newstring=newstring+"'"
			else:
				newstring=newstring+mystring[pos-1:pos]
		elif mystring[pos]=="$":
			#variable expansion
			if (pos+1)>=len(mystring):
				#we're at the end of the string, error
				return ""
			if mystring[pos+1]=="{":
				newpos=pos+1
				while newpos<len(mystring) and mystring[newpos]!="}":
					newpos=newpos+1
				if newpos>=len(mystring):
					return "" # ending } not found
				varname=mystring[pos+2:newpos]
				if len(varname)==0:
					return "" #zero-length variable, error
				newstring=newstring+getsetting(varname,recdepth+1)
				pos=newpos+1
			else:
				newpos=pos+1
				while newpos<len(mystring) and (mystring[newpos] not in string.whitespace):
					newpos=newpos+1
				if newpos>=len(mystring):
					varname=mystring[pos+1:]
				else:
					varname=mystring[pos+1:newpos]
				pos=newpos
				if len(varname)==0:
					return "" #zero-length variable, error
				newstring=newstring+getsetting(varname,recdepth+1)
				#recurse
		else:
			newstring=newstring+mystring[pos]
			pos=pos+1
	return newstring
				
def getconfig(mycfg):
	myconfigfile=open(mycfg,"r")
	myconfiglines=myconfigfile.readlines()
	myconfigfile.close()
	myconfigdict={}
	for x in myconfiglines:
		#strip whitespace
		x=string.strip(x)
		#skip comment or blank line
		if (len(x)==0):
			continue
		if (x[0]=="#"):
			continue
		myparts=string.split(x,"=")
		if myparts<2:
			continue
			#invalid line, no equals sign
		mykey=string.strip(myparts[0])
		myvalue=string.strip(string.join(myparts[1:],"="))
		if myvalue[0]=='"':
			if myvalue[-1]=='"':
				myvalue=myvalue[1:-1]
			else:
				continue
				#no closing double-quote!
		elif myvalue[0]=="'":
			if myvalue[-1]=="'":
				pass
			else:
				continue
				#no closing single-quote!
		if len(myvalue)>0:
			myconfigdict[mykey]=myvalue
	return myconfigdict

def relparse(myver):
	number=0
	p1=0
	p2=0
	mynewver=string.split(myver,"_")
	if len(mynewver)==2:
		#alpha,beta or pre
		number=string.atof(mynewver[0])
		if "beta" == mynewver[1][:4]:
			p1=-3
			try:
				p2=string.atof(mynewver[1][4:])
			except:
				p2=0
		elif "alpha" == mynewver[1][:5]:
			p1=-4
			try:
				p2=string.atof(mynewver[1][5:])
			except:
				p2=0
		elif "pre" ==mynewver[1][:3]:
			p1=-2
			try:
				p2=string.atof(mynewver[1][3:])
			except:
				p2=0
		elif "rc" ==mynewver[1][:2]:
			p1=-1
			try:
				p2=string.atof(mynewver[1][2:])
			except:
				p2=0

		elif "p" ==mynewver[1][:1]:
			try:
				p1=string.atoi(mynewver[1][1:])
			except:
				p1=0
	else:
		#normal number or number with letter at end
		divider=len(myver)-1
		if myver[divider:] not in "1234567890":
			#letter at end
			p1=ord(myver[divider:])
			number=string.atof(myver[0:divider])
		else:
			number=string.atof(myver)		
	return [number,p1,p2]


def revverify(myrev):
	if len(myrev)==0:
		return 0
	if myrev[0]=="r":
		try:
			string.atoi(myrev[1:])
			return 1
		except: 
			pass
	return 0

#returns 1 if valid version string, else 0
# valid string in format: <v1>.<v2>...<vx>[a-z,_{alpha,beta,pre}[vy]]
# ververify doesn't do package rev.

def ververify(myval):
	global ERRVER
	ERRVER=""
	myval=string.split(myval,'.')
	for x in myval[1:]:
		x="."+x
	for x in myval[:-1]:
		try:
			foo=string.atof(x)
		except:
			ERRVER=x+" is not a valid version component."
			return 0
	try:
		string.atof(myval[-1])
		return 1
	except:
		pass
	if myval[-1][-1] in "abcdefghijklmnopqrstuvwxyz":
		try:
			string.atof(myval[-1][:-1])
			# if we got here, it's something like .02a
			return 1
		except:
			pass
	splits=string.split(myval[-1],"_")
	if len(splits)!=2:
		#not a valid _alpha, _beta, _pre or _p, so fail
		ERRVER="Too many or too few \"_\" characters."
		return 0
	try:
		string.atof(splits[0])
	except:
		#something like .asldfkj_alpha1 which is invalid :)
		ERRVER=splits[0]+" is not a valid number."
		return 0
	valid=["alpha","beta","p","rc","pre"]
	for x in valid:
		if splits[1][0:len(x)]==x:
			firpart=x
			secpart=splits[1][len(x):]
			ok=1
	if not ok:
		ERRVER='Did not find an "alpha", "beta", "pre" or "p" after trailing "_"'
		return 0
	if len(secpart)==0:
		if firpart=="p":
			#patchlevel requires an int
			ERRVER='"p" (patchlevel) requires a trailing integer (i.e. "p3")'
			return 0	
		else:
			#alpha, beta and pre don't require an int
			return 1
	try:
		string.atoi(secpart)
		return 1
		#the int after the "alpha", "beta" or "pre" was ok
	except:
		ERRVER=secpart+" is not a valid integer."
		return 0
		#invalid number!

def justname(mypkg):
	myparts=string.split(mypkg,'-')
	for x in myparts:
		if ververify(x):
			return 0
	return 1

#isinstalled will tell you if a package is installed.  Call as follows:
# isinstalled("sys-apps/foo") will tell you if a package called foo (any
# version) is installed.  isinstalled("sys-apps/foo-1.2") will tell you
# if foo-1.2 (any version) is installed.

def isinstalled(mycatpkg):
	mycatpkg=string.split(mycatpkg,"/")
	if not os.path.isdir("/var/db/pkg/"+mycatpkg[0]):
		return 0
	mypkgs=os.listdir("/var/db/pkg/"+mycatpkg[0])
	if justname(mycatpkg[1]):
		# only name specified
		for x in mypkgs:
			thispkgname=pkgsplit(x)[0]
			if mycatpkg[1]==thispkgname:
				return 1
	else:
		# name and version specified
		for x in mypkgs:
			if mycatpkg[1]==x:
				return 1
	return 0

# This function can be used as a package verification function, i.e.
# "pkgsplit("foo-1.2-1") will return None if foo-1.2-1 isn't a valid
# package (with version) name.  If it is a valid name, pkgsplit will
# return a list containing: [ pkgname, pkgversion(norev), pkgrev ].
# For foo-1.2-1, this list would be [ "foo", "1.2", "1" ].  For 
# Mesa-3.0, this list would be [ "Mesa", "3.0", "0" ].

def pkgsplit(mypkg):
	global ERRPKG
	ERRPKG=""
	myparts=string.split(mypkg,'-')
	if len(myparts)<2:
		ERRPKG="Not enough \"-\" characters."
		return None
	if revverify(myparts[-1]):
		if ververify(myparts[-2]):
			if len(myparts)==2:
				ERRPKG="Found rev and version, but no package name."
				return None
			else:
				for x in myparts[:-2]:
					if ververify(x):
						ERRPKG=x+" shouldn't look like a version part."
						return None
						#names can't have versiony looking parts
				return [string.join(myparts[:-2],"-"),myparts[-2],myparts[-1]]
		else:
			ERRPKG="Found revision but "+myparts[-2]+" does not appear to be a valid version."
			return None

	elif ververify(myparts[-1]):
		if len(myparts)==1:
			ERRPKG="Found version, but no package name."
			return None
		else:
			for x in myparts[:-1]:
				if ververify(x):
					ERRPKG=x+" shouldn't look like a version part."
					return None
			return [string.join(myparts[:-1],"-"),myparts[-1],"r0"]
	else:
		ERRPKG=myparts[-1]+" doesn't appear to be a version or rev string."
		return None

# vercmp:
# This takes two version strings and returns an integer to tell you whether
# the versions are the same, val1>val2 or val2>val1.

def vercmp(val1,val2):
	val1=string.split(val1,'-')
	if len(val1)==2:
		val1[0]=val1[0]+"."+val1[1]
	val1=string.split(val1[0],'.')
	#add back decimal point so that .03 does not become "3" !
	for x in val1[1:]:
		x="."+x
	val2=string.split(val2,'-')
	if len(val2)==2:
		val2[0]=val2[0]+"."+val2[1]
	val2=string.split(val2[0],'.')
	for x in val2[1:]:
		x="."+x
	if len(val2)<len(val1):
		for x in range(0,len(val1)-len(val2)):
			val2.append("0")
	elif len(val1)<len(val2):
		for x in range(0,len(val2)-len(val1)):
			val1.append("0")
	#The above code will extend version numbers out so they
	#have the same number of digits.
	myval1=[]
	for x in range(0,len(val1)):
		cmp1=relparse(val1[x])
		cmp2=relparse(val2[x])
		for y in range(0,3):
			myret=cmp1[y]-cmp2[y]
			if myret != 0:
				return myret
	return 0

def pkgcmp(pkg1,pkg2):
	mycmp=vercmp(pkg1[1],pkg2[1])
	if mycmp>0:
		return 1
	if mycmp<0:
		return -1
	r1=string.atoi(pkg1[2][1:])
	r2=string.atoi(pkg2[2][1:])
	if r1>r2:
		return 1
	if r2>r1:
		return -1
	return 0

def pkgsame(pkg1,pkg2):
	if (string.split(pkg1,'-')[0])==(string.split(pkg2,'-')[0]):
		return 1
	else:
		return 0

def pkg(myname):
        return string.split(myname,'-')[0]

def ver(myname):
        a=string.split(myname,'-')
        return myname[len(a[0])+1:]


configdefaults=getconfig("/etc/make.defaults")
configsettings=getconfig("/etc/make.conf")
