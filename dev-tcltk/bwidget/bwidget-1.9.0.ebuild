# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/bwidget/bwidget-1.9.0.ebuild,v 1.3 2012/11/20 20:36:58 ago Exp $

EAPI=4

inherit eutils multilib

MY_PN=${PN/bw/BW}
MY_P=${MY_PN}-${PV}

DESCRIPTION="High-level widget set for Tcl/Tk"
HOMEPAGE="http://tcllib.sourceforge.net/"
SRC_URI="mirror://sourceforge/tcllib/${MY_P}.tar.gz"

LICENSE="BWidget"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="doc"

DEPEND="dev-lang/tk"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/$(get_libdir)/${P}
	doins *.tcl
	doins -r images lang

	insinto /usr/share/doc/${PF}/
	doins -r demo
	dodoc ChangeLog README.txt

	use doc && dohtml BWman/*
}
