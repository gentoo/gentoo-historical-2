# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-text/recode/recode-3.5.ebuild,v 1.3 2002/08/02 17:42:50 phoenix Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Convert files between various character sets."
SRC_URI="ftp://gnu.wwc.edu/recode/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/"
KEYWORDS="x86"

DEPEND="virtual/glibc
	nls? ( sys-devel/gettext )"
RDEPEND="${DEPEND}"

SLOT="0"
LICENSE="GPL-2"

src_compile() {

	local myconf
	use nls || myconf="--disable-nls"
        
	./configure --host=${CHOST}				\
		--prefix=/usr			  		\
		--mandir=/usr/share/man				\
		--infodir=/usr/share/info			\
		$myconf || die
			
	emake || die
}

src_install() {
	
	make prefix=${D}/usr					\
		mandir=${D}/usr/share/man			\
		infodir=${D}/usr/share/info			\
		install || die

	dodoc AUTHORS BACKLOG COPYING* ChangeLog INSTALL
	dodoc NEWS README THANKS TODO
}

