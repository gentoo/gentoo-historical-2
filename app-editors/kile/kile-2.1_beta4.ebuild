# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/kile/kile-2.1_beta4.ebuild,v 1.6 2010/10/06 23:48:08 tampakrap Exp $

EAPI=3

KMNAME="extragear/office"

if [[ ${PV} != *9999* ]]; then
	MY_P=${P/_beta/b}

	SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

	KDE_DOC_DIRS="doc"
fi

inherit kde4-base

DESCRIPTION="A Latex Editor and TeX shell for KDE"
HOMEPAGE="http://kile.sourceforge.net/"

LICENSE="FDL-1.2 GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="4"
IUSE="debug handbook +pdf +png"

DEPEND="
	x11-misc/shared-mime-info
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kdebase-data)
	|| (
		$(add_kdebase_dep okular 'pdf?,ps')
		app-text/acroread
	)
	virtual/latex-base
	virtual/tex-base
	pdf? (
		app-text/dvipdfmx
		app-text/ghostscript-gpl
	)
	png? (
		app-text/dvipng
		media-gfx/imagemagick[png]
	)
"

S=${WORKDIR}/${MY_P}

DOCS=( kile-remote-control.txt )

src_prepare() {
	kde4-base_src_prepare

	# I know upstream wants to help us but it doesn't work..
	sed -e '/INSTALL( FILES AUTHORS/s/^/#DISABLED /' \
		-i CMakeLists.txt || die

	use handbook || rm -fr doc
}
