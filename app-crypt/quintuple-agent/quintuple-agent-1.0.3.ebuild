# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/quintuple-agent/quintuple-agent-1.0.3.ebuild,v 1.6 2004/06/24 21:37:15 agriffis Exp $

DESCRIPTION="Quintuple Agent stores your (GnuPG) secrets in a secure manner."
HOMEPAGE="http://www.vibe.at/tools/secret-agent/"
SRC_URI="http://www.vibe.at/tools/secret-agent/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE="nls"

DEPEND="app-crypt/gnupg
	>=dev-libs/glib-1.2.0
	>=x11-libs/gtk+-1.2.0
	nls? ( sys-devel/gettext )"

src_compile() {
	econf `use_enable nls` || die
	emake || die
}

src_install() {
	einstall || die
	fperms +s /usr/bin/q-agent

	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO
	docinto doc
	dodoc doc/*.sgml
}

pkg_postinst() {
	einfo "q-agent is installed SUID root to make use of protected memory space"
	einfo "This is needed in order to have a secure place to store your passphrases,"
	einfo "etc. at runtime but may make some sysadmins nervous"
}
