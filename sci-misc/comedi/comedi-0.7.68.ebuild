# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/comedi/comedi-0.7.68.ebuild,v 1.1 2004/12/27 21:40:39 ribosome Exp $

inherit kernel-mod eutils

DESCRIPTION="Comedi - COntrol and MEasurement Device Interface for Linux"
SRC_URI="ftp://ftp.comedi.org/pub/comedi/${P}.tar.gz"
HOMEPAGE="http://www.comedi.org"
KEYWORDS="x86"
IUSE=""
LICENSE="GPL-2"
SLOT="0"

src_compile()
{
	kernel-mod_getversion

	addpredict ${KERNEL_DIR}

	set_arch_to_kernel
	./configure --prefix=${D}/usr --libdir=${D}/lib --with-linuxdir=${KERNEL_DIR}
	emake
}

src_install()
{
	make install
	set_arch_to_portage
}
