# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/porthole/porthole-0.2.ebuild,v 1.1 2004/02/01 16:00:27 carpaski Exp $

DESCRIPTION="A GTK+-based frontend to Portage"
HOMEPAGE="http://porthole.sourceforge.net"
SRC_URI="mirror://sourceforge/porthole/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND=">=dev-python/pygtk-2.0.0
        >=gnome-base/libglade-2"

src_install() {
	python setup.py install --root=${D} || die
	chmod -R a+r ${D}/usr/share/porthole
	chmod -R a+r ${D}/usr/doc/porthole-0.2
}
