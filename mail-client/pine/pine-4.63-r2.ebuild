# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/pine/pine-4.63-r2.ebuild,v 1.5 2005/08/01 20:51:53 ferdy Exp $

inherit eutils

# Using this ugly hack, since we're making our own versioned copies of chappa 
# patch, as upstream doesn't version them. (see #59573) 
CHAPPA_PF="${P}-r2"

DESCRIPTION="A tool for reading, sending and managing electronic messages."
HOMEPAGE="http://www.washington.edu/pine/
	http://www.math.washington.edu/~chappa/pine/patches/"
SRC_URI="ftp://ftp.cac.washington.edu/pine/${P/-/}.tar.bz2
	mirror://gentoo/${CHAPPA_PF}-chappa-all.patch.gz"
#	ipv6? (
#		http://www.ngn.euro6ix.org/IPv6/${PN}/${P}-v6-20031001.diff
#		http://www.ngn.euro6ix.org/IPv6/${PN}/readme.${P}-v6-20031001
#	)"

LICENSE="PICO"
SLOT="0"
KEYWORDS="alpha amd64 ~ia64 ppc ~ppc-macos sparc x86"
IUSE="ssl ldap kerberos largeterminal pam passfile debug"

DEPEND="virtual/libc
	>=sys-apps/sed-4
	>=sys-libs/ncurses-5.1
	pam? ( >=sys-libs/pam-0.72 )
	ssl? ( dev-libs/openssl )
	ldap? ( net-nds/openldap )
	kerberos? ( app-crypt/mit-krb5 )"
RDEPEND="${DEPEND} app-misc/mime-types"

S="${WORKDIR}/${P/-/}"

maildir_warn() {
	einfo
	einfo "This build of Pine has Maildir support built in as"
	einfo "part of the chappa-all patch."
	einfo
	einfo "If you have a maildir at ~/Maildir it will be your"
	einfo "default INBOX. The path may be changed with the"
	einfo "\"maildir-location\" setting in Pine."
	einfo
	einfo "To use /var/spool/mail INBOX again, set"
	einfo "\"disable-these-drivers=md\" in your .pinerc file."
	einfo
	einfo "Alternately, you might want to read following webpage, which explains, how to"
	einfo "use multiple mailboxes simultaneously:"
	echo
	echo "http://www.math.washington.edu/~chappa/pine/pine-info/collections/incoming-folders/"
	echo
}

pkg_setup() {
	maildir_warn
}

src_unpack() {
	unpack ${A} && cd "${S}"

	epatch "${FILESDIR}/pine-4.62-spooldir-permissions.patch" || die

	# Various fixes and features.
	epatch "${WORKDIR}/${CHAPPA_PF}-chappa-all.patch" || die
	# Fix flock() emulation.
	cp "${FILESDIR}/flock.c" "${S}/imap/src/osdep/unix" || die
	# Build the flock() emulation.
	epatch "${FILESDIR}/imap-4.7c2-flock_4.60.patch" || die
	if use ldap ; then
		# Link to shared ldap libs instead of static.
		epatch "${FILESDIR}/pine-4.30-ldap.patch" || die
		mkdir "${S}/ldap"
		ln -s /usr/lib "${S}/ldap/libraries"
		ln -s /usr/include "${S}/ldap/include"
	fi
#	if use ipv6 ; then
#		epatch "${DISTDIR}/${P}-v6-20031001.diff" || die
#	fi
	if use passfile ; then
		#Is this really the correct place to define it?
		epatch "${FILESDIR}/pine-4.56-passfile.patch" || die
	fi
	if use largeterminal ; then
		# Add support for large terminals by doubling the size of pine's internal display buffer
		epatch "${FILESDIR}/pine-4.61-largeterminal.patch" || die
	fi

	# Something from RedHat.
	epatch "${FILESDIR}/pine-4.31-segfix.patch" || die
	# Create lockfiles with a mode of 0600 instead of 0666.
	epatch "${FILESDIR}/pine-4.40-lockfile-perm.patch" || die
	# Add missing time.h includes.
	epatch "${FILESDIR}/imap-2000-time.patch" || die
	# Bug #23336 - makes pine transparent in terms that support it.
	epatch "${FILESDIR}/transparency.patch" || die

	# Bug #72861 - relaxes subject length for base64-encoded subjects
	epatch "${FILESDIR}/pine-4.61-subjectlength.patch" || die

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
	local myconf
	if use ssl ; then
		myconf="${myconf} SSLDIR=/usr SSLTYPE=unix SSLCERTS=/etc/ssl/certs"
		sed -e "s:\$(SSLDIR)/certs:/etc/ssl/certs:" \
			-e "s:\$(SSLCERTS):/etc/ssl/certs:" \
			-e "s:-I\$(SSLINCLUDE) ::" \
			-i "${S}/imap/src/osdep/unix/Makefile" || die "sed Makefile failed"
	else
		myconf="${myconf} NOSSL"
	fi
	if use ldap ; then
		./contrib/ldap-setup lnp lnp
		myconf="${myconf} LDAPCFLAGS=-DENABLE_LDAP"
	else
		myconf="${myconf} NOLDAP"
	fi
	if use kerberos ; then
		myconf="${myconf} EXTRAAUTHENTICATORS=gss"
	fi

	if use ppc-macos; then
		target=osx
	else
		if use pam ; then
			target=lnp
		else
			target=slx
		fi
	fi

	./build ${myconf} ${target} || die "compile problem"
}

src_install() {
	dobin bin/pine bin/pico bin/pilot bin/mtest bin/rpdump bin/rpload \
	      mailutil/mailutil

	# Only mailbase should install /etc/mailcap
#	donewins doc/mailcap.unx mailcap

	doman doc/pine.1 doc/pico.1 doc/pilot.1 doc/rpdump.1 doc/rpload.1 \
	      imap/src/mailutil/mailutil.1
	dodoc CPYRIGHT README doc/brochure.txt doc/tech-notes.txt
#	if use ipv6 ; then
#		dodoc "${DISTDIR}/readme.${P}-v6-20031001"
#	fi

	docinto imap
	dodoc imap/docs/*.txt imap/docs/CONFIG imap/docs/RELNOTES

	docinto imap/rfc
	dodoc imap/docs/rfc/*.txt

	docinto html/tech-notes
	dohtml -r doc/tech-notes/
}

pkg_postinst() {
	maildir_warn
}
