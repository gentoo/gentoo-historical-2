# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/afbinit/afbinit-1.0.1-r1.ebuild,v 1.6 2004/06/28 19:48:07 agriffis Exp $

inherit eutils

DESCRIPTION="loads the microcode for Elite3D framebuffers to use X"
HOMEPAGE="I dont have a home :("
SRC_URI="http://cvs.gentoo.org/~weeve/files/${P}.tar.bz2"
IUSE=""

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="-* sparc"

DEPEND="virtual/libc"

src_compile() {
	emake || die "make failed"
}

src_install() {
	dosbin afbinit
	dosbin rc.afb
	exeinto /etc/init.d ; newexe ${FILESDIR}/afbinit.init afbinit
}

pkg_postinst() {
	einfo "To use afbinit, you'll need the AFB microcode."
	einfo "This is available via a Solaris install at /usr/lib/afb.ucode"
	einfo "or via sun.com"
}
