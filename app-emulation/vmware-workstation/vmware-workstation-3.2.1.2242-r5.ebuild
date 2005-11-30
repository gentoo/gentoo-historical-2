# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vmware-workstation/vmware-workstation-3.2.1.2242-r5.ebuild,v 1.1 2005/11/09 16:49:32 wolf31o2 Exp $

# Unlike many other binary packages the user doesn't need to agree to a licence
# to download VM Ware.  The agreeing to a licence is part of the configure step
# which the user must run manually.

inherit toolchain-funcs eutils

S=${WORKDIR}/vmware-distrib
ANY_ANY="vmware-any-any-update94"
NP="VMware-workstation-3.2.1-2242"
DESCRIPTION="Emulate a complete PC on your PC without the usual performance overhead of most emulators"
HOMEPAGE="http://www.vmware.com/products/desktop/ws_features.html"
SRC_URI="http://vmware-svca.www.conxion.com/software/${NP}.tar.gz
	http://www.vmware.com/download1/software/${NP}.tar.gz
	ftp://download1.vmware.com/pub/software/${NP}.tar.gz
	http://vmware-chil.www.conxion.com/software/${NP}.tar.gz
	http://vmware-heva.www.conxion.com/software/${NP}.tar.gz
	http://vmware.wespe.de/software/${NP}.tar.gz
	ftp://vmware.wespe.de/pub/software/${NP}.tar.gz
	http://ftp.cvut.cz/vmware/${ANY_ANY}.tar.gz
	http://ftp.cvut.cz/vmware/obsolete/${ANY_ANY}.tar.gz
	http://knihovny.cvut.cz/ftp/pub/vmware/${ANY_ANY}.tar.gz
	http://knihovny.cvut.cz/ftp/pub/vmware/obselete/${ANY_ANY}.tar.gz
	mirror://gentoo/vmware.png"

LICENSE="vmware"
SLOT="0"
KEYWORDS="-* x86"
IUSE=""
RESTRICT="nostrip"

DEPEND=">=dev-lang/perl-5
	virtual/os-headers"

RDEPEND="sys-libs/glibc
	virtual/x11
	media-libs/gdk-pixbuf"

dir=/opt/vmware/workstation
Ddir=${D}/${dir}
VMWARE_GROUP=${VMWARE_GROUP:-vmware}

pkg_setup() {
	# This is due to both bugs #104480 and #106170
	enewgroup "${VMWARE_GROUP}"
}

