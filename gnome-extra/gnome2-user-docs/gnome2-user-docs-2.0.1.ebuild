# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome2-user-docs/gnome2-user-docs-2.0.1.ebuild,v 1.4 2002/12/15 10:44:20 bjb Exp $


DESCRIPTION="end user documentation for Gnome2 "
HOMEPAGE="http://www.gnome.org"
LICENSE="FDL-1.1"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha"
DEPEND="virtual/glibc
	>=app-text/docbook-sgml-utils-0.6.9
	>=app-text/scrollkeeper-0.3.9"
RDEPEND=$DEPEND
SRC_URI="mirror://gnome/2.0.2/sources/${PN}/${P}.tar.bz2"
S=${WORKDIR}/${P}

src_compile() { 
	econf
	emake || die
}

src_install () {
	einstall
}

pkg_postinst () {
  scrollkeeper-update -p /var/lib/scrollkeeper
}
