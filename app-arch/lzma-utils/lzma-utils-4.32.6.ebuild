# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/lzma-utils/lzma-utils-4.32.6.ebuild,v 1.4 2008/06/21 13:11:03 armin76 Exp $

# Remember: we cannot leverage autotools in this ebuild in order
#           to avoid circular deps with autotools

inherit eutils

MY_P="lzma-${PV/_}"
DESCRIPTION="LZMA interface made easy"
HOMEPAGE="http://tukaani.org/lzma/"
SRC_URI="http://tukaani.org/lzma/${MY_P}.tar.gz
	nocxx? ( mirror://gentoo/${P}-nocxx.patch.bz2 )"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="nocxx"

RDEPEND="!app-arch/lzma
	!<app-arch/p7zip-4.57"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	if use nocxx ; then
		epatch "${WORKDIR}"/${P}-nocxx.patch
		find -type f -print0 | xargs -0 touch -r configure
		epunt_cxx
	fi
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README THANKS
	use nocxx && newbin "${FILESDIR}"/lzma-nocxx.sh lzma
}

pkg_postinst() {
	if use nocxx ; then
		ewarn "You have a neutered lzma package install due to USE=nocxx."
		ewarn "You will only be able to unpack lzma archives."
	fi
}
