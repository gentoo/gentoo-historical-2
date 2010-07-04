# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/qwriter/qwriter-0.1.9.ebuild,v 1.3 2010/07/04 17:07:38 phajdan.jr Exp $

EAPI="2"
LANGS="ru"

inherit qt4-r2

MY_P="${P}-src"

DESCRIPTION="Advanced text editor with syntax highlighting"
HOMEPAGE="http://qt-apps.org/content/show.php/QWriter?content=106377"
#upstream failed to provide a sane url
SRC_URI="http://qwriter.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="x11-libs/qt-gui:4
	x11-libs/qscintilla"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i "s:languages:/usr/share/${PN}/languages:" src/MainWindow.cpp \
		|| die "failed to fix translation path"
	qt4-r2_src_prepare
}

src_install() {
	dobin bin/${PN} || die "dobin failed"
	newicon images/w.png ${PN}.png || die "newicon failed"
	make_desktop_entry ${PN} QWriter ${PN} \
		|| die "make_desktop_entry failed"
	insinto /usr/share/${PN}/languages/
	for x in ${LANGS};do
		for j in ${LINGUAS};do
			if [[ $x == $j ]]; then
				doins languages/${PN}_$x.qm \
					|| die "failed to install $x translation"
			fi
		done
	done
}
