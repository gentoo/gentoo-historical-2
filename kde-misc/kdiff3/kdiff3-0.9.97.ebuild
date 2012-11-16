# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kdiff3/kdiff3-0.9.97.ebuild,v 1.2 2012/11/16 22:14:37 ago Exp $

EAPI=4

if [[ ${PV} != *9999* ]]; then
	KDE_LINGUAS="ar bg br bs ca ca@valencia cs cy da de el en_GB eo es et fr ga
	gl hi hne hr hu is it ja ka lt mai ml nb nds nl nn pl pt pt_BR ro ru rw sk
	sv ta tg tr ug uk zh_CN zh_TW"
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 ~ppc ~ppc64 ~x86 ~amd64-linux"
	KDE_HANDBOOK="optional"
else
	ESVN_REPO_URI="https://kdiff3.svn.sourceforge.net/svnroot/kdiff3/trunk/kdiff3"
	KEYWORDS=""
fi

KDE_REQUIRED="optional"
inherit kde4-base qt4-r2

DESCRIPTION="Qt/KDE based frontend to diff3"
HOMEPAGE="http://kdiff3.sourceforge.net/"

LICENSE="GPL-2"
SLOT="4"
IUSE="debug kde"

DEPEND="
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
	kde? ( $(add_kdebase_dep kdelibs) )
"
RDEPEND="${DEPEND}
	sys-apps/diffutils
"

RESTRICT="!kde? ( test )"

src_unpack(){
	if [[ ${PV} == *9999* ]]; then
		subversion_src_unpack
	elif use kde; then
		kde4-base_src_unpack
	else
		qt4-r2_src_unpack
	fi
}

src_prepare() {
	if ! use kde; then
		# adapt to Gentoo paths
		sed -e s,documentation.path.*$,documentation.path\ =\ "${EPREFIX}"/usr/share/doc/"${PF}", \
		-e s,target.path.*$,target.path\ =\ "${EPREFIX}"/usr/bin, \
		"${S}"/src-QT4/kdiff3.pro > "${S}"/src-QT4/kdiff3_fixed.pro
	else
		kde4-base_src_prepare
	fi

	echo "Categories=Qt;KDE;Development;" >> "${S}"/src-QT4/kdiff3.desktop
}

src_configure() {
	if use kde; then
		kde4-base_src_configure
	else
		eqmake4 "${S}"/src-QT4/kdiff3_fixed.pro
	fi
}

src_compile() {
	if use kde; then
		kde4-base_src_compile
	else
		qt4-r2_src_compile
	fi
}

src_install() {
	if use kde; then
		kde4-base_src_install
	else
		qt4-r2_src_install
	fi
}

src_test() {
	if use kde; then
		kde4-base_src_test
	fi
}
