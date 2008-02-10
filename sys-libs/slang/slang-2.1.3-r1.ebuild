# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/slang/slang-2.1.3-r1.ebuild,v 1.2 2008/02/10 21:39:22 dirtyepic Exp $

inherit eutils

DESCRIPTION="a portable programmer's library designed to allow a developer to create robust portable software."
HOMEPAGE="http://www.s-lang.org"
SRC_URI="ftp://ftp.fu-berlin.de/pub/unix/misc/slang/v${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~x86"
IUSE="cjk pcre png"

RDEPEND="pcre? ( dev-libs/libpcre )
	png? ( media-libs/libpng )
	cjk? ( dev-libs/oniguruma )"
DEPEND="${RDEPEND}
	!=sys-libs/slang-2.1.2"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-2.1.2-slsh-libs.patch
}

src_compile() {
	econf $(use_with pcre) $(use_with png) \
		$(use_with cjk onig)
	emake elf static || die "emake elf static failed."
	cd slsh
	emake slsh || die "emake slsh failed."
}

src_install() {
	emake -j1 DESTDIR="${D}" install-all || die "emake install failed."

	rm -rf "${D}"/usr/share/doc/{slang,slsh}

	dodoc NEWS README *.txt doc/{,internal,text}/*.txt
	dohtml doc/slangdoc.html slsh/doc/html/*.html
}
