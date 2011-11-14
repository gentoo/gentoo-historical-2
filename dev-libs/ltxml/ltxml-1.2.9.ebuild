# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ltxml/ltxml-1.2.9.ebuild,v 1.1 2011/11/14 03:53:45 xmw Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Integrated set of XML tools and a developers tool-kit with C API"
HOMEPAGE="http://www.ltg.ed.ac.uk/software/xml/"
SRC_URI=ftp://ftp.cogsci.ed.ac.uk/pub/LTXML/${P}.tar.gz

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ia64 ~ppc ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND=""

PV_MAJ="${PV:0:1}${PV:2:1}"

S=${WORKDIR}/${P}/XML

src_compile() {
	emake all
}

src_install() {
	emake -j1 install \
		datadir="${D}"/usr/$(get_libdir)/${PN}${PV_MAJ} \
		libdir="${D}"/usr/$(get_libdir) \
		prefix="${D}"/usr
}
