# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/pine/pine-4.50-r4.ebuild,v 1.3 2002/12/09 04:33:14 manson Exp $

IUSE="ssl ldap"

S=${WORKDIR}/${PN}${PV}
DESCRIPTION="A tool for reading, sending and managing electronic messages."
SRC_URI="ftp://ftp.cac.washington.edu/${PN}/${PN}${PV}.tar.gz"
HOMEPAGE="http://www.washington.edu/pine/"

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.1
	>=sys-libs/pam-0.72
	ssl? ( dev-libs/openssl )
	ldap? ( net-nds/openldap )"

SLOT="0"
LICENSE="PICO"
KEYWORDS="x86 ppc sparc "


src_unpack() {
	unpack ${A}

	if [ "`use mbox`" ] ; then
		patch -d ${S} -p0 < ${FILESDIR}/imap-4.7c2-flock.patch
	else
		patch -d ${S} -p1 < ${FILESDIR}/pine-4.50-maildir.patch
		patch -d ${S} -p0 < ${FILESDIR}/imap-4.7c2-flock+maildir.patch
	fi

	# fix for Home and End keys
        patch -d ${S} -p1 < ${FILESDIR}/pine-4.21-fixhome.patch

        # flock() emulation
        cp ${FILESDIR}/flock.c ${S}/imap/src/osdep/unix

        # change /bin/passwd to /usr/bin/passwd
        patch -d ${S} -p1 < ${FILESDIR}/pine-4.21-passwd.patch

	if [ "`use ldap`" ] ; then
		# link to shared ldap libs instead of static
		patch -d ${S} -p1 < ${FILESDIR}/pine-4.30-ldap.patch
		mkdir ${S}/ldap
		ln -s /usr/lib ${S}/ldap/libraries
		ln -s /usr/include ${S}/ldap/include
	fi

	# small flock() related fix
        patch -d ${S} -p0 < ${FILESDIR}/pine-4.40-boguswarning.patch

        # segfix? not sure what this is for but it still applies
        patch -d ${S} -p1 < ${FILESDIR}/pine-4.31-segfix.patch

        # change lock files from 0666 to 0600
        patch -d ${S} -p0 < ${FILESDIR}/pine-4.40-lockfile-perm.patch

        # add missing needed time.h includes
        patch -d ${S} -p1 < ${FILESDIR}/imap-2000-time.patch

        # gets rid of a call to stripwhitespace()
        patch -d ${S} -p1 < ${FILESDIR}/pine-4.33-whitespace.patch

	if [ -n "$DEBUG" ]; then
		cd ${S}/pine
		cp makefile.lnx makefile.orig
		sed -e "s:-g -DDEBUG -DDEBUGJOURNAL:${CFLAGS} -g -DDEBUG -DDEBUGJOURNAL:" \
			< makefile.orig > makefile.lnx
		cd ${S}/pico
		cp makefile.lnx makefile.orig
		sed -e "s:-g -DDEBUG:${CFLAGS} -g -DDEBUG:" \
			< makefile.orig > makefile.lnx
	else
		cd ${S}/pine
		cp makefile.lnx makefile.orig
		sed -e "s:-g -DDEBUG -DDEBUGJOURNAL:${CFLAGS}:" \
			< makefile.orig > makefile.lnx
		cd ${S}/pico
		cp makefile.lnx makefile.orig
		sed -e "s:-g -DDEBUG:${CFLAGS}:" makefile.orig > makefile.lnx
	fi

}

src_compile() {                           
	BUILDOPTS=""
	if [ "`use ssl`" ] 
	then
		BUILDOPTS="${BUILDOPTS} SSLDIR=/usr SSLTYPE=unix SSLCERTS=/etc/ssl/certs"
		cd ${S}/imap/src/osdep/unix
		cp Makefile Makefile.orig
		sed \
			-e "s:\$(SSLDIR)/certs:/etc/ssl/certs:" \
			-e "s:\$(SSLCERTS):/etc/ssl/certs:" \
			-e "s:-I\$(SSLINCLUDE) ::" \
			< Makefile.orig > Makefile
		cd ${S}
	else
		BUILDOPTS="${BUILDOPTS} NOSSL"
	fi
	if [ "`use ldap`" ]
	then
		./contrib/ldap-setup lnp lnp
		BUILDOPTS="${BUILDOPTS} LDAPCFLAGS=-DENABLE_LDAP"
	else
		BUILDOPTS="${BUILDOPTS} NOLDAP"
	fi
		
	./build ${BUILDOPTS} lnp || die
}

src_install() {                               
	into /usr
	dobin bin/pine bin/pico bin/pilot bin/mtest bin/rpdump bin/rpload

	doman doc/pine.1 doc/pico.1 doc/pilot.1 doc/rpdump.1 doc/rpload.1

	insinto /etc
	doins doc/mime.types
	donewins doc/mailcap.unx mailcap

	dodoc CPYRIGHT README doc/brochure.txt doc/tech-notes.txt
	use mbox || dodoc README.maildir

	docinto imap
	dodoc imap/docs/*.txt imap/docs/CONFIG imap/docs/FAQ imap/docs/RELNOTES

	docinto imap/rfc
	dodoc imap/docs/rfc/*.txt

	docinto html/tech-notes
	dodoc doc/tech-notes/*.html
}

