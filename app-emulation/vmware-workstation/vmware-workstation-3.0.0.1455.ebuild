# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vmware-workstation/vmware-workstation-3.0.0.1455.ebuild,v 1.3 2002/07/11 06:30:13 drobbins Exp $

DESCRIPTION="Emulate a complete PC on your PC without the usual performance overhead of most emulators."
S=${WORKDIR}/vmware-distrib
NP="VMwareWorkstation-3.0.0-1455"

# Unlike many other binary packages the user doesn't need to agree to a licence
# to download VM Ware. The agreeing to a licence is part of the configure step
# which the user must run manually.
SRC_PATH0="http://vmware-svca.www.conxion.com/software"
SRC_PATH1="http://www.vmware.com/download1/software"
SRC_PATH2="ftp://download1.vmware.com/pub/software"
SRC_PATH3="http://vmware-chil.www.conxion.com/software"
SRC_PATH4="http://vmware-heva.www.conxion.com/software"
SRC_PATH5="http://vmware.wespe.de/software"
SRC_PATH6="ftp://vmware.wespe.de/pub/software"

SRC_URI="$SRC_PATH0/${NP}.tar.gz
	 $SRC_PATH1/${NP}.tar.gz
	 $SRC_PATH2/${NP}.tar.gz
	 $SRC_PATH3/${NP}.tar.gz
	 $SRC_PATH4/${NP}.tar.gz
	 $SRC_PATH5/${NP}.tar.gz
	 $SRC_PATH6/${NP}.tar.gz"

HOMEPAGE="http://www.vmware.com/products/desktop/ws_features.html"
DEPEND="virtual/glibc virtual/x11 sys-kernel/linux-headers >=sys-devel/perl-5"
#debug is needed to prevent a segfault from stripping vmware executables
export DEBUG="yes"

src_install () {
	# Copy:
	dodir /opt/vmware/bin
	cp -a bin/* ${D}/opt/vmware/bin/
	# vmware and vmware-ping needs to be suid root.
	chmod u+s ${D}/opt/vmware/bin/vmware
	chmod u+s ${D}/opt/vmware/bin/vmware-ping

	dodir /opt/vmware/lib
	cp -a lib/* ${D}/opt/vmware/lib/
	# Since with Gentoo we compile everthing it doesn't make sense to keep
	# the precompiled modules arround. Saves about 4 megs of disk space too.
	rm -r ${D}/opt/vmware/lib/modules/binary

	dodir /opt/vmware/doc
	cp -a doc/* ${D}/opt/vmware/doc/

	dodir /opt/vmware/man/
	cp -a man/* ${D}/opt/vmware/man/

	# vmware service loader
	exeinto /etc/init.d
	newexe ${FILESDIR}/${PVR}/vmware vmware

	# vmware enviroment
	insinto /etc/env.d
	doins ${FILESDIR}/${PVR}/90vmware

	dodir /etc/vmware/
	cp -a etc/* ${D}/etc/vmware/

	dodir /etc/vmware/init.d
	dodir /etc/vmware/init.d/rc0.d
	dodir /etc/vmware/init.d/rc1.d
	dodir /etc/vmware/init.d/rc2.d
	dodir /etc/vmware/init.d/rc3.d
	dodir /etc/vmware/init.d/rc4.d
	dodir /etc/vmware/init.d/rc5.d
	dodir /etc/vmware/init.d/rc6.d
	cp -a installer/services.sh ${D}/etc/vmware/init.d/vmware

	# Questions: 
	einfo "Adding answers to /etc/vmware/locations"
	echo "answer BINDIR /opt/vmware/bin" >> ${D}/etc/vmware/locations
	echo "answer LIBDIR /opt/vmware/lib" >> ${D}/etc/vmware/locations
	echo "answer MANDIR /opt/vmware/man" >> ${D}/etc/vmware/locations
	echo "answer DOCDIR /opt/vmware/doc" >> ${D}/etc/vmware/locations
	echo "answer RUN_CONFIGURATOR no" >> ${D}/etc/vmware/locations
	echo "answer INITDIR /etc/vmware/init.d" >> ${D}/etc/vmware/locations
	echo "answer INITSCRIPTSDIR /etc/vmware/init.d" >> ${D}/etc/vmware/locations
}

pkg_preinst () {
	# This must be done after the install to get the mtimes on each file
	# right. This perl snippet gets the /etc/vmware/locations file code:
	# perl -e "@a = stat('bin/vmware'); print \$a[9]"

	#Note: it's a bit weird to use ${D} in a preinst script but it should work
	#(drobbins, 1 Feb 2002)

	einfo "Generating /etc/vmware/locations file."
	d=`echo ${D} | wc -c`
	for x in `find ${D}/opt/vmware ${D}/etc/vmware`
	do
		x="`echo ${x} | cut -c ${d}-`"
		if [ -d ${D}/${x} ]
		then
			echo "directory ${x}" >> ${D}/etc/vmware/locations
		else
			echo -n "file ${x}" >> ${D}/etc/vmware/locations
			if [ "${x}" == "/etc/vmware/locations" ]
			then
				echo "" >> ${D}/etc/vmware/locations
			else
				echo -n " " >> ${D}/etc/vmware/locations
				perl -e "@a = stat('${D}${x}'); print \$a[9]" >> ${D}/etc/vmware/locations
				echo "" >> ${D}/etc/vmware/locations
			fi
		fi
	done
}

pkg_postinst () {
	einfo "Activating vmware init scripts..."
	rc-update add vmware default
	einfo
	einfo "You need to run /opt/vmware/bin/vmware-config.pl to complete the install."
	einfo
}

pkg_postrm () {
	einfo 
	einfo "To remove all traces of vmware you will need to remove the files"
	einfo "in /etc/vmware/, /etc/init.d/vmware, /lib/modules/*/misc/vm*.o,"
	einfo "and .vmware/ in each users home directory."
	einfo 
}
