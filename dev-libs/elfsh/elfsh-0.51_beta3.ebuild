# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/elfsh/elfsh-0.51_beta3.ebuild,v 1.6 2004/07/02 04:39:57 eradicator Exp $

inherit eutils

MY_PV=${PV/_beta/b}
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="interactive and scriptable ELF machine to play with executable files, shared libraries and relocatable ELF32 objects"
HOMEPAGE="http://devhell.org/projects/elfsh"
SRC_URI="http://elfsh.segfault.net/files/elfsh-${MY_PV}-portable.tgz
	http://devhell.org/projects/elfsh/files/elfsh-${MY_PV}-portable.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/libc
	>=dev-libs/expat-1.95
	>=sys-devel/gettext-0.11"

src_unpack() {
	unpack ${A}
	cd ${S}
	#[ -f ${FILESDIR}/${PN}-${MY_PV}.diff ] &&
	#	epatch ${FILESDIR}/${PN}-${MY_PV}.diff
	epatch ${FILESDIR}/${PN}-0.51b2.diff
}

src_compile() {
	# emacs does not have to be a requirement.
	emake ETAGS=echo || die "emake failed"
}

src_install() {
	dodir /usr/share/elfsh
	einstall DESTDIR=${D} || die "einstall failed"
}
