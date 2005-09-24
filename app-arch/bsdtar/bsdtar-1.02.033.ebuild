# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/bsdtar/bsdtar-1.02.033.ebuild,v 1.1 2005/09/24 00:03:39 flameeyes Exp $

inherit eutils flag-o-matic

DESCRIPTION="BSD tar command"
HOMEPAGE="http://people.freebsd.org/~kientzle/libarchive/"
SRC_URI="http://people.freebsd.org/~kientzle/libarchive/src/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc-macos ~x86"
IUSE="build static"

RDEPEND="!static? ( >=dev-libs/libarchive-1.02.032 )"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PN}-1.02.027-osx.patch
}

src_compile() {
	( use static || use build ) && append-ldflags -static

	econf --bindir=/bin || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install

	# Create tar symlink for BSD userlands
	if [[ ${USERLAND} == "BSD" ]]; then
		dosym bsdtar /bin/tar
		dosym bsdtar.1.gz /usr/share/man/man1/tar.1.gz
	fi
}
