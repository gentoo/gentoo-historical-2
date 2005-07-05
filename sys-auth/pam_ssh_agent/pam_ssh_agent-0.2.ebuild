# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_ssh_agent/pam_ssh_agent-0.2.ebuild,v 1.2 2005/07/05 19:46:54 azarah Exp $

inherit toolchain-funcs flag-o-matic multilib

DESCRIPTION="PAM module that spawns a ssh-agent and adds identities using the password supplied at login"
HOMEPAGE="http://pam-ssh-agent.sourceforge.net/"
SRC_URI="mirror://sourceforge/pam-ssh-agent/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="net-misc/keychain
	sys-libs/pam
	dev-tcltk/expect"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s:gcc:$(tc-getCC) \${CFLAGS}:" Makefile
	sed -i -e "s:/lib/:/$(get_libdir)/:" Makefile
}

src_compile() {
	append-flags -fPIC

	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc README
}
