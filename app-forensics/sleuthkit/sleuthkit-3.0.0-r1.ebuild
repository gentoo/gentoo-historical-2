# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/sleuthkit/sleuthkit-3.0.0-r1.ebuild,v 1.2 2009/03/01 17:41:48 fmccor Exp $

inherit eutils flag-o-matic autotools

SLOT=0

DESCRIPTION="A collection of file system and media management forensic analysis tools"
HOMEPAGE="http://www.sleuthkit.org/sleuthkit/"
SRC_URI="mirror://sourceforge/sleuthkit/${P}.tar.gz"

LICENSE="GPL-2 IBM"
KEYWORDS="~amd64 ~sparc ~x86"

DEPEND="ewf? ( app-forensics/libewf )
	aff? ( app-forensics/afflib )"
RDEPEND="${DEPEND}
	dev-perl/DateManip"

IUSE="aff ewf"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# AC_FUNC_REALLOC in configure.ac that hasn't been propagated
	eautoreconf
}

src_compile() {
	econf	|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc docs/*.txt README.txt CHANGES.txt TODO.txt
}
