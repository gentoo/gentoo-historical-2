# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/libewf/libewf-20090209.ebuild,v 1.3 2009/03/05 23:15:20 jer Exp $

inherit eutils autotools

MY_P=${P/libewf/libewf-beta}

DESCRIPTION="Implementation of the EWF (SMART and EnCase) image format"
HOMEPAGE="http://libewf.sourceforge.net"
SRC_URI="mirror://sourceforge/libewf/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
# upstream bug #2597171, pyewf has implicit declarations
#IUSE="debug python rawio unicode"
IUSE="debug rawio unicode"

DEPEND="
	sys-libs/e2fsprogs-libs
	sys-libs/zlib
	dev-libs/openssl"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable unicode wide-character-type) \
		$(use_enable rawio raw-access) \
		$(use_enable debug verbose-output) \
		$(use_enable debug debug-output)
	emake
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog NEWS README documents/*.txt
	doman manuals/*.1 manuals/*.3
}
