# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/luma/luma-2.2.1.ebuild,v 1.4 2008/07/27 22:12:11 carlo Exp $

EAPI=1

inherit eutils qt3

DESCRIPTION="Luma is a graphical utility for accessing and managing data stored on LDAP servers."
HOMEPAGE="http://luma.sourceforge.net/"
SRC_URI="mirror://sourceforge/luma/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~sparc ~x86 ~amd64"
IUSE="samba"

RDEPEND="x11-libs/qt:3
	>=dev-lang/python-2.3
	>=dev-python/PyQt-3.10
	>=dev-python/python-ldap-2.0.1
	samba? ( >=dev-python/py-smbpasswd-1.0 )"
DEPEND="x11-libs/qt:3
	>=dev-lang/python-2.3
	>=dev-python/PyQt-3.10
	>=dev-python/python-ldap-2.0.1
	samba? ( >=dev-python/py-smbpasswd-1.0 )"

src_install() {
	# if $QTDIR/etc/settings/qtrc file exists, the qt build tools try to create
	[ -d "$QTDIR/etc/settings" ] && addwrite "$QTDIR/etc/settings"
	addpredict "$QTDIR/etc/settings"

	dodir /usr
	python install.py --prefix="${D}"/usr
	make_desktop_entry "luma" Luma "/usr/share/luma/icons/luma-128.png" "System;Qt"
}
