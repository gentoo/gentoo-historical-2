# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kdissert/kdissert-1.0.5.ebuild,v 1.5 2005/11/22 05:55:02 josejx Exp $

inherit kde

DESCRIPTION="KDissert - a mindmapping-like tool"
HOMEPAGE="http://www.freehackers.org/~tnagy/kdissert/index.html"
SRC_URI="http://www.freehackers.org/~tnagy/kdissert/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ppc sparc ~x86"
IUSE=""

DEPEND=">=dev-util/scons-0.96.1
	>=dev-lang/python-2.3"
RDEPEND=""

need-kde 3.3

PATCHES="${FILESDIR}/kde.py-bksys-1.5.1.diff"

src_compile() {
	local myconf="qtdir=${QTDIR} kdedir=${KDEDIR} prefix=/usr"
	use amd64 && myconf="${myconf} libsuffix=64"

	scons configure ${myconf} || die "configure failed"
	scons ${MAKEOPTS} || die "scons failed"
}

src_install() {
	DESTDIR="${D}" scons install
	dodoc AUTHORS README ROADMAP VERSION
}