src_unpack() {
	check_KV
	unpack ${NP}.tar.gz
	if [ "${KV:0:3}" == "2.6" ] || [ "${KV:0:3}" == "2.5" ] ; then
		unpack ${ANY_ANY}.tar.gz
		mv -f ${ANY_ANY}/*.tar ${S}/lib/modules/source/
	fi
}

src_compile() {
	has_version '<sys-libs/glibc-2.3.2' \
		&& GLIBC_232=0 \
		|| GLIBC_232=1

	if [ ${GLIBC_232} -eq 1 ] ; then
		$(tc-getCC) -W -Wall -shared -o vmware-glibc-2.3.2-compat.so \
			${FILESDIR}/${PV}/vmware-glibc-2.3.2-compat.c \
			|| die "could not make module"
	else
		return 0
	fi
}

src_install() {
	# lets make gcc happy regardless of what version we're using
	epatch ${FILESDIR}/${PV}/vmware-config.pl-gcc-generalized.patch

	dodir ${dir}/bin
	cp -pPR bin/* ${Ddir}/bin

	dodir ${Ddir}/lib
	cp -pPR lib/* ${Ddir}/lib
	# Since with Gentoo we compile everthing it doesn't make sense to keep
	# the precompiled modules arround. Saves about 4 megs of disk space too.
	rm -rf ${Ddir}/lib/modules/binary
	# We also remove libgdk_pixbuf stuff, to resolve bug #81344.
	rm -rf ${Ddir}/lib/lib/libgdk_pixbuf.so.2
	# We set vmware-vmx and vmware-ping suid
	chmod u+s ${Ddir}/bin/vmware-ping
	chmod u+s ${Ddir}/lib/bin/vmware-vmx

	dodoc doc/* || die "dodoc"
	# Fix for bug #91191
	dodir ${dir}/doc
	insinto ${dir}/doc
	doins doc/EULA || die "copying EULA"

	doman ${S}/man/man1/vmware.1.gz || die "doman"

	# vmware service loader
	newinitd ${FILESDIR}/${PV}/vmware vmware || die "newinitd"

	# vmware enviroment
	doenvd ${FILESDIR}/${PV}/90vmware || die "doenvd"

	dodir /etc/vmware/
	cp -pPR etc/* ${D}/etc/vmware/

	dodir /etc/vmware/init.d
	dodir /etc/vmware/init.d/rc0.d
	dodir /etc/vmware/init.d/rc1.d
	dodir /etc/vmware/init.d/rc2.d
	dodir /etc/vmware/init.d/rc3.d
	dodir /etc/vmware/init.d/rc4.d
	dodir /etc/vmware/init.d/rc5.d
	dodir /etc/vmware/init.d/rc6.d
	cp -pPR installer/services.sh ${D}/etc/vmware/init.d/vmware
	dosed 's/mknod -m 600/mknod -m 660/' /etc/vmware/init.d/vmware || die
	dosed '/c 119 "$vHubNr"/ a\
		chown root:vmware /dev/vmnet*\
		' /etc/vmware/init.d/vmware || die

	# This is to fix a problem where if someone merges vmware and then
	# before configuring vmware they upgrade or re-merge the vmware
	# package which would rmdir the /etc/vmware/init.d/rc?.d directories.
	keepdir /etc/vmware/init.d/rc{0,1,2,3,4,5,6}.d

	# A simple icon I made
	insinto ${dir}/lib/icon
	doins ${DISTDIR}/vmware.png || die
	doicon ${DISTDIR}/vmware.png || die

	make_desktop_entry vmware "VMWare Workstation" vmware.png

	# this removes the user/group warnings
	chown -R root:0 ${D} || die

	# this makes the vmware-vmx executable only executable by vmware group
	fowners root:vmware ${dir}/lib/bin{,-debug}/vmware-vmx || die
	fperms 4750 ${dir}/lib/bin{,-debug}/vmware-vmx || die

	# this adds udev rules for vmmon*
	dodir /etc/udev/rules.d
	echo 'KERNEL=="vmmon*", GROUP="vmware" MODE=660' > \
		${D}/etc/udev/rules.d/60-vmware.rules || die

	# Questions:
	einfo "Adding answers to /etc/vmware/locations"
	locations="${D}/etc/vmware/locations"
	echo "answer BINDIR ${dir}/bin" >> ${locations}
	echo "answer LIBDIR ${dir}/lib" >> ${locations}
	echo "answer MANDIR ${dir}/man" >> ${locations}
	echo "answer DOCDIR ${dir}/doc" >> ${locations}
	echo "answer RUN_CONFIGURATOR no" >> ${locations}
	echo "answer INITDIR /etc/vmware/init.d" >> ${locations}
	echo "answer INITSCRIPTSDIR /etc/vmware/init.d" >> ${locations}

	if [ ${GLIBC_232} -eq 1 ] ; then
		dolib.so vmware-glibc-2.3.2-compat.so
		cd ${Ddir}/lib/bin
		mv vmware-ui{,.bin}
		mv vmware-mks{,.bin}
		echo '#!/bin/sh' > vmware-ui
		echo 'LD_PRELOAD=vmware-glibc-2.3.2-compat.so exec "$0.bin" "$@"' >> vmware-ui
		chmod a+x vmware-ui
		cp vmware-{ui,mks}
	else
		return 0
	fi
}

pkg_preinst() {
	# This must be done after the install to get the mtimes on each file
	# right. This perl snippet gets the /etc/vmware/locations file code:
	# perl -e "@a = stat('bin/vmware'); print \$a[9]"
	# The above perl line and the find line below output the same thing.
	# I would think the find line is faster to execute.
	# find /opt/vmware/workstation/bin/vmware -printf %T@

	#Note: it's a bit weird to use ${D} in a preinst script but it should work
	#(drobbins, 1 Feb 2002)

	einfo "Generating /etc/vmware/locations file."
	d=`echo ${D} | wc -c`
	for x in `find ${Ddir} ${D}/etc/vmware` ; do
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
	einfo "You need to run ${dir}/bin/vmware-config.pl to complete the install."
	einfo
	einfo "For VMware Add-Ons just visit"
	einfo "http://www.vmware.com/download/downloadaddons.html"
	einfo
	einfo "Also note that when you reboot you should run:"
	einfo "/etc/init.d/vmware start"
	einfo "before trying to run vmware.  Or you could just add"
	einfo "it to the default run level:"
	einfo "rc-update add vmware default"
	echo
	ewarn "Remember, in order to run vmware, you have to"
	ewarn "be in the '${VMWARE_GROUP}' group."
	echo
	ewarn "VMWare allows for the potential of overwriting files as root.  Only"
	ewarn "give VMWare access to trusted individuals."
}

pkg_postrm() {
	einfo
	einfo "To remove all traces of vmware you will need to remove the files"
	einfo "in /etc/vmware/, /etc/init.d/vmware, /lib/modules/*/misc/vm*.o,"
	einfo "and .vmware/ in each users home directory. Don't forget to rmmod the"
	einfo "vm* modules, either."
	einfo
}
