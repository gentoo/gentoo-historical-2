# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/elfsh/elfsh-0.51_beta3.ebuild,v 1.4 2006/01/27 00:01:10 solar Exp $

inherit eutils

MY_PV=${PV/_beta/b}
S=${WORKDIR}/${PN}-${MY_PV}
DESCRIPTION="scripting language to modify ELF binaries"
HOMEPAGE="http://elfsh.segfault.net/"
SRC_URI="mirror://gentoo/elfsh-${MY_PV}-portable.tgz"
#http://elfsh.segfault.net/files/elfsh-${MY_PV}-portable.tgz

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=dev-libs/expat-1.95"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-gentoo.patch
	sed -i \
		-e "s:-g3 -O2:${CFLAGS}:" \
		`find -name Makefile` \
		|| die
}

src_compile() {
	# emacs does not have to be a requirement.
	emake ETAGS=echo || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "einstall failed"
}
