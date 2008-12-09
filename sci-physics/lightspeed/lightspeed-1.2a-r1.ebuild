# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/lightspeed/lightspeed-1.2a-r1.ebuild,v 1.6 2008/12/09 12:06:35 bicatali Exp $

inherit eutils

DEB_PATCH="${PN}_${PV}-7"
DESCRIPTION="OpenGL interactive relativistic simulator"
HOMEPAGE="http://lightspeed.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://sourceforge/${PN}/objects-1.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${DEB_PATCH}.diff.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

IUSE="nls truetype"
LANGS="es"
for i in ${LANGS}; do
	IUSE="${IUSE} linguas_${i}"
done

DEPEND="virtual/opengl
	x11-libs/gtkglext
	x11-libs/gtkglarea
	>=x11-libs/gtk+-2
	media-libs/libpng
	media-libs/tiff
	truetype? ( media-libs/ftgl )"

S2="${WORKDIR}/objects"

src_unpack() {
	unpack ${A}
	epatch ${DEB_PATCH}.diff
}

src_compile() {
	econf \
		--with-gtk=2 \
		$(use_enable nls) \
		$(use_with truetype ftgl)
	emake || die "emake failed"
	for i in ${LANGS}; do
		use linguas_${i} && emake ${i}.gmo
	done
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newicon src/icon.xpm lightspeed.xpm
	make_desktop_entry ${PN} "Light Speed! Relativistic Simulator"
	dodoc AUTHORS ChangeLog MATH NEWS README TODO || die
	newdoc debian/changelog ChangeLog.Debian || die
	cd ${S2}
	newdoc README objects-README || die
	insinto /usr/share/${PN}
	doins *.3ds *.lwo || die
}

pkg_postinst() {
	elog
	elog "Some 3d models have been placed in /usr/share/${PN}"
	elog "You can load them in Light Speed! from the File menu."
	elog
}
