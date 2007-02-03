# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/eject/eject-2.1.5-r1.ebuild,v 1.2 2007/02/03 15:58:23 eroyf Exp $

inherit eutils

DESCRIPTION="A command to eject a disc from the CD-ROM drive"
HOMEPAGE="http://eject.sourceforge.net/ http://ca.geocities.com/jefftranter@rogers.com/eject.html"
SRC_URI="http://www.ibiblio.org/pub/Linux/utils/disk-management/${P}.tar.gz
	http://www.pobox.com/~tranter/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="nls"

DEPEND="!virtual/eject"
PROVIDE="virtual/eject"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}"-2.0.13-xmalloc.patch
	epatch "${FILESDIR}/${PN}"-2.1.4-scsi-rdwr.patch
	epatch "${FILESDIR}/${PN}"-2.1.5-handle-spaces.patch #151257
}

src_compile() {
	econf $(use_enable nls) || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog README PORTING TODO AUTHORS NEWS PROBLEMS
}
