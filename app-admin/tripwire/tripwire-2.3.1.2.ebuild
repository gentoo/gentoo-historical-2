# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/tripwire/tripwire-2.3.1.2.ebuild,v 1.4 2003/08/05 14:35:23 vapier Exp $

inherit eutils

TW_VER="2.3.1-2"
DESCRIPTION="Open Source File Integrity Checker and IDS"
HOMEPAGE="http://www.tripwire.org/"
SRC_URI="http://flow.dl.sourceforge.net/sourceforge/tripwire/tripwire-${TW_VER}.tar.gz
	http://non-us.debian.org/debian-non-US/pool/non-US/main/t/tripwire/tripwire_2.3.1.2-6.1.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 -alpha"
#NOTE:  im working on integrating debians portability fixes, alpha support (at least) 
#		will be working soon.

DEPEND="virtual/glibc
	dev-util/patchutils
	sys-devel/automake
	dev-libs/openssl"
RDEPEND="virtual/glibc
	virtual/cron
	virtual/mta
	dev-libs/openssl"

S=${WORKDIR}/tripwire-${TW_VER}

src_unpack() {
	# unpack tripwire source tarball
	unpack tripwire-${TW_VER}.tar.gz; cd ${S}

	# some patches ive collected/made for tripwire
	# mostly from mandrake, some from other sources
	epatch ${FILESDIR}/tripwire-2.3.0-50-rfc822.patch.bz2
	epatch ${FILESDIR}/tripwire-2.3.1-2-fhs.patch.bz2
	epatch ${FILESDIR}/tripwire-2.3.1-2-gcc-3.3.patch.bz2
	epatch ${FILESDIR}/tripwire-2.3.1-gcc3.patch.bz2
	epatch ${FILESDIR}/tripwire-jbj.patch.bz2
	epatch ${FILESDIR}/tripwire-mkstemp.patch.bz2
	
	# pull out the interesting debian patches
	filterdiff  -i '*/man/man8/twadmin.8' \
		-z  --strip=1	\
		${DISTDIR}/tripwire_2.3.1.2-6.1.diff.gz > ${T}/debian-patch.diff
	epatch ${T}/debian-patch.diff
	
	# cleanup ready for build
	rm -rf ${S}/src/STLport*
	touch ${S}/src/STLport_r ${S}/src/STLport_d
}				
	
src_compile() {
	cd ${S}/src
	emake release RPM_OPT_FLAGS="${CXXFLAGS}"
}

src_install() {
	dosbin ${S}/bin/*/siggen
	dosbin ${S}/bin/*/tripwire
	dosbin ${S}/bin/*/twadmin
	dosbin ${S}/bin/*/twprint

	for i in {4,5,8}
	do
		cd ${S}/man/man${i}
		doman *.$i
		cd ${S}
	done

	dodir /etc/tripwire
	dodir /var/lib/tripwire/report
	
	exeinto /etc/cron.daily
	doexe ${FILESDIR}/tripwire.cron
	
	dodoc README Release_Notes ChangeLog COPYING policy/policyguide.txt TRADEMARK \
	${FILESDIR}/tripwire.gif ${FILESDIR}/tripwire.txt

	insinto /etc/tripwire
	doins ${FILESDIR}/twcfg.txt ${FILESDIR}/twpol.txt 

	exeinto /etc/tripwire
	doexe ${FILESDIR}/twinstall.sh

	fperms 755 /etc/tripwire/twinstall.sh /etc/cron.daily/tripwire.cron
}

pkg_postinst() {
	einfo "After installing this package, you should run \"/etc/tripwire/twinstall.sh\""
	einfo "to generate cryptographic keys, and \"tripwire --init\" to initialize the"
	einfo "database Tripwire uses.  This must be done manually because the key used to"
	einfo "sign the database should be different for each system."
	einfo
	einfo "There is also a quickstart guide, included in the docs directory"
	einfo
}
