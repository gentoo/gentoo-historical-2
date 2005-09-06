# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-medialibs/emul-linux-x86-medialibs-1.1-r1.ebuild,v 1.1 2005/09/06 22:11:26 herbs Exp $

DESCRIPTION="Media libraries for emulation of 32bit x86 on amd64"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

RDEPEND=">=app-emulation/emul-linux-x86-baselibs-2.0
	>=app-emulation/emul-linux-x86-soundlibs-2.0"

S=${WORKDIR}

src_install() {
	# Remove this to avoid confict with emul-soundlibs
	rm -f ${WORKDIR}/emul/linux/x86/usr/lib/libesd.so*

	cp -RPvf ${WORKDIR}/* ${D}/
}
