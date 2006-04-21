# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_ssh_agent/pam_ssh_agent-0.2-r1.ebuild,v 1.3 2006/04/21 15:54:12 flameeyes Exp $

inherit toolchain-funcs flag-o-matic eutils pam

DESCRIPTION="PAM module that spawns a ssh-agent and adds identities using the password supplied at login"
HOMEPAGE="http://pam-ssh-agent.sourceforge.net/"
SRC_URI="mirror://sourceforge/pam-ssh-agent/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="net-misc/keychain
	virtual/pam"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-openpam.patch
	sed -i -e "s:gcc:$(tc-getCC) \${CFLAGS}:" Makefile
}

src_compile() {
	append-flags -fPIC

	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dopammod ${S}/pam_ssh_agent.so
	dodoc README
}
