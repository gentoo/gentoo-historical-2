# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/discover/discover-2.0.7.ebuild,v 1.1 2005/03/09 01:00:37 vapier Exp $

DESCRIPTION="Library and front-end for retrieving information about a system's hardware"
HOMEPAGE="http://componentizedlinux.org/discover/"
SRC_URI="http://archive.progeny.com/progeny/discover/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc -sparc ~x86"
IUSE="pcmcia"

DEPEND="pcmcia? ( virtual/linux-sources )
	net-misc/curl
	dev-libs/expat"
PDEPEND="sys-apps/discover-data"

src_unpack() {
	unpack ${A}
	cd ${S}
	if ! which docbook-to-man 2>/dev/null ; then
		if which docbook2man 2>/dev/null ; then
			sed -i 's:docbook-to-man:docbook2man:' doctools/docbook.mk
		else
			sed -i 's:docbook-to-man:echo:' doctools/docbook.mk
		fi
	fi
}

src_compile() {
	local myconf=""
	use pcmcia \
		&& myconf="--with-pcmcia-headers=/usr/src/linux/include"
	econf ${myconf} || die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS README RELEASE
}
