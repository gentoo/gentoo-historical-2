# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/itcl/itcl-3.3.1_pre20090417.ebuild,v 1.2 2009/08/18 08:09:18 fauli Exp $

inherit eutils

MY_PN="incrTcl"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Object Oriented Enhancements for Tcl/Tk"
HOMEPAGE="http://incrtcl.sourceforge.net/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

IUSE=""
SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc x86"

DEPEND="dev-lang/tcl"

S="${WORKDIR}/${MY_PN}/${PN}"

src_compile() {
	econf || die "econf failed"
	emake CFLAGS_DEFAULT="${CFLAGS}" || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc ../{CHANGES,ChangeLog,INCOMPATIBLE,README,TODO}
}
