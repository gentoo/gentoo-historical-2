# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/gzip/gzip-1.3.10.ebuild,v 1.1 2006/12/31 11:17:56 vapier Exp $

inherit eutils flag-o-matic

DESCRIPTION="Standard GNU compressor"
HOMEPAGE="http://www.gnu.org/software/gzip/"
SRC_URI="ftp://alpha.gnu.org/gnu/gzip/${P}.tar.gz
	mirror://gnu/gzip/${P}.tar.gz
	mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="nls static pic"

RDEPEND=""
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"
PROVIDE="virtual/gzip"

src_unpack() {
	unpack ${A}
	cd "${S}"
	#epatch "${FILESDIR}"/${PN}-1.3.5-rsync.patch
	epatch "${FILESDIR}"/${PN}-1.3.8-install-symlinks.patch
}

src_compile() {
	use static && append-flags -static
	# avoid text relocation in gzip
	use pic && export DEFS="NO_ASM"
	econf $(use_enable nls) || die
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc ChangeLog NEWS README THANKS TODO
	docinto txt
	dodoc algorithm.doc gzip.doc

	# keep most things in /usr, just the fun stuff in /
	dodir /bin
	mv "${D}"/usr/bin/{gunzip,gzip,zcat} "${D}"/bin/ || die
	dosym /bin/gunzip /usr/bin/gunzip || die
}
