# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/cyrus-imap-admin/cyrus-imap-admin-2.2.3.ebuild,v 1.1 2004/01/20 18:19:59 max Exp $

inherit perl-module eutils

DESCRIPTION="Utilities and Perl modules to administer a Cyrus IMAP server."
HOMEPAGE="http://asg.web.cmu.edu/cyrus/imapd/"
SRC_URI="ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/cyrus-imapd-${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="ssl kerberos"

DEPEND="virtual/glibc
	sys-devel/libtool
	sys-devel/autoconf
	sys-devel/automake
	>=sys-apps/sed-4
	>=sys-libs/db-3.2
	>=dev-lang/perl-5.6.1
	>=dev-libs/cyrus-sasl-2.1.13
	dev-perl/Term-ReadLine-Perl
	dev-perl/TermReadKey
	ssl? ( >=dev-libs/openssl-0.9.6 )
	kerberos? ( virtual/krb5 )"

S="${WORKDIR}/cyrus-imapd-${PV}"

src_unpack() {
	unpack ${A} && cd "${S}"

	# DB4 detection and versioned symbols.
	epatch "${FILESDIR}/cyrus-imapd-${PV}-db4.patch"

	# Recreate configure.
	export WANT_AUTOCONF="2.5"
	ebegin "Recreating configure"
	rm -f configure config.h.in
	sh SMakefile &>/dev/null || die "SMakefile failed"
	eend $?

	# When linking with rpm, you need to link with more libraries.
	sed -e "s:lrpm:lrpm -lrpmio -lrpmdb:" -i configure || die "sed failed"
}

src_compile() {
	local myconf
	myconf="${myconf} `use_with ssl openssl`"
	myconf="${myconf} `use_with kerberos gssapi`"

	econf \
		--disable-server \
		--enable-murder \
		--enable-listext \
		--enable-netscapehack \
		--with-cyrus-group=mail \
		--with-com_err=yes \
		--with-auth=unix  \
		--with-perl=/usr/bin/perl \
		--enable-cyradm \
		${myconf}

	emake -C "${S}/lib" all || die "compile problem"
	emake -C "${S}/perl" all || die "compile problem"
}

src_install () {
	make -C "${S}/perl" DESTDIR="${D}" install || die "install problem"
}
