# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/nvi/nvi-1.81.5-r3.ebuild,v 1.4 2006/09/19 13:13:15 gustavoz Exp $

inherit eutils

DESCRIPTION="Vi clone"
HOMEPAGE="http://www.bostic.com/vi/"
SRC_URI="http://www.kotnet.org/~skimo/nvi/devel/${P}.tar.gz"

LICENSE="Sleepycat"
SLOT="0"
KEYWORDS="x86 ~ppc sparc ~mips ~alpha ~hppa ~amd64 ~ppc64"
IUSE="perl unicode"

DEPEND="=sys-libs/db-4*"
RDEPEND="${DEPEND}
	!app-editors/vim
	!app-editors/gvim"
PROVIDE="virtual/editor"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
	# Fix bug 23888
	epatch "${FILESDIR}"/${P}-tcsetattr.patch
	epatch "${FILESDIR}"/${P}-gcc4.patch
	epatch "${FILESDIR}"/${P}-db4.patch
	touch "${S}"/dist/{configure,aclocal.m4,Makefile.in,stamp-h.in}
}

src_compile() {
	local myconf

	use perl && myconf="${myconf} --enable-perlinterp"
	use unicode && myconf="${myconf} --enable-widechar"

	cd build.unix
	ECONF_SOURCE=../dist econf \
		--program-prefix=n \
		${myconf} \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	cd build.unix
	emake DESTDIR="${D}" install || die "install failed"
}

pkg_postinst() {
	[[ ! -e "${ROOT}"/usr/bin/vi ]] &&
		ln -sf nvi "${ROOT}"/usr/bin/vi
	[[ ! -e "${ROOT}"/usr/bin/ex ]] &&
		ln -sf nvi "${ROOT}"/usr/bin/ex
	[[ ! -e "${ROOT}"/usr/bin/view ]] &&
		ln -sf nvi "${ROOT}"/usr/bin/view
}

pkg_postrm() {
	[[ -L "${ROOT}"/usr/bin/vi && ! -f "${ROOT}"/usr/bin/vi ]] &&
		rm -f "${ROOT}"/usr/bin/vi
	[[ -L "${ROOT}"/usr/bin/ex && ! -f "${ROOT}"/usr/bin/ex ]] &&
		rm -f "${ROOT}"/usr/bin/ex
	[[ -L "${ROOT}"/usr/bin/view && ! -f "${ROOT}"/usr/bin/view ]] &&
		rm -f "${ROOT}"/usr/bin/view
}
