# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/texinfo/texinfo-4.8.ebuild,v 1.1 2005/01/04 03:24:18 vapier Exp $

inherit flag-o-matic eutils

DESCRIPTION="The GNU info program and utilities"
HOMEPAGE="http://www.gnu.org/software/texinfo/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="nls build static"

RDEPEND="virtual/libc
	!build? ( >=sys-libs/ncurses-5.2-r2 )"
DEPEND="${RDEPEND}
	!build? (
		>=sys-apps/sed-4.0.5
		nls? ( sys-devel/gettext )
	)"

src_unpack() {
	unpack ${A}

	cd "${S}"/doc
	# Get the texinfo info page to have a proper name of texinfo.info
	sed -i 's:setfilename texinfo:setfilename texinfo.info:' texinfo.txi

	sed -i \
		-e 's:INFO_DEPS = texinfo:INFO_DEPS = texinfo.info:' \
		-e 's:texinfo\::texinfo.info\::' \
		Makefile.in
}

src_compile() {
	local myconf=
	if ! use nls || use build ; then
		myconf="--disable-nls"
	fi
	use static && append-ldflags -static

	econf ${myconf} || die
	emake || die
}

src_install() {
	if use build ; then
		newbin util/ginstall-info install-info
		dobin makeinfo/makeinfo util/{texi2dvi,texindex}
	else
		make DESTDIR="${D}" install || die "install failed"
		dosbin ${FILESDIR}/mkinfodir

		if [[ ! -f ${D}/usr/share/info/texinfo.info ]] ; then
			die "Could not install texinfo.info!!!"
		fi

		dodoc AUTHORS ChangeLog INTRODUCTION NEWS README TODO
		newdoc info/README README.info
		newdoc makeinfo/README README.makeinfo
	fi
}
