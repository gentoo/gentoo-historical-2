# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/noarp/noarp-1.2.3.ebuild,v 1.1 2003/11/04 03:04:07 vapier Exp $

DESCRIPTION="a kernel module and userspace tool for hiding network interfaces"
HOMEPAGE="http://www.masarlabs.com/noarp/"
SRC_URI="http://www.masarlabs.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=""

pkg_setup() {
	if [ "${KV:0:3}" != "2.4" ] ; then
		die "Sorry but this only works with 2.4 kernels"
	fi
}

src_compile() {
	econf --prefix=/ || die
	emake || die
}

src_install() {
	emake DESTDIR=${D} install || die
	dodoc README ChangeLog AUTHORS
}
