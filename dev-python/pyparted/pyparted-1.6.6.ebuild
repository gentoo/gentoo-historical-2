# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyparted/pyparted-1.6.6.ebuild,v 1.6 2004/12/30 21:03:58 wolf31o2 Exp $

RH_EXTRAVERSION="2"

inherit eutils rpm

DESCRIPTION="Python bindings for parted"
HOMEPAGE="http://fedora.redhat.com"
SRC_URI="http://download.fedora.redhat.com/pub/fedora/linux/core/development/SRPMS/${P}-${RH_EXTRAVERSION}.src.rpm"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc -*"
IUSE=""

# Needed to build...
DEPEND=">=sys-apps/parted-1.6.9"

src_unpack() {
	rpm_src_unpack
}

src_compile() {
	cd ${S}

	# This is needed otherwise it won't build
	# If anyone wants to figure out why... go ahead!
	export LDFLAGS="-ldl"
	econf || die
	emake || die
}

src_install () {
	einstall || die "Install failed!"
	dodoc AUTHORS COPYING README ChangeLog
}
