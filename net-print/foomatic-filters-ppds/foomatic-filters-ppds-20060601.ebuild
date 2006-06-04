# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/foomatic-filters-ppds/foomatic-filters-ppds-20060601.ebuild,v 1.1 2006/06/04 14:51:42 genstef Exp $

DESCRIPTION="linuxprinting.org PPD files for non-postscript printers"
HOMEPAGE="http://www.linuxprinting.org/foomatic.html"
SRC_URI="http://gentooexperimental.org/~genstef/dist/${P}.tar.gz"
# http://linuxprinting.org/download/foomatic

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="net-print/foomatic-filters"

src_compile() {
	rm -f $(find . -name "*gimp-print*")
	rm -f $(find . -name "*hpijs*")
	# conflicts with foomatic-filters
	rm -f bin/{foomatic-gswrapper,foomatic-rip}
	rm -f share/man/man1/{foomatic-gswrapper,foomatic-rip}.1
}

src_install() {
	./install -d ${D} -p /usr -z || die "ppds install failed"
	
	dodoc README
}
