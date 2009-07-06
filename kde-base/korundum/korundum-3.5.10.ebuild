# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/korundum/korundum-3.5.10.ebuild,v 1.5 2009/07/06 18:11:21 ranger Exp $

KMNAME=kdebindings
KMCOPYLIB="libsmokeqt smoke/qt libsmokekde smoke/kde"
KMCOMPILEONLY="qtruby"
KM_MAKEFILESREV=1
EAPI="1"
inherit kde-meta

DESCRIPTION="KDE ruby bindings"
HOMEPAGE="http://techbase.kde.org/Development/Languages/Ruby"
KEYWORDS="amd64 ~ppc ppc64 ~sparc x86"
IUSE=""

# NOTE: qtruby isn't slotted
DEPEND=">=virtual/ruby-1.8
~kde-base/qtruby-${PV}
>=kde-base/smoke-${PV}:${SLOT}"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/no-gtk-glib-check.diff"
	"${FILESDIR}/korundum-3.5.10-gcc44.patch" )

# Because this installs into /usr/lib/ruby/..., it doesn't have SLOT=X.Y like the rest of KDE,
# and it installs into /usr entirely.
# Note that it still depends on a specific range of (slotted) smoke and qtruby versions.
SLOT="0"
src_compile() {
	kde_src_compile myconf
	myconf="$myconf --prefix=/usr"
	kde_src_compile configure make
}
