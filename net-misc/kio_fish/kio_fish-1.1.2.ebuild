# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/kio_fish/kio_fish-1.1.2.ebuild,v 1.10 2003/02/13 14:55:14 vapier Exp $

inherit kde-base

need-kde 3
newdepend ">=net-misc/openssh-3.1_p1"

DESCRIPTION="a kioslave for KDE 3 that lets you view and manipulate your remote files using SSH."
SRC_URI="http://ich.bin.kein.hoschi.de/fish/${P}.tar.bz2"
HOMEPAGE="http://ich.bin.kein.hoschi.de/fish/"

LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc "

warning_msg() {

ewarn "WARNING: this app is now part of kdebase-3.1. It is very much recommended that you"
ewarn "upgrade to kde 3.1 instead of using this standalone app, because it is no longer being"
ewarn "updated or fixed. In addition, it won't even compile on a kde 3.1 system."

}

src_unpack() {

    warning_msg
    kde_src_unpack

}

src_install() {
	dodir /usr/kde/3/share/services
	make DESTDIR=${D} install || die
}

src_postinst() {
    warning_msg
}
