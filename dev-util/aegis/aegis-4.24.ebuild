# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/aegis/aegis-4.24.ebuild,v 1.1 2008/06/30 01:43:53 darkside Exp $

inherit autotools

IUSE="tk"

DESCRIPTION="A transaction based revision control system"
SRC_URI="mirror://sourceforge/aegis/${P}.tar.gz"
HOMEPAGE="http://aegis.sourceforge.net"

DEPEND="sys-libs/zlib
	sys-devel/gettext
	sys-apps/groff
	sys-devel/bison
	dev-libs/libxml2
	tk? ( >=dev-lang/tk-8.3 )"
RDEPEND="" #221421

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~ppc ~sparc ~x86"

src_unpack() {
	unpack ${A}
	cd "${S}"

	#FIXME: ? Not sure what effect this has. Only way to get it to compile.
	sed -i 's/$(SH) etc\/compat.2.3//' Makefile.in || \
		die "sed Makefile.in failed"
	eautomake || die "eautomake failed"
}

src_compile() {
	# By default aegis configure puts shareable read/write files (locks etc)
	# in ${prefix}/com/aegis but the FHS says /var/lib/aegis can be shared.

	myconf="${myconf} --with-nlsdir=/usr/share/locale"

	econf \
		--sharedstatedir=/var/lib/aegis \
		${myconf} || die "./configure failed"

	# Second ebuild causes redefined/undefined function errors
	#make clean

	# not emake safe, I think
	make || die
}

src_install () {
	make RPM_BUILD_ROOT="${D}" install || die

	# OK so ${D}/var/lib/aegis gets UID=3, but for some
	# reason so do the files under /usr/share, even though
	# they are read-only.
	chown -R root:root "${D}"/usr/share
	dodoc lib/en/*

	# Link to share dir so user has a chance of noticing it.
	dosym /usr/share/aegis /usr/share/doc/${PF}/scripts

	# Config file examples are documentation.
	mv "${D}"/usr/share/aegis/config.example "${D}"/usr/share/doc/"${PF}"/

	dodoc BUILDING README
}
