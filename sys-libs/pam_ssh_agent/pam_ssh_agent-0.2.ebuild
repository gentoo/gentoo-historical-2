# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/pam_ssh_agent/pam_ssh_agent-0.2.ebuild,v 1.1 2004/03/02 06:15:17 vapier Exp $

inherit gcc

DESCRIPTION="PAM module that spawns a ssh-agent and adds identities using the password supplied at login"
HOMEPAGE="http://pam-ssh-agent.sourceforge.net/"
SRC_URI="mirror://sourceforge/pam-ssh-agent/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"

DEPEND="sys-libs/pam
	>=sys-apps/sed-4"
RDEPEND="net-misc/keychain
	dev-tcltk/expect"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i "s:gcc:$(gcc-getCC) ${CFLAGS}:" Makefile
}

src_compile() {
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc LICENSE README
}
