# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/pine/pine-4.58-r2.ebuild,v 1.5 2004/06/30 06:58:58 merlin Exp $

inherit eutils

DESCRIPTION="A tool for reading, sending and managing electronic messages."
SRC_URI="ftp://ftp.cac.washington.edu/pine/${PN}${PV}.tar.bz2
	mirror://gentoo/${P}-chappa-all-20030915.patch.gz"
HOMEPAGE="http://www.washington.edu/pine/
	http://www.math.washington.edu/~chappa/pine/patches/"

LICENSE="PICO"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
IUSE="ssl ldap passfile"

DEPEND="virtual/glibc
	>=sys-apps/sed-4
	>=sys-libs/ncurses-5.1
	>=sys-libs/pam-0.72
	ssl? ( dev-libs/openssl )
	ldap? ( net-nds/openldap )
	!mail-client/pine-maildir"

S="${WORKDIR}/${PN}${PV}"

src_unpack() {
	unpack ${A} && cd "${S}"

	epatch "${WORKDIR}/${P}-chappa-all-20030915.patch"
	epatch "${FILESDIR}/pine-4.21-fixhome.patch"
	epatch "${FILESDIR}/imap-4.7c2-flock.patch"
	cp "${FILESDIR}/flock.c" "${S}/imap/src/osdep/unix"

	if use ldap ; then
		# link to shared ldap libs instead of static
		epatch "${FILESDIR}/pine-4.30-ldap.patch"
		mkdir "${S}/ldap"
		ln -s /usr/lib "${S}/ldap/libraries"
		ln -s /usr/include "${S}/ldap/include"
	fi

	if use passfile ; then
		epatch "${FILESDIR}/pine-4.56-passfile.patch"
	fi

	epatch "${FILESDIR}/pine-4.31-segfix.patch"
	epatch "${FILESDIR}/pine-4.40-lockfile-perm.patch"
	epatch "${FILESDIR}/imap-2000-time.patch"
	epatch "${FILESDIR}/pine-4.33-whitespace.patch"
	# bug #23336 - makes pine transparent in terms that support it
	epatch "${FILESDIR}/transparency.patch"

	if use debug ; then
		sed -e "s:-g -DDEBUG -DDEBUGJOURNAL:${CFLAGS} -g -DDEBUG -DDEBUGJOURNAL:" \
			-i "${S}/pine/makefile.lnx" || die "sed pine/makefile.lnx failed"
		sed -e "s:-g -DDEBUG:${CFLAGS} -g -DDEBUG:" \
			-i "${S}/pico/makefile.lnx" || die "sed pico/makefile.lnx failed"
	else
		sed -e "s:-g -DDEBUG -DDEBUGJOURNAL:${CFLAGS}:" \
			-i "${S}/pine/makefile.lnx" || die "sed pine/makefile.lnx failed"
		sed -e "s:-g -DDEBUG:${CFLAGS}:" \
			-i "${S}/pico/makefile.lnx" || die "sed pico/makefile.lnx failed"
	fi

	sed -e "s:/usr/local/lib/pine.conf:/etc/pine.conf:" \
		-i "${S}/pine/osdep/os-lnx.h" || die "sed os-lnx.h failed"
}

src_compile() {
	local BUILDOPTS

	if use ssl ; then
		BUILDOPTS="${BUILDOPTS} SSLDIR=/usr SSLTYPE=unix SSLCERTS=/etc/ssl/certs"
		sed -e "s:\$(SSLDIR)/certs:/etc/ssl/certs:" \
			-e "s:\$(SSLCERTS):/etc/ssl/certs:" \
			-e "s:-I\$(SSLINCLUDE) ::" \
			-i "${S}/imap/src/osdep/unix/Makefile" || die "sed Makefile failed"
	else
		BUILDOPTS="${BUILDOPTS} NOSSL"
	fi

	if use ldap ; then
		./contrib/ldap-setup lnp lnp
		BUILDOPTS="${BUILDOPTS} LDAPCFLAGS=-DENABLE_LDAP"
	else
		BUILDOPTS="${BUILDOPTS} NOLDAP"
	fi

	./build ${BUILDOPTS} lnp || die "compile problem"
}

src_install() {
	exeinto /usr/bin
	doexe bin/pine bin/pico bin/pilot bin/mtest bin/rpdump bin/rpload

	insinto /etc
	doins doc/mime.types

	# Only mailbase should install /etc/mailcap
#	donewins doc/mailcap.unx mailcap

	doman doc/pine.1 doc/pico.1 doc/pilot.1 doc/rpdump.1 doc/rpload.1
	dodoc CPYRIGHT README doc/brochure.txt doc/tech-notes.txt

	docinto imap
	dodoc imap/docs/*.txt imap/docs/CONFIG imap/docs/RELNOTES

	docinto imap/rfc
	dodoc imap/docs/rfc/*.txt

	docinto html/tech-notes
	dohtml -r doc/tech-notes/
}
