# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/koctave/koctave-0.65.ebuild,v 1.3 2004/06/24 22:05:21 agriffis Exp $

inherit kde
need-kde 3

IUSE=""

DESCRIPTION="A KDE GUI for Octave numerical computing system"
HOMEPAGE="http://bubben.homelinux.net/~matti/koctave/"
SRC_URI="http://bubben.homelinux.net/~matti/koctave/${PN}3-0.65.tar.bz2"
S=${WORKDIR}/${PN}3-${PV}

LICENSE="GPL-2"
KEYWORDS="x86 ~amd64 ~ppc"

DEPEND="virtual/glibc
	app-sci/octave
	kde-base/kdebase"
