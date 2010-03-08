# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/dvipdfmx/dvipdfmx-20090708-r1.ebuild,v 1.6 2010/03/08 12:21:38 ssuominen Exp $

EAPI="2"

inherit eutils base autotools

DESCRIPTION="DVI to PDF translator with multi-byte character support"
HOMEPAGE="http://project.ktug.or.kr/dvipdfmx/"
SRC_URI="http://project.ktug.or.kr/${PN}/snapshot/latest/${P}.tar.gz"
IUSE=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ppc ppc64 sparc x86"

DEPEND="
	app-text/libpaper
	media-libs/libpng
	sys-libs/zlib
	virtual/tex-base
	app-text/libpaper
"
RDEPEND="${DEPEND}
	>=app-text/poppler-0.12.3-r3
	app-text/poppler-data
"

PATCHES=(
	"${FILESDIR}/${PV}-fix_file_collisions.patch"
	"${FILESDIR}/${P}-libpng14.patch"
)

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_install() {
	# Override dvipdfmx.cfg default installation location so that it is easy to
	# modify it and it gets config protected. Symlink it from the old location.
	emake configdatadir="/etc/texmf/dvipdfm" DESTDIR="${D}" install || die "make install failed"
	dosym /etc/texmf/dvipdfm/dvipdfmx.cfg /usr/share/texmf/dvipdfm/dvipdfmx.cfg || die

	# Symlink poppler-data cMap, bug #201258
	dosym /usr/share/poppler/cMap /usr/share/texmf/fonts/cmap/cMap || die
	dodoc AUTHORS ChangeLog README || die

# Remove symlink conflicting with app-text/dvipdfm (bug #295235)
	rm "${D}"/usr/bin/ebb
}

pkg_postinst() {
	[[ ${ROOT} == / ]] && /usr/sbin/texmf-update
}

pkg_postrm() {
	[[ ${ROOT} == / ]] && /usr/sbin/texmf-update
}
