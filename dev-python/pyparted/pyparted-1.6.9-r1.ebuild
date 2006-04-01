# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyparted/pyparted-1.6.9-r1.ebuild,v 1.7 2006/04/01 18:48:01 agriffis Exp $

RH_EXTRAVERSION="3"

inherit eutils rpm flag-o-matic

DESCRIPTION="Python bindings for parted"
HOMEPAGE="http://fedora.redhat.com"
SRC_URI="http://download.fedora.redhat.com/pub/fedora/linux/core/development/SRPMS/${P}-${RH_EXTRAVERSION}.src.rpm"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ia64 ppc sparc x86"
IUSE=""

# Needed to build...
DEPEND="=dev-lang/python-2.4*
	>=sys-apps/parted-1.6.9"

src_unpack() {
	rpm_src_unpack
}

src_compile() {
	cd ${S}

	# -fPIC needed for compilation on amd64, applied globally as only one shared
	# lib is produced by this package.
	append-flags -fPIC

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
