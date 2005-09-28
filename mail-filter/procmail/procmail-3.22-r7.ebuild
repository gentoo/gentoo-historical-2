# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/procmail/procmail-3.22-r7.ebuild,v 1.6 2005/09/28 18:55:01 metalgod Exp $

inherit eutils flag-o-matic

DESCRIPTION="Mail delivery agent/filter"
HOMEPAGE="http://www.procmail.org/"
SRC_URI="http://www.procmail.org/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ~ppc ppc64 s390 sparc x86"
IUSE="mbox selinux"
PROVIDE="virtual/mda"

DEPEND="virtual/libc virtual/mta"
RDEPEND="virtual/libc
	selinux? ( sec-policy/selinux-procmail )"

src_compile() {
	# -finline-functions (implied by -O3) leaves strstr() in an infinite loop.
	# To work around this, we append -fno-inline-functions to CFLAGS
	append-flags -fno-inline-functions

	sed -e "s:CFLAGS0 = -O:CFLAGS0 = ${CFLAGS}:" \
		-e "s:LOCKINGTEST=__defaults__:#LOCKINGTEST=__defaults__:" \
		-e "s:#LOCKINGTEST=/tmp:LOCKINGTEST=/tmp:" \
		-i Makefile

	if ! use mbox ; then
		echo "# Use maildir-style mailbox in user's home directory" > ${S}/procmailrc
		echo 'DEFAULT=$HOME/.maildir/' >> ${S}/procmailrc
		cd ${S}
		epatch ${FILESDIR}/gentoo-maildir2.diff
	else
		echo '# Use mbox-style mailbox in /var/spool/mail' > ${S}/procmailrc
		echo 'DEFAULT=/var/spool/mail/$LOGNAME' >> ${S}/procmailrc
	fi

	# Do not use lazy bindings on lockfile and procmail
	epatch "${FILESDIR}/${PN}-lazy-bindings.diff"

	# Fix for bug #102340
	epatch "${FILESDIR}/${PN}-comsat-segfault.diff"

	emake || die
}

src_install () {
	cd ${S}/new
	insinto /usr/bin
	insopts -m 6755
	doins procmail

	insopts -m 2755
	doins lockfile

	dobin formail mailstat
	insopts -m 0644

	doman *.1 *.5

	cd ${S}
	dodoc Artistic COPYING FAQ FEATURES HISTORY INSTALL KNOWN_BUGS README

	insinto /etc
	doins procmailrc

	docinto examples
	dodoc examples/*
}
