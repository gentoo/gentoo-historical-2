# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksim/ksim-3.5.10.ebuild,v 1.5 2009/06/18 04:02:41 jer Exp $

KMNAME=kdeutils
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="KDE system monitoring applets."
KEYWORDS="~alpha amd64 hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility snmp"

DEPEND="x11-libs/libXext
	snmp? ( net-analyzer/net-snmp )"

PATCHES="${FILESDIR}/${PN}-3.5.8-freebsd.patch"

src_unpack() {
	kde-meta_src_unpack

	# Fix the desktop file.
	sed -i -e "s:Hidden=true:Hidden=false:" ksim/ksim.desktop || die "sed failed"
}

src_compile() {
	myconf="$myconf $(use_with snmp)"
	kde-meta_src_compile
}

src_install() {
	kde-meta_src_install
	# see bug 144731
	rm "${D}${KDEDIR}/share/applications/kde/ksim.desktop"
}
