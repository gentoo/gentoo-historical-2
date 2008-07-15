# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mailutils/mailutils-0.6-r3.ebuild,v 1.9 2008/07/15 03:26:05 dirtyepic Exp $

inherit eutils

DESCRIPTION="A useful collection of mail servers, clients, and filters."
HOMEPAGE="http://www.gnu.org/software/mailutils/mailutils.html"
SRC_URI="http://ftp.gnu.org/gnu/mailutils/${P}.tar.bz2"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"

KEYWORDS="alpha ~amd64 ~ppc ~sparc x86"
IUSE="mailwrapper nls pam mysql postgres gdbm test"
PROVIDE="virtual/mailx"

RDEPEND="!virtual/mailx
	!mail-client/nmh
	!mail-client/elm
	dev-scheme/guile
	gdbm? ( sys-libs/gdbm )
	mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-server )
	nls? ( sys-devel/gettext )
	virtual/mta"

DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )"

pkg_setup() {
	# Default to MySQL if USE="mysql postgres', bug #58162.
	if use mysql && use postgres; then
		echo
		ewarn "You have both 'mysql' and 'postgres' in your USE flags."
		ewarn "Portage will build this package with MySQL support."
		echo
		ewarn "If this is not what you want; please hit Control-C now;"
		ewarn "change you USE flags then emerge this package again."
		echo
		ewarn "Waiting 30 seconds before continuing..."
		ewarn "(Control-C to abort)..."
		epause 30
	fi
}
src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-mh-Makefile.in.patch
	epatch "${FILESDIR}"/${PN}-IDEF0954-IDEF0955.patch
	epatch "${FILESDIR}"/${PN}-IDEF0956.patch
	epatch "${FILESDIR}"/${PN}-IDEF0957.patch
	epatch "${FILESDIR}"/${PN}-getline.diff
	epatch "${FILESDIR}"/${PN}-SQLinjection.patch
	epatch "${FILESDIR}"/${P}-imap4d-format-string.patch
	epatch "${FILESDIR}"/${P}-imap4d-gcc4.0-ftbfs.patch
}

src_compile() {

	local myconf="--localstatedir=/var --sharedstatedir=/var --enable-mh-utils"

	# bug in autoconf logic treats both --with and --without as set,
	# so we cannot do use_with
	# use mysql && myconf="${myconf} --with-mysql"
	# use postgres && myconf="${myconf} --with-postgres"
	if use mysql && use postgres; then
		einfo "build with MySQL support."
		myconf="${myconf} --with-mysql"
	elif use mysql; then
		einfo "build with MySQL support."
		myconf="${myconf} --with-mysql"
	elif use postgres; then
		einfo "build with PotsgreSQL support."
		myconf="${myconf} --with-postgres"
	fi

	# do not disable-sendmail for postfix user w/o mailwrapper, bug #44249.
	has_postfix=$(best_version mail-mta/postfix)
	has_postfix=${has_postfix%-[0-9]*}
	has_postfix=${has_postfix##*\/}

	if [ "$has_postfix" == "postfix" ]; then
		einfo "postfix detected"
		einfo "enable-sendmail"
	else
		if ! use mailwrapper; then
			myconf="${myconf} --enable-sendmail"
		else
			myconf="${myconf} --disable-sendmail"
			einfo "disable-sendmail"
		fi
	fi

	myconf="${myconf} $(use_enable nls) $(use_enable pam) $(use_enable gdbm)"
	econf ${myconf} || die "configure failed"
	emake || die "compile failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	# mail.rc stolen from mailx, resolve bug #37302.
	insinto /etc
	doins "${FILESDIR}/mail.rc"
}
