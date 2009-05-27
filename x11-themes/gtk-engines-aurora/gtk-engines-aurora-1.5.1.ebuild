# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-aurora/gtk-engines-aurora-1.5.1.ebuild,v 1.3 2009/05/27 06:52:14 fauli Exp $

EAPI=2
inherit versionator

MY_MAJ=$(get_version_component_range 1-2)

DESCRIPTION="Aurora GTK+ Theme Engine"
HOMEPAGE="http://www.gnome-look.org/content/show.php?content=56438"
SRC_URI="http://gnome-look.org/CONTENT/content-files/56438-aurora-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.10:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/aurora-${MY_MAJ}

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
	tar -xzf aurora-gtk-engine-${MY_MAJ}.tar.gz || die "unpack failed"
	tar -xjf Aurora.tar.bz2 || die "unpack failed"
}

src_configure() {
	econf --disable-dependency-tracking --enable-animation
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
	insinto /usr/share/themes/Aurora
	doins -r ../Aurora/* || die "doins failed"
}
