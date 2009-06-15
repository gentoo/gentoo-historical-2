# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gwenview/gwenview-1.4.2-r2.ebuild,v 1.5 2009/06/15 11:44:42 pva Exp $

ARTS_REQUIRED="never"

EAPI="1"

inherit kde

MY_P=${P/_/}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Gwenview is a fast and easy to use image viewer for KDE."
HOMEPAGE="http://gwenview.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
LICENSE="GPL-2"

SLOT="3.5"
KEYWORDS="amd64 ppc ~sparc x86 ~x86-fbsd"
IUSE="kipi"

DEPEND="kipi? ( >=media-plugins/kipi-plugins-0.1.0_beta2 )
		media-gfx/exiv2"
RDEPEND="${DEPEND}"

need-kde 3.5

I18N="${PN}-i18n-${PV}"

LANGS="ar az bg br ca cs cy da de el en_GB es et fi fo fr ga gl he hi hu
is it ja ka ko lt nb nl nso pa pl pt pt_BR ro ru rw sk sr sr@Latn sv ta
th tr uk xh zh_CN zh_TW zu"

for X in ${LANGS}; do
	SRC_URI="${SRC_URI} linguas_${X}? ( mirror://sourceforge/${PN}/${I18N}.tar.bz2 )"
	IUSE="${IUSE} linguas_${X}"
done

PATCHES=(
	"${FILESDIR}/gwenview-1.4.2-exiv2.patch"
	"${FILESDIR}/gwenview-1.4.2-desktop-file.diff"
	)

src_unpack() {
	kde_src_unpack

	if [ -d "${WORKDIR}/${I18N}" ]; then
		cd "${WORKDIR}/${I18N}"
		for X in ${LANGS}; do
			use linguas_${X} || rm -rf "${X}"
		done
		rm -f configure
	fi
}

src_compile() {
	local myconf="$(use_with kipi)"
	rm -f "${S}/configure"

	if [ -d "${WORKDIR}/${I18N}" ]; then
		KDE_S="${WORKDIR}/${I18N}" \
		kde_src_compile
	else
		kde_src_compile
	fi
}

src_install() {
	if [ -d "${WORKDIR}/${I18N}" ]; then
		KDE_S="${WORKDIR}/${I18N}" \
		kde_src_install
	else
		kde_src_install
	fi
}
