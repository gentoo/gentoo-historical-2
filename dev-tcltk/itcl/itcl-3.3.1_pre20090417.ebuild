# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/itcl/itcl-3.3.1_pre20090417.ebuild,v 1.7 2010/06/18 05:38:46 bicatali Exp $

inherit eutils multilib versionator

MY_PN="incrTcl"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Object Oriented Enhancements for Tcl/Tk"
HOMEPAGE="http://incrtcl.sourceforge.net/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

IUSE=""
SLOT="0"
LICENSE="BSD"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"

DEPEND="dev-lang/tcl"

S="${WORKDIR}/${MY_PN}/${PN}"

src_compile() {
	econf || die "econf failed"
	emake CFLAGS_DEFAULT="${CFLAGS}" || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc ../{CHANGES,ChangeLog,INCOMPATIBLE,README,TODO}
	cat >> "${T}"/34${PN} <<- EOF
	LDPATH="/usr/$(get_libdir)/${PN}$(get_version_component_range 1-2)/"
	EOF
	doenvd "${T}"/34${PN} || die
}
