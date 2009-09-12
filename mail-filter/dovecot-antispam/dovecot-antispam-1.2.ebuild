# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/dovecot-antispam/dovecot-antispam-1.2.ebuild,v 1.1 2009/09/12 13:10:28 patrick Exp $

EAPI="1"

inherit confutils

DESCRIPTION="A dovecot antispam plugin supporting multiple backends"
HOMEPAGE="http://johannes.sipsolutions.net/Projects/dovecot-antispam"
SRC_URI="http://johannes.sipsolutions.net/download/dovecot-antispam/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +dspam crm114 mailtrain signature-log syslog"

DEPEND="net-mail/dovecot
	dspam? ( mail-filter/dspam )
	crm114? ( app-text/crm114 )"
RDEPEND="${DEPEND}"

# we need this to prevent errors from dovecot-config
top_builddir() {
	return
}

pkg_setup() {
	confutils_require_one dspam signature-log mailtrain crm114
	confutils_use_depend_all syslog debug
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# make it compile with dovecot 1.2
	epatch "${FILESDIR}"/dovecot-antispam-dovecot1.2-compilefix.patch
}

src_compile() {
	source "${ROOT}"/usr/lib/dovecot/dovecot-config || \
		die "cannot find dovecot-config"

	echo DOVECOT=${dovecot_incdir} > .config
	echo INSTALLDIR=${moduledir}/imap/ >> .config
	echo PLUGINNAME=antispam >> .config
	echo USER=root >> .config
	echo GROUP=root >> .config

	use dspam && echo BACKEND=dspam-exec >> .config
	use signature-log && echo BACKEND=signature-log >> .config
	use mailtrain && echo BACKEND=mailtrain >> .config
	use crm114 && echo BACKEND=crm114-exec >> .config

	if use debug; then
		if use syslog; then
			echo DEBUG=syslog >> .config
		else
			echo DEBUG=stderr >> .config
		fi
	fi

	emake || die "make failed"
}

src_install() {
	source "${ROOT}"/usr/lib/dovecot/dovecot-config || \
		die "cannot find dovecot-config"

	dodir "${moduledir}"/imap/
	make DESTDIR="${D}" install || die "make install failed"

	newman antispam.7 dovecot-antispam.7
	dodoc NOTES README
}
