# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/gigaset-isdn/gigaset-isdn-0.4.0.ebuild,v 1.2 2004/12/05 21:40:11 mrness Exp $

MY_P=${P/-isdn/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Kernel driver for Gigaset 307X/M105/M101 and compatible ISDN adapters."
HOMEPAGE="http://gigaset307x.sourceforge.net/"
LICENSE="GPL-2"
DEPEND="virtual/linux-sources"

SRC_URI="mirror://sourceforge/gigaset307x/${MY_P}.tar.bz2"
SLOT="0"
KEYWORDS="x86"
IUSE="debug"

src_compile() {
	cd "${S}"
	./configure --kernel=${KV} --root=${D} --prefix=/usr \
		--with-ring `use_with debug`

	(
		unset ARCH
		emake || die "Compilation failed"
	)
}

src_install () {
	cd "${S}"
	#Disable depmod while in sandbox
	sed -i -e 's:.*depmod :#&:' generic/post
	einstall ROOT=${D} || die "Failed to install drivers"

	dodoc README Release.notes TODO known_bugs.txt
}

pkg_postinst () {
	depmod -ae ${KV}
}
