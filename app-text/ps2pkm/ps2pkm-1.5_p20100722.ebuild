# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ps2pkm/ps2pkm-1.5_p20100722.ebuild,v 1.2 2010/10/25 09:59:13 jer Exp $

EAPI=3

DESCRIPTION="Tool that converts a PostScript type1 font into a corresponding TeX PK font"
HOMEPAGE="http://tug.org/texlive/"
SRC_URI="mirror://gentoo/texlive-${PV#*_p}-source.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa"
IUSE=""

DEPEND="dev-libs/kpathsea"
RDEPEND="
	!<app-text/texlive-core-2010
	!app-text/ptex
	${DEPEND}"

S=${WORKDIR}/texlive-${PV#*_p}-source/texk/${PN}

src_configure() {
	econf --with-system-kpathsea
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog CHANGES.type1 README README.14m README.type1 || die
}
