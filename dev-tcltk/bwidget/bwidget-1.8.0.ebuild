# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/bwidget/bwidget-1.8.0.ebuild,v 1.2 2009/08/11 20:04:45 fauli Exp $

inherit eutils

DESCRIPTION="high-level widget set for Tcl/Tk completely written in Tcl"

MY_PN=${PN/bw/BW}
MY_P=${MY_PN}-${PV}
HOMEPAGE="http://tcllib.sourceforge.net/"
SRC_URI="mirror://sourceforge/tcllib/${MY_P}.tar.gz"
IUSE="doc"
LICENSE="BWidget"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc x86"

DEPEND="dev-lang/tk
		dev-lang/tcl"

S=${WORKDIR}/${MY_P}

src_install() {
	cd ${S}
	insinto /usr/$(get_libdir)/${P}
	doins *.tcl
	cp -R images lang ${D}usr/$(get_libdir)/${P}
	dodoc ChangeLog LICENSE.txt README.txt
	cp -R demo ${D}usr/share/doc/${PF}/
	use doc && dohtml BWman/*
}
