# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyxf86config/pyxf86config-0.3.34-r1.ebuild,v 1.2 2008/02/14 02:50:22 robbat2 Exp $

inherit eutils python rpm

# Tag for which Fedora Core version it's from
FCVER="8"

# Revision of the RPM. Shouldn't affect us, as we're just grabbing the source
# tarball out of it
RPMREV="1"

DESCRIPTION="Python wrappers for libxf86config"
HOMEPAGE="http://fedoraproject.org/wiki/SystemConfig/"
SRC_URI="mirror://fedora-dev/development/source/SRPMS/${P}-${RPMREV}.fc${FCVER}.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE=""

RDEPEND="=dev-libs/glib-2*
		  dev-lang/python"
DEPEND="${RDEPEND}
		>=x11-base/xorg-server-1.1.1-r1"

src_unpack() {
	rpm_src_unpack
	cd "${S}"

	if has_version '>=x11-base/xorg-server-1.4' ; then
		epatch "${FILESDIR}/xorg-server-1.4-compat.patch"
	fi
}

src_compile() {
	python_version
	econf --with-python-version=${PYVER} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
