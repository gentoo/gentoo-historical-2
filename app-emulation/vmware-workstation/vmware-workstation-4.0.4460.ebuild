# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vmware-workstation/vmware-workstation-4.0.4460.ebuild,v 1.1 2003/04/10 15:16:46 prez Exp $

# Unlike many other binary packages the user doesn't need to agree to a licence
# to download VM Ware. The agreeing to a licence is part of the configure step
# which the user must run manually.

S=${WORKDIR}/vmware-distrib
NP="VMware-workstation-4.0.0-4460"
DESCRIPTION="Emulate a complete PC on your PC without the usual performance overhead of most emulators"
SRC_URI="http://vmware-svca.www.conxion.com/software/${NP}.tar.gz
	http://download.vmware.com/htdocs/software/${NP}.tar.gz
	http://www.vmware.com/download1/software/${NP}.tar.gz
	ftp://download1.vmware.com/pub/software/${NP}.tar.gz
	http://vmware-chil.www.conxion.com/software/${NP}.tar.gz
	http://vmware-heva.www.conxion.com/software/${NP}.tar.gz
	http://vmware.wespe.de/software/${NP}.tar.gz
	ftp://vmware.wespe.de/pub/software/${NP}.tar.gz"
HOMEPAGE="http://www.vmware.com/products/desktop/ws_features.html"

SLOT="0"
LICENSE="vmware"
KEYWORDS="~x86 -ppc -sparc"
IUSE="kde"

DEPEND="virtual/glibc
	virtual/x11
	sys-kernel/linux-headers
	>=dev-lang/perl-5
	>=dev-lang/tcl-8.3.3
	sys-apps/pciutils"

RDEPEND=${DEPEND}

RESTRICT="nostrip"

src_install() {
	# lets make gcc happy regardless of what version we're using
#	patch -p0 < ${FILESDIR}/${PVR}/vmware-config.pl-gcc-generalized.patch

	dodir /opt/vmware/bin
	cp -a bin/* ${D}/opt/vmware/bin/
	# vmware and vmware-ping needs to be suid root.
	chmod u+s ${D}/opt/vmware/bin/vmware || die
	chmod u+s ${D}/opt/vmware/bin/vmware-ping || die

	dodir /opt/vmware/lib
	cp -a lib/* ${D}/opt/vmware/lib/

	chmod u+s ${D}/opt/vmware/lib/bin/vmware-vmx || die

	# Since with Gentoo we compile everthing it doesn't make sense to keep
	# the precompiled modules arround. Saves about 4 megs of disk space too.
	rm -rf ${D}/opt/vmware/lib/modules/binary

	dodir /opt/vmware/doc
	cp -a doc/* ${D}/opt/vmware/doc/

	dodir /opt/vmware/man/
	cp -a man/* ${D}/opt/vmware/man/

	# vmware service loader
	exeinto /etc/init.d
	newexe ${FILESDIR}/${PVR}/vmware vmware || die

	# vmware enviroment
	insinto /etc/env.d
	doins ${FILESDIR}/${PVR}/90vmware || die

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
	cp -a installer/services.sh ${D}/etc/vmware/init.d/vmware || die

	# This is to fix a problem where if someone merges vmware and then
	# before configuring vmware they upgrade or re-merge the vmware
	# package which would rmdir the /etc/vmware/init.d/rc?.d directories.
	keepdir /etc/vmware/init.d/rc{0,1,2,3,4,5,6}.d

	# A simple icon I made
	dodir /opt/vmware/lib/icon
	insinto /opt/vmware/lib/icon
	doins ${FILESDIR}/${PVR}/vmware.png || die

	if [ "`use kde`" ] ; then
		dodir /usr/share/applnk/Applications
		insinto /usr/share/applnk/Applications
		doins "${FILESDIR}/${PVR}/VMwareWorkstation.desktop"
	fi


	dodir /usr/bin
	dosym /opt/vmware/bin/vmware /usr/bin/vmware

	# Questions:
	einfo "Adding answers to /etc/vmware/locations"
	locations="${D}/etc/vmware/locations"
	echo "answer BINDIR /opt/vmware/bin" >> ${locations}
	echo "answer LIBDIR /opt/vmware/lib" >> ${locations}
	echo "answer MANDIR /opt/vmware/man" >> ${locations}
	echo "answer DOCDIR /opt/vmware/doc" >> ${locations}
	echo "answer RUN_CONFIGURATOR no" >> ${locations}
	echo "answer INITDIR /etc/vmware/init.d" >> ${locations}
	echo "answer INITSCRIPTSDIR /etc/vmware/init.d" >> ${locations}
}

pkg_preinst() {
	# This must be done after the install to get the mtimes on each file
	# right. This perl snippet gets the /etc/vmware/locations file code:
	# perl -e "@a = stat('bin/vmware'); print \$a[9]"
	# The above perl line and the find line below output the same thing.
	# I would think the find line is faster to execute.
	# find /opt/vmware/bin/vmware -printf %T@

	#Note: it's a bit weird to use ${D} in a preinst script but it should work
	#(drobbins, 1 Feb 2002)

	einfo "Generating /etc/vmware/locations file."
	d=`echo ${D} | wc -c`
	for x in `find ${D}/opt/vmware ${D}/etc/vmware` ; do
		x="`echo ${x} | cut -c ${d}-`"
		if [ -d ${D}/${x} ] ; then
			echo "directory ${x}" >> ${D}/etc/vmware/locations
		else
			echo -n "file ${x}" >> ${D}/etc/vmware/locations
			if [ "${x}" == "/etc/vmware/locations" ] ; then
				echo "" >> ${D}/etc/vmware/locations
			elif [ "${x}" == "/etc/vmware/not_configured" ] ; then
				echo "" >> ${D}/etc/vmware/locations
			else
				echo -n " " >> ${D}/etc/vmware/locations
				#perl -e "@a = stat('${D}${x}'); print \$a[9]" >> ${D}/etc/vmware/locations
				find ${D}${x} -printf %T@ >> ${D}/etc/vmware/locations
				echo "" >> ${D}/etc/vmware/locations
			fi
		fi
	done
}

pkg_config() {
	# In case pkg_config() ends up being the defacto standard for
	# configuring packages (malverian <malverian@gentoo.org>)

	einfo "Running /opt/vmware/bin/vmware-config.pl"
	/opt/vmware/bin/vmware-config.pl
}

pkg_postinst() {
	# This is to fix the problem where the not_configured file doesn't get
	# removed when the configuration is run. This doesn't remove the file
	# It just tells the vmware-config.pl script it can delete it.
	einfo "Updating /etc/vmware/locations"
	for x in /etc/vmware/._cfg????_locations ; do
		if [ -f $x ] ; then
			cat $x >> /etc/vmware/locations
			rm $x
		fi
	done

	einfo
	einfo "You need to run /opt/vmware/bin/vmware-config.pl to complete the install."
	einfo
	einfo "For VMware Add-Ons just visit"
	einfo "http://www.vmware.com/download/downloadaddons.html"
	einfo
	einfo "After configuring, type 'vmware' to launch"
}

pkg_postrm() {
	einfo 
	einfo "To remove all traces of vmware you will need to remove the files"
	einfo "in /etc/vmware/, /etc/init.d/vmware, /lib/modules/*/misc/vm*.o,"
	einfo "and .vmware/ in each users home directory."
	einfo 
}
